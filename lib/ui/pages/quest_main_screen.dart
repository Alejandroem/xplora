import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import '../widgets/streak_summary_widget.dart';
import '../widgets/quest_tabs.dart';
import '../widgets/app_bar_tabs.dart';

/// Quest Main Screen - Browse and manage quests
/// App bar includes back button, title, and QR code scanner
class QuestMainScreen extends ConsumerStatefulWidget {
  const QuestMainScreen({super.key, this.initialTab});

  final QuestTab? initialTab;

  @override
  ConsumerState<QuestMainScreen> createState() => _QuestMainScreenState();
}

class _QuestMainScreenState extends ConsumerState<QuestMainScreen> {
  @override
  void initState() {
    super.initState();
    // Set initial tab if provided
    if (widget.initialTab != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(questTabProvider.notifier).state = widget.initialTab!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(questTabProvider);
    final selectedIndex = selectedTab.index;

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Text(
            'Quest',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          hideBottomDivider: true,
          centerTitle: true,
          height: 64,
          bottom: AppBarTabs(
            tabs: const ['Todo', 'In Progress'],
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              ref.read(questTabProvider.notifier).state = QuestTab.values[index];
            },
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.more_horiz,
          //       color: context.colors.iconColor,
          //       size: 32,
          //     ),
          //     onPressed: () {
          //       // TODO: Implement QR code scanner for quest verification
          //     },
          //   ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(spacing16, spacing8, spacing16, 0),
          child: QuestTabContent(selectedTab: selectedTab),
        ),
      ),
    );
  }
}
