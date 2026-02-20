import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../../utils/location_utils.dart';
import '../pages/place_detail.dart';
import 'carousel_card.dart';

class PlaceCard extends ConsumerWidget {
  final Place item;
  final bool isInGrid;

  const PlaceCard(
    this.item, {
    super.key,
    this.isInGrid = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    final distance = formatDistance(location, item.geo['lat']!, item.geo['lng']!);
    final imageUrl = item.imageUrls.isNotEmpty ? item.imageUrls.first : null;
    final heroTag = 'place-image-${item.placeId}-${isInGrid ? 'grid' : 'carousel'}';

    return CarouselCard(
      imageUrl: imageUrl,
      title: item.name,
      heroTag: heroTag,
      width: isInGrid ? null : 160,
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
                  distance,
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
                  item.location ?? 'San Juan, PR',
                  style: bodySmallStyle.copyWith(
                    fontSize: 12,
                    color: context.colors.textSecondary.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  distance,
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
