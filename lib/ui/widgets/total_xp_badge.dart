import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class TotalXpBadge extends StatelessWidget {
  TotalXpBadge({super.key, required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: xpColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: xpColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 20,
          ),
          const SizedBox(width: 14),
          Text(
            'Earn up to $xp XP',
            style: bodyTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
