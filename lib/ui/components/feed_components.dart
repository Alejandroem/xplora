import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../widgets/places_section.dart';
import '../widgets/categories_chips.dart';
import '../widgets/email_verification_banner.dart';
import '../widgets/quests_carousel.dart';
import '../widgets/streak_widget.dart';
import '../widgets/community_widget.dart';
import 'quest_components.dart';

class FeedComponents extends ConsumerWidget {
  const FeedComponents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlacesSection(),
          SizedBox(height: spacing24),
          // Streak and Community side by side
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: StreakWidget()),
                  SizedBox(width: spacing12),
                  Expanded(child: CommunityWidget()),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing24),
          Padding(
            padding: EdgeInsets.fromLTRB(spacing16, 0, spacing16, spacing16),
            child: QuestComponents(),
          )
        ],
    );
  }
}
