import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme.dart';

/// Reusable achievement widget that displays an achievement badge
/// - isEmpty = false: Shows filled achievement with icon and background
/// - isEmpty = true: Shows empty slot with border and small circle
class AchievementWidget extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final bool isEmpty; // Indicates empty slot (no achievement earned yet)
  final Color? borderColor; // Border color for earned achievements
  final double? borderWidth; // Border width for earned achievements

  const AchievementWidget({
    super.key,
    this.icon,
    this.imageUrl,
    this.size = 72,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.isEmpty = false, // Default to false for filled achievements
    this.borderColor, // Optional border color
    this.borderWidth, // Optional border width
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.colors.bgSecondary;
    final iconColorFinal = iconColor ?? context.colors.iconColor;
    final radius = borderRadius ?? radiusCard;

    // Empty state: bordered container with small circle in center
    if (isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: context.colors.border,
            width: borderWidthDefault,
          ),
        ),
        child: Center(
          child: Container(
            width: size * 0.25, // Circle is 25% of container size
            height: size * 0.25,
            decoration: BoxDecoration(
              color: context.colors.border.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    // Earned state: achievement badge with full colors
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                  width: borderWidth ?? 2.0,
                )
              : null,
        ),
        child: icon != null
            ? Icon(
                icon,
                color: iconColorFinal,
                size: size * 0.35, // Icon size proportional to container size
              )
            : imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: SvgPicture.asset(
                          'assets/svg/badge.svg',
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                            iconColorFinal,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                  child: SvgPicture.asset(
                      'assets/svg/badge.svg',
                      width: 32,
                      height: 32,
                      colorFilter: ColorFilter.mode(
                        iconColorFinal,
                        BlendMode.srcIn,
                      ),
                    ),
                ),
      ),
    );
  }
}
