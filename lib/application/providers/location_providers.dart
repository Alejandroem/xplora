import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';

import '../../domain/services/settings_crud_service.dart';
import 'settings_providers.dart';

class LocationState {
  final Position? position;
  final bool isLoading;

  LocationState({this.position, this.isLoading = false});
}

class LocationNotifier extends StateNotifier<LocationState> {
  final SettingsCrudService settingsCrudService;
  Timer? _timer;
  LocationNotifier(
    this.settingsCrudService,
  ) : super(LocationState()) {
    getCurrentLocation();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(
        kDebugMode
            ? const Duration(
                seconds: 15,
              )
            : const Duration(
                minutes: 5,
              ), (timer) {
      getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );
      if (state.position == null ||
          Geolocator.distanceBetween(
                state.position!.latitude,
                state.position!.longitude,
                position.latitude,
                position.longitude,
              ) >=
              3) {
        state = LocationState(position: position);
      }
    } catch (e) {
      state = LocationState();
    }
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(
    ref.watch(settingsCrudServiceProvider),
  ),
);

final minimumDistanceProvider = StateProvider<int>((ref) {
  return 10000;
});
