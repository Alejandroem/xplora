import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../components/feed_components.dart';
import 'adventures_carousel_card.dart';
import 'bouncing_carousel.dart';
import 'filter_bubble.dart';

class NearestAdventures extends ConsumerWidget {
  const NearestAdventures({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);

    // Check if location tracking is enabled (user granted permission through custom dialog)
    final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);

    if (!locationTrackingEnabled) {
      return const SizedBox
          .shrink(); // Don't show carousel if location tracking not enabled
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Row(
              children: [
                Text(
                  'Places',
                  style: h2Style.copyWith(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(nearbyAdventuresProvider).when(
                      data: (adventures) {
                        // Filter adventures based on selected activity types
                        List<Adventure> filteredAdventures = adventures;

                        if (selectedActivityTypes.isNotEmpty) {
                          filteredAdventures = adventures
                              .where((adventure) =>
                                  selectedActivityTypes.contains(adventure.category))
                              .toList();
                        }

                        // TODO: Implement 'For You' and 'Following' filter logic
                        // For now, all filters use nearby adventures
                        // selectedFilter can be used here to implement different logic

                        if (filteredAdventures.isNotEmpty) {
                          const maxCards = 20;
                          final displayedAdventures =
                              filteredAdventures.take(maxCards).toList();
                          final hasMore = filteredAdventures.length > maxCards;

                          return GenericBouncingCarousel<Adventure>(
                            items: displayedAdventures,
                            itemBuilder: (adventure, index) =>
                                AdventuresCarouselCard(adventure),
                            hasMore: hasMore,
                            onSeeMoreTap: () {
                              ref
                                  .read(bottomNavigationBarProvider.notifier)
                                  .state = NavigationItem.search;
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              selectedActivityTypes.isNotEmpty
                                  ? 'No adventures found for selected activity types'
                                  : 'No adventures found nearby',
                              style:
                                  bodyTextStyle.copyWith(color: textSecondary),
                            ),
                          );
                        }
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                      error: (error, stack) => Center(
                        child: Text(
                          'Error: $error',
                          style: bodyTextStyle.copyWith(color: errorColor),
                        ),
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}



