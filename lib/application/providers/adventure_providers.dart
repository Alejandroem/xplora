import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/adventure_in_progress.dart';
import '../../domain/services/adventure_crud_service.dart';
import '../../infrastructure/services/firebase_adventure_crud_service.dart';
import '../notifiers/adventure_in_progress.dart';
import 'auth_providers.dart';

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

final adventureInProgressTrackerProvider = StateNotifierProvider.autoDispose<
    AdventureInProgressNotifier, AdventureInProgress?>((ref) {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  return AdventureInProgressNotifier(adventureCrudService, authService);
});
