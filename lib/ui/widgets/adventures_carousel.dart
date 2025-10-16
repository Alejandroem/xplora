import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import 'adventures_carousel_card.dart';

// Provider for selected filter
final selectedCarouselFilterProvider = StateProvider<String>((ref) => 'Nearby');

// Provider for selected activity type
final selectedActivityTypeProvider = StateProvider<String?>((ref) => null);

class NearestAdventures extends ConsumerWidget {
  const NearestAdventures({super.key});

  void _showActivityTypesModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
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
                      children: [
                        // Clear filter option
                        FilterBubble(
                          text: 'All Types',
                          isSelected:
                              ref.watch(selectedActivityTypeProvider) == null,
                          onTap: () {
                            ref
                                .read(selectedActivityTypeProvider.notifier)
                                .state = null;
                            Navigator.pop(context);
                          },
                        ),
                        ...categories
                            .where((c) => c.name != 'All')
                            .map((category) {
                          final isSelected =
                              ref.watch(selectedActivityTypeProvider) ==
                                  category.id;
                          return FilterBubble(
                            text: category.name,
                            isSelected: isSelected,
                            onTap: () {
                              ref
                                  .read(selectedActivityTypeProvider.notifier)
                                  .state = category.id;
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error',
                      style: TextStyle(color: textPrimary)),
                ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedCarouselFilterProvider);
    final selectedActivityType = ref.watch(selectedActivityTypeProvider);
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
                      text: 'Specific Activity Types',
                      isSelected: selectedActivityType != null,
                      onTap: () => _showActivityTypesModal(context, ref),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 18,
                        color: selectedActivityType != null
                            ? textPrimary
                            : textPrimary,
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
                        // Filter adventures based on selected activity type
                        List<Adventure> filteredAdventures = adventures;

                        if (selectedActivityType != null) {
                          filteredAdventures = adventures
                              .where((adventure) =>
                                  adventure.category == selectedActivityType)
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

                          return ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...displayedAdventures.map(
                                (adventure) => AdventuresCarouselCard(
                                  adventure,
                                ),
                              ),
                              if (hasMore)
                                InkWell(
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
                                              Icons.search,
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
                                )
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              selectedActivityType != null
                                  ? 'No adventures found for this activity type'
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
