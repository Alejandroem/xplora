import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class TotalXpBadge extends StatelessWidget {
  TotalXpBadge({super.key, required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: bgTertiary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: border,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 14),
          Text(
            'Earn up to $xp XP',
            style: xpNumberStyle
          ),
        ],
      ),
    );
  }
}
