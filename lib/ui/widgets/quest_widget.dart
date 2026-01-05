import 'package:flutter/material.dart';
import '../../theme.dart';

/// Quest widget with two states: browse (empty) and in-progress
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
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Center icon
              Image.asset(
                'assets/png/xplora-logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: spacing32),
              // Browse Quest button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: PrimaryButton(
                  onPressed: onBrowseQuest,
                  text: 'Browse Quest',
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quest', style: h3Style),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$availableCount Available', style: bodySmallStyle),
                  Text('$nearbyCount Nearby', style: bodySmallStyle),
                ],
              ),
            ],
          )
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
      padding: const EdgeInsets.all(spacing16),
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
                style: h3Style,
              ),
              GestureDetector(
                  onTap: () {
                    print('QR Code Tapped');
                  },
                  child: Icon(
                    Icons.qr_code,
                    color: context.colors.textPrimary,
                  ))
            ],
          ),
          const SizedBox(height: spacing8),
          // Quest title (dummy)
          Text(
            dummyQuestTitle,
            style: bodyTextStyle,
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
                    style: bodySmallStyle,
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
                child: SizedBox(
                  height: 40,
                  child: SecondaryButton(
                    text: 'See Quest Details',
                    onPressed: onSeeQuestDetails,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: spacing8),
              SizedBox(
                height: 40,
                child: SecondaryButton(
                  text: 'More Quest',
                  onPressed: onMoreQuest,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: spacing8),
              SizedBox(
                height: 40,
                child: SecondaryButton(
                  text: 'Queue',
                  onPressed: onQueue,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
