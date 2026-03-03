import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';
import '../../infrastructure/services/firebase_place_crud_service.dart';
import '../notifiers/paginated_places_notifier.dart';
import 'auth_service_providers.dart';
import 'location_providers.dart';

final placeCrudServiceProvider = Provider<PlaceCrudService>((ref) {
  return FirebasePlaceCrudService();
});

final nearbyPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final placeCrudService = ref.watch(placeCrudServiceProvider);
  final position = ref.watch(locationProvider).position;
  if (position == null) return [];

  const radiusInKm = 3.0 * 1.60934; // 3 miles → km
  final center = GeoPoint(position.latitude, position.longitude);

  final places = await placeCrudService.fetchNearby(
    center: center,
    radiusInKm: radiusInKm,
  );

  // Sort by distance (nearest to farthest) — required since geohash queries
  // return results from multiple range buckets with no inherent distance order.
  places.sort((a, b) {
    final geopointA = a.geo['geopoint'] as GeoPoint;
    final distanceA = Geolocator.distanceBetween(
      position.latitude, position.longitude,
      geopointA.latitude, geopointA.longitude,
    );
    final geopointB = b.geo['geopoint'] as GeoPoint;
    final distanceB = Geolocator.distanceBetween(
      position.latitude, position.longitude,
      geopointB.latitude, geopointB.longitude,
    );
    return distanceA.compareTo(distanceB);
  });

  return places;
});

final allPlacesProvider = FutureProvider.autoDispose<List<Place>>((ref) async {
  final placeCrudService = ref.watch(placeCrudServiceProvider);

  final places = await placeCrudService.readByFilters([
    {'field': 'status', 'operator': '==', 'value': 'active'},
  ]);

  return places ?? [];
});

final userSubmissionsProvider = FutureProvider.autoDispose<List<Place>>((ref) async {
  final authService = ref.read(authServiceProvider);
  final userId = (await authService.getAuthUser())?.id;
  if (userId == null) return [];

  final placeCrudService = ref.read(placeCrudServiceProvider);
  final places = await placeCrudService.readByFilters(
    [
      {'field': 'userId', 'operator': '==', 'value': userId},
      {'field': 'source', 'operator': '==', 'value': 'user_contribution'},
    ],
    orderBy: 'createdAt',
    descending: true,
  );

  return places ?? [];
});

final paginatedPlacesProvider =
    StateNotifierProvider<PaginatedPlacesNotifier, PaginatedPlacesState>(
  (ref) {
    final placeCrudService = ref.watch(placeCrudServiceProvider);
    return PaginatedPlacesNotifier(placeCrudService);
  },
);
