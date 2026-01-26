import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme.dart';

/// Notification item tile matching the design system
/// Features:
/// - SVG icon with color background (15% opacity) on the left
/// - Title and description text
/// - Timestamp on the right
/// - Proper spacing and dividers
class NotificationItemTile extends StatelessWidget {
  final String svgIconPath;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final String timeAgo;
  final bool isLast;
  final VoidCallback? onTap;

  const NotificationItemTile({
    super.key,
    required this.svgIconPath,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.timeAgo,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SVG Icon with color background (15% opacity)
                Container(
                  width: 47,
                  height: 47,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      svgIconPath,
                      width: 21,
                      height: 21,
                    ),
                  ),
                ),
                const SizedBox(width: spacing16),
                // Title, description, and timestamp
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Expanded(
                            child: Text(
                              title,
                              style: bodyTextStyle.copyWith(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: spacing8),
                          // Timestamp
                          Text(
                            timeAgo,
                            style: bodySmallStyle.copyWith(
                              color: context.isDarkMode ? bgPrimaryLight.withValues(alpha: 0.5) : context.colors.textTertiary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: spacing4),
                      // Description
                      Text(
                        description,
                        style: bodySmallStyle.copyWith(
                          color: context.isDarkMode ? bgPrimaryLight.withValues(alpha: 0.7) : context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Border with spacing (only if not last item)
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacing16),
            child: Divider(
              height: 1,
              thickness: borderWidthDefault,
              color: context.colors.border.withValues(alpha: 0.3),
            ),
          ),
      ],
    );
  }
}
