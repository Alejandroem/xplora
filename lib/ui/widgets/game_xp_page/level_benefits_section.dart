import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme.dart';

/// Level Benefits section widget
/// Displays benefits of leveling up
class LevelBenefitsSection extends StatelessWidget {
  const LevelBenefitsSection({super.key});

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
            'Level Benefits',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing16),
          const _BenefitItem(
            label: 'Unlock new quests',
          ),
          const SizedBox(height: spacing16),
          const _BenefitItem(
            label: 'Earn achievements',
          ),
          const SizedBox(height: spacing16),
          const _BenefitItem(
            label: 'Increase community rank',
          ),
          const SizedBox(height: spacing16),
          const _BenefitItem(
            label: 'Access special events',
          ),
        ],
      ),
    );
  }
}

/// Individual benefit item with checkmark
class _BenefitItem extends StatelessWidget {
  final String label;

  const _BenefitItem({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkmark icon
        SvgPicture.asset(
          'assets/svg/checkmark.svg',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: spacing12),
        // Label
        Text(
          label,
          style: bodyTextStyle.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
      ],
    );
  }
}
