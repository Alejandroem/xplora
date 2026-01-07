import 'package:flutter/material.dart';
import '../../theme.dart';

class BrowseQuestWidget extends StatelessWidget {
  const BrowseQuestWidget({
    super.key,
    required this.onBrowseQuest,
    required this.availableCount,
    required this.nearbyCount,
  });

  final VoidCallback onBrowseQuest;
  final int availableCount;
  final int nearbyCount;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center icon
              Expanded(
                child: Image.asset(
                  'assets/png/xplora-logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$availableCount Available', style: bodySmallStyle.copyWith(color: context.colors.textSecondary)),
                  Text('$nearbyCount Nearby', style: bodySmallStyle.copyWith(color: context.colors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: spacing24),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Browse Quest button
              PrimaryButton(
                onPressed: onBrowseQuest,
                text: 'Browse Quest',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
