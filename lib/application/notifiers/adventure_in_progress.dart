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

class AdventureInProgressNotifier extends StateNotifier<AdventureInProgress?> {
  final int _timeAtPlaceCheckerInterval = kDebugMode ? 10 : 60;
  final int _timeAtPlaceCheckerDuration = kDebugMode ? 1 : 30;
  Timer? _timeAtPlaceChecker;

  final AdventureCrudService _adventureCrudService;
  final AuthService _authService;

  AdventureInProgressNotifier(
    this._adventureCrudService,
    this._authService,
  ) : super(null) {
    _timeAtPlaceChecker = Timer.periodic(
      Duration(seconds: _timeAtPlaceCheckerInterval),
      (timer) {
        //We have one in progress
        log('Check timer has ticked');
        checkTimer().then((_) => log('check timer has finished'));
      },
    );
  }

  Future<void> checkTimer() async {
    XploraUser? user = await _authService.getAuthUser();
    if (user == null) {
      log('User is not authenticated');
      return;
    }
    if (state != null) {
      log('Checking if the user has been at the place for more than $_timeAtPlaceCheckerDuration minutes');
      final timeAtPlace = DateTime.now().difference(state!.enteredPlaceAt);
      if (timeAtPlace.inMinutes >= _timeAtPlaceCheckerDuration) {
        log('User has been at the place for more than $_timeAtPlaceCheckerDuration minutes');
        // create a copy with the current user id

        final adventure = state!.adventure.copyWith(
          userId: user.id,
          adventureId: state!.adventure.id,
        );
        _adventureCrudService.create(adventure);
        log('Adventure has been saved');
        clearAdventureInProgress();
      }
    } else {
      //lets get the list of all adventures
      List<Adventure>? allAvailableAdventures =
          await _adventureCrudService.readByFilters([
        {
          'field': 'userId',
          'operator': 'unset',
        },
      ]);

      if (allAvailableAdventures == null || allAvailableAdventures.isEmpty) {
        return;
      }
      //get current user location
      final userLocation = await getUserLocation();

      if (userLocation == null ||
          userLocation.latitude == null ||
          userLocation.longitude == null) {
        return;
      }
      //Check the locations of the adventures
      // Filter a list of adventures that are 30 meters away from the user
      log('Checking for nearby adventures');
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

      final userPreviousAdventures = await _adventureCrudService.readByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': user.id,
        },
      ]);

      if (userPreviousAdventures != null && userPreviousAdventures.isNotEmpty) {
        //If the user has previous adventures, we will filter out the ones that the user has already completed
        log('Filtering out adventures that the user has already completed');
        nearbyAdventures.removeWhere(
          (adventure) =>
              userPreviousAdventures.indexWhere(
                (userAdventure) => userAdventure.adventureId == adventure.id,
              ) !=
              -1,
        );
      }

      if (nearbyAdventures.isNotEmpty) {
        //If there are nearby adventures, we will set the first one as the adventure in progress
        log('Setting adventure in progress');
        setAdventureInProgress(nearbyAdventures.first);
      }
    }
  }

  void setAdventureInProgress(Adventure adventure) {
    state = AdventureInProgress(
      adventure: adventure,
      enteredPlaceAt: DateTime.now(),
    );
  }

  void clearAdventureInProgress() {
    state = null;
  }

  @override
  void dispose() {
    _timeAtPlaceChecker?.cancel();
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
