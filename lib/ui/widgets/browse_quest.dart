import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

class BrowseQuest extends StatelessWidget {
  const BrowseQuest({
    super.key,
    required this.onStartAdventure,
    required this.onSeeMore,
  });

  final VoidCallback onStartAdventure;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      border: const Border.fromBorderSide(BorderSide.none),
      boxShadow: const [elevation1],
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Hidden Alleyway Treasures',
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
          const SizedBox(height: spacing4),

          // Description
          Text(
            'Discover 3 secret murals in the Mission District',
            style: bodySmallStyle.copyWith(
              color: context.colors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: spacing8),

          // Location and duration row
          Row(
            children: [
              // Location icon and text
              SvgPicture.asset(
                'assets/svg/grey-location-pin.svg',
                width: iconSizeMedium,
                height: iconSizeMedium,
                colorFilter: ColorFilter.mode(
                  context.colors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: spacing4),
              Text(
                'Mission District',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: spacing16),
              // Clock icon and text
              SvgPicture.asset(
                'assets/svg/grey-clock.svg',
                width: iconSizeMedium,
                height: iconSizeMedium,
                colorFilter: ColorFilter.mode(
                  context.colors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '45 min',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing16),

          // Buttons row
          Row(
            children: [
              // Start Adventure button
              Expanded(
                child: PrimaryButton(
                  onPressed: onStartAdventure,
                  text: 'Start Adventure',
                ),
              ),
              const SizedBox(width: spacing12),
              // See More button
              Expanded(
                child: SecondaryButton(
                  onPressed: onSeeMore,
                  text: 'See More',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
