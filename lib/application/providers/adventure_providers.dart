import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/adventure_in_progress.dart';
import '../../domain/services/adventure_crud_service.dart';
import '../../infrastructure/services/firebase_adventure_crud_service.dart';
import '../notifiers/adventure_in_progress.dart';
import 'auth_providers.dart';
import 'xplorauser_providers.dart';

final adventuresCrudServiceProvider = Provider<AdventureCrudService>((ref) {
  return FirebaseAdventureCrudService();
});

final userAdventuresProvider = FutureProvider<List<Adventure>?>((ref) async {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);
  if (!await authService.isSignedInFuture()) {
    return null;
  }

  final userId = (await authService.getAuthUser())?.id!;

  return adventureCrudService.readByFilters([
    {
      'field': 'userId',
      'operator': '==',
      'value': userId,
    }
  ]);
});

final availableAdventuresProvider =
    FutureProvider<List<Adventure>?>((ref) async {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);

  List<Adventure>? allAdventures = await adventureCrudService.readByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);
  final userAdventures = await ref.watch(userAdventuresProvider.future);
  if (allAdventures != null &&
      allAdventures.isNotEmpty &&
      userAdventures != null &&
      userAdventures.isNotEmpty) {
    allAdventures.removeWhere(
      (a) =>
          userAdventures.indexWhere(
            (userAdventure) => userAdventure.adventureId == a.id,
          ) !=
          -1,
    );
  }
  return allAdventures;
});

final featuredAdventuresProvider =
    FutureProvider<List<Adventure>?>((ref) async {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);

  List<Adventure>? allAdventures = await adventureCrudService.readByFilters([
    {
      'field': 'featured',
      'operator': '==',
      'value': true,
    }
  ]);
  return allAdventures;
});

final adventureInProgressTrackerProvider = StateNotifierProvider.autoDispose<
    AdventureInProgressNotifier, AdventureInProgress?>((ref) {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);

  return AdventureInProgressNotifier(
    adventureCrudService,
    authService,
    profileService,
  );
});

final nearbyAdventuresProvider = FutureProvider<List<Adventure>?>((ref) async {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  final allAvailableAdventures = await adventureCrudService.readByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);

  if (allAvailableAdventures == null || allAvailableAdventures.isEmpty) {
    return null;
  }
  try {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return allAvailableAdventures;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return allAvailableAdventures;
      }
    }

    final userLocation = await location.getLocation();

    if (userLocation.latitude == null || userLocation.longitude == null) {
      return allAvailableAdventures;
    }

    if (!await authService.isSignedInFuture()) {
      return allAvailableAdventures;
    }

    final user = await authService.getAuthUser();
    if (user == null) {
      return allAvailableAdventures;
    }

    final userPreviousAdventures = await adventureCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': user.id,
      },
    ]);

    List<Adventure> nearbyAdventures = allAvailableAdventures.where(
      (adventure) {
        final distance = Geolocator.distanceBetween(
          userLocation.latitude!,
          userLocation.longitude!,
          adventure.latitude,
          adventure.longitude,
        );
        if (kDebugMode) {
          return true;
        }
        return distance <= 30;
      },
    ).toList();

    if (userPreviousAdventures != null && userPreviousAdventures.isNotEmpty) {
      nearbyAdventures.removeWhere(
        (adventure) =>
            userPreviousAdventures.indexWhere(
              (userAdventure) => userAdventure.adventureId == adventure.id,
            ) !=
            -1,
      );
    }

    return nearbyAdventures;
  } catch (e) {
    return allAvailableAdventures;
  }
});

final selectedCategoriesProvider = StateProvider<List<String>>((ref) {
  return [];
});

final userPreviousAdventuresProvider =
    FutureProvider<List<Adventure>?>((ref) async {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  if (!await authService.isSignedInFuture()) {
    return null;
  }

  final user = await authService.getAuthUser();
  if (user == null) {
    return null;
  }

  return adventureCrudService.readByFilters([
    {
      'field': 'userId',
      'operator': '==',
      'value': user.id,
    },
  ]);
});
