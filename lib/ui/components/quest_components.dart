import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../pages/quest_main_screen.dart';
import '../widgets/quest_tabs.dart';
import '../widgets/quest_widget.dart' show QuestWidget, QuestState;

// Test state provider for cycling through quest states
final testQuestStateProvider =
    StateProvider<QuestState>((ref) => QuestState.browse);

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

    // Watch user ID to react to auth state changes (login/logout)
    final userIdAsync = ref.watch(currentAuthUserIdStreamProvider);
    final userId = userIdAsync.value;

    // Determine next state for button text
    final nextState = switch (questState) {
      QuestState.browse => 'In-Progress',
      QuestState.inProgress => 'Completed',
      QuestState.completed => 'Browse',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Quest',
            style: h3Style.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: spacing8),
        QuestWidget(
          questState: questState,
          onStartAdventure: () {
            if (userId == null) {
              showXploraSnackBar(
                context,
                'Please sign in to start quest',
                isInfo: true,
                duration: const Duration(seconds: 2),
              );
              return;
            }

            Navigator.of(context).pushNamed('/quest-main');
          },
          onDetails: () {
            if (userId == null) {
              showXploraSnackBar(
                context,
                'Please sign in to view quest details',
                isInfo: true,
                duration: const Duration(seconds: 2),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QuestMainScreen(
                  initialTab: QuestTab.inProgress,
                ),
              ),
            );
          },
          onSeeMore: () {
            if (userId == null) {
              showXploraSnackBar(
                context,
                'Please sign in to view more quests',
                isInfo: true,
                duration: const Duration(seconds: 2),
              );
              return;
            }

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
