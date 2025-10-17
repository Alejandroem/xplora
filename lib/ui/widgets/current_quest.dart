import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../application/providers/adventure_providers.dart';
import '../../theme.dart';
import '../pages/quest_list_page.dart';

class CurrentQuest extends ConsumerStatefulWidget {
  const CurrentQuest({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurrentQuestState();
}

class _CurrentQuestState extends ConsumerState<CurrentQuest> {
  // Handle reward collection and state transition
  Future<void> _collectReward(WidgetRef ref, dynamic questInProgress) async {
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

    // Show idle state when no quest is active
    if (questInProgress == null) {
      final nearbyAdventures = ref.watch(nearbyAdventuresProvider);

      return InkWell(
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
                style: subHeadingLabelStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
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
                            color: textSecondary,
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
                                style: subHeadingLabelStyle.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                ),
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
                error: (error, stack) => Text(
                  'Browse available quests',
                  style: bodyTextStyle.copyWith(
                    fontSize: 11,
                    color: textSecondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final adventure = questInProgress.adventure;
    final completeness = questInProgress.completeness;

    // Quest Complete State: Show when completeness is 100%
    if (completeness >= 100) {
      return GlassContainer(
        borderRadius: 12,
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: iconColor,
                size: 40,
              ),
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
                style: subHeadingLabelStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),

            // Collect Reward Button
            PrimaryButton(
              width: MediaQuery.sizeOf(context).width*0.33,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              onPressed: () async {
                // Handle reward collection
                await _collectReward(ref, questInProgress);
              },
              text: 'Collect +${adventure?.experience.toInt()} XP',
            ),
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
                  adventure.title,
                  style: subHeadingLabelStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // XP Reward
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentSecondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        color: accentSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '+${adventure.experience.toInt()} XP',
                        style: bodyTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: accentSecondary,
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
              backgroundColor: strokeDivider,
              progressColor: accentSecondary,
              barRadius: const Radius.circular(4),
            ),
            const SizedBox(height: 12),

            // Queued Quest Badge (hardcoded for now as requested)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: accentPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: accentPrimary.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.queue,
                      size: 18,
                      color: accentPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+2 queued',
                      style: bodyTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentPrimary,
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
