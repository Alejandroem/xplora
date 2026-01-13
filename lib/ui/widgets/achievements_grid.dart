import 'package:flutter/material.dart';

import '../../theme.dart';
import 'achievement_widget.dart';

/// Reusable grid widget for displaying achievements
class AchievementsGrid extends StatelessWidget {
  final int itemCount;
  final double achievementRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final Function(int)? onTap;
  final int crossAxisCount;

  const AchievementsGrid({
    super.key,
    required this.itemCount,
    this.achievementRadius = 36,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cell size based on radius (diameter + some padding)
    final cellSize = achievementRadius * 2 + spacing8;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing16,
        crossAxisSpacing: spacing16,
        childAspectRatio: 1.0,
        mainAxisExtent: cellSize,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Center(
          child: AchievementWidget(
            radius: achievementRadius,
            icon: Icons.emoji_events,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            onTap: onTap != null ? () => onTap!(index) : null,
          ),
        );
      },
    );
  }
}
