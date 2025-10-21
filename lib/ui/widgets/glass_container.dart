import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Reusable widget for cards and containers with glassmorphism effect
/// Uses rgba(18,18,18,0.65) background, backdrop blur, and subtle purple border
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? blur; /// Backdrop blur amount (default: 12px)
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.blur,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur ?? cardContainerBlur.toDouble(),
          sigmaY: blur ?? cardContainerBlur.toDouble(),
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: midSurface, /// rgba(18,18,18,0.65)
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            border: border ?? Border.all(
              color: cardContainerBorder, /// #8A2BE2 at 10% opacity
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), /// Soft shadow for depth
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
