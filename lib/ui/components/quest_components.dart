import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../domain/models/adventure_in_progress.dart';
import '../../theme.dart';
import '../widgets/current_quest.dart';
import '../widgets/glass_container.dart';
import '../widgets/primary_button.dart';
import '../widgets/quest_widget.dart';
import '../widgets/secondary_button.dart';

class QuestComponents extends ConsumerStatefulWidget {
  const QuestComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestComponentsState();
}

class _QuestComponentsState extends ConsumerState<QuestComponents> {
  @override
  Widget build(BuildContext context) {
    // final questInProgress = ref.watch(adventureInProgressTrackerProvider);
    final hasQuestInProgress = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        Text(
          'Quest',
          style: h2Style,
        ),
        const SizedBox(height: spacing8),
        // Quest Widget
        QuestWidget(
          hasQuestInProgress: hasQuestInProgress,
          availableCount: 20, // TODO: Replace with actual count from provider
          nearbyCount: 3, // TODO: Replace with actual count from provider
          onBrowseQuest: () {
            Navigator.of(context).pushNamed('/quest-main');
          },
          onSeeQuestDetails: () {
            // TODO: See quest details opens the quest detail screen.
          },
          onMoreQuest: () {
            // TODO: More quest opens the main quest to-do tab screen.
            Navigator.of(context).pushNamed('/quest-main');
          },
          onQueue: () {
            // TODO: Queue opens the main quest in progress tab screen.
          },
        ),
      ],
    );
  }
}
