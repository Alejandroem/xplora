import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';

/// Shimmer utility class with reusable shimmer widgets
class ShimmerWidgets {
  ShimmerWidgets._();

  /// Base shimmer wrapper with app theme colors
  static Widget baseShimmer({
    required BuildContext context,
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? context.colors.bgSecondary,
      highlightColor: highlightColor ?? context.colors.bgTertiary,
      child: child,
    );
  }

  /// Shimmer container for image placeholders
  static Widget imageShimmer({
    required BuildContext context,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return baseShimmer(
      context: context,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.bgTertiary,
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
      ),
    );
  }

  /// Shimmer for text placeholders
  static Widget textShimmer({
    required BuildContext context,
    double width = 100,
    double height = spacing16,
    BorderRadius? borderRadius,
  }) {
    return baseShimmer(
      context: context,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.bgTertiary,
          borderRadius: borderRadius ?? BorderRadius.circular(radiusSmall),
        ),
      ),
    );
  }

  /// Shimmer for card placeholders
  static Widget cardShimmer({
    required BuildContext context,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Widget? child,
  }) {
    return baseShimmer(
      context: context,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(spacing16),
        decoration: BoxDecoration(
          color: context.colors.bgTertiary,
          borderRadius: borderRadius ?? BorderRadius.circular(radiusMedium),
        ),
        child: child,
      ),
    );
  }

  /// Adventure card shimmer (matches CarouselCard design)
  static Widget adventureCardShimmer({
    required BuildContext context,
    double? width = 150,
    double? imageHeight = 140,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusCard),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image shimmer (top section)
          baseShimmer(
            context: context,
            child: Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.bgTertiary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(radiusCard),
                  topRight: Radius.circular(radiusCard),
                ),
              ),
            ),
          ),
          // Bottom content section
          Container(
            padding: const EdgeInsets.all(spacing8),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radiusCard),
                bottomRight: Radius.circular(radiusCard),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title shimmer
                baseShimmer(
                  context: context,
                  child: Container(
                    width: 100,
                    height: spacing16,
                    decoration: BoxDecoration(
                      color: context.colors.bgTertiary,
                      borderRadius: BorderRadius.circular(radiusSmall),
                    ),
                  ),
                ),
                const SizedBox(height: spacing4),
                // City/State shimmer
                baseShimmer(
                  context: context,
                  child: Container(
                    width: 70,
                    height: 12,
                    decoration: BoxDecoration(
                      color: context.colors.bgTertiary,
                      borderRadius: BorderRadius.circular(radiusSmall),
                    ),
                  ),
                ),
                const SizedBox(height: spacing4),
                // Category and XP row
                Row(
                  children: [
                    // Category shimmer
                    baseShimmer(
                      context: context,
                      child: Container(
                        width: 60,
                        height: 13,
                        decoration: BoxDecoration(
                          color: context.colors.bgTertiary,
                          borderRadius: BorderRadius.circular(radiusSmall),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // XP shimmer
                    baseShimmer(
                      context: context,
                      child: Container(
                        width: 50,
                        height: 13,
                        decoration: BoxDecoration(
                          color: context.colors.bgTertiary,
                          borderRadius: BorderRadius.circular(radiusSmall),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
