import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/quest_providers.dart';
import '../../domain/models/adventure_in_progress.dart';
import '../../theme.dart';
import '../pages/quest_list_page.dart';

class CurrentQuest extends ConsumerStatefulWidget {
  const CurrentQuest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrentQuestState();
}

class _CurrentQuestState extends ConsumerState<CurrentQuest>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isCollecting = false;

  @override
  void initState() {
    super.initState();

    // Create glow/pulse animation controller
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Pulse animation: scale and opacity
    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 70,
      ),
    ]).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  // Handle reward collection and state transition
  Future<void> _collectReward(WidgetRef ref, dynamic questInProgress) async {
    // Trigger pulse animation
    setState(() {
      _isCollecting = true;
    });

    await _glowController.forward(from: 0.0);

    // Wait a bit for the animation to be visible
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      _isCollecting = false;
    });

    // TODO: Implement reward collection logic
    // 1. Award XP to user
    // 2. Mark quest as completed
    // 3. Check for queued quests
    // 4. Either start next queued quest or return to idle state

    // For now, this is a placeholder that will be connected to your state management
    // Example implementation:
    // await ref.read(userXpProvider.notifier).addXp(questInProgress.adventure.experience);
    // await ref.read(adventureInProgressTrackerProvider.notifier).completeQuest();
  }

  @override
  Widget build(BuildContext context) {
    final questInProgress = ref.watch(adventureInProgressTrackerProvider);

    // Wrap the entire widget with AnimatedSwitcher for smooth transitions
    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Combine fade and scale animations
            final fadeAnimation = animation;
            final scaleAnimation = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ));

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
          child: _buildCurrentState(context, questInProgress),
        ),
        // TEMPORARY: Test buttons to cycle through states
        // _buildTestButtons(context, questInProgress),
      ],
    );
  }

  // TEMPORARY: Test buttons overlay
  Widget _buildTestButtons(BuildContext context, dynamic questInProgress) {
    return Positioned(
      top: 8,
      right: 8,
      child: GlassContainer(
        borderRadius: 8,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cycle button: null → 60% → 100% → null
            InkWell(
              onTap: () {
                _cycleQuestState(questInProgress);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: brandPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 14,
                      color: brandPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Test',
                      style: bodyTextStyle.copyWith(
                        fontSize: 10,
                        color: brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TEMPORARY: Cycle through quest states for testing
  void _cycleQuestState(dynamic currentQuest) {
    if (currentQuest == null) {
      // null → active (60%)
      // Create a mock quest with 60% completeness
      ref.read(adventureInProgressTrackerProvider.notifier).state =
          _createMockQuest(60);
    } else {
      final completeness = currentQuest.completeness ?? 0;
      if (completeness < 100) {
        // active (60%) → complete (100%)
        ref.read(adventureInProgressTrackerProvider.notifier).state =
            _createMockQuest(100);
      } else {
        // complete (100%) → null
        ref.read(adventureInProgressTrackerProvider.notifier).state = null;
      }
    }
  }

  // TEMPORARY: Create a mock quest for testing
  AdventureInProgress? _createMockQuest(int completeness) {
    // Get first nearby adventure to use as test data
    final nearbyAdventures = ref.read(nearbyAdventuresProvider);

    return nearbyAdventures.whenOrNull(
      data: (adventures) {
        if (adventures.isEmpty) return null;

        // Return an actual AdventureInProgress object
        return AdventureInProgress(
          adventure: adventures.first,
          enteredPlaceAt: DateTime.now(),
          completeness: completeness,
        );
      },
    );
  }

  Widget _buildCurrentState(BuildContext context, dynamic questInProgress) {
    // Show idle state when no quest is active
    if (questInProgress == null) {
      final nearbyAdventures = ref.watch(nearbyQuestProvider);

      return InkWell(
        key: const ValueKey('idle_state'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const QuestListPage(),
            ),
          );
        },
        child: GlassContainer(
          borderRadius: 12,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outlined,
                color: iconColor,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'Start Quest',
                style: bodyTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Suggested Quest Preview
              nearbyAdventures.when(
                data: (adventures) {
                  if (adventures.isEmpty) {
                    return Text(
                      'No quests available nearby',
                      style: bodyTextStyle.copyWith(
                        fontSize: 11,
                        color: textSecondary.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    );
                  }

                  final suggestedQuest = adventures.first;
                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suggested',
                          style: bodyTextStyle.copyWith(
                            fontSize: 10,
                            color: textTertiary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                suggestedQuest.title,
                                style: bodySmallStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: textSecondary,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textSecondary,
                    ),
                  ),
                ),
                error: (error, stack) => Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Browse available quests',
                        style: bodyTextStyle.copyWith(
                          fontSize: 11,
                          color: textSecondary.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    final adventure = questInProgress?.adventure;
    final completeness = questInProgress?.completeness ?? 60;

    // Quest Complete State: Show when completeness is 100%
    if (completeness >= 100) {
      return GlassContainer(
        key: const ValueKey('complete_state'),
        borderRadius: 12,
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon with glow animation
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isCollecting ? _glowAnimation.value : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: _isCollecting
                          ? [
                              BoxShadow(
                                color: iconColor
                                    .withOpacity(0.5 * _glowAnimation.value),
                                blurRadius: 20 * _glowAnimation.value,
                                spreadRadius: 5 * _glowAnimation.value,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: iconColor,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),

            // Quest Complete Label
            Text(
              'Quest Complete',
              style: bodyTextStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),

            // Quest Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                adventure?.title ?? 'Quest Title',
                style: bodyTextStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),

            // Collect Reward Button with pulse animation
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isCollecting ? _glowAnimation.value : 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: _isCollecting
                          ? [
                              BoxShadow(
                                color: brandSecondary
                                    .withOpacity(0.6 * _glowAnimation.value),
                                blurRadius: 15 * _glowAnimation.value,
                                spreadRadius: 3 * _glowAnimation.value,
                              ),
                            ]
                          : null,
                    ),
                    child: PrimaryButton(
                      // width: MediaQuery.sizeOf(context).width*0.33,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      onPressed: _isCollecting
                          ? null
                          : () async {
                              // Handle reward collection
                              await _collectReward(ref, questInProgress);
                            },
                      text: 'Collect +${adventure?.experience.toInt()} XP',
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    }

    // Calculate progress count based on completeness percentage
    // For demo purposes, let's assume max steps of 5
    final maxSteps = 5;
    final currentStep =
        ((completeness / 100) * maxSteps).round().clamp(0, maxSteps);

    return InkWell(
      key: const ValueKey('active_state'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const QuestListPage(),
          ),
        );
      },
      child: GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Quest Title and XP in one row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adventure?.title ?? 'Quest Title',
                  style: bodySmallStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // XP Reward
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: xpColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        color: xpColor,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '+${adventure?.experience.toInt()} XP',
                        style: bodyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: xpColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Progress label with count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress:',
                  style: bodyTextStyle.copyWith(
                    fontSize: 12,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$currentStep/$maxSteps',
                  style: bodyTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Horizontal Progress Bar with visual blocks
            LinearPercentIndicator(
              padding: const EdgeInsets.all(0),
              lineHeight: 8.0,
              percent: completeness / 100,
              backgroundColor: border,
              progressColor: brandSecondary,
              barRadius: const Radius.circular(4),
            ),
            const SizedBox(height: 12),

            // Queued Quest Badge (hardcoded for now as requested)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: brandPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: brandPrimary.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.queue,
                      size: 18,
                      color: brandPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+2 queued',
                      style: bodyTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: brandPrimary,
                      ),
                    ),
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
