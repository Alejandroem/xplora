import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../application/providers/adventure_providers.dart';
import '../../theme.dart';

/// Persistent Quest Progress Indicator
/// Displays minimal progress for active quest
/// Non-intrusive, fixed position element
class QuestProgressIndicator extends ConsumerWidget {
  const QuestProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questInProgress = ref.watch(adventureInProgressTrackerProvider);

    // Don't show if no quest is active
    if (questInProgress == null) {
      return const SizedBox.shrink();
    }

    final completeness = questInProgress.completeness;
    final percentage = completeness.clamp(0, 100);

    return Positioned(
      bottom: 100, // Above bottom nav bar
      left: 16,
      child: GlassContainer(
        borderRadius: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular progress indicator
            CircularPercentIndicator(
              radius: 18,
              lineWidth: 3,
              percent: percentage / 100,
              center: Text(
                '$percentage%',
                style: bodyTextStyle.copyWith(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              progressColor: accentSecondary,
              backgroundColor: strokeDivider,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 8),
            // Quest title
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Active Quest',
                    style: bodyTextStyle.copyWith(
                      fontSize: 9,
                      color: textSecondary,
                    ),
                  ),
                  Text(
                    questInProgress.adventure.title,
                    style: bodyTextStyle.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
