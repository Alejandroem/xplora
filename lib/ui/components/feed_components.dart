import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/category_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../theme.dart';
import '../widgets/adventures_carousel.dart';
import '../widgets/categories_chips.dart';
import '../widgets/email_verification_banner.dart';
import '../widgets/featured_adventure.dart';
import '../widgets/quests_carousel.dart';
import '../widgets/smooth_filter_scroll_row.dart';
import 'quest_components.dart';

// Provider for selected filter
final selectedCarouselFilterProvider = StateProvider<String>((ref) => 'Nearby');

// Provider for selected activity types (multiple)
final selectedActivityTypesProvider = StateProvider<List<String>>((ref) => []);

class FeedComponents extends ConsumerStatefulWidget {
  const FeedComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedComponentsState();
}

class _FeedComponentsState extends ConsumerState<FeedComponents> {
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
    final selectedFilter = ref.watch(selectedCarouselFilterProvider);
    final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);
    final filters = ['Nearby', 'For You', 'Following'];

    // Check if location tracking is enabled (user granted permission through custom dialog)
    final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // SizedBox(height: 200),
        const EmailVerificationBanner(),
        if (locationTrackingEnabled) ...[
          const SizedBox(height: 20),
          // Filter Bubble Row with smooth scrolling
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
        ],
        // FeaturedAdventure(),
        const NearestAdventures(),
        const SizedBox(height: 8),
        const CategoriesChips(),
        const NearbyQuests(),
        const QuestComponents(),
        const SizedBox(
          height: 90,
        )
      ],
    );
  }
}
