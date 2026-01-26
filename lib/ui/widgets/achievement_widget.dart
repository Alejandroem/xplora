import 'package:flutter/material.dart';

import '../../theme.dart';

/// Reusable achievement widget that displays an achievement badge
class AchievementWidget extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;

  const AchievementWidget({
    super.key,
    this.icon,
    this.imageUrl,
    this.size = 72,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.colors.bgSecondary;
    final iconColorFinal = iconColor ?? context.colors.iconColor;
    final radius = borderRadius ?? radiusCard;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: icon != null
            ? Icon(
                icon,
                color: iconColorFinal,
                size: 32, // Icon size proportional to container size
              )
            : imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: Image.network(
                      imageUrl!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.emoji_events,
                        color: iconColorFinal,
                        size: 32,
                      ),
                    ),
                  )
                : Icon(
                    Icons.emoji_events,
                    color: iconColorFinal,
                    size: 32,
                  ),
      ),
    );
  }
}
