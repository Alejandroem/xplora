import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';

/// Shimmer utility class with reusable shimmer widgets
class ShimmerWidgets {
  ShimmerWidgets._();

  /// Base shimmer wrapper with app theme colors
  static Widget baseShimmer({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? const Color(0xff1a1a1a),
      highlightColor: highlightColor ?? const Color(0xff2a2a2a),
      child: child,
    );
  }

  /// Shimmer container for image placeholders
  static Widget imageShimmer({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return baseShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(0),
        ),
      ),
    );
  }

  /// Shimmer for cached network image placeholder
  static Widget cachedImageShimmer({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xff121212),
        highlightColor: const Color(0xff2a2a2a),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1a1a1a),
            borderRadius: borderRadius ?? BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  /// Shimmer for text placeholders
  static Widget textShimmer({
    double width = 100,
    double height = 16,
    BorderRadius? borderRadius,
  }) {
    return baseShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Shimmer for card placeholders
  static Widget cardShimmer({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    Widget? child,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: baseShimmer(
        child: child ??
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }

  /// Shimmer for circular/avatar placeholders
  static Widget circleShimmer({
    double radius = 40,
  }) {
    return baseShimmer(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Adventure card shimmer (specific to carousel cards)
  static Widget adventureCardShimmer({
    double width = 160,
    double height = 200,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xff121212),
        highlightColor: const Color(0xff2a2a2a),
        period: const Duration(milliseconds: 1500),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1a1a1a),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.7,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xff2a2a2a),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xff2a2a2a),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 40,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xff2a2a2a),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: width * 0.9,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xff2a2a2a),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
