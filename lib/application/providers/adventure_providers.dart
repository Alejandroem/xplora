import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/adventure_in_progress.dart';
import '../../domain/services/adventure_crud_service.dart';
import '../../infrastructure/services/firebase_adventure_crud_service.dart';
import '../notifiers/adventure_in_progress.dart';
import 'achievements_providers.dart';
import 'auth_providers.dart';
import 'location_providers.dart';
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

  List<Adventure>? allAdventures = await adventureCrudService.readByFilters([]);

  allAdventures?.removeWhere(
    (adventure) => adventure.userId != null && adventure.userId != '',
  );
  
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

final featuredAdventuresProvider = StreamProvider<List<Adventure>?>((ref) {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);

  return adventureCrudService.streamByFilters([
    {
      'field': 'featured',
      'operator': '==',
      'value': true,
    }
  ]);
});

final adventureInProgressTrackerProvider = StateNotifierProvider.autoDispose<
    AdventureInProgressNotifier, AdventureInProgress?>((ref) {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  final achievementsService = ref.watch(achievementsServiceProvider);

  return AdventureInProgressNotifier(
    adventureCrudService,
    authService,
    profileService,
    achievementsService,
  );
});

final nearbyAdventuresProvider = StreamProvider<List<Adventure>>((ref) async* {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  // Stream all available adventures that are not associated with any user
  final allAvailableAdventures = adventureCrudService.streamByFilters([]);

  // Listen to available adventures stream
  await for (final adventures in allAvailableAdventures) {
    if (adventures == null || adventures.isEmpty) {
      continue; // Skip yielding if the list is empty
    }

    try {
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

      final userLocation = ref.watch(locationProvider);
      if (userLocation.isLoading || userLocation.position == null) {
        [];
        continue;
      }

      final userPreviousAdventures = await adventureCrudService.readByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': user.id,
        },
      ]);

      List<Adventure> nearbyAdventures = adventures;

      //remove those who have the userId set, except empty strings
      nearbyAdventures.removeWhere(
        (adventure) => adventure.userId != null && adventure.userId != '',
      );

      //sort adventures by distance
      nearbyAdventures.sort((a, b) {
        final distanceA = Geolocator.distanceBetween(
          userLocation.position!.latitude,
          userLocation.position!.longitude,
          a.latitude,
          a.longitude,
        );
        final distanceB = Geolocator.distanceBetween(
          userLocation.position!.latitude,
          userLocation.position!.longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      if (userPreviousAdventures != null && userPreviousAdventures.isNotEmpty) {
        nearbyAdventures.removeWhere(
          (adventure) => userPreviousAdventures.any(
            (userAdventure) {
              if (userAdventure.adventureId != adventure.id) {
                return false;
              }
              if (userAdventure.completedAt == null &&
                  userAdventure.hoursToCompleteAgain == null) {
                return true;
              }
              final completedAt = userAdventure.completedAt!;
              final hoursToComplete = userAdventure.hoursToCompleteAgain!;
              final expirationTime =
                  completedAt.add(Duration(hours: hoursToComplete));
              return DateTime.now().isBefore(expirationTime);
            },
          ),
        );
      }

      if (nearbyAdventures.isNotEmpty) {
        yield nearbyAdventures;
      } else {
        yield [];
      }
    } catch (e, stackTrace) {
      debugPrint('Error in nearbyAdventuresProvider: $e\n$stackTrace');
      yield adventures; // Only yield if adventures is non-empty
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
