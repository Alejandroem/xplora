import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location_pkg;
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

import '../../domain/services/settings_crud_service.dart';
import 'auth_service_providers.dart';
import 'settings_crud_providers.dart';
import 'settings_providers.dart';

class LocationState {
  final Position? position;
  final bool isLoading;

  LocationState({this.position, this.isLoading = false});
}

class LocationNotifier extends StateNotifier<LocationState> {
  final SettingsCrudService settingsCrudService;
  Timer? _timer;
  bool _isInitialized = false;
  
  LocationNotifier(
    this.settingsCrudService,
  ) : super(LocationState()) {
    // Don't automatically start location requests
    // Only start when explicitly requested
  }

  void initializeLocationTracking() {
    if (!_isInitialized) {
      print('🗺️ LocationNotifier: Initializing location tracking');
      _isInitialized = true;
      // Set initial loading state
      state = LocationState(isLoading: true);
      getCurrentLocation();
      _startLocationUpdates();
    }
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
    if (!_isInitialized) {
      return; // Don't request location if not initialized
    }
    
    // Set loading state
    // state = LocationState(isLoading: true, position: state.position);
    
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
        state = LocationState(position: position, isLoading: false);
      } else {
        // Position hasn't changed significantly, just clear loading
        // state = LocationState(position: state.position, isLoading: false);
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

// Provider to control when location tracking should be enabled
final locationTrackingEnabledProvider = StateProvider<bool>((ref) {
  return false;
});

// Helper function to check and request location service
Future<bool> _checkLocationService(location_pkg.Location location) async {
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    print('🗺️ Location services are not enabled, requesting...');
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print('🗺️ User declined to enable location services');
      return false;
    }
  }
  return true;
}

// Helper function to enable location tracking
void _enableLocationTracking(Ref ref) {
  print('🗺️ Enabling location tracking');
  ref.read(locationTrackingEnabledProvider.notifier).state = true;
  ref.read(locationProvider.notifier).initializeLocationTracking();
  ref.read(locationPermissionRequestStatusProvider.notifier).state = LocationPermissionRequestStatus.none;
}

// Enum to represent location permission request status
enum LocationPermissionRequestStatus {
  none,           // No request needed
  requestNeeded,  // Permission denied/expired, show regular dialog
  permanentlyDenied, // Permission permanently denied, show settings dialog
}

// Provider to flag when location permission dialog should be shown
final locationPermissionRequestStatusProvider = StateProvider<LocationPermissionRequestStatus>((ref) {
  return LocationPermissionRequestStatus.none;
});

