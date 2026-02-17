import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebasePlaceCrudService extends FirebaseCrudService<Place>
    implements PlaceCrudService {
  FirebasePlaceCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('places')
              .withConverter<Place>(
                fromFirestore: (snapshot, _) => Place.fromJson(
                    {...snapshot.data()!, 'placeId': snapshot.id}),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
