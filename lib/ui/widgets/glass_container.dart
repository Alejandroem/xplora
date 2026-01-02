import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable widget for cards and containers with glassmorphism effect
/// Uses rgba(18,18,18,0.65) background, backdrop blur, and subtle purple border
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? blur; /// Backdrop blur amount (default: 12px)
  final Border? border;
  final Color? bgColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.blur,
    this.border,
    this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? radiusMedium),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur ?? cardContainerBlur.toDouble(),
          sigmaY: blur ?? cardContainerBlur.toDouble(),
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor ?? context.colors.bgSecondary, /// rgba(18,18,18,0.65)
            borderRadius: BorderRadius.circular(borderRadius ?? radiusMedium),
            border: border ?? Border.all(
              color: context.colors.cardContainerBorder, /// #8A2BE2 at 10% opacity
              width: borderWidthDefault,
            ),
            boxShadow: const [elevation1],
          ),
          child: child,
        ),
      ),
    );
  }
}
