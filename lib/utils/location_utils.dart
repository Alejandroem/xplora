import 'package:geolocator/geolocator.dart';

import '../application/providers/location_providers.dart';

String formatDistance(LocationState location, double lat, double lng) {
  if (location.position == null) return '- mi. away';

  final distance = Geolocator.distanceBetween(
    location.position!.latitude,
    location.position!.longitude,
    lat,
    lng,
  );
  final miles = distance / 1609.34;
  if (miles < 0.1) {
    return '${(distance * 3.28084).toStringAsFixed(0)} ft. away';
  } else {
    return '${miles.toStringAsFixed(1)} mi. away';
  }
}
