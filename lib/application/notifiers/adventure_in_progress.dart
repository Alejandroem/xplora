import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/adventure_in_progress.dart';
import '../../domain/models/xplora_user.dart';
import '../../domain/services/adventure_crud_service.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';

class AdventureInProgressNotifier extends StateNotifier<AdventureInProgress?> {
  final int _checkInterval = 10; // Update completeness every 10 seconds
  final int _leaveThreshold = kDebugMode
      ? 10
      : 600; // Time outside before clearing (10 sec debug, 10 min prod)
  final int _awardThreshold = kDebugMode
      ? 60
      : 600; // Time inside to award adventure (1 min debug, 10 min prod)

  Timer? _locationCheckTimer;
  Timer? _leaveAreaTimer;
  Timer? _awardAdventureTimer;

  final AdventureCrudService _adventureCrudService;
  final AuthService _authService;
  final XploraProfileService _xploraProfileService;

  AdventureInProgressNotifier(
    this._adventureCrudService,
    this._authService,
    this._xploraProfileService,
  ) : super(null) {
    _locationCheckTimer = Timer.periodic(
      Duration(
          seconds: _checkInterval), // Completeness will update every 10 seconds
      (timer) {
        _checkUserLocation();
      },
    );
  }

  Future<void> _checkUserLocation() async {
    XploraUser? user = await _authService.getAuthUser();
    if (user == null) {
      log('User is not authenticated');
      return;
    }

    final userLocation = await getUserLocation();
    if (userLocation == null ||
        userLocation.latitude == null ||
        userLocation.longitude == null) {
      log('Unable to get user location');
      return;
    }

    if (state != null) {
      // Adventure in progress, track the time spent and update completeness
      final distance = Geolocator.distanceBetween(
        userLocation.latitude!,
        userLocation.longitude!,
        state!.adventure.latitude,
        state!.adventure.longitude,
      );

      if (distance > 30) {
        // User has left the place, start the leave timer
        if (_leaveAreaTimer == null) {
          log('User has left the area, starting leave timer');
          _leaveAreaTimer = Timer(Duration(seconds: _leaveThreshold), () {
            log('User has been away for more than $_leaveThreshold seconds, clearing adventure in progress');
            clearAdventureInProgress();
          });
        }
      } else {
        // User is still in the area, cancel leave timer and update completeness
        _leaveAreaTimer?.cancel();
        _leaveAreaTimer = null;
        _updateCompleteness(); // Update completeness every 10 seconds

        // Check if the adventure should be awarded
        if (_awardAdventureTimer == null) {
          log('User is at the location, starting award timer');
          _awardAdventureTimer =
              Timer(Duration(seconds: _awardThreshold), () async {
            log('User has stayed for more than $_awardThreshold seconds, awarding adventure');
            await _awardAdventure();
          });
        }
      }
    } else {
      // No adventure in progress, find nearby adventures
      log('No adventure in progress, checking for nearby adventures');
      await _findAndStartNearbyAdventure(user, userLocation);
    }
  }

  Future<void> _findAndStartNearbyAdventure(
      XploraUser user, LocationData userLocation) async {
    // Get all available adventures
    List<Adventure>? allAvailableAdventures =
        await _adventureCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': 'unset',
      },
    ]);

    if (allAvailableAdventures == null || allAvailableAdventures.isEmpty) {
      log('No available adventures found');
      return;
    }

    // Filter adventures that are within 30 meters
    List<Adventure> nearbyAdventures = allAvailableAdventures.where(
      (adventure) {
        final distance = Geolocator.distanceBetween(
          userLocation.latitude!,
          userLocation.longitude!,
          adventure.latitude,
          adventure.longitude,
        );
        return distance <= 30;
      },
    ).toList();

    log('Found ${nearbyAdventures.length} nearby adventures');

    // Fetch user's completed adventures to filter them out
    final userPreviousAdventures = await _adventureCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': user.id,
      },
    ]);

    if (userPreviousAdventures != null && userPreviousAdventures.isNotEmpty) {
      log('Filtering out completed adventures');
      nearbyAdventures.removeWhere(
        (adventure) =>
            userPreviousAdventures.indexWhere(
              (userAdventure) => userAdventure.adventureId == adventure.id,
            ) !=
            -1,
      );
    }

    if (nearbyAdventures.isNotEmpty) {
      log('Setting adventure in progress');
      setAdventureInProgress(nearbyAdventures.first);
    } else {
      log('No new nearby adventures found for the user');
    }
  }

  void _updateCompleteness() {
    if (state != null) {
      final timeSpent =
          DateTime.now().difference(state!.enteredPlaceAt).inSeconds;
      final completenessPercentage =
          (timeSpent / _awardThreshold * 100).toInt();

      // Ensure completeness is capped at 100
      final updatedCompleteness =
          completenessPercentage > 100 ? 100 : completenessPercentage;

      log('Updating completeness: $updatedCompleteness%');

      // Update the state with the new completeness value
      state = state!.copyWith(completeness: updatedCompleteness);
    }
  }

  Future<void> _awardAdventure() async {
    XploraUser? user = await _authService.getAuthUser();
    if (user == null || state == null) return;

    // Award the adventure
    final adventure = state!.adventure.copyWith(
      userId: user.id,
      adventureId: state!.adventure.id,
    );
    await _adventureCrudService.create(adventure);
    log('Adventure has been awarded to user: ${user.id}');

    // Update user profile with experience points
    final userProfile = await _xploraProfileService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': user.id,
      },
    ]);

    if (userProfile != null && userProfile.isNotEmpty) {
      final userExperience = userProfile.first.experience;
      final updatedExperience = userExperience + adventure.experience.toInt();
      await _xploraProfileService.update(
        userProfile.first.copyWith(
          experience: updatedExperience.ceil(),
        ),
        userProfile.first.id!,
      );
      log('User experience updated to: $updatedExperience');
    }

    clearAdventureInProgress(); // Adventure awarded, clear progress
  }

  void setAdventureInProgress(Adventure adventure) {
    state = AdventureInProgress(
      adventure: adventure,
      enteredPlaceAt: DateTime.now(),
      completeness: 0,
    );

    // Clear any existing leave or award timers since the user is now starting a new adventure
    _leaveAreaTimer?.cancel();
    _awardAdventureTimer?.cancel();
    _leaveAreaTimer = null;
    _awardAdventureTimer = null;

    // Start the timer for awarding the adventure
    _awardAdventureTimer = Timer(Duration(seconds: _awardThreshold), () async {
      log('User has stayed for more than $_awardThreshold seconds, awarding adventure');
      await _awardAdventure();
    });
  }

  void clearAdventureInProgress() {
    state = null;
    _leaveAreaTimer?.cancel();
    _awardAdventureTimer?.cancel();
    _leaveAreaTimer = null;
    _awardAdventureTimer = null;
  }

  @override
  void dispose() {
    _locationCheckTimer?.cancel();
    _leaveAreaTimer?.cancel();
    _awardAdventureTimer?.cancel();
    super.dispose();
  }

  Future<LocationData?> getUserLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();

    return locationData;
  }
}
