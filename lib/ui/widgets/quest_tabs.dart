import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/models/quest.dart' as quest_model;
import '../../theme.dart';
import 'contribute_section.dart';
import 'custom_dropdown.dart';

enum QuestTab { todo, inProgress, completed }

/// Global provider to hold the currently selected quest tab.
/// Uses autoDispose so state resets when Quest screen is left.
final questTabProvider =
    StateProvider.autoDispose<QuestTab>((ref) => QuestTab.todo);

/// Tracks which quest categories are expanded (by id).
/// Also autoDispose so all categories collapse when leaving the screen.
final questCategoryExpandedProvider =
    StateProvider.autoDispose<Set<String>>((ref) => <String>{});

/// Provider for selected location in quest todo tab
/// TODO: When user location is enabled, automatically select the nearest
/// location from the available dropdown options based on GPS coordinates
final selectedLocationProvider =
    StateProvider.autoDispose<String>((ref) => 'San Juan, PR');

class _QuestCategory {
  final String id;
  final String title;
  final List<_QuestItem> quests;
  final int priority;

  const _QuestCategory({
    required this.id,
    required this.title,
    required this.quests,
    required this.priority,
  });
}

enum QuestType { location, qr, input }

class _QuestItem {
  final String title;
  final QuestType type;
  final int xp;
  final bool enabled;

  // For location type: duration in minutes
  final int? durationMinutes;

  // For QR and input types: progress tracking
  final int? currentProgress;
  final int? totalProgress;

  // For active quest: detailed information
  final String? description;
  final String? hint;

  const _QuestItem({
    required this.title,
    required this.type,
    required this.xp,
    this.enabled = true,
    this.durationMinutes,
    this.currentProgress,
    this.totalProgress,
    this.description,
    this.hint,
  });

  double? get progressPercentage {
    if (currentProgress != null &&
        totalProgress != null &&
        totalProgress! > 0) {
      return currentProgress! / totalProgress!;
    }
    return null;
  }
}

/// Quest tab content - displays content based on selected tab
class QuestTabContent extends ConsumerWidget {
  const QuestTabContent({super.key, required this.selectedTab});

  final QuestTab selectedTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

  static const _activeQuest = _QuestItem(
    title: 'El Morro Entry phrase',
    type: QuestType.input,
    description: 'Find the hidden entry phrases on the front historical monument.',
    hint: 'They\'ll become useful in the future.',
    currentProgress: 1,
    totalProgress: 3,
    xp: 60,
  );

  static const _upNext = _QuestItem(
    title: 'Fly a kite at El Morro',
    type: QuestType.location,
    durationMinutes: 30,
    currentProgress: 0,
    totalProgress: 1,
    xp: 50,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Quest heading
            Text(
              'Active Quest',
              style: h1Style.copyWith(
                color: context.colors.textPrimary,
                fontSize: 24
              ),
            ),
            const SizedBox(height: spacing8),

            // Active quest card
            const _ActiveQuestCard(quest: _activeQuest),
            const SizedBox(height: spacing16),

            // Up Next section heading
            Text(
              'Up Next',
              style: h1Style.copyWith(
                color: context.colors.textPrimary,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: spacing8),

            // Up Next quest tile with minus icon
            const _QuestListTile(item: _upNext, showMinusIcon: true),
          ],
        ),
      ),
    );
  }
}

/// Active Quest Card - displays detailed information about the current active quest
class _ActiveQuestCard extends StatelessWidget {
  const _ActiveQuestCard({required this.quest});

  final _QuestItem quest;

