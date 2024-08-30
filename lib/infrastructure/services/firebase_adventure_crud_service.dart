import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/adventure.dart';
import '../../domain/services/adventure_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseAdventureCrudService extends FirebaseCrudService<Adventure>
    implements AdventureCrudService {
  FirebaseAdventureCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('adventures')
              .withConverter<Adventure>(
                fromFirestore: (snapshot, _) =>
                    Adventure.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
