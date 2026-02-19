import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';
import '../../infrastructure/services/firebase_place_crud_service.dart';
import '../notifiers/paginated_places_notifier.dart';
import 'location_providers.dart';

final placeCrudServiceProvider = Provider<PlaceCrudService>((ref) {
  return FirebasePlaceCrudService();
});

final nearbyPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final placeCrudService = ref.watch(placeCrudServiceProvider);
  final locationState = ref.watch(locationProvider);

  final places = await placeCrudService.readByFilters([
    {'field': 'status', 'operator': '==', 'value': 'active'},
  ]);

  if (places == null || places.isEmpty) {
    return [];
  }

  final activePlaces = places;

  // Filter and sort by distance if user location is available
  if (locationState.position != null) {
    final userPosition = locationState.position!;
    const maxDistanceInMiles = 20.0;
    const metersPerMile = 1609.34;
    const maxDistanceInMeters = maxDistanceInMiles * metersPerMile;

    // Filter places within 20-mile radius
    final nearbyPlaces = activePlaces.where((place) {
      final distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        place.geo['lat']!,
        place.geo['lng']!,
      );
      return distance <= maxDistanceInMeters;
    }).toList();

    // Sort by distance (nearest to farthest)
    nearbyPlaces.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        a.geo['lat']!,
        a.geo['lng']!,
      );

      final distanceB = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        b.geo['lat']!,
        b.geo['lng']!,
      );

      return distanceA.compareTo(distanceB);
    });

    return nearbyPlaces;
  }

  return activePlaces;
});

final allPlacesProvider = FutureProvider.autoDispose<List<Place>>((ref) async {
  final placeCrudService = ref.watch(placeCrudServiceProvider);

  final places = await placeCrudService.readByFilters([
    {'field': 'status', 'operator': '==', 'value': 'active'},
  ]);

  return places ?? [];
});

final paginatedPlacesProvider =
    StateNotifierProvider<PaginatedPlacesNotifier, PaginatedPlacesState>(
  (ref) {
    final placeCrudService = ref.watch(placeCrudServiceProvider);
    return PaginatedPlacesNotifier(placeCrudService);
  },
);
