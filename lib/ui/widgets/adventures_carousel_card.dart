import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../pages/adventure_detail.dart';
import 'carousel_card.dart';

class AdventuresCarouselCard extends ConsumerWidget {
  final Adventure adventure;
  const AdventuresCarouselCard(this.adventure, {super.key});

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
      heroTag: 'adventure-image-${adventure.id}-carousel',
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AdventureDetail('carousel', adventure),
          ),
        );
      },
      bottomContent: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: context.colors.textPrimary,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '${adventure.experience.toInt()} XP',
                    style: bodyTextStyle.copyWith(
                      fontSize: 11,
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.location_on,
                  color: context.colors.textPrimary,
                  size: 12,
                ),
                Flexible(
                  child: Text(
                    _getDistance(ref),
                    style: bodyTextStyle.copyWith(
                      fontSize: 11,
                      color: context.colors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
