import 'package:flutter/material.dart';

import '../../theme.dart';
import 'achievement_widget.dart';

/// Reusable grid widget for displaying achievements
/// - If earnedCount is specified: Shows N earned achievements + rest as empty slots
/// - If earnedCount is null: Shows all achievements as earned
class AchievementsGrid extends StatelessWidget {
  final int itemCount; // Total number of slots to display
  final int? earnedCount; // Number of earned achievements (null = all earned)
  final double achievementSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final Function(int)? onTap;
  final int crossAxisCount;
  final double? borderRadius;
  final Color? borderColor; // Border color for earned achievements
  final double? borderWidth; // Border width for earned achievements
  final double mainAxisSpacing; // Vertical spacing between items
  final double crossAxisSpacing; // Horizontal spacing between items

  const AchievementsGrid({
    super.key,
    required this.itemCount,
    this.earnedCount, // Null means all achievements are earned
    this.achievementSize = 72,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.crossAxisCount = 3,
    this.borderRadius,
    this.borderColor, // Optional border color
    this.borderWidth, // Optional border width
    this.mainAxisSpacing = spacing16, // Default vertical spacing
    this.crossAxisSpacing = spacing16, // Default horizontal spacing
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cell size based on achievement size
    final cellSize = achievementSize;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 1.0,
        mainAxisExtent: cellSize,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // If earnedCount is null, all achievements are earned
        final int effectiveEarnedCount = earnedCount ?? itemCount;

        // Check if this achievement is earned or empty
        final bool isEarned = index < effectiveEarnedCount;
        final bool isEmpty = !isEarned; // Not earned = empty slot

        return Center(
          child: AchievementWidget(
            size: achievementSize,
            // Don't pass icon - let it default to badge.svg
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            borderRadius: borderRadius,
            borderColor: borderColor,
            borderWidth: borderWidth,
            isEmpty: isEmpty,
            onTap: onTap != null ? () => onTap!(index) : null,
          ),
        );
      },
    );
  }
}
