import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../components/feed_components.dart';
import 'adventures_carousel_card.dart';
import 'bouncing_carousel.dart';
import 'filter_bubble.dart';
import 'smooth_filter_scroll_row.dart';

class NearestAdventures extends ConsumerStatefulWidget {
  const NearestAdventures({super.key});

  @override
  ConsumerState<NearestAdventures> createState() => _NearestAdventuresState();
}

class _NearestAdventuresState extends ConsumerState<NearestAdventures> {
  Future<void> _showActivityTypesModal(
      BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selectedTypes = ref.watch(selectedActivityTypesProvider);

          return GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activity Types',
                        style: h3Style,
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                ref.watch(allCategories).when(
                      data: (categories) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories
                              .where((c) => c.name != 'All')
                              .map((category) {
                            final isSelected =
                                selectedTypes.contains(category.id);
                            return FilterBubble(
                              text: category.name,
                              isSelected: isSelected,
                              onTap: () {
                                final currentTypes =
                                    ref.read(selectedActivityTypesProvider);
                                if (isSelected) {
                                  // Remove from selection
                                  ref
                                          .read(selectedActivityTypesProvider
                                              .notifier)
                                          .state =
                                      currentTypes
                                          .where((id) => id != category.id)
                                          .toList();
                                } else {
                                  // Add to selection
                                  ref
                                      .read(selectedActivityTypesProvider
                                          .notifier)
                                      .state = [...currentTypes, category.id];
                                }
                              },
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error',
                          style: TextStyle(color: textPrimary)),
                    ),
                if (selectedTypes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                      text: 'Clear all',
                      onPressed: () {
                        ref.read(selectedActivityTypesProvider.notifier).state =
                            [];
                      },
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);

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
              selectedActivityTypes: selectedActivityTypes,
              onFilterTap: (filter) {
                ref.read(selectedCarouselFilterProvider.notifier).state =
                    filter;
              },
              onActivityTypesTap: () => _showActivityTypesModal(context, ref),
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