// Provider that automatically enables location tracking for authenticated users with permission
final autoEnableLocationTrackingProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final isSignedIn = await authService.isSignedInFuture();

  final location = location_pkg.Location();

  if (isSignedIn) {
    // === Authenticated User Flow ===
    print('🗺️ autoEnableLocationTrackingProvider: User authenticated');

    // Check and request location service if needed
    final serviceEnabled = await _checkLocationService(location);
    if (!serviceEnabled) {
      return; // Service not enabled, exit early
    }

    // Get current permission status (using permission_handler)
    permission_handler.PermissionStatus permission = await permission_handler.Permission.location.status;

    if (permission.isGranted || permission.isLimited) {
      // Permission already granted, enable tracking
      print('🗺️ User has location permission');
      _enableLocationTracking(ref);
    } else if (permission.isDenied) {
      // Permission denied or expired - auto-request for logged-in users
      print('🗺️ Permission denied/expired, automatically requesting...');
      permission = await permission_handler.Permission.location.request();

      // Get settings notifier
      final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);

      if (permission.isGranted || permission.isLimited) {
        // Permission granted after request
        print('🗺️ Permission granted');
        _enableLocationTracking(ref);
        await settingsNotifier.setLocationEnabled(true);
      } else if (permission.isPermanentlyDenied) {
        // Permission permanently denied
        print('🗺️ Permission permanently denied');
        ref.read(locationPermissionRequestStatusProvider.notifier).state = LocationPermissionRequestStatus.permanentlyDenied;

        // Update settings - location denied
        await settingsNotifier.setLocationEnabled(false);
      } else {
        // User denied the request
        print('🗺️ User denied permission request');
        ref.read(locationPermissionRequestStatusProvider.notifier).state = LocationPermissionRequestStatus.none;

        // Update settings - location denied
        await settingsNotifier.setLocationEnabled(false);
      }
    } else if (permission.isPermanentlyDenied) {
      // Permission was already permanently denied
      print('🗺️ Permission permanently denied');
      ref.read(locationPermissionRequestStatusProvider.notifier).state = LocationPermissionRequestStatus.permanentlyDenied;
    } else {
      print('🗺️ Unknown permission status: $permission');
    }
  } else {
    // === Non-Authenticated User Flow ===
    // Only check (don't request) service and permission status
    print('🗺️ autoEnableLocationTrackingProvider: User not authenticated, checking status only');

    // Check if location service is enabled (without requesting)
    final serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      print('🗺️ Location service is not enabled');
      return;
    }
    print('🗺️ Location service is enabled');

    // Check permission status (without requesting)
    final permission = await permission_handler.Permission.location.status;

    if (permission.isGranted || permission.isLimited) {
      // Permission already granted, enable tracking (without updating permission status)
      print('🗺️ Location permission is granted, enabling tracking');
      ref.read(locationTrackingEnabledProvider.notifier).state = true;
      ref.read(locationProvider.notifier).initializeLocationTracking();
    } else if (permission.isDenied) {
      print('🗺️ Location permission is denied');
    } else if (permission.isPermanentlyDenied) {
      print('🗺️ Location permission is permanently denied');
    } else {
      print('🗺️ Location permission status: $permission');
    }
  }
});

// Provider to check if location permission is granted
final locationPermissionProvider = FutureProvider<bool>((ref) async {
  try {
    // First check if location services are enabled without requesting
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check permission status without requesting
    final permission = await Geolocator.checkPermission();

    // Only return true if permission is already granted
    // Don't request permission here to avoid triggering dialogs
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  } catch (e) {
    // If any error occurs, assume no permission
    return false;
  }
});

/// Provider that converts current location to "City, Country" format
/// Uses ISO country code (e.g., "San Juan, PR", "Rawalpindi, PK")
/// Returns null if location is unavailable or geocoding fails
final geocodedLocationProvider = FutureProvider<String?>((ref) async {
  final locationState = ref.watch(locationProvider);
  final position = locationState.position;

  // Return null if no position available
  if (position == null) {
    return null;
  }

  try {
    // await Future.delayed(const Duration(seconds: 5));
    // throw Exception();
    // Use geocoding to convert coordinates to address
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // placemarks.forEach((placemark) {
    //   print('🗺️ placemark: $placemark');
    // });

    if (placemarks.isEmpty) {
      return null;
    }

    final placemark = placemarks.first;
    final city = placemark.locality;
    final countryCode = placemark.isoCountryCode; // e.g., "US", "PR", "PK"

    // Use ISO country code for consistency across all locations
    // This avoids issues like:
    // - Duplication: "San Juan, San Juan" (PR uses city as administrativeArea)
    // - Long names: "Rawalpindi, Islamabad Capital Territory"
    // - Inconsistencies: Different countries format administrativeArea differently
    if (city != null && city.isNotEmpty && countryCode != null && countryCode.isNotEmpty) {
      return '$city, $countryCode';
    }

    // Fallback to just city if no country code available
    if (city != null && city.isNotEmpty) {
      return city;
    }

    // Geocoding succeeded but couldn't extract useful info, return null
    return null;
  } catch (e) {
    // Geocoding failed, hide location
    print('🗺️ geocodedLocationProvider: Geocoding failed - $e');
    return null;
  }
});