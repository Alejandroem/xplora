import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/setting.dart';
import '../../domain/services/settings_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseSettingsCrudService extends FirebaseCrudService<Setting>
    implements SettingsCrudService {
  FirebaseSettingsCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('settings')
              .withConverter<Setting>(
                fromFirestore: (snapshot, _) =>
                    Setting.fromJson({...snapshot.data()!, 'id': snapshot.id}),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
