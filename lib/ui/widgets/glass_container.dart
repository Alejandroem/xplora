import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable widget for cards and containers with glassmorphism effect
/// Uses rgba(18,18,18,0.65) background, backdrop blur, and subtle purple border
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final BorderRadiusGeometry? customBorderRadius;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final Color? bgColor;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final bool showBorder;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.customBorderRadius,
    this.padding,
    this.border,
    this.bgColor,
    this.boxShadow,
    this.width,
    this.height,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = customBorderRadius ??
        BorderRadius.circular(borderRadius ?? radiusMedium);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor ?? context.colors.bgSecondary,

            /// rgba(18,18,18,0.65)
            borderRadius: effectiveBorderRadius,
            border: showBorder ? border ??
                Border.all(
                  color: context.colors.cardContainerBorder,

                  /// #8A2BE2 at 10% opacity
                  width: borderWidthDefault,
                ) : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
