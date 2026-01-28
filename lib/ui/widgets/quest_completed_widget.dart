import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';

class QuestCompletedWidget extends StatelessWidget {
  const QuestCompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const title = 'Hidden Alleyway Treasures';
    const xpEarned = 250;

    return GlassContainer(
      border: const Border.fromBorderSide(BorderSide.none),
      boxShadow: const [elevation1],
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Checkmark icon in rounded square
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: brandSecondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(radiusLarge),
              border: Border.all(
                color: brandSecondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/overflow-checkmark-circle.svg',
                width: 36,
                height: 36,
              ),
            )
          ),
          const SizedBox(height: spacing12),

          // Title
          Text(
            title,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: spacing12),

          // XP badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: spacing12,
              vertical: spacing8,
            ),
            decoration: BoxDecoration(
              color: brandSecondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(radiusSmall),
              border: Border.all(
                color: brandSecondary.withValues(alpha: 0.3),
                width: borderWidthDefault,
              ),
            ),
            child: Text(
              '+ ${xpEarned}xp',
              style: bodySmallStyle.copyWith(
                color: brandSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: spacing16),
        ],
      ),
    );
  }
}
