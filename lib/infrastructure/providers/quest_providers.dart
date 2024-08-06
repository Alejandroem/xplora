import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/xplora_quest_crud_service.dart';
import '../../domain/services/xplora_quest_step_crud_service.dart';
import '../services/firebase_xplora_quest_crud_service.dart';
import '../services/firebase_xplora_quest_step_crud_service.dart';

final questCrudServiceProvider = Provider<XploraQuestCrudService>((ref) {
  return FirebaseXploraQuestCrudService();
});

final questStepCrudServiceProvider =
    Provider<XploraQuestStepCrudService>((ref) {
  return FirebaseXploraQuestStepCrudService();
});
