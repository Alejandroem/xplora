import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/quest.dart';
import '../../domain/models/quest_in_progress.dart';
import '../../domain/services/xplora_quest_crud_service.dart';
import '../../infrastructure/services/firebase_xplora_quest_crud_service.dart';
import '../notifiers/quest_validator_notifier.dart';
import 'achievements_providers.dart';
import 'auth_providers.dart';
import 'location_providers.dart';
import 'xplorauser_providers.dart';

final questCrudServiceProvider = Provider<XploraQuestCrudService>((ref) {
  return FirebaseXploraQuestCrudService();
});

final nearbyQuestProvider = StreamProvider<List<Quest>>((ref) async* {
  final questCrudService = ref.watch(questCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  // Stream all available quests that are not associated with any user
  final allAvailableQuestsStream = questCrudService.streamByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);

  await for (final allAvailableQuests in allAvailableQuestsStream) {
    if (allAvailableQuests == null || allAvailableQuests.isEmpty) {
      continue; // Skip yield if no quests are available
    }

    try {
      final userLocation = ref.watch(locationProvider);
      if (userLocation.isLoading || userLocation.position == null) {
        yield allAvailableQuests;
        continue;
      }

      final isSignedIn = await authService.isSignedInFuture();
      if (!isSignedIn) {
        yield allAvailableQuests;
        continue;
      }

      final user = await authService.getAuthUser();
      if (user == null) {
        yield allAvailableQuests;
        continue;
      }

      final userPreviousQuests = await questCrudService.readByFilters([
            {
              'field': 'userId',
              'operator': '==',
              'value': user.id,
            },
          ]) ??
          [];

      List<Quest> filteredQuests = List.from(allAvailableQuests);
      if (userPreviousQuests.isNotEmpty) {
        filteredQuests.removeWhere((quest) => userPreviousQuests
            .any((userQuest) => userQuest.questId == quest.id));
      }

      // Only yield if filteredQuests is non-empty
      if (filteredQuests.isNotEmpty) {
        yield filteredQuests;
      }
    } catch (e, stackTrace) {
      log('Error in nearbyQuestProvider: $e\n$stackTrace');
      // Yield allAvailableQuests only if it's non-empty
      if (allAvailableQuests.isNotEmpty) {
        yield allAvailableQuests;
      }
    }
  }
});

final userPreviousQuestProvider = FutureProvider<List<Quest>>((ref) async {
  final questCrudService = ref.watch(questCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  if (!await authService.isSignedInFuture()) {
    return [];
  }

  final user = await authService.getAuthUser();
  if (user == null) {
    return [];
  }

  List<Quest> userPreviousQuest = await questCrudService.readByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': user.id,
        },
      ]) ??
      [];

  return userPreviousQuest;
});

final questInProgressTrackerProvider =
    StateNotifierProvider<QuestValidatorNotifier, QuestInProgress?>((ref) {
  return QuestValidatorNotifier(
    ref,
    ref.watch(questCrudServiceProvider),
    ref.watch(profileServiceProvider),
    ref.watch(achievementsServiceProvider),
    ref.watch(authServiceProvider),
  );
});
