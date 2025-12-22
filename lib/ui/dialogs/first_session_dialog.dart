import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'base_dialog.dart';

/// First Session Dialog - Prompts user to try their first check-in
class FirstSessionDialog extends ConsumerWidget {
  const FirstSessionDialog({super.key});

  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m away';
    } else {
      final km = (distanceInMeters / 1000).toStringAsFixed(1);
      return '$km km away';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAdventures = ref.watch(nearbyAdventuresProvider);
    final userLocation = ref.watch(locationProvider);

    return BaseDialog(
      showCloseButton: true,
      icon: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accentPrimary.withOpacity(0.2),
          border: Border.all(
            color: accentPrimary.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.location_on_rounded,
          size: 50,
        ),
      ),
      title: 'Try your first check-in',
      description: 'Earn XP by checking in at a nearby place.',
      content: nearbyAdventures.when(
        data: (adventures) {
          if (adventures.isEmpty) {
            return const _NearbyPlaceCard(
              placeName: 'Explore your area',
              distance: 'No nearby places yet',
              imageUrl: null,
            );
          }

          final nearestAdventure = adventures.first;
          final distance = userLocation.position != null
              ? Geolocator.distanceBetween(
                  userLocation.position!.latitude,
                  userLocation.position!.longitude,
                  nearestAdventure.latitude,
                  nearestAdventure.longitude,
                )
              : null;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NearbyPlaceCard(
                placeName: nearestAdventure.title,
                distance: distance != null ? _formatDistance(distance) : '—',
                imageUrl: nearestAdventure.imageUrl,
              ),
            ],
          );
        },
        loading: () => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NearbyPlaceCard(
              placeName: 'Finding nearby places...',
              distance: '—',
              imageUrl: null,
            ),
          ],
        ),
        error: (_, __) => const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NearbyPlaceCard(
              placeName: 'Explore your area',
              distance: 'Error loading places',
              imageUrl: null,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            // Explore button
            Expanded(
              child: SecondaryButton(
                text: 'Explore',
                fontSize: 16,
                padding: const EdgeInsets.symmetric(vertical: 14),
                onPressed: () {
                  Navigator.of(context).pop('explore');
                },
              ),
            ),
            const SizedBox(width: 12),

            // Scan QR button
            Expanded(
              child: PrimaryButton(
                height: 50,
                onPressed: () {
                  Navigator.of(context).pop('scan_qr');
                },
                text: 'Scan QR',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Nearby place card widget
class _NearbyPlaceCard extends StatelessWidget {
  final String placeName;
  final String distance;
  final String? imageUrl;

  const _NearbyPlaceCard({
    required this.placeName,
    required this.distance,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Place image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accentSecondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Transform.scale(
                          scale: 0.5,
                          child: CircularProgressIndicator(
                            color: accentPrimary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.place_rounded,
                        size: 28,
                      ),
                    )
                  : const Icon(
                      Icons.explore_rounded,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Place details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  placeName,
                  style: subHeadingLabelStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.navigation_rounded,
                      color: textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: bodyTextStyle.copyWith(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to show the first session dialog
Future<String?> showFirstSessionDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const FirstSessionDialog();
    },
  );
}

/// Helper function to show the first session dialog if location is enabled
Future<void> showFirstSessionDialogIfLocationEnabled(
    BuildContext context, WidgetRef ref) async {
  final isLocationEnabled = ref.read(locationTrackingEnabledProvider);
  if (isLocationEnabled) {
    final overlayContext = Navigator.of(context).overlay?.context;
    if (overlayContext != null) {
      // Show dialog on previous screen after this screen is popped
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showFirstSessionDialog(overlayContext);
      });
    }
  }
}
