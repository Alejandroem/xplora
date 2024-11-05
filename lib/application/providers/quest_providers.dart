import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

import '../../domain/models/quest.dart';
import '../../domain/models/quest_in_progress.dart';
import '../../domain/services/xplora_quest_crud_service.dart';
import '../../infrastructure/services/firebase_xplora_quest_crud_service.dart';
import '../notifiers/quest_validator_notifier.dart';
import 'auth_providers.dart';

final questCrudServiceProvider = Provider<XploraQuestCrudService>((ref) {
  return FirebaseXploraQuestCrudService();
});

final nearbyQuestProvider =
    StreamProvider.autoDispose<List<Quest>>((ref) async* {
  final questCrudService = ref.watch(questCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final location = Location();

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
      bool serviceEnabled =
          await location.serviceEnabled() || await location.requestService();
      if (!serviceEnabled) {
        yield allAvailableQuests;
        continue;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
      }
      if (permissionGranted != PermissionStatus.granted) {
        yield allAvailableQuests;
        continue;
      }

      final userLocation = await location.getLocation();
      if (userLocation.latitude == null || userLocation.longitude == null) {
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
    ref.watch(authServiceProvider),
  );
});
