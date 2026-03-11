import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/validation_config.dart';
import '../../domain/services/validation_config_service.dart';
import 'firebase_crud_service.dart';

class FirebaseValidationConfigService extends FirebaseCrudService<ValidationConfig>
    implements ValidationConfigService {
  FirebaseValidationConfigService()
      : super(
          FirebaseFirestore.instance
              .collection('validationConfigs')
              .withConverter<ValidationConfig>(
                fromFirestore: (snap, _) =>
                    ValidationConfig.fromJson({...snap.data()!, 'id': snap.id}),
                toFirestore: (e, _) => e.toJson()..remove('id'),
              ),
        );
}
