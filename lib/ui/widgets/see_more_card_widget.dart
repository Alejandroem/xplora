import 'package:flutter/material.dart';

import '../../theme.dart';

/// See More Card for carousels
class SeeMoreCard extends StatelessWidget {
  final VoidCallback onTap;

  const SeeMoreCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: spacing16),
        child: GlassContainer(
          borderRadius: radiusCard,
          padding: const EdgeInsets.all(spacing16),
          child: SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: context.colors.textSecondary,
                  size: iconSizeLarge*2,
                ),
                Text(
                  'See more',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}