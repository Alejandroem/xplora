import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/adventures_carousel.dart';
import '../widgets/categories_chips.dart';
import '../widgets/email_verification_banner.dart';
import '../widgets/featured_adventure.dart';
import 'quest_components.dart';

class FeedComponents extends ConsumerStatefulWidget {
  const FeedComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedComponentsState();
}

class _FeedComponentsState extends ConsumerState<FeedComponents> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmailVerificationBanner(),
        FeaturedAdventure(),
        NearestAdventures(),
        CategoriesChips(),
        QuestComponents(),
      ],
    );
  }
}
