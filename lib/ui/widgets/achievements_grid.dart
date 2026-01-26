import 'package:flutter/material.dart';

import '../../theme.dart';
import 'achievement_widget.dart';

/// Reusable grid widget for displaying achievements
class AchievementsGrid extends StatelessWidget {
  final int itemCount;
  final double achievementSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final Function(int)? onTap;
  final int crossAxisCount;
  final double? borderRadius;

  const AchievementsGrid({
    super.key,
    required this.itemCount,
    this.achievementSize = 72,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.crossAxisCount = 3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cell size based on achievement size + some padding
    final cellSize = achievementSize + spacing8;

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
            size: achievementSize,
            icon: Icons.emoji_events,
            backgroundColor: backgroundColor,
            iconColor: iconColor,
            borderRadius: borderRadius,
            onTap: onTap != null ? () => onTap!(index) : null,
          ),
        );
      },
    );
  }
}
