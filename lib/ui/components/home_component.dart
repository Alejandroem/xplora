import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/categories_chips.dart';
import '../widgets/current_quest.dart';
import '../widgets/quest_add.dart';
import '../widgets/quest_carousel.dart';

class HomeComponent extends ConsumerStatefulWidget {
  const HomeComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeComponentState();
}

class _HomeComponentState extends ConsumerState<HomeComponent> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            QuestAdd(),
            CurrentQuest(),
            QuestCarousel(),
            CategoriesChips(),
          ],
        ),
      ),
    );
  }
}
