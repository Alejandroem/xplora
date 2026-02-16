import 'package:flutter/material.dart';
import 'browse_quest.dart';
import 'in_progress_quest.dart';
import 'quest_completed_widget.dart';

enum QuestState { browse, inProgress, completed }

// Quest widget that changes states between browse, in-progress, and completed.
// - BrowseQuest (State A): Empty state with "Start Adventure" and "See More" buttons
// - InProgressQuest (State B): Active quest with progress bar and "Continue"/"See More" buttons
// - QuestCompletedWidget (State C): Completion state with checkmark and XP earned
class QuestWidget extends StatelessWidget {
  final QuestState questState;
  final VoidCallback onStartAdventure;
  final VoidCallback onContinue;
  final VoidCallback onSeeMore;

  const QuestWidget({
    super.key,
    required this.questState,
    required this.onStartAdventure,
    required this.onContinue,
    required this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    switch (questState) {
      case QuestState.inProgress:
        return InProgressQuest(
          onContinue: onContinue,
          onSeeMore: onSeeMore,
        );
      case QuestState.completed:
        return const QuestCompletedWidget();
      case QuestState.browse:
        return BrowseQuest(
          onStartAdventure: onStartAdventure,
          onSeeMore: onSeeMore,
        );
    }
  }
}

