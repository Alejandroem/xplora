import 'package:flutter/material.dart';
import '../../theme.dart';

class InProgressQuest extends StatelessWidget {
  const InProgressQuest({
    super.key,
    required this.onContinue,
    required this.onSeeMore,
  });

  final VoidCallback onContinue;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const title = 'Hidden Alleyway Treasures';
    const description = 'Discover 3 secret murals in the Mission District';
    const checkpointsCompleted = 2;
    const totalCheckpoints = 3;
    const progressPercentage = 67;

    return GlassContainer(
      border: const Border.fromBorderSide(BorderSide.none),
      boxShadow: const [elevation1],
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: spacing4),

          // Description
          Text(
            description,
            style: bodySmallStyle.copyWith(
              color: context.colors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 10),

          // Progress info and percentage row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$checkpointsCompleted of $totalCheckpoints checkpoints',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              Text(
                '$progressPercentage%',
                style: bodySmallStyle.copyWith(
                  color: brandSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(radiusLarge),
            child: LinearProgressIndicator(
              value: progressPercentage / 100,
              minHeight: 8,
              backgroundColor: context.colors.bgTertiary,
              valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
            ),
          ),
          const SizedBox(height: spacing16),

          // Buttons row
          Row(
            children: [
              // Continue button
              Expanded(
                child: PrimaryButton(
                  onPressed: onContinue,
                  text: 'Continue',
                ),
              ),
              const SizedBox(width: spacing12),
              // See More button
              Expanded(
                child: SecondaryButton(
                  onPressed: onSeeMore,
                  text: 'See More',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
