import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../application/providers/adventure_providers.dart';

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
    return InkWell(
      onTap: () {
        /* Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuestDetail(widget.quest),
          ),
        ); */
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        questInProgress.adventure.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        questInProgress.adventure.shortDescription,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // TODO: Used for quest with steps
                      /* Text(
                        'Step ${widget.quest.steps.indexWhere(
                              (element) {
                                return element.completed == false;
                              },
                            ) + 1} of ${widget.quest.steps.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ), */
                    ],
                  ),
                ),
              ),
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: LinearPercentIndicator(
                  padding: const EdgeInsets.all(0),
                  lineHeight: 14.0,
                  percent: questInProgress.completeness / 100,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
