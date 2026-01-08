import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../pages/adventure_detail.dart';
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
      if (distance < 1000) {
        return '${distance.toStringAsFixed(0)}m';
      } else {
        return '${(distance / 1000).toStringAsFixed(0)}km';
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
      width: isInGrid ? null : 150,
      // For grid: use expandImage to fill available space
      // For carousel: use fixed height
      expandImage: isInGrid,
      imageHeight: isInGrid ? null : 140,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdventureDetail(
              isInGrid ? 'grid' : 'carousel',
              adventure,
            ),
          ),
        );
      },
      bottomContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('City, State',
              style: bodySmallStyle.copyWith(
                fontSize: 12,
                color: context.colors.textSecondary,
              )),
          const SizedBox(height: spacing4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Category',
                  style: bodySmallStyle.copyWith(
                    fontSize: 13,
                    color: context.colors.textTertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: spacing4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      '+${adventure.experience.toInt()} XP',
                      style: xpNumberStyle.copyWith(
                        color: xpColor,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
