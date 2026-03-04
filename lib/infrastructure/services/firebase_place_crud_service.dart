import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geolocator/geolocator.dart';

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
                // Denormalized flat list of all category IDs from all
                // selection paths — used for server-side "For You" queries.
                'categoryIds': entity.categorySelections
                    .expand((sel) => sel.path)
                    .toSet()
                    .toList(),
              },
              ),
        );

  @override
  String generateId() => collection.doc().id;

  @override
  Future<List<Place>> fetchNearby({
    required GeoPoint center,
    required double radiusInKm,
  }) async {
    final snapshots = await GeoCollectionReference<Place>(collection).fetchWithin(
      center: GeoFirePoint(center),
      radiusInKm: radiusInKm,
      field: 'geo',
      geopointFrom: (place) => place.geo['geopoint'] as GeoPoint,
      queryBuilder: (query) => query.where('status', isEqualTo: 'active'),
      strictMode: true,
    );

    return snapshots.map((s) => s.data()).whereType<Place>().toList();
  }

  @override
  Future<List<Place>> fetchForYou(List<String> interestIds) async {
    final querySnapshot = await collection
        .where('status', isEqualTo: 'active')
        .where('categoryIds', arrayContainsAny: interestIds)
        .limit(100)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

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
