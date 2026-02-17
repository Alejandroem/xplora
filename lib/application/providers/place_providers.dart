import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';
import '../../infrastructure/services/firebase_place_crud_service.dart';

final placeCrudServiceProvider = Provider<PlaceCrudService>((ref) {
  return FirebasePlaceCrudService();
});

final nearbyPlacesProvider = StreamProvider<List<Place>>((ref) async* {
  final placeCrudService = ref.watch(placeCrudServiceProvider);

  // Stream all places from the places collection
  final allPlacesStream = placeCrudService.streamByFilters([]);

  await for (final places in allPlacesStream) {
    if (places == null || places.isEmpty) {
      yield [];
      continue;
    }

    // Filter to only show active places
    final activePlaces = places.where(
      (place) => place.status == 'active',
    ).toList();

    yield activePlaces;
  }
});
