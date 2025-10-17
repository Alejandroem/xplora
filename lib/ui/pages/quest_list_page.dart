import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets/quest_list.dart';

class QuestListPage extends StatelessWidget {
  const QuestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: 'Quest List',
        ),
        body: Hero(
          tag: 'quest-list',
          child: QuestList(
            isHero: true,
          ),
        ),
      ),
    );
  }
}
