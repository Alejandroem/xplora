import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/validation_config.dart';
import '../../domain/services/place_crud_service.dart';
import '../../domain/services/validation_config_service.dart';
import '../../domain/models/place.dart';
import 'check_in_detection_state.dart';

class CheckInDetectionNotifier
    extends StateNotifier<CheckInDetectionState> {

  static const double _cacheRefreshThresholdM = 50;
  static const int _maxCacheAgeSec = 300;

  // 10m: ignores GPS jitter when standing still, fine-grained enough to
  // detect entry into even a small geofence before walking through it.
  static const int _distanceFilterM = 10;

  StreamSubscription<Position>? _positionSub;
  bool _isTrackingEnabled = false;

  // Own place list cache (independent of nearbyPlacesProvider)
  List<Place> _cachedCheckablePlaces = [];
  Position? _lastCachePosition;
  DateTime? _lastCacheTime;

  // Lazy ValidationConfig cache
  final Map<String, ValidationConfig> _configCache = {};

  final ValidationConfigService _validationConfigService;
  final PlaceCrudService _placeCrudService;

  CheckInDetectionNotifier(
    Ref ref,
    this._validationConfigService,
    this._placeCrudService,
  ) : super(const CheckInDetectionState.inactive());

  void enableLocationTracking() {
    if (_isTrackingEnabled) return;
    _isTrackingEnabled = true;

    // Stream fires only when user moves ≥ _distanceFilterM.
    // GPS stays warm between updates — no repeated cold starts,
    // and no wasted reads when the user is stationary.
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: _distanceFilterM,
      ),
    ).listen(
      (position) => _onPositionUpdate(position),
      onError: (e) =>
          debugPrint('CheckInDetection: position stream error – $e'),
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _onPositionUpdate(Position position) async {
    // Check location services once per update
    final locationServicesEnabled = await Geolocator.isLocationServiceEnabled();

    // Refresh place cache if needed
    final shouldRefresh = _cachedCheckablePlaces.isEmpty ||
        _lastCachePosition == null ||
        _lastCacheTime == null ||
        Geolocator.distanceBetween(
              _lastCachePosition!.latitude,
              _lastCachePosition!.longitude,
              position.latitude,
              position.longitude,
            ) >
            _cacheRefreshThresholdM ||
        DateTime.now().difference(_lastCacheTime!).inSeconds > _maxCacheAgeSec;

    if (shouldRefresh) {
      try {
        // Scan radius must be larger than the biggest radiusM in any
        // ValidationConfig. 1km is intentionally hardcoded — any legitimate
        // check-in geofence fits within it. A geofence larger than 1km would
        // mean the user can "check in" while being almost a mile from the
        // place, which is not a real check-in. If that ever changes, bump
        // this value and update the Firestore geo index accordingly.
        final all = await _placeCrudService.fetchNearby(
          center: GeoPoint(position.latitude, position.longitude),
          radiusInKm: 1.0,
        );
        _cachedCheckablePlaces =
            all.where((p) => p.validationConfigId != null).toList();
        _lastCachePosition = position;
        _lastCacheTime = DateTime.now();
        debugPrint(
          'CheckInDetection: cache refreshed – ${_cachedCheckablePlaces.length} checkable places',
        );
      } catch (e) {
        debugPrint('CheckInDetection: place cache refresh failed – $e');
        return;
      }
    }

    // No candidates → inactive
    if (_cachedCheckablePlaces.isEmpty) {
      state = const CheckInDetectionState.inactive();
      return;
    }

    // Candidates found → monitoring
    state = CheckInDetectionState.monitoring(
      candidatePlaceIds: _cachedCheckablePlaces.map((p) => p.placeId).toList(),
    );

    // Check each candidate
    for (final place in _cachedCheckablePlaces) {
      final configId = place.validationConfigId!;

      // Fetch config (lazy, in-memory cache)
      ValidationConfig? config = _configCache[configId];
      if (config == null) {
        try {
          config = await _validationConfigService.read(configId);
          if (config == null) {
            debugPrint('CheckInDetection: config $configId not found, skipping');
            continue;
          }
          _configCache[configId] = config;
        } catch (e) {
          debugPrint('CheckInDetection: config fetch error for $configId – $e');
          continue;
        }
      }

      // Location services gate (per-place)
      if (config.requireLocationServices && !locationServicesEnabled) {
        debugPrint(
          'CheckInDetection: location services required but unavailable for ${place.placeId}',
        );
        continue;
      }

      // Accuracy gate (app-side, uses minAccuracyM from config)
      if (position.accuracy > config.minAccuracyM) {
        debugPrint(
          'CheckInDetection: position accuracy (${position.accuracy}m) worse '
          'than required (${config.minAccuracyM}m), skipping ${place.placeId}',
        );
        continue;
      }

      // Compute distance
      final geopoint = place.geo['geopoint'] as GeoPoint;
      final distanceM = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        geopoint.latitude,
        geopoint.longitude,
      );

      // Inside check
      if (distanceM <= config.radiusM) {
        debugPrint(
          'CheckInDetection: inside ${place.placeId} (${distanceM.toStringAsFixed(1)}m)',
        );
        state = CheckInDetectionState.inside(
          place: place,
          config: config,
          distanceM: distanceM,
        );
        return;
      }
    }

    // No match; state already set to monitoring above
  }
}
