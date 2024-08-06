import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/quest_step.dart';
import '../../domain/services/xplora_quest_step_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseXploraQuestStepCrudService extends FirebaseCrudService<QuestStep>
    implements XploraQuestStepCrudService {
  FirebaseXploraQuestStepCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('quest_steps')
              .withConverter<QuestStep>(
                fromFirestore: (snapshot, _) =>
                    QuestStep.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
