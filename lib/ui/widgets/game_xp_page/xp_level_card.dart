import 'package:flutter/material.dart';

import '../../../theme.dart';

/// XP Level display card widget
/// Shows current level, XP progress, and XP to next level
class XpLevelCard extends StatelessWidget {
  final int level;
  final int currentXp;
  final int maxXp;

  const XpLevelCard({
    super.key,
    required this.level,
    required this.currentXp,
    required this.maxXp,
  });

  @override
  Widget build(BuildContext context) {
    final int xpToNextLevel = maxXp - currentXp;
    final double progress = currentXp / maxXp;

    return Container(
      padding: const EdgeInsets.all(spacing24),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusLarge),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      child: Row(
        children: [
          // Circular level indicator
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: brandSecondary.withValues(alpha: 0.08),
              border: Border.all(
                color: brandSecondary,
                width: 2.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lvl',
                  style: bodySmallStyle.copyWith(
                    color: brandSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$level',
                  style: h1Style.copyWith(
                    color: brandSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: spacing16),
          // XP progress section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // XP text
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'XP ',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: '$currentXp',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: ' / $maxXp',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textSecondary.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: spacing12),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(radiusLarge),
                  child: SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: context.colors.bgTertiary,
                      valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
                      borderRadius: BorderRadius.circular(radiusLarge),
                    ),
                  ),
                ),
                const SizedBox(height: spacing12),
                // XP to next level
                Text(
                  '$xpToNextLevel XP to next level',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textSecondary.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}