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

  /// Shimmer for location text in app bar
  static Widget locationTextShimmer({
    required BuildContext context,
  }) {
    return baseShimmer(
      context: context,
      child: Container(
        width: 85,
        height: 12,
        decoration: BoxDecoration(
          color: context.colors.bgTertiary,
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
    );
  }

  /// Shimmer grid for the interests selection screen (matches InterestButton layout)
  static Widget interestGridShimmer({
    required BuildContext context,
    int itemCount = 10,
  }) {
    // Wrap the entire grid in a single Shimmer so all items animate in sync
    return Shimmer.fromColors(
      baseColor: context.colors.bgSecondary,
      highlightColor: context.colors.bgTertiary,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: spacing12,
          mainAxisSpacing: spacing12,
        ),
        itemCount: itemCount,
        itemBuilder: (_, index) => Container(
          decoration: BoxDecoration(
            color: context.colors.bgTertiary,
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          padding: const EdgeInsets.all(spacing16),
          child: Row(
            children: [
              // Icon placeholder
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: context.colors.bgSecondary,
                  borderRadius: BorderRadius.circular(radiusSmall),
                ),
              ),
              const SizedBox(width: spacing16),
              // Label placeholder — varies width slightly for a natural look
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: index.isEven ? 0.75 : 0.55,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: context.colors.bgSecondary,
                      borderRadius: BorderRadius.circular(radiusSmall),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Adventure card shimmer (matches CarouselCard design)
  static Widget adventureCardShimmer({
    required BuildContext context,
    double? width = 160,
    double? imageHeight = 130,
    bool isInGrid = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radiusLarge),
        boxShadow: const [elevation1],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radiusLarge),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          child: Column(
            mainAxisSize: isInGrid ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image shimmer (top section)
              isInGrid
                  ? Expanded(
                      child: baseShimmer(
                        context: context,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.colors.bgTertiary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(radiusLarge),
                              topRight: Radius.circular(radiusLarge),
                            ),
                          ),
                        ),
                      ),
                    )
                  : baseShimmer(
                      context: context,
                      child: Container(
                        height: imageHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colors.bgTertiary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(radiusLarge),
                            topRight: Radius.circular(radiusLarge),
                          ),
                        ),
                      ),
                    ),
              // Bottom content section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(spacing12),
                decoration: BoxDecoration(
                  color: context.colors.bgSecondary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(radiusLarge),
                    bottomRight: Radius.circular(radiusLarge),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: spacing4),
                    // Title shimmer
                    baseShimmer(
                      context: context,
                      child: Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: context.colors.bgTertiary,
                          borderRadius: BorderRadius.circular(radiusSmall),
                        ),
                      ),
                    ),
                    // Bottom content based on card type
                    if (isInGrid) ...[
                      const SizedBox(height: spacing8),
                      // Grid: only distance shimmer
                      baseShimmer(
                        context: context,
                        child: Container(
                          width: 60,
                          height: 12,
                          decoration: BoxDecoration(
                            color: context.colors.bgTertiary,
                            borderRadius: BorderRadius.circular(radiusSmall),
                          ),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: spacing8),
                      // Carousel: city/state and distance
                      baseShimmer(
                        context: context,
                        child: Container(
                          width: 80,
                          height: 12,
                          decoration: BoxDecoration(
                            color: context.colors.bgTertiary,
                            borderRadius: BorderRadius.circular(radiusSmall),
                          ),
                        ),
                      ),
                      const SizedBox(height: spacing4),
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
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
