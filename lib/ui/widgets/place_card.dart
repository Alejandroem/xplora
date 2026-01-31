import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../pages/place_detail.dart';
import 'carousel_card.dart';

class PlaceCard extends ConsumerWidget {
  final Adventure adventure;
  final bool isInGrid;

  const PlaceCard(
    this.adventure, {
    super.key,
    this.isInGrid = false,
  });

  String _getDistance(WidgetRef ref) {
    final location = ref.watch(locationProvider);
    if (location.position != null) {
      final distance = Geolocator.distanceBetween(
        location.position!.latitude,
        location.position!.longitude,
        adventure.latitude,
        adventure.longitude,
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
    return CarouselCard(
      imageUrl: adventure.imageUrl,
      title: adventure.title,
      heroTag:
          'adventure-image-${adventure.id}-${isInGrid ? 'grid' : 'carousel'}',
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
              adventure,
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
                  'San Juan, PR',
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
