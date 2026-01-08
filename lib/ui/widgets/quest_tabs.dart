import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import 'contribute_section.dart';

enum QuestTab { todo, inProgress, completed }

/// Global provider to hold the currently selected quest tab.
/// Uses autoDispose so state resets when Quest screen is left.
final questTabProvider =
    StateProvider.autoDispose<QuestTab>((ref) => QuestTab.todo);

/// Tracks which quest categories are expanded (by id).
/// Also autoDispose so all categories collapse when leaving the screen.
final questCategoryExpandedProvider =
    StateProvider.autoDispose<Set<String>>((ref) => <String>{});

class _QuestCategory {
  final String id;
  final String title;
  final List<_QuestItem> quests;

  const _QuestCategory({
    required this.id,
    required this.title,
    required this.quests,
  });
}

class _QuestItem {
  final String title;
  final String subtitle;
  final int xp;
  final bool enabled;

  const _QuestItem({
    required this.title,
    required this.subtitle,
    required this.xp,
    this.enabled = true,
  });
}

/// Segmented quest tabs + placeholder content.
///
/// Uses design-system components (GlassContainer, spacing, typography)
/// and Riverpod state instead of setState.
class QuestTabs extends ConsumerWidget {
  const QuestTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(questTabProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassContainer(
          borderRadius: radiusPill,
          padding: const EdgeInsets.all(spacing4),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  context: context,
                  ref: ref,
                  label: 'To-do',
                  tab: QuestTab.todo,
                  selectedTab: selectedTab,
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context: context,
                  ref: ref,
                  label: 'In Progress',
                  tab: QuestTab.inProgress,
                  selectedTab: selectedTab,
                ),
              ),
              Expanded(
                child: _buildTabButton(
                  context: context,
                  ref: ref,
                  label: 'Completed',
                  tab: QuestTab.completed,
                  selectedTab: selectedTab,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: spacing16),
        Expanded(
          child: _buildTabContent(context, ref, selectedTab),
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required QuestTab tab,
    required QuestTab selectedTab,
  }) {
    final isSelected = selectedTab == tab;

    return TextButton(
      onPressed: () {
        if (!isSelected) {
          ref.read(questTabProvider.notifier).state = tab;
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: spacing8,
          horizontal: spacing12,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPill),
        ),
        backgroundColor:
            isSelected ? context.colors.bgTertiary : Colors.transparent,
        foregroundColor: isSelected
            ? context.colors.textPrimary
            : context.colors.textSecondary,
      ),
      child: Center(
        child: Text(
          label,
          style: bodyTextStyle.copyWith(
            color: isSelected
                ? context.colors.textPrimary
                : context.colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    WidgetRef ref,
    QuestTab selectedTab,
  ) {
    if (selectedTab == QuestTab.todo) {
      return _TodoTabContent(ref: ref);
    } else if (selectedTab == QuestTab.inProgress) {
      // Align so the GlassContainer only takes as much vertical
      // space as the text needs, instead of expanding to full height.
      return const Align(
        alignment: Alignment.topCenter,
        child: _InProgressTabContent(),
      );
    } else if (selectedTab == QuestTab.completed) {
      // Completed list is also top-aligned and only as tall as needed.
      return const Align(
        alignment: Alignment.topCenter,
        child: _CompletedTabContent(),
      );
    }

    String text;
    switch (selectedTab) {
      case QuestTab.todo:
        text = 'To-do quests will appear here.';
        break;
      case QuestTab.inProgress:
        text = 'Quests you are currently working on will appear here.';
        break;
      case QuestTab.completed:
        text = 'Your completed quests will appear here.';
        break;
    }

    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: bodyTextStyle.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _InProgressTabContent extends StatelessWidget {
  const _InProgressTabContent();

  static const _queued = [
    _QuestItem(
      title: 'Queued Quest',
      subtitle: 'This quest is waiting in your queue.',
      xp: 25,
    ),
    _QuestItem(
      title: 'Another Queued Quest',
      subtitle: 'Short description for the queued quest.',
      xp: 35,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // In-progress quest description (no heading)
            GlassContainer(
              borderRadius: radiusLarge,
              padding: const EdgeInsets.all(spacing16),
              child: Text(
                'You\'re currently on an adventure! This is where the in-progress '
                'quest description will appear, with details about what to do next '
                'and how to complete your quest.',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: spacing16),
        
            // Queued section heading
            Text(
              'Queued',
              style: h3Style.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: spacing8),
        
            // Queued quests list, using same quest item UI as To-do
            ClipRRect(
              borderRadius: BorderRadius.circular(radiusLarge),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.bgSecondary,
                  borderRadius: BorderRadius.circular(radiusLarge),
                  border: Border.all(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < _queued.length; i++) ...[
                      _QuestListTile(item: _queued[i]),
                      if (i != _queued.length - 1)
                        Divider(
                          height: 1,
                          color: context.colors.border,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedTabContent extends StatelessWidget {
  const _CompletedTabContent();

  static const _completed = [
    _QuestItem(
      title: 'Completed Quest',
      subtitle: 'You finished this adventure. Great job!',
      xp: 25,
    ),
    _QuestItem(
      title: 'Beach Cleanup',
      subtitle: 'Helped clean the local beach.',
      xp: 40,
    ),
    _QuestItem(
      title: 'City Explorer',
      subtitle: 'Visited 3 new locations in the city.',
      xp: 60,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radiusLarge),
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.bgSecondary,
                  borderRadius: BorderRadius.circular(radiusLarge),
                  border: Border.all(
                    color: context.colors.border,
                    width: borderWidthDefault,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < _completed.length; i++) ...[
                      _QuestListTile(item: _completed[i]),
                      if (i != _completed.length - 1)
                        Divider(
                          height: 1,
                          color: context.colors.border,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoTabContent extends ConsumerWidget {
  const _TodoTabContent({required this.ref});

  final WidgetRef ref;

  static const _categories = [
    _QuestCategory(
      id: 'go_adventure',
      title: 'Go Adventure!',
      quests: [
        _QuestItem(
          title: 'Quest Title',
          subtitle: 'Short Description',
          xp: 25,
        ),
        _QuestItem(
          title: 'Quest Title',
          subtitle: 'Short Description',
          xp: 25,
        ),
        _QuestItem(
          title: 'Quest Title',
          subtitle: 'Short Description',
          xp: 25,
        ),
      ],
    ),
    _QuestCategory(
      id: 'daily',
      title: 'Daily Quests',
      quests: [
        _QuestItem(
          title: 'Daily Quest',
          subtitle: 'Short Description',
          xp: 15,
        ),
        _QuestItem(
          title: 'Daily Quest',
          subtitle: 'Short Description',
          xp: 15,
        ),
      ],
    ),
    _QuestCategory(
      id: 'activities',
      title: 'Activities',
      quests: [
        _QuestItem(
          title: 'Activity Quest',
          subtitle: 'Short Description',
          xp: 10,
          enabled: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(questCategoryExpandedProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quest categories
          ...List.generate(_categories.length, (index) {
            final category = _categories[index];
            final isExpanded = expanded.contains(category.id);
            return Column(
              children: [
                _QuestCategoryTile(
                  category: category,
                  isExpanded: isExpanded,
                  onToggle: () {
                    final notifier = ref.read(questCategoryExpandedProvider.notifier);
                    final current = Set<String>.from(notifier.state);
                    if (isExpanded) {
                      current.remove(category.id);
                    } else {
                      current.add(category.id);
                    }
                    notifier.state = current;
                  },
                ),
                if (index < _categories.length - 1) const SizedBox(height: spacing8),
              ],
            );
          }),
          // Extra spacing before Contribute section
          const SizedBox(height: spacing24),
          // Contribute section at the end
          const ContributeSection(),
          const SizedBox(height: spacing16),
        ],
      ),
    );
  }
}

class _QuestCategoryTile extends StatelessWidget {
  const _QuestCategoryTile({
    required this.category,
    required this.isExpanded,
    required this.onToggle,
  });

  final _QuestCategory category;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: GlassContainer(
            borderRadius: radiusLarge,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing16,
              vertical: spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.title,
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: context.colors.textPrimary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: spacing4),
          ClipRRect(
            borderRadius: BorderRadius.circular(radiusLarge),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.bgSecondary,
                borderRadius: BorderRadius.circular(radiusLarge),
                border: Border.all(
                  color: context.colors.border,
                  width: borderWidthDefault,
                ),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < category.quests.length; i++) ...[
                    _QuestListTile(item: category.quests[i]),
                    if (i != category.quests.length - 1)
                      Divider(
                        height: 1,
                        color: context.colors.border,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuestListTile extends StatelessWidget {
  const _QuestListTile({required this.item});

  final _QuestItem item;

  @override
  Widget build(BuildContext context) {
    final isEnabled = item.enabled;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      // Keep transparent so the outer card's border and background
      // remain visible even for disabled items.
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? () {} : null,
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (!states.contains(MaterialState.pressed)) return null;
          return isDark ? questSplashDark : questSplashLight;
        }),
        child: Container(
          // Keep row background transparent so the outer card border
          // (including rounded corners) is always visible, even when disabled.
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? context.colors.bgTertiary
                      : context.colors.elevated,
                  borderRadius: BorderRadius.circular(radiusSmall),
                ),
              ),
              const SizedBox(width: spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: bodyTextStyle.copyWith(
                        color: isEnabled
                            ? context.colors.textPrimary
                            : context.colors.textDisabled,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: spacing4),
                    Text(
                      item.subtitle,
                      style: bodyTextStyle.copyWith(
                        color: isEnabled
                            ? context.colors.textSecondary
                            : context.colors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: spacing12),
              Text(
                '+${item.xp} XP',
                style: bodyTextStyle.copyWith(
                  color: isEnabled ? xpColor : context.colors.textDisabled,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

