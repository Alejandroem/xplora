import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../pages/place_detail.dart';
import 'carousel_card.dart';

class PlaceCard extends ConsumerWidget {
  final dynamic item; // Can be either Place or Adventure
  final bool isInGrid;

  const PlaceCard(
    this.item, {
    super.key,
    this.isInGrid = false,
  });

  bool get _isPlace => item is Place;
  bool get _isAdventure => item is Adventure;

  String _getDistance(WidgetRef ref) {
    final location = ref.watch(locationProvider);
    if (location.position != null) {
      double lat, lng;

      if (_isPlace) {
        final place = item as Place;
        lat = place.geo['lat']!;
        lng = place.geo['lng']!;
      } else if (_isAdventure) {
        final adventure = item as Adventure;
        lat = adventure.latitude;
        lng = adventure.longitude;
      } else {
        return '--';
      }

      final distance = Geolocator.distanceBetween(
        location.position!.latitude,
        location.position!.longitude,
        lat,
        lng,
      );
      // Convert meters to miles (1 mile = 1609.34 meters)
      final miles = distance / 1609.34;
      if (miles < 0.1) {
        return '${(distance * 3.28084).toStringAsFixed(0)} ft. away';
      } else {
        return '${miles.toStringAsFixed(1)} mi. away';
      }
    }
    return '--';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? imageUrl;
    String title;
    String heroTag;
    String? subtitle;

    if (_isPlace) {
      final place = item as Place;
      imageUrl = place.imageUrls.isNotEmpty
          ? place.imageUrls.first
          : null;
      title = place.name;
      heroTag = 'place-image-${place.placeId}-${isInGrid ? 'grid' : 'carousel'}';
      subtitle = place.location;
    } else if (_isAdventure) {
      final adventure = item as Adventure;
      imageUrl = adventure.imageUrl;
      title = adventure.title;
      heroTag = 'adventure-image-${adventure.id}-${isInGrid ? 'grid' : 'carousel'}';
      subtitle = null; // Adventures don't have address, using hardcoded value below
    } else {
      // Fallback
      imageUrl = 'https://via.placeholder.com/300x200';
      title = 'Unknown';
      heroTag = 'unknown-${isInGrid ? 'grid' : 'carousel'}';
      subtitle = null;
    }

    return CarouselCard(
      imageUrl: imageUrl,
      title: title,
      heroTag: heroTag,
      width: isInGrid ? null : 160,
      // For grid: use expandImage to fill available space
      // For carousel: use fixed height
      expandImage: isInGrid,
      imageHeight: isInGrid ? null : 130,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetail(
              isInGrid ? 'grid' : 'carousel',
              item,
            ),
          ),
        );
      },
      bottomContent: isInGrid
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getDistance(ref),
                  style: bodySmallStyle.copyWith(
                    fontSize: 12,
                    color: context.colors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle ?? 'San Juan, PR',
                  style: bodySmallStyle.copyWith(
                    fontSize: 12,
                    color: context.colors.textSecondary.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getDistance(ref),
                  style: bodySmallStyle.copyWith(
                    fontSize: 12,
                    color: context.colors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
    );
  }
}
