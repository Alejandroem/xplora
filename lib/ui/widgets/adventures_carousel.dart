import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import 'adventures_carousel_card.dart';
import 'bouncing_carousel.dart';
import 'smooth_filter_scroll_row.dart';

// Provider for selected filter
final selectedCarouselFilterProvider = StateProvider<String>((ref) => 'Nearby');

class NearestAdventures extends ConsumerStatefulWidget {
  const NearestAdventures({super.key});

  @override
  ConsumerState<NearestAdventures> createState() => _NearestAdventuresState();
}

class _NearestAdventuresState extends ConsumerState<NearestAdventures> {
  @override
  Widget build(BuildContext context) {
    // Check if location tracking is enabled (user granted permission through custom dialog)
    final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);

    if (!locationTrackingEnabled) {
      return const SizedBox
          .shrink(); // Don't show carousel if location tracking not enabled
    }

    final selectedFilter = ref.watch(selectedCarouselFilterProvider);
    final filters = ['Nearby', 'For You', 'Following'];

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Row(
              children: [
                Text(
                  'Places',
                  style: h2Style,
                ),
                const Spacer(),
              ],
            ),
          ),
          // Filter Bubble Row
          Padding(
            padding: const EdgeInsets.only(bottom: spacing8),
            child: SmoothFilterScrollRow(
              filters: filters,
              selectedFilter: selectedFilter,
              onFilterTap: (filter) {
                ref.read(selectedCarouselFilterProvider.notifier).state =
                    filter;
              },
            ),
          ),
          SizedBox(
            height: 200,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(nearbyAdventuresProvider).when(
                      data: (adventures) {
                        // TODO: Implement 'For You' and 'Following' filter logic
                        // For now, all filters use nearby adventures
                        // selectedFilter can be used here to implement different logic

                        if (adventures.isNotEmpty) {
                          const maxCards = 20;
                          final displayedAdventures =
                              adventures.take(maxCards).toList();
                          final hasMore = adventures.length > maxCards;

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
                              'No adventures found nearby',
                              style:
                                  bodyTextStyle.copyWith(color: context.colors.textSecondary),
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



