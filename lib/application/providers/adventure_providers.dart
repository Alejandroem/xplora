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

final nearbyAdventuresProvider =
    StreamProvider.autoDispose<List<Adventure>>((ref) async* {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  // Stream all available adventures that are not associated with any user
  final allAvailableAdventures = adventureCrudService.streamByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);

  // Listen to available adventures stream
  await for (final adventures in allAvailableAdventures) {
    if (adventures == null || adventures.isEmpty) {
      yield [];
      continue;
    }

    try {
      // Check if the user is signed in early to reduce unnecessary processing
      final isSignedIn = await authService.isSignedInFuture();
      if (!isSignedIn) {
        yield adventures;
        continue;
      }

      final user = await authService.getAuthUser();
      if (user == null) {
        yield adventures;
        continue;
      }

      final location = Location();

      // Check if location services are enabled
      bool serviceEnabled =
          await location.serviceEnabled() || await location.requestService();
      if (!serviceEnabled) {
        yield adventures;
        continue;
      }

      // Request location permissions if not already granted
      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      }
      if (permissionGranted != PermissionStatus.granted) {
        yield adventures;
        continue;
      }

      // Get current user location
      final userLocation = await location.getLocation();
      if (userLocation.latitude == null || userLocation.longitude == null) {
        yield adventures;
        continue;
      }

      // Fetch user's previous adventures
      final userPreviousAdventures =
          await adventureCrudService.streamByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': user.id,
        },
      ]).first;

      // Filter nearby adventures within 30 meters
      List<Adventure> nearbyAdventures = adventures.where((adventure) {
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
      }).toList();

      // Remove any adventures the user has previously done
      if (userPreviousAdventures != null && userPreviousAdventures.isNotEmpty) {
        nearbyAdventures.removeWhere(
          (adventure) => userPreviousAdventures.any(
            (userAdventure) => userAdventure.adventureId == adventure.id,
          ),
        );
      }

      yield nearbyAdventures;
    } catch (e, stackTrace) {
      // Log the error and stack trace for easier debugging
      debugPrint('Error in nearbyAdventuresProvider: $e\n$stackTrace');
      yield adventures;
    }
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
