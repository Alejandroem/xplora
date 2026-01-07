import 'package:flutter/material.dart';
import '../../theme.dart';

class InProgressQuestWidget extends StatelessWidget {
  const InProgressQuestWidget({
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
