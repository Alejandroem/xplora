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

  // 10m: ignores GPS jitter when standing still, fine-grained enough to
  // detect entry into even a small geofence before walking through it.
  static const int _distanceFilterM = 10;

  StreamSubscription<Position>? _positionSub;
  bool _isTrackingEnabled = false;

  // Own place list cache (independent of nearbyPlacesProvider)
  List<Place> _cachedCheckablePlaces = [];
  Position? _lastCachePosition;

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
      onDone: () =>
          debugPrint('CheckInDetection: position stream closed unexpectedly'),
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  Future<void> _onPositionUpdate(Position position) async {
    // If already inside a place, only check if the user has left.
    // Skips full detection loop to prevent spurious monitoring flashes
    // and avoid disrupting a Phase 2 check-in session mid-flow.
    final current = state;
    if (current is CheckInDetectionInside) {
      final geopoint = current.place.geo['geopoint'] as GeoPoint?;
      if (geopoint != null) {
        final distanceM = Geolocator.distanceBetween(
          position.latitude, position.longitude,
          geopoint.latitude, geopoint.longitude,
        );
        if (distanceM <= current.config.radiusM) {
          debugPrint(
            'CheckInDetection: still inside ${current.place.placeId} (${distanceM.toStringAsFixed(1)}m), no state change',
          );
          return;
        }
      }
      debugPrint(
        'CheckInDetection: left ${current.place.placeId}, falling through to detection loop',
      );
      // user left the geofence — fall through to full detection loop
    }

    // Lazily checked below only if a place requires it.
    // null = not yet checked this update.
    bool? locationServicesEnabled;

    // Refresh place cache if needed
    final shouldRefresh = _cachedCheckablePlaces.isEmpty ||
        _lastCachePosition == null ||
        Geolocator.distanceBetween(
              _lastCachePosition!.latitude,
              _lastCachePosition!.longitude,
              position.latitude,
              position.longitude,
            ) >
            _cacheRefreshThresholdM;

    if (shouldRefresh) {
      // Set immediately before the async fetch so concurrent position updates
      // that arrive while the fetch is in-flight see a non-null reference
      // position and skip their own fetch (distance will be ~0m).
      _lastCachePosition = position;
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
        _cachedCheckablePlaces = all.toList();
        debugPrint(
          'CheckInDetection: cache refreshed – ${_cachedCheckablePlaces.length} checkable places',
        );
      } catch (e) {
        _lastCachePosition = null; // reset so next update retries
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

    // Sort by distance so nearest place wins when user is inside
    // multiple overlapping geofences simultaneously.
    _cachedCheckablePlaces.sort((a, b) {
      final geopointA = a.geo['geopoint'] as GeoPoint?;
      final geopointB = b.geo['geopoint'] as GeoPoint?;
      if (geopointA == null) return 1;
      if (geopointB == null) return -1;
      final da = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        geopointA.latitude, geopointA.longitude,
      );
      final db = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        geopointB.latitude, geopointB.longitude,
      );
      return da.compareTo(db);
    });

    // Check each candidate
    for (final place in _cachedCheckablePlaces) {
      // Use embedded config from place doc; fall back to globalDefault if absent.
      ValidationConfig? config = place.validationConfig;

      if (config == null) {
        // Fetch globalDefault (lazy, in-memory cache)
        config = _configCache['globalDefault'];
        if (config == null) {
          try {
            config = await _validationConfigService.read('globalDefault');
            if (config == null) {
              debugPrint('CheckInDetection: globalDefault config not found, skipping ${place.placeId}');
              continue;
            }
            _configCache['globalDefault'] = config;
          } catch (e) {
            debugPrint('CheckInDetection: globalDefault fetch error – $e');
            continue;
          }
        }
      }

      // Location services gate (per-place, checked lazily — only if needed,
      // only once per position update regardless of how many places require it)
      if (config.requireLocationServices) {
        locationServicesEnabled ??= await Geolocator.isLocationServiceEnabled();
        if (!locationServicesEnabled) {
          debugPrint(
            'CheckInDetection: location services required but unavailable for ${place.placeId}',
          );
          continue;
        }
      }

      // debugPrint('position.accuracy: ${position.accuracy}');

      // Accuracy gate (app-side, uses minAccuracyM from config)
      if (position.accuracy > config.minAccuracyM) {
        debugPrint(
          'CheckInDetection: position accuracy (${position.accuracy}m) worse '
          'than required (${config.minAccuracyM}m), skipping ${place.placeId}',
        );
        continue;
      }

      // Compute distance
      final geopoint = place.geo['geopoint'] as GeoPoint?;
      if (geopoint == null) {
        debugPrint('CheckInDetection: missing geopoint for ${place.placeId}, skipping');
        continue;
      }
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
          position: position,
        );
        return;
      }
    }

    // No match; state already set to monitoring above
  }
}
