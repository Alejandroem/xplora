import 'package:flutter/material.dart';
import 'browse_quest.dart';
import 'in_progress_quest.dart';

// TODO: Quest widget that will change states from browse quest to in-progress.
// Currently uses hasQuestInProgress boolean to toggle between:
// - BrowseQuest (State A): Empty state with "Browse Quest" button
// - InProgressQuest (State B): Active quest with progress bar and action buttons
//   - QR code scan icon (top right) to confirm and verify e.g. each peak has been completed
// Note: Radius for "Nearby" quests will be small, 10-20ish meters (TBD)
class QuestWidget extends StatelessWidget {
  final bool hasQuestInProgress;
  final int availableCount;
  final int nearbyCount;
  final VoidCallback onBrowseQuest;
  final VoidCallback onSeeQuestDetails;
  final VoidCallback onMoreQuest;
  final VoidCallback onQueue;

  const QuestWidget({
    super.key,
    required this.hasQuestInProgress,
    required this.availableCount,
    required this.nearbyCount,
    required this.onBrowseQuest,
    required this.onSeeQuestDetails,
    required this.onMoreQuest,
    required this.onQueue,
  });

  @override
  Widget build(BuildContext context) {
    if (hasQuestInProgress) {
      // In-Progress State (using dummy data for now)
      const dummyQuestTitle = 'Cerro Minne 3 peak hike';
      const dummyProgress = 30;

      return InProgressQuest(
          dummyQuestTitle: dummyQuestTitle,
          dummyProgress: dummyProgress,
          onSeeQuestDetails: onSeeQuestDetails,
          onMoreQuest: onMoreQuest,
          onQueue: onQueue);
    }

    // Browse Quest State (Empty State)
    return BrowseQuest(
        onBrowseQuest: onBrowseQuest,
        availableCount: availableCount,
        nearbyCount: nearbyCount);
  }
}

