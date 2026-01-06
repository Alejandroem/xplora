import 'package:flutter/material.dart';
import '../../theme.dart';

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

class BrowseQuest extends StatelessWidget {
  const BrowseQuest({
    super.key,
    required this.onBrowseQuest,
    required this.availableCount,
    required this.nearbyCount,
  });

  final VoidCallback onBrowseQuest;
  final int availableCount;
  final int nearbyCount;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center icon
              Expanded(
                child: Image.asset(
                  'assets/png/xplora-logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$availableCount Available', style: bodySmallStyle.copyWith(color: context.colors.textSecondary)),
                  Text('$nearbyCount Nearby', style: bodySmallStyle.copyWith(color: context.colors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: spacing24),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Browse Quest button
              PrimaryButton(
                onPressed: onBrowseQuest,
                text: 'Browse Quest',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InProgressQuest extends StatelessWidget {
  const InProgressQuest({
    super.key,
    required this.dummyQuestTitle,
    required this.dummyProgress,
    required this.onSeeQuestDetails,
    required this.onMoreQuest,
    required this.onQueue,
  });

  final String dummyQuestTitle;
  final int dummyProgress;
  final VoidCallback onSeeQuestDetails;
  final VoidCallback onMoreQuest;
  final VoidCallback onQueue;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.fromLTRB(spacing16, spacing4, spacing16, spacing16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "In Progress" label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'In Progress',
                style: h3Style.copyWith(color: context.colors.textPrimary),
              ),
              IconButton(
                  onPressed: () {
                    print('QR Code Tapped');
                  },
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: context.colors.textPrimary,
                  ))
            ],
          ),
          const SizedBox(height: spacing8),
          // Quest title (dummy)
          Text(
            dummyQuestTitle,
            style: bodyTextStyle.copyWith(color: context.colors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: spacing16),
          // Progress bar with percentage (dummy)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radiusSmall),
                      child: LinearProgressIndicator(
                        value: dummyProgress / 100,
                        minHeight: 8,
                        backgroundColor: context.colors.bgTertiary,
                        valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(width: spacing16),
                  Text(
                    '$dummyProgress%',
                    style: bodySmallStyle.copyWith(color: context.colors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: spacing16),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  maxLines: 1,
                  text: 'See Quest Details',
                  onPressed: onSeeQuestDetails,
                ),
              ),
              const SizedBox(width: spacing8),
              Flexible(
                child: SecondaryButton(
                  maxLines: 1,
                  text: 'More Quest',
                  onPressed: onMoreQuest,
                ),
              ),
              const SizedBox(width: spacing8),
              Flexible(
                child: SecondaryButton(
                  text: 'Queue',
                  onPressed: onQueue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
