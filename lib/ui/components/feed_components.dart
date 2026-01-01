import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/adventures_carousel.dart';
import '../widgets/categories_chips.dart';
import '../widgets/email_verification_banner.dart';
import '../widgets/quests_carousel.dart';
import 'quest_components.dart';

class FeedComponents extends ConsumerWidget {
  const FeedComponents({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmailVerificationBanner(),
        NearestAdventures(),
        SizedBox(height: 8),
        CategoriesChips(),
        NearbyQuests(),
        QuestComponents(),
        SizedBox(
          height: 90,
        )
      ],
    );
  }
}
