import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import 'adventures_carousel_card.dart';

// Provider for selected filter
final selectedCarouselFilterProvider = StateProvider<String>((ref) => 'Nearby');

// Provider for selected activity types (multiple)
final selectedActivityTypesProvider = StateProvider<List<String>>((ref) => []);

class NearestAdventures extends ConsumerWidget {
  const NearestAdventures({super.key});

  void _showActivityTypesModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
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
                        style: h3Style.copyWith(color: textPrimary),
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
                            final isSelected = selectedTypes.contains(category.id);
                            return FilterBubble(
                              text: category.name,
                              isSelected: isSelected,
                              onTap: () {
                                final currentTypes = ref.read(selectedActivityTypesProvider);
                                if (isSelected) {
                                  // Remove from selection
                                  ref.read(selectedActivityTypesProvider.notifier).state =
                                      currentTypes.where((id) => id != category.id).toList();
                                } else {
                                  // Add to selection
                                  ref.read(selectedActivityTypesProvider.notifier).state =
                                      [...currentTypes, category.id];
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
                if(selectedTypes.isNotEmpty)
                  ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: SecondaryButton(
                        text: 'Clear all',
                        onPressed: (){
                          ref
                              .read(selectedActivityTypesProvider.notifier)
                              .state = [];
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
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedCarouselFilterProvider);
    final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);
    final filters = ['Nearby', 'For You', 'Following'];

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
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Row(
              children: [
                Text(
                  'Nearby Places',
                  style: h2Style.copyWith(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const Spacer(),
              ],
            ),
          ),
          // Filter Bubble Row
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 2, 8.0, 12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterBubble(
                        text: filter,
                        isSelected: isSelected,
                        onTap: () {
                          ref
                              .read(selectedCarouselFilterProvider.notifier)
                              .state = filter;
                        },
                      ),
                    );
                  }),
                  // Activity Types dropdown bubble
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterBubble(
                      text: selectedActivityTypes.isEmpty
                          ? 'Selected Activity Types'
                          : 'Selected Activity Types (${selectedActivityTypes.length})',
                      isSelected: selectedActivityTypes.isNotEmpty,
                      onTap: () => _showActivityTypesModal(context, ref),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: textPrimary,
                      ),
                      iconAtEnd: true,
                    ),
                  ),
                ],
              ),
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
                          final itemCount = displayedAdventures.length + (hasMore ? 1 : 0);

                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              // Show "See more" card at the end if hasMore
                              if (index == displayedAdventures.length && hasMore) {
                                return InkWell(
                                  onTap: () {
                                    ref
                                        .read(bottomNavigationBarProvider
                                            .notifier)
                                        .state = NavigationItem.search;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GlassContainer(
                                      borderRadius: 12,
                                      padding: const EdgeInsets.all(16.0),
                                      child: SizedBox(
                                        width: 130,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: accentSecondary,
                                              size: 40,
                                            ),
                                            Text(
                                              'See more',
                                              style:
                                                  subHeadingLabelStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Return adventure card
                              return AdventuresCarouselCard(
                                displayedAdventures[index],
                              );
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
                          style: bodyTextStyle.copyWith(color: feedbackAlert),
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
