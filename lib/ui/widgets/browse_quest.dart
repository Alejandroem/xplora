import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

/// Browse Quest Widget
/// Displays a featured quest location with explore call-to-action
class BrowseQuest extends StatelessWidget {
  const BrowseQuest({
    super.key,
    this.locationName = 'Castillo San Felipe del Morro',
    required this.onStartAdventure,
    required this.onSeeMore,
  });

  final String locationName;
  final VoidCallback onStartAdventure;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      boxShadow: const [elevation1],
      showBorder: false,
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon, title and description row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compass icon with circular background
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandPrimary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/compass.svg',
                    width: iconSizeLarge,
                    height: iconSizeLarge,
                    colorFilter: ColorFilter.mode(
                      brandPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: spacing8),

              // Text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Explore" label
                    Text(
                      'Explore',
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    // Location name
                    Text(
                      locationName,
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: spacing4),

                    // Subtitle
                    Text(
                      'Complete all Quest',
                      style: bodySmallStyle.copyWith(
                        color: context.colors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing16),

          // Buttons row
          Row(
            spacing: spacing16,
            children: [
              // Start button
              Expanded(
                child: PrimaryButton(
                  onPressed: onStartAdventure,
                  text: 'Start',
                  borderRadius: radiusPill,
                ),
              ),
              // See More button
              Expanded(
                child: SecondaryButton(
                  onPressed: onSeeMore,
                  text: 'See More',
                  borderRadius: radiusPill,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
