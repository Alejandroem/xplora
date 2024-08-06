import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/quest.dart';
import '../../domain/services/xplora_quest_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseXploraQuestCrudService extends FirebaseCrudService<Quest>
    implements XploraQuestCrudService {
  FirebaseXploraQuestCrudService()
      : super(
          FirebaseFirestore.instance.collection('quests').withConverter<Quest>(
                fromFirestore: (snapshot, _) =>
                    Quest.fromJson(snapshot.data()!),
                toFirestore: (profile, _) => profile.toJson(),
              ),
        );
}
