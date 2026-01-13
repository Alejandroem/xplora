import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../widgets/achievements_grid.dart';

class AchievementsPage extends ConsumerWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.colors.iconColor,
              size: iconSizeLarge,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Achievements',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured Achievements section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Feature Achievements',
                    style: h2Style.copyWith(
                      color: context.colors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to edit featured achievements
                    },
                    child: Text(
                      'Edit',
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: spacing16),
              // Featured achievements grid (3x2)
              AchievementsGrid(
                itemCount: 6,
                achievementRadius: 48,
                onTap: (index) {
                  // TODO: Show achievement details
                },
              ),
              const SizedBox(height: spacing24),
              // Divider
              Divider(
                color: context.colors.border,
                thickness: borderWidthDefault,
              ),
              const SizedBox(height: spacing24),
              // All achievements section
              Text(
                'All',
                style: h2Style.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: spacing16),
              // All achievements grid (3 columns, many rows)
              AchievementsGrid(
                itemCount: 18, // Showing 18 achievements (6 rows)
                achievementRadius: 48,
                onTap: (index) {
                  // TODO: Show achievement details
                },
              ),
              const SizedBox(height: spacing24),
            ],
          ),
        ),
      ),
    );
  }
}
