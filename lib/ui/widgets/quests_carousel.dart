import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/quest_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../components/feed_components.dart';
import 'bouncing_carousel.dart';
import 'quests_carousel_card.dart';

class NearbyQuests extends ConsumerWidget {
  const NearbyQuests({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);

    // Check if location tracking is enabled
    final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);

    if (!locationTrackingEnabled) {
      return const SizedBox.shrink();
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
                  'Quests',
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
                return ref.watch(nearbyQuestProvider).when(
                      data: (quests) {
                        // Filter quests based on selected activity types
                        List<Quest> filteredQuests = quests;

                        if (selectedActivityTypes.isNotEmpty) {
                          filteredQuests = quests
                              .where((quest) =>
                                  quest.category != null &&
                                  selectedActivityTypes.contains(quest.category))
                              .toList();
                        }

                        // TODO: Implement 'For You' and 'Following' filter logic
                        // For now, all filters use nearby quests

                        if (filteredQuests.isNotEmpty) {
                          const maxCards = 20;
                          final displayedQuests =
                              filteredQuests.take(maxCards).toList();
                          final hasMore = filteredQuests.length > maxCards;

                          return GenericBouncingCarousel<Quest>(
                            items: displayedQuests,
                            itemBuilder: (quest, index) =>
                                QuestsCarouselCard(quest),
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
                                  ? 'No quests found for selected activity types'
                                  : 'No quests found nearby',
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
