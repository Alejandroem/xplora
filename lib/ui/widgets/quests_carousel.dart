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
                  style: h2Style,
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
                        if (quests.isNotEmpty) {
                          const maxCards = 20;
                          final displayedQuests =
                          quests.take(maxCards).toList();
                          final hasMore = quests.length > maxCards;

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
                            child: Text( 'No quests found nearby',
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
