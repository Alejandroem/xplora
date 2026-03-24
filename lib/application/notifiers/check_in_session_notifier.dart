import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/services/check_in_session_service.dart';
import '../providers/check_in_providers.dart';
import 'check_in_detection_state.dart';
import 'check_in_session_state.dart';

class CheckInSessionNotifier extends StateNotifier<CheckInSessionState> {
  final CheckInSessionService _service;
  final Ref _ref;

  static const int _maxRetries = 3;

  Timer? _pingTimer;

  CheckInSessionNotifier(this._ref, this._service)
      : super(const CheckInSessionState.idle());

  /// Called by the provider listener on every detection state change.
  Future<void> onDetectionState(
    CheckInDetectionState? previous,
    CheckInDetectionState next,
  ) async {
    // Only act on transition INTO inside from a non-inside state.
    if (next is! CheckInDetectionInside) return;
    if (previous is CheckInDetectionInside) return;

    // Don't start if a session is already in-flight or active.
    if (state is CheckInSessionStarting) return;
    if (state is CheckInSessionActive) return;

    await _startSession(next);
  }

  Future<void> _startSession(CheckInDetectionInside inside,
      [int attempt = 0]) async {
    final place = inside.place;
    final position = inside.position;

    debugPrint('CheckInSession: state → starting(${place.placeId})');
    state = CheckInSessionState.starting(placeId: place.placeId);

    try {
      final result = await _service.start(
        placeId: place.placeId,
        lat: position.latitude,
        lng: position.longitude,
        accuracyM: position.accuracy,
        speedMps: position.speed >= 0 ? position.speed : null,
        isMocked: position.isMocked,
      );

      // Edge case: user left the place while /start was in-flight.
      // Let the session expire server-side via sessionTtlSec — don't ping.
      final currentDetection = _ref.read(checkInDetectionProvider);
      if (currentDetection is! CheckInDetectionInside ||
          currentDetection.place.placeId != place.placeId) {
        debugPrint(
          'CheckInSession: user left ${place.placeId} before /start responded. '
          'Session ${result.sessionId} will expire server-side.',
        );
        state = const CheckInSessionState.idle();
        return;
      }

      debugPrint(
        'CheckInSession: state → active(sessionId=${result.sessionId}, placeId=${place.placeId})',
      );
      state = CheckInSessionState.active(
        session: result,
        placeId: place.placeId,
      );
      _startPinging(result, place.placeId);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('CheckInSession: /start failed [${e.code}] ${e.message}');
      state = CheckInSessionState.failed(
        placeId: place.placeId,
        reason: e.code,
      );
      if (_isTransientError(e.code)) {
        await _scheduleRetry(inside, attempt);
      }
    } catch (e) {
      debugPrint('CheckInSession: /start unexpected error – $e');
      state = CheckInSessionState.failed(
        placeId: place.placeId,
        reason: 'unknown',
      );
    }
  }

  /// Transient errors are worth retrying automatically while the user is
  /// still inside the same place. Permanent errors (place not active,
  /// cooldown, one-time consumed, mock location, resource limits) are not
  /// retried — the UI surfaces the reason instead.
  bool _isTransientError(String code) =>
      code == 'internal' || code == 'unavailable';

  Future<void> _scheduleRetry(
      CheckInDetectionInside inside, int attempt) async {
    if (attempt >= _maxRetries) {
      debugPrint(
        'CheckInSession: max retries ($_maxRetries) reached for ${inside.place.placeId}, giving up',
      );
      return;
    }

    await Future.delayed(const Duration(seconds: 5));

    // Only retry if the user is still inside the same place and the session
    // is still in failed state (not reset by a leave/re-enter in the meantime).
    final current = _ref.read(checkInDetectionProvider);
    if (current is CheckInDetectionInside &&
        current.place.placeId == inside.place.placeId &&
        state is CheckInSessionFailed) {
      debugPrint(
        'CheckInSession: retrying /start for ${inside.place.placeId} '
        '(attempt ${attempt + 1}/$_maxRetries)',
      );
      await _startSession(current, attempt + 1);
    }
  }

  void _startPinging(CheckInStartResult session, String placeId) {
    _pingTimer?.cancel();
    _onPingTick(session.sessionId, placeId); // immediate first ping
    _pingTimer = Timer.periodic(
      Duration(seconds: session.pingRecommendedIntervalSec),
      (_) => _onPingTick(session.sessionId, placeId),
    );
    debugPrint(
      'CheckInSession: pinging started — interval ${session.pingRecommendedIntervalSec}s',
    );
  }

  Future<void> _onPingTick(String sessionId, String placeId) async {
    final position = await Geolocator.getLastKnownPosition();
    if (position == null) {
      debugPrint('CheckInSession: ping skipped — no last known position');
      return;
    }

    // print position
    debugPrint(
        'CheckInSession: ping position latitude ${position.latitude}, longitude ${position.longitude}, accuracy ${position.accuracy}, speed ${position.speed}');

    try {
      final result = await _service.ping(
        sessionId: sessionId,
        lat: position.latitude,
        lng: position.longitude,
        accuracyM: position.accuracy,
        speedMps: position.speed >= 0 ? position.speed : null,
      );

      debugPrint(
        'CheckInSession: ping → status=${result.status}, inside=${result.inside}, '
        'distance=${result.distanceM.toStringAsFixed(1)}m, '
        'progress=${(result.progressPercent * 100).toStringAsFixed(0)}%',
      );

      if (result.rejectReason != null) {
        debugPrint('CheckInSession: ping rejected — ${result.rejectReason}');
        return;
      }

      // Session just locked → stop pinging, auto-call /complete
      if (result.status == 'IN_PROGRESS') {
        _pingTimer?.cancel();
        _pingTimer = null;
        debugPrint(
            'CheckInSession: session locked → IN_PROGRESS, calling /complete');
        await _complete(sessionId, placeId);
      }
    } on FirebaseFunctionsException catch (e) {
      debugPrint('CheckInSession: ping failed [${e.code}] ${e.message}');
      // Session expired or completed server-side — stop pinging
      if (e.code == 'failed-precondition' || e.code == 'not-found') {
        _pingTimer?.cancel();
        _pingTimer = null;
        state = const CheckInSessionState.idle();
      }
      // Transient errors (internal, unavailable) — keep pinging
    } catch (e) {
      debugPrint('CheckInSession: ping unexpected error – $e');
    }
  }

  Future<void> _complete(String sessionId, String placeId) async {
    try {
      final result = await _service.complete(sessionId: sessionId);
      debugPrint(
        'CheckInSession: completed — timesCompleted=${result.timesCompleted}, '
        'cooldownUntil=${result.cooldownUntil}',
      );
      state = CheckInSessionState.completed(
        placeId: placeId,
        result: result,
      );
    } on FirebaseFunctionsException catch (e) {
      debugPrint('CheckInSession: /complete failed [${e.code}] ${e.message}');
      // Session already completed/expired server-side — reset to idle
      if (e.code == 'failed-precondition' || e.code == 'not-found') {
        state = const CheckInSessionState.idle();
      }
      // Transient errors — leave state as-is, ping timer already cancelled
    } catch (e) {
      debugPrint('CheckInSession: /complete unexpected error – $e');
    }
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    super.dispose();
  }
}
