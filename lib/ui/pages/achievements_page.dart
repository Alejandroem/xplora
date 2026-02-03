import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../widgets/achievements_grid.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual achievements count from user's data
    const totalAchievements = 21; // Total number of achievements earned by the user

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          centerTitle: true, // Center the title
          title: Text(
            'Achievements',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(spacing16),
          child: AchievementsGrid(
            itemCount: totalAchievements,
            // earnedCount not specified = all achievements shown are earned
            achievementSize: 110, // Larger circular badges
            borderRadius: 60, // Circular (half of size)
            borderColor: brandSecondary, // Teal/cyan colored border
            borderWidth: borderWidthDefault,
            iconColor: context.colors.iconColor.withValues(alpha: 0.2),
            crossAxisSpacing: spacing24, // Horizontal spacing
            onTap: (index) {
              // TODO: Show achievement details
            },
          ),
        ),
      ),
    );
  }
}
