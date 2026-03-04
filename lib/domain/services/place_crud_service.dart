import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/place.dart';
import 'crud_service.dart';

abstract class PlaceCrudService extends CrudService<Place> {
  String generateId();

  Future<List<Place>> fetchNearby({
    required GeoPoint center,
    required double radiusInKm,
  });

  Future<List<Place>> fetchForYou(List<String> interestIds);
}
