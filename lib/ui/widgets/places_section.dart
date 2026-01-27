import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import 'carousel_widget.dart';
import 'place_card.dart';
import 'smooth_filter_scroll_row.dart';

/*
// Provider for selected activity types (multiple)
final selectedActivityTypesProvider = StateProvider<List<String>>((ref) => []);
 */

// Provider for selected filter
final selectedCarouselFilterProvider = StateProvider<String>((ref) => 'Nearby');

class PlacesSection extends ConsumerStatefulWidget {
  const PlacesSection({super.key});

  @override
  ConsumerState<PlacesSection> createState() => _NearestAdventuresState();
}

class _NearestAdventuresState extends ConsumerState<PlacesSection> {
  /*
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
   */
  @override
  Widget build(BuildContext context) {
    // final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);

    // Check if location tracking is enabled (user granted permission through custom dialog)
    // final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);
    //
    // if (!locationTrackingEnabled) {
    //   return const SizedBox
    //       .shrink(); // Don't show carousel if location tracking not enabled
    // }

    final selectedFilter = ref.watch(selectedCarouselFilterProvider);
    final filters = ['Nearby', 'For You', 'Following'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(spacing16, spacing16, spacing16, 0),
          child: Text(
            'Places',
            style: h2Style,
          ),
        ),
        const SizedBox(height: spacing8),
        // Filter Bubble Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing16),
          child: SmoothFilterScrollRow(
            alignCenter: false,
            filters: filters,
            selectedFilter: selectedFilter,
            onFilterTap: (filter) {
              ref.read(selectedCarouselFilterProvider.notifier).state = filter;
            },
          ),
        ),
        const SizedBox(height: spacing16),
        Consumer(
          builder: (context, ref, child) {
            // Show "Coming soon" for 'For You' and 'Following' filters
            if (selectedFilter == 'For You' || selectedFilter == 'Following') {
              return SizedBox(
                height: 150,
                child: _buildComingSoon(
                  context: context,
                  icon: selectedFilter == 'For You'
                      ? Icons.auto_awesome
                      : Icons.people_outline,
                  title: selectedFilter,
                ),
              );
            }

            // Show nearby adventures for 'Nearby' filter
            return ref.watch(nearbyAdventuresProvider).when(
                  data: (adventures) {
                    /*
                    // Filter adventures based on selected activity types
                      List<Adventure> filteredAdventures = adventures;

                      if (selectedActivityTypes.isNotEmpty) {
                        filteredAdventures = adventures
                            .where((adventure) =>
                                selectedActivityTypes.contains(adventure.category))
                            .toList();
                      }
                     */

                    if (adventures.isNotEmpty) {
                      const maxCards = 20;
                      final displayedAdventures =
                          adventures.take(maxCards).toList();
                      final hasMore = adventures.length > maxCards;

                      return CarouselWidget<Adventure>(
                        items: displayedAdventures,
                        itemBuilder: (adventure, index) => Padding(
                          padding:
                              EdgeInsets.only(left: index == 0 ? spacing16 : 0),
                          child: PlaceCard(adventure),
                        ),
                        hasMore: hasMore,
                        onSeeMoreTap: () {
                          ref.read(bottomNavigationBarProvider.notifier).state =
                              NavigationItem.search;
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No places found',
                          style: bodyTextStyle.copyWith(
                              color: context.colors.textSecondary),
                        ),
                      );
                    }
                  },
                  loading: () {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            for (int index = 0; index < 3; index++) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? spacing16 : 0,
                                  right: index == 2 ? spacing16 : 0,
                                ),
                                child: ShimmerWidgets.adventureCardShimmer(
                                    context: context),
                              ),
                              if (index < 2) const SizedBox(width: spacing8),
                            ],
                          ],
                        ),
                      ),
                    );
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
      ],
    );
  }

  /// Common "Coming soon" placeholder (matching search screen pattern)
  Widget _buildComingSoon({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSizeLarge * 2,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: spacing16),
          Text(
            title,
            style: h3Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing8),
          Text(
            'Coming soon',
            style: bodyTextStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
