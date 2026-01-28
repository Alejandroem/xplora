import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../pages/quest_main_screen.dart';
import '../widgets/quest_tabs.dart';
import '../widgets/quest_widget.dart' show QuestWidget, QuestState;

// Test state provider for cycling through quest states
final testQuestStateProvider = StateProvider<QuestState>((ref) => QuestState.browse);

class QuestComponents extends ConsumerStatefulWidget {
  const QuestComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestComponentsState();
}

class _QuestComponentsState extends ConsumerState<QuestComponents> {
  void _cycleQuestState() {
    final currentState = ref.read(testQuestStateProvider);
    final nextState = switch (currentState) {
      QuestState.browse => QuestState.inProgress,
      QuestState.inProgress => QuestState.completed,
      QuestState.completed => QuestState.browse,
    };
    ref.read(testQuestStateProvider.notifier).state = nextState;
  }

  @override
  Widget build(BuildContext context) {
    // final questInProgress = ref.watch(adventureInProgressTrackerProvider);
    final questState = ref.watch(testQuestStateProvider);

    // Determine next state for button text
    final nextState = switch (questState) {
      QuestState.browse => 'In-Progress',
      QuestState.inProgress => 'Completed',
      QuestState.completed => 'Browse',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuestWidget(
          questState: questState,
          onStartAdventure: () {
            Navigator.of(context).pushNamed('/quest-main');
          },
          onContinue: () {
            // TODO: Continue the current quest
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QuestMainScreen(
                  initialTab: QuestTab.inProgress,
                ),
              ),
            );
          },
          onSeeMore: () {
            Navigator.of(context).pushNamed('/quest-main');
          },
        ),
        const SizedBox(height: spacing12),
        // Test button to cycle through states
        SecondaryButton(
          onPressed: _cycleQuestState,
          text: 'Test: Switch to $nextState Quest State',
        ),
      ],
    );
  }
}
