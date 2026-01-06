import 'package:flutter/material.dart';
import '../../theme.dart';

// TODO: Community will open community screen after MVP is ready.
// The emblem (shield/crown) is a badge for the user's club/team.
class CommunityWidget extends StatelessWidget {
  const CommunityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const int activeFriends = 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Community heading
        Text(
          'Community',
          style: h2Style.copyWith(color: context.colors.textPrimary)
        ),
        const SizedBox(height: spacing8),
        SizedBox(
          width: double.infinity,
          child: GlassContainer(
            padding: const EdgeInsets.all(spacing16),
            child: Column(
              children: [
                // Crown/Shield icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Shield background
                    Icon(
                      Icons.shield,
                      size: 64, // 64
                      color: context.colors.textPrimary.withOpacity(0.2),
                    ),
                    // Crown on top
                    Icon(
                      Icons.emoji_events,
                      size: 32,
                      color: context.colors.textPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: spacing12),

                // Active friends count
                Text(
                  '$activeFriends Friends Active',
                  style: bodySmallStyle.copyWith(color: context.colors.textSecondary)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
