import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import 'carousel_card.dart';

class QuestsCarouselCard extends ConsumerWidget {
  final Quest quest;
  const QuestsCarouselCard(this.quest, {super.key});

  String _getDistance(WidgetRef ref) {
    final location = ref.watch(locationProvider);
    if (location.position != null &&
        quest.stepLatitude != null &&
        quest.stepLongitude != null) {
      final distance = Geolocator.distanceBetween(
        location.position!.latitude,
        location.position!.longitude,
        quest.stepLatitude!,
        quest.stepLongitude!,
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
      imageUrl: quest.imageUrl,
      title: quest.title,
      heroTag: 'quest-image-${quest.id}-carousel',
      onTap: () {
        // TODO: Navigate to quest detail page
        showXploraSnackBar(context, 'TODO: Implement quest detail page for ${quest.title}', isInfo: true);
      },
      bottomContent: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: textPrimary,
                  size: 12,
                ),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '${quest.experience.toInt()} XP',
                    style: bodyTextStyle.copyWith(
                      fontSize: 11,
                      color: textPrimary,
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
                  color: textPrimary,
                  size: 12,
                ),
                Flexible(
                  child: Text(
                    _getDistance(ref),
                    style: bodyTextStyle.copyWith(
                      fontSize: 11,
                      color: textPrimary,
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
