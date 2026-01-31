import 'package:flutter/material.dart';

import '../../theme.dart';

/// See More Card for carousels
class SeeMoreCard extends StatelessWidget {
  final VoidCallback onTap;
  final double? width;

  const SeeMoreCard({
    super.key,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = GlassContainer(
      border: const Border.fromBorderSide(BorderSide.none),
      boxShadow: const [elevation1],
      borderRadius: radiusLarge,
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: context.colors.textSecondary.withValues(alpha: 0.6),
            size: iconSizeLarge * 2,
          ),
          const SizedBox(height: spacing12),
          Text(
            'See more',
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    final wrappedCard = width != null
        ? SizedBox(width: width, child: cardChild)
        : SizedBox(width: 160, child: cardChild);

    return Padding(
      padding: const EdgeInsets.only(right: spacing16),
      child: InkWell(
        onTap: onTap,
        child: wrappedCard,
      ),
    );
  }
}