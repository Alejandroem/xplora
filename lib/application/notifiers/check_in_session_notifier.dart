import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/check_in_session_service.dart';
import '../providers/check_in_providers.dart';
import 'check_in_detection_state.dart';
import 'check_in_session_state.dart';

class CheckInSessionNotifier extends StateNotifier<CheckInSessionState> {
  final CheckInSessionService _service;
  final Ref _ref;

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

    final place = next.place;
    final position = next.position;

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
    } on FirebaseFunctionsException catch (e) {
      debugPrint(
        'CheckInSession: /start failed [${e.code}] ${e.message}',
      );
      state = CheckInSessionState.failed(
        placeId: place.placeId,
        reason: e.code,
      );
    } catch (e) {
      debugPrint('CheckInSession: /start unexpected error – $e');
      state = CheckInSessionState.failed(
        placeId: place.placeId,
        reason: 'unknown',
      );
    }
  }
}
