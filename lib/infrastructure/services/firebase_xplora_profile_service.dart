import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/xplora_profile_service.dart';
import 'firebase_crud_service.dart';

class FirebaseXploraProfileCrudService
    extends FirebaseCrudService<XploraProfile> implements XploraProfileService {
  FirebaseXploraProfileCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('profiles')
              .withConverter<XploraProfile>(
                fromFirestore: (snapshot, _) =>
                    XploraProfile.fromJson(snapshot.data()!),
                toFirestore: (profile, _) => profile.toJson(),
              ),
        );
}
