import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';

// TODO: Community will open community screen after MVP is ready.
class CommunityWidget extends StatelessWidget {
  const CommunityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    const int nearbyExplorers = 12;
    const int activeFriends = 2;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const SizedBox(height: spacing12),
              // Icon and avatars row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing12),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    SvgPicture.asset('assets/svg/star-badge.svg',
                        color: context.colors.textPrimary.withValues(alpha: 0.5),
                      width: 33,
                      height: 33,),
                  ],
                ),
              ),
              const SizedBox(height: spacing16),

              // Explorers count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing12),
                child: Text(
                  '$nearbyExplorers Explorers Nearby',
                  style: bodySmallStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: spacing8),

              // Active friends text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing12),
                child: Text(
                  '$activeFriends friends active today',
                  style: bodySmallStyle.copyWith(
                      color:
                          context.colors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 13),
                ),
              ),
              const SizedBox(height: spacing24),

              // Divider
              Container(
                height: borderWidthDefault,
                color: context.colors.border,
              ),
              const SizedBox(height: spacing12),

              // Chevron icon (bottom right)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing12),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    LucideIcons.chevronRight,
                    color: context.colors.textSecondary.withValues(alpha: 0.4),
                    size: iconSizeLarge,
                  ),
                ),
              ),
              const SizedBox(height: spacing8),
            ],
          ),
        ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, int index) {
    return Positioned(
      left: index * (36 * 0.6),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.bgTertiary,
          border: Border.all(
            color: context.colors.bgSecondary,
            width: borderWidthDefault * 2,
          ),
        ),
        child: ClipOval(
          child: Icon(
            LucideIcons.user,
            color: context.colors.textSecondary,
            size: iconSizeSmall,
          ),
        ),
      ),
    );
  }
}
