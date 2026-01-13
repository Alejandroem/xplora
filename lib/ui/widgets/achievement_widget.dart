import 'package:flutter/material.dart';

import '../../theme.dart';

/// Reusable achievement widget that displays an achievement badge
class AchievementWidget extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const AchievementWidget({
    super.key,
    this.icon,
    this.imageUrl,
    this.radius = 36,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.colors.bgSecondary;
    final iconColorFinal = iconColor ?? context.colors.iconColor;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: icon != null
            ? Icon(
                icon,
                color: iconColorFinal,
                size: radius * 0.6, // Icon size proportional to radius
              )
            : imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      imageUrl!,
                      width: radius * 2,
                      height: radius * 2,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.emoji_events,
                        color: iconColorFinal,
                        size: radius * 0.6,
                      ),
                    ),
                  )
                : Icon(
                    Icons.emoji_events,
                    color: iconColorFinal,
                    size: radius * 0.6,
                  ),
      ),
    );
  }
}
