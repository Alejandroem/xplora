import 'package:flutter/material.dart';
import '../../theme.dart';

/// Community Widget - Explorer Network
/// Shows information about the community feature (currently in beta)
class CommunityWidget extends StatelessWidget {
  const CommunityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Community heading
        Text(
          'Community',
          style: h3Style.copyWith(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spacing8),
        Expanded(
          child: GlassContainer(
            boxShadow: const [elevation1],
            showBorder: false,
            padding: const EdgeInsets.all(spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Main title
                Text(
                  'Explorer Network',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: spacing16),

                // Description
                Text(
                  'Join and create clubs with membership',
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontSize: 13
                  ),
                ),
                const SizedBox(height: spacing8),

                // Status label
                Text(
                  'Status: Closed (Beta)',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textTertiary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                  ),
                ),
                const SizedBox(height: spacing16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
