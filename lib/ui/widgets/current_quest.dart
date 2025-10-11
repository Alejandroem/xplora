import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../application/providers/adventure_providers.dart';
import '../../theme.dart';

class CurrentQuest extends ConsumerStatefulWidget {
  const CurrentQuest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrentQuestState();
}

class _CurrentQuestState extends ConsumerState<CurrentQuest> {
  @override
  Widget build(BuildContext context) {
    final questInProgress = ref.watch(adventureInProgressTrackerProvider);
    if (questInProgress == null) {
      return const SizedBox.shrink();
    }

    final completeness = questInProgress.completeness;
    final percentage = completeness.clamp(0, 100);

    return InkWell(
      onTap: () {
        /* Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuestDetail(widget.quest),
          ),
        ); */
      },
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.flag_circle,
                          color: accentPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'IN PROGRESS',
                          style: bodyTextStyle.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: accentPrimary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      questInProgress.adventure.title,
                      style: subHeadingLabelStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      questInProgress.adventure.shortDescription,
                      style: bodyTextStyle.copyWith(
                        fontSize: 12,
                        color: textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Progress percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: bodyTextStyle.copyWith(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: bodyTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: accentSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Progress bar
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: LinearPercentIndicator(
                padding: const EdgeInsets.all(0),
                lineHeight: 6.0,
                percent: percentage / 100,
                backgroundColor: strokeDivider,
                progressColor: accentSecondary,
                barRadius: const Radius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
