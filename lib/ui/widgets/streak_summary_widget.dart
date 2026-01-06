import 'package:flutter/material.dart';
import '../../theme.dart';

/// Streak Summary Widget - Displays XP progress and daily streak
/// Compact design matching the first image with teal accent color
class StreakSummaryWidget extends StatelessWidget {
  final int currentXp;
  final int totalXp;
  final int dayStreak;
  final List<bool> weekProgress; // 7 days, true = completed

  const StreakSummaryWidget({
    super.key,
    required this.currentXp,
    required this.totalXp,
    required this.dayStreak,
    required this.weekProgress,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXp / totalXp;

    return GlassContainer(
      padding: const EdgeInsets.all(spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Simple badge with fire icon and day count
          Container(
            width: 80,
            padding: const EdgeInsets.all(spacing8),
            decoration: BoxDecoration(
              color: context.colors.bgTertiary,
              borderRadius: BorderRadius.circular(radiusMedium),
              border: Border.all(
                color: context.colors.border,
                width: borderWidthDefault,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Fire icon
                Icon(
                  Icons.local_fire_department,
                  size: iconSizeLarge*1.5,
                  color: brandPrimary,
                ),
                const SizedBox(height: spacing4),
                // Day count
                Text(
                  '$dayStreak',
                  style: h2Style.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Label
                Text(
                  'Day Streak',
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: spacing16),

          // Right: XP progress and weekly circles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // XP count
                Text(
                  'XP $currentXp/$totalXp',
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing8),

                // Progress bar - white (following design system)
                ClipRRect(
                  borderRadius: BorderRadius.circular(radiusPill),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: spacing8,
                    backgroundColor: context.colors.bgTertiary,
                    valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
                    borderRadius: BorderRadius.circular(radiusPill),
                  ),
                ),
                const SizedBox(height: spacing12),

                // Weekly day circles with labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDayIndicator(context, 0, 'Mon'),
                    _buildDayIndicator(context, 1, 'Tue'),
                    _buildDayIndicator(context, 2, 'Wed'),
                    _buildDayIndicator(context, 3, 'Thu'),
                    _buildDayIndicator(context, 4, 'Fri'),
                    _buildDayIndicator(context, 5, 'Sat'),
                    _buildDayIndicator(context, 6, 'Sun'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual day indicator with circle and label
  Widget _buildDayIndicator(BuildContext context, int index, String label) {
    final hasProgress = index < weekProgress.length && weekProgress[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle indicator
        Container(
          width: iconSizeMedium,
          height: iconSizeMedium,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasProgress ? brandPrimary : Colors.transparent,
            border: Border.all(
              color: hasProgress ? brandPrimary : context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: hasProgress
              ? Icon(
                  Icons.check,
                  size: iconSizeSmall,
                  color: whiteClr,
                )
              : null,
        ),
        const SizedBox(height: spacing4),
        // Day label
        Text(
          label,
          style: bodySmallStyle.copyWith(
            color: context.colors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
