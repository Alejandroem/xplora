import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme.dart';

/// How XP is Earned section widget
/// Displays a list of ways to earn XP in the game
class HowXpEarnedSection extends StatelessWidget {
  const HowXpEarnedSection({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How XP is Earned',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing16),
          const _XpEarnItem(
            icon: 'assets/svg/location-pin.svg',
            label: 'Complete quests',
          ),
          const SizedBox(height: spacing16),
          const _XpEarnItem(
            icon: 'assets/svg/calendar-empty.svg',
            label: 'Daily quests',
          ),
          const SizedBox(height: spacing16),
          const _XpEarnItem(
            icon: 'assets/svg/person-running.svg',
            label: 'Stay active',
          ),
          const SizedBox(height: spacing16),
          const _XpEarnItem(
            icon: 'assets/svg/compass.svg',
            label: 'Visit places',
          ),
          const SizedBox(height: spacing16),
          const _XpEarnItem(
            icon: 'assets/svg/plus.svg',
            label: 'Submit new places',
          ),
          const SizedBox(height: spacing16),
          const _XpEarnItem(
            icon: 'assets/svg/fire.svg',
            label: 'Earn rewards',
          ),
        ],
      ),
    );
  }
}

/// Individual XP earning item
class _XpEarnItem extends StatelessWidget {
  final String icon;
  final String label;

  const _XpEarnItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon container
        SizedBox(
          width: 32,
          height: 32,
          child: SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            fit: BoxFit.scaleDown,
          ),
        ),
        const SizedBox(width: spacing12),
        // Label
        Text(
          label,
          style: bodyTextStyle.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
