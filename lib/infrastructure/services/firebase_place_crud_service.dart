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
                toFirestore: (entity, _) => {
                ...entity.toJson(),
                // json_serializable doesn't call .toJson() on nested objects
                // without explicitToJson:true, so we fix it manually here.
                'categorySelections': entity.categorySelections
                    .map((e) => e.toJson())
                    .toList(),
              },
              ),
        );

  @override
  String generateId() => collection.doc().id;

  @override
  Future<List<Place>?> readPaginated({
    required int limit,
    Place? startAfter,
    List<Map<String, dynamic>>? filters,
  }) async {
    var query = filters != null && filters.isNotEmpty
        ? getQueryFromFilters(filters)
        : collection as Query<Place>;

    query = query.orderBy(FieldPath.documentId);

    if (startAfter != null) {
      final docId = startAfter.placeId;
      if (docId != null) {
        final docSnapshot = await collection.doc(docId).get();
        if (docSnapshot.exists) {
          query = query.startAfterDocument(docSnapshot);
        }
      }
    }

    query = query.limit(limit);
    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
