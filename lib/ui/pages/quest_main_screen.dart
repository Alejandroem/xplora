import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets/quest_list.dart';
import '../widgets/streak_summary_widget.dart';

/// Quest Main Screen - Browse and manage quests
/// App bar includes back button, title, and QR code scanner
class QuestMainScreen extends StatelessWidget {
  const QuestMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Text(
            'Quest',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.colors.iconColor,
              size: iconSizeLarge,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.qr_code_scanner,
                color: context.colors.iconColor,
                size: iconSizeLarge,
              ),
              onPressed: () {
                // TODO: Implement QR code scanner for quest verification
              },
            ),
          ],
        ),
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Summary at the top (non-scrollable)
            Padding(
              padding: EdgeInsets.fromLTRB(spacing16, spacing16, spacing16, 0),
              child: StreakSummaryWidget(
                currentXp: 5787, // TODO: Get from user profile provider
                totalXp: 8000, // TODO: Get from level calculation
                dayStreak: 137, // TODO: Get from streak provider
                weekProgress: [true, true, true, true, false, false, false], // TODO: Get from activity tracking
              ),
            ),
          ],
        ),
      ),
    );
  }
}
