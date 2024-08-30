import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/quest.dart';
import '../../domain/models/quest_step.dart';
import '../../domain/services/xplora_quest_crud_service.dart';
import '../../domain/services/xplora_quest_step_crud_service.dart';
import '../../infrastructure/services/firebase_xplora_quest_crud_service.dart';
import '../../infrastructure/services/firebase_xplora_quest_step_crud_service.dart';

final questCrudServiceProvider = Provider<XploraQuestCrudService>((ref) {
  return FirebaseXploraQuestCrudService();
});

final questStepCrudServiceProvider =
    Provider<XploraQuestStepCrudService>((ref) {
  return FirebaseXploraQuestStepCrudService();
});

final currentQuestForUserProvider =
    StreamProvider.family<Quest?, String>((ref, userId) {
  final questCrudService = ref.watch(questCrudServiceProvider);
  return questCrudService.streamByFilters([
    {
      'field': 'isActive',
      'operator': '==',
      'value': true,
    },
    {
      'field': 'userId',
      'operator': '==',
      'value': userId,
    }
  ]).map((quests) {
    if (quests?.isEmpty ?? true) {
      return null;
    }
    return quests!.first;
  });
});

final currentStepFromQuestProvider =
    StreamProvider.family<QuestStep?, String>((ref, userId) {
  final questCrudService = ref.watch(questCrudServiceProvider);
  return questCrudService.streamByFilters([
    {
      'field': 'isActive',
      'operator': '==',
      'value': true,
    },
    {
      'field': 'userId',
      'operator': '==',
      'value': userId,
    }
  ]).map((quests) {
    if (quests?.isEmpty ?? true) {
      return null;
    }
    return quests!.first.steps
        .where(
          (step) => !(step.completed ?? false),
        )
        .first;
  });
});
