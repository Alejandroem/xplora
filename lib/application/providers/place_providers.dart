import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';
import '../../infrastructure/services/firebase_place_crud_service.dart';
import '../notifiers/paginated_places_notifier.dart';
import 'auth_providers.dart';
import 'auth_service_providers.dart';
import 'location_providers.dart';

final placeCrudServiceProvider = Provider<PlaceCrudService>((ref) {
  return FirebasePlaceCrudService();
});

final nearbyPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final placeCrudService = ref.watch(placeCrudServiceProvider);
  final locationState = ref.watch(locationProvider);
  final currentUserId = (await ref.read(authServiceProvider).getAuthUser())?.id;

  final places = await placeCrudService.readByFilters([
    {'field': 'status', 'operator': '==', 'value': 'active'},
  ]);

  if (places == null || places.isEmpty) {
    return [];
  }

  // Exclude the current user's own submissions
  final activePlaces = currentUserId != null
      ? places.where((p) => p.userId != currentUserId).toList()
      : places;

  // Filter and sort by distance if user location is available
  if (locationState.position != null) {
    final userPosition = locationState.position!;
    const maxDistanceInMiles = 3.0;
    const metersPerMile = 1609.34;
    const maxDistanceInMeters = maxDistanceInMiles * metersPerMile;

    // Filter places within 3-mile radius
    final nearbyPlaces = activePlaces.where((place) {
      final geopoint = place.geo['geopoint'] as GeoPoint;
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        geopoint.latitude,
        geopoint.longitude,
      );
      return distance <= maxDistanceInMeters;
    }).toList();

    // Sort by distance (nearest to farthest)
    nearbyPlaces.sort((a, b) {
      final geopointA = a.geo['geopoint'] as GeoPoint;
      final distanceA = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        geopointA.latitude,
        geopointA.longitude,
      );

      final geopointB = b.geo['geopoint'] as GeoPoint;
      final distanceB = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        geopointB.latitude,
        geopointB.longitude,
      );

      return distanceA.compareTo(distanceB);
    });

    return nearbyPlaces;
  }

  return activePlaces;
});

final allPlacesProvider = FutureProvider.autoDispose<List<Place>>((ref) async {
  final placeCrudService = ref.watch(placeCrudServiceProvider);
  final currentUserId = (await ref.read(authServiceProvider).getAuthUser())?.id;

  final places = await placeCrudService.readByFilters([
    {'field': 'status', 'operator': '==', 'value': 'active'},
  ]);

  if (places == null) return [];

  // Exclude the current user's own submissions
  if (currentUserId != null) {
    return places.where((p) => p.userId != currentUserId).toList();
  }

  return places;
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
