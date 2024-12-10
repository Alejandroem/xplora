import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/achievement.dart';
import '../../domain/services/achievements_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseAchievementsCrudService extends FirebaseCrudService<Achievement>
    implements AchievementsCrudService {
  FirebaseAchievementsCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('achievements')
              .withConverter<Achievement>(
                fromFirestore: (snapshot, _) =>
                    Achievement.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
