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

final nearbyQuestProvider = FutureProvider<List<Quest>?>((ref) async {
  final questCrudService = ref.watch(questCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

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

  List<Quest>? allAvailableQuests = await questCrudService.readByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);

  if (allAvailableQuests == null || allAvailableQuests.isEmpty) {
    return null;
  }

  final userLocation = await location.getLocation();

  if (userLocation.latitude == null || userLocation.longitude == null) {
    return allAvailableQuests;
  }

  if (!await authService.isSignedInFuture()) {
    return allAvailableQuests;
  }

  final user = await authService.getAuthUser();
  if (user == null) {
    return allAvailableQuests;
  }

  List<Quest>? userPreviousQuest = await questCrudService.readByFilters([
    {
      'field': 'userId',
      'operator': '==',
      'value': user.id,
    },
  ]);

  if (userPreviousQuest != null && userPreviousQuest.isNotEmpty) {
    allAvailableQuests.removeWhere((quest) =>
        userPreviousQuest.any((userQuest) => userQuest.questId == quest.id));
  }

  return [
    ...allAvailableQuests,
    ...?userPreviousQuest,
  ];
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
