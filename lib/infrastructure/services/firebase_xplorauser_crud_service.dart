import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_crud_service.dart';

import '../../domain/models/xplora_user.dart';
import '../../domain/services/xplorauser_crud_service.dart';

class FirebaseXplorauserCrudService extends FirebaseCrudService<XploraUser>
    implements XploraUserService {
  FirebaseXplorauserCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('users')
              .withConverter<XploraUser>(
                fromFirestore: (snapshot, _) =>
                    XploraUser.fromJson(snapshot.data()!),
                toFirestore: (user, _) => user.toJson(),
              ),
        );
}
