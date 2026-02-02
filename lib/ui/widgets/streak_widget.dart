import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import '../components/quest_components.dart';
import 'quest_widget.dart' show QuestState;

class StreakWidget extends ConsumerWidget {
  const StreakWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the test quest state
    // final questState = ref.watch(testQuestStateProvider);

    // Dummy data
    int currentStreak = 3; // Test with multi-week streak
    const int visibleDays = 7;
    // Always show 7 days, starting from first circle

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // STREAK heading
        Text('Streak',
            style: h3Style.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: spacing8),
        Expanded(
          child: GlassContainer(
            showBorder: false,
            boxShadow: const [elevation1],
            padding: const EdgeInsets.all(spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Header with icon and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/flame.svg',
                      colorFilter:
                          ColorFilter.mode(brandSecondary, BlendMode.srcIn),
                      width: iconSizeLarge,
                      height: iconSizeLarge,
                    ),
                    const SizedBox(width: spacing12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$currentStreak-Day Streak',
                            style: bodyTextStyle.copyWith(
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: spacing12),
                          // Day indicators (dots)
                          Wrap(
                            spacing: spacing8,
                            runSpacing: spacing8,
                            children: List.generate(visibleDays, (index) {
                              return _DayIndicator(
                                index: index,
                                currentStreak: currentStreak,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Description text
                // Text(
                //   'Stay consistent to unlock rewards',
                //   // currentStreak > 0
                //   //     ? 'You\'ve explored $currentStreak ${currentStreak == 1 ? 'day' : 'days'} in a row.'
                //   //     : 'Start your exploration streak today!',
                //   style: bodySmallStyle.copyWith(
                //     color: context.colors.textSecondary,
                //   ),
                // ),
                // const SizedBox(height: 6),

                // if (questState == QuestState.inProgress ||
                //     questState == QuestState.completed) ...[
                //   const SizedBox(height: spacing12),
                //   Text(
                //     'Keep up the momentum',
                //     style: bodySmallStyle.copyWith(
                //         color: context.colors.textSecondary, fontSize: 11),
                //   )
                // ],
                // const SizedBox(height: spacing16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DayIndicator extends StatelessWidget {
  final int index;
  final int currentStreak;

  const _DayIndicator({
    required this.index,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate position within current week (0-6)
    // For multi-week streaks, show only current week's progress
    final currentWeekPosition =
        currentStreak > 0 ? (currentStreak - 1) % 7 : -1;

    // Determine states
    final isCompleted = index <= currentWeekPosition;
    final isCurrentTarget =
        index == currentWeekPosition + 1 && currentWeekPosition < 6;

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? brandSecondary
            : context.colors.textPrimary.withValues(alpha: 0.2),
        border: isCurrentTarget
            ? Border.all(
                color: brandSecondary,
                width: borderWidthDefault,
              )
            : null,
      ),
    );
  }
}
