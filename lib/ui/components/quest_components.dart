import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../theme.dart';
import '../pages/quest_list_page.dart';
import '../widgets/current_quest.dart';

class QuestComponents extends ConsumerStatefulWidget {
  const QuestComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestComponentsState();
}

class _QuestComponentsState extends ConsumerState<QuestComponents> {
  @override
  Widget build(BuildContext context) {
    final questInProgress = ref.watch(adventureInProgressTrackerProvider);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.explore,
                  color: context.colors.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  questInProgress == null ? 'Nearby Quests' : 'Active Quest',
                  style: h3Style,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const QuestListPage(),
                                ),
                              );
                            },
                            child: GlassContainer(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list_alt,
                                    color: context.colors.iconColor,
                                    size: 30,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'View Quests',
                                    style: bodyTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: context.colors.textPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GlassContainer(
                            borderRadius: 12,
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.smart_toy_outlined,
                                  color: context.colors.iconColor,
                                  size: 30,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lora AI',
                                  style: bodyTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Coming Soon',
                                  style: bodyTextStyle.copyWith(
                                    fontSize: 10,
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CurrentQuest(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