  String _getQuestTypeIcon() {
    switch (quest.type) {
      case QuestType.location:
        return 'assets/svg/location-pin.svg';
      case QuestType.qr:
        return 'assets/svg/scan-grey.svg';
      case QuestType.input:
        return 'assets/svg/edit-grey.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      padding: const EdgeInsets.all(spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Icon, Title + Description, XP badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quest type icon in circular container
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: context.colors.bgTertiary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    _getQuestTypeIcon(),
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.colors.iconColor.withValues(alpha: 0.7),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: spacing12),
              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (quest.description != null) ...[
                      const SizedBox(height: spacing4),
                      Text(
                        quest.description!,
                        style: bodySmallStyle.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: spacing12),
              // XP badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing12,
                  vertical: spacing4,
                ),
                decoration: BoxDecoration(
                  color: brandSecondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: brandSecondary.withValues(alpha: 0.3),
                    width: borderWidthDefault,
                  ),
                ),
                child: Text(
                  '${quest.xp}xp',
                  style: bodySmallStyle.copyWith(
                    color: brandSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          // Hint text (if available)
          if (quest.hint != null) ...[
            const SizedBox(height: spacing24),
            Text(
              'Hint: ${quest.hint}',
              style: bodySmallStyle.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ],
          // Progress section
          if (quest.currentProgress != null && quest.totalProgress != null) ...[
            const SizedBox(height: spacing8),
            // Progress text
            Text(
              '${quest.currentProgress}/${quest.totalProgress} completed',
              style: bodySmallStyle.copyWith(
                color: context.colors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 2),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(radiusMedium),
              child: SizedBox(
                height: 6,
                child: LinearProgressIndicator(
                  value: quest.progressPercentage,
                  backgroundColor: context.colors.bgTertiary,
                  valueColor: AlwaysStoppedAnimation<Color>(brandSecondary),
                  borderRadius: BorderRadius.circular(radiusMedium),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompletedTabContent extends StatelessWidget {
  const _CompletedTabContent();

  static const _completed = [
    _QuestItem(
      title: 'Completed Quest',
      type: QuestType.location,
      durationMinutes: 3,
      currentProgress: 1,
      totalProgress: 1,
      xp: 25,
    ),
    _QuestItem(
      title: 'Beach Cleanup',
      type: QuestType.qr,
      currentProgress: 5,
      totalProgress: 5,
      xp: 40,
    ),
    _QuestItem(
      title: 'City Explorer',
      type: QuestType.input,
      currentProgress: 3,
      totalProgress: 3,
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
      id: 'adventure',
      title: 'Adventure',
      priority: 1,
      quests: [
        _QuestItem(
          title: 'La Garita del Diablo',
          type: QuestType.location,
          durationMinutes: 1,
          currentProgress: 0,
          totalProgress: 1,
          xp: 50,
        ),
        _QuestItem(
          title: 'Collect El Morro QR codes',
          type: QuestType.qr,
          currentProgress: 1,
          totalProgress: 3,
          xp: 30,
        ),
        _QuestItem(
          title: 'El Morro secret',
          type: QuestType.input,
          currentProgress: 0,
          totalProgress: 1,
          xp: 20,
        ),
      ],
    ),
    _QuestCategory(
      id: 'challenges',
      title: 'Challenges',
      priority: 2,
      quests: [
        _QuestItem(
          title: 'Challange 1',
          type: QuestType.location,
          durationMinutes: 2,
          currentProgress: 0,
          totalProgress: 1,
          xp: 15,
        ),
        _QuestItem(
          title: 'Challenge 2',
          type: QuestType.qr,
          currentProgress: 0,
          totalProgress: 2,
          xp: 15,
        ),
      ],
    ),
    _QuestCategory(
      id: 'empty_category',
      title: 'Empty Category (Test)',
      priority: 3,
      quests: [], // This category has no quests and should NOT show
    ),
    _QuestCategory(
      id: 'activities',
      title: 'Activities',
      priority: 4,
      quests: [
        _QuestItem(
          title: 'Activity Quest',
          type: QuestType.input,
          currentProgress: 0,
          totalProgress: 1,
          xp: 10,
          enabled: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(questCategoryExpandedProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);

    // Filter categories to only show those that have quests, then sort by priority
    final availableCategories = _categories
        .where((category) => category.quests.isNotEmpty)
        .toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: spacing8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location dropdown
          CustomDropdown(
            label: 'Location',
            value: selectedLocation,
            items: const [
              'San Juan, PR',
              'New York, NY',
              'Los Angeles, CA',
              'Miami, FL',
              'Chicago, IL',
            ],
            onChanged: (newLocation) {
              ref.read(selectedLocationProvider.notifier).state = newLocation;
            },
            showLabel: false,
            width: MediaQuery.sizeOf(context).width * 0.42,
          ),
          const SizedBox(height: spacing16),
          // Quest categories (only those with available quests)
          ...List.generate(availableCategories.length, (index) {
            final category = availableCategories[index];
            final isExpanded = expanded.contains(category.id);
            return Column(
              children: [
                _QuestCategoryTile(
                  category: category,
                  isExpanded: isExpanded,
                  onToggle: () {
                    final notifier =
                        ref.read(questCategoryExpandedProvider.notifier);
                    final current = Set<String>.from(notifier.state);
                    if (isExpanded) {
                      current.remove(category.id);
                    } else {
                      current.add(category.id);
                    }
                    notifier.state = current;
                  },
                ),
                if (index < availableCategories.length - 1)
                  const SizedBox(height: spacing12),
              ],
            );
          }),
          // Spacing before Contribute section
          const SizedBox(height: spacing12),
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
          child: SizedBox(
            // height: 59,
            child: GlassContainer(
              borderRadius: radiusMedium,
              padding: const EdgeInsets.all(spacing16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.title,
                    style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded
                        ? context.colors.textPrimary
                        : context.colors.textPrimary.withValues(alpha: 0.7),
                    size: 25,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isExpanded) ...[
          const SizedBox(height: spacing12),
          Column(
            children: [
              for (var i = 0; i < category.quests.length; i++) ...[
                _QuestListTile(item: category.quests[i]),
                if (i != category.quests.length - 1)
                  const SizedBox(height: spacing12),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

class _QuestListTile extends StatelessWidget {
  const _QuestListTile({required this.item, this.showMinusIcon = false});

  final _QuestItem item;
  final bool showMinusIcon;

  String _getQuestTypeIcon() {
    switch (item.type) {
      case QuestType.location:
        return 'assets/svg/location-pin.svg';
      case QuestType.qr:
        return 'assets/svg/scan-grey.svg';
      case QuestType.input:
        return 'assets/svg/edit-grey.svg';
    }
  }

  String _getProgressText() {
    if (item.type == QuestType.location && item.durationMinutes != null) {
      return '${item.durationMinutes} min.';
    } else if (item.currentProgress != null && item.totalProgress != null) {
      return '${item.currentProgress}/${item.totalProgress} completed';
    }
    return '';
  }

  /// Convert _QuestItem to Quest model for navigation
  /// This is temporary mock data conversion until real data is integrated
  quest_model.Quest _toQuest() {
    // Map local QuestType to domain QuestType
    final domainQuestType = item.type == QuestType.location
        ? quest_model.QuestType.location
        : item.type == QuestType.qr
            ? quest_model.QuestType.qr
            : quest_model.QuestType.input;

    return quest_model.Quest(
      id: 'mock-${item.title.toLowerCase().replaceAll(' ', '-')}',
      userId: null,
      questId: 'quest-${item.title.toLowerCase().replaceAll(' ', '-')}',
      category: 'Adventure',
      title: item.title,
      shortDescription: item.description ?? item.title,
      longDescription: item.description ??
          'A quiet corner in the city holds a secret. Find it, observe what makes it special, and unlock its story.',
      imageUrl: 'https://picsum.photos/400/300',
      experience: item.xp.toDouble(),
      stepType: domainQuestType,
      timeInSeconds: item.durationMinutes != null ? item.durationMinutes! * 60 : null,
      stepLatitude: null,
      stepLongitude: null,
      distance: null,
      stepCode: null,
      hasNotified: null,
      completedAt: null,
      hoursToCompleteAgain: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = item.enabled;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showProgressBar = item.progressPercentage != null;

    return Container(
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled
                ? () {
                    // Navigate to quest detail screen
                    Navigator.pushNamed(
                      context,
                      '/quest-detail',
                      arguments: _toQuest(),
                    );
                  }
                : null,
            overlayColor: MaterialStateProperty.resolveWith((states) {
              if (!states.contains(MaterialState.pressed)) return null;
              return isDark ? questSplashDark : questSplashLight;
            }),
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(spacing16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quest type icon in circular container
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: context.colors.bgTertiary,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                _getQuestTypeIcon(),
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  context.colors.iconColor
                                      .withValues(alpha: 0.7),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: spacing12),
                          // Title and progress text
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
                                      fontSize: 15),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: spacing4),
                                Row(
                                  children: [
                                    if (item.type == QuestType.location &&
                                        item.durationMinutes != null) ...[
                                      SvgPicture.asset(
                                        'assets/svg/grey-clock-2.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: spacing4),
                                    ],
                                    Text(
                                      _getProgressText(),
                                      style: bodySmallStyle.copyWith(
                                        color: isEnabled
                                            ? context.colors.textSecondary.withValues(alpha: 0.6)
                                            : context.colors.textDisabled,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: spacing12,),
                          // XP badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: spacing12,
                              vertical: spacing4,
                            ),
                            decoration: BoxDecoration(
                              color: brandSecondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(radiusSmall),
                              border: Border.all(
                                  color: brandSecondary.withValues(alpha: 0.3),
                                  width: borderWidthDefault),
                            ),
                            child: Text(
                              '${item.xp}xp',
                              style: bodySmallStyle.copyWith(
                                color: brandSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: spacing12),
                        ],
                      ),
                      // Progress bar
                      if (showProgressBar) ...[
                        const SizedBox(height: spacing12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(radiusMedium),
                          child: SizedBox(
                            height: 6,
                            child: LinearProgressIndicator(
                              value: item.progressPercentage,
                              backgroundColor: context.colors.bgTertiary,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(brandSecondary),
                              borderRadius: BorderRadius.circular(radiusMedium),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // +/- icon positioned at top right
                Positioned(
                  top: -10,
                  right: -10,
                  child: IconButton(
                    onPressed: isEnabled
                        ? () {
                            // TODO: Implement quest movement
                            // + icon: When pressed, move the quest to "Up Next" section
                            // in the in-progress tab (queued for the active quest slot)
                            // - icon: When pressed, move the quest out of "Up Next" section
                            // back to the todo tab
                          }
                        : null,
                    icon: Icon(
                      showMinusIcon ? Icons.remove : Icons.add,
                      size: 20,
                      color: isEnabled
                          ? context.colors.iconColor
                          : context.colors.textDisabled,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
