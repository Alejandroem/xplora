import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

/// In Progress Quest Widget
/// Displays a quest currently being completed with status badge
class InProgressQuest extends StatelessWidget {
  const InProgressQuest({
    super.key,
    this.title = 'El Morro QR codes',
    this.description = 'Collect 3 hidden QR codes around El Morro',
    required this.onContinue,
    required this.onSeeMore,
  });

  final String title;
  final String description;
  final VoidCallback onContinue;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      showBorder: false,
      boxShadow: const [elevation1],
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon, title, description and status badge row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scan icon with circular background
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandPrimary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/scan-grey.svg',
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
                    // Title
                    Text(
                      title,
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              const SizedBox(width: spacing8),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing8,
                  vertical: spacing4,
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
                  'In Progress',
                  style: bodySmallStyle.copyWith(
                    color: brandSecondary,
                    fontSize: 12
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: spacing16),

          // Buttons row
          Row(
            spacing: spacing16,
            children: [
              // Details button
              Expanded(
                child: PrimaryButton(
                  onPressed: onContinue,
                  text: 'Details',
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
