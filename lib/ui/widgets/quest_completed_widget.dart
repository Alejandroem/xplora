import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../theme.dart';

/// Quest Completed Widget
/// Displays completion status with XP earned
class QuestCompletedWidget extends StatelessWidget {
  const QuestCompletedWidget({
    super.key,
    this.description = '3/3 hidden QR codes collected around El Morro',
    this.xpEarned = 50,
  });

  final String description;
  final int xpEarned;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      showBorder: false,
      boxShadow: const [elevation1],
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and text row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkmark icon with circular background
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: brandSecondary.withValues(alpha: 0.3), width: borderWidthDefault),
                  shape: BoxShape.circle,
                  color: brandSecondary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/overflow-checkmark-circle.svg',
                    width: iconSizeLarge,
                    height: iconSizeLarge,
                  ),
                ),
              ),
              const SizedBox(width: spacing12),

              // Text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Quest Complete!" title
                    Text(
                      'Quest Complete!',
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: spacing4),

                    // Description
                    Text(
                      description,
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing16),

          // XP button (centered)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: spacing48,
                vertical: spacing8,
              ),
              decoration: BoxDecoration(
                color: brandSecondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(radiusPill),
                border: Border.all(
                  color: brandSecondary.withValues(alpha: 0.3),
                  width: borderWidthDefault,
                ),
              ),
              child: Text(
                '+${xpEarned}xp',
                style: h3Style.copyWith(
                  color: brandSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
