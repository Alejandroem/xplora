import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets/game_xp_page/xp_level_card.dart';
import '../widgets/game_xp_page/how_xp_earned_section.dart';
import '../widgets/game_xp_page/level_benefits_section.dart';

/// Game XP settings page
class GameXpPage extends StatelessWidget {
  const GameXpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Text(
            'Game XP',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          centerTitle: true,
          height: 64,
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(spacing16),
            child: Column(
              children: [
                XpLevelCard(
                  level: 9,
                  currentXp: 3450,
                  maxXp: 4000,
                ),
                SizedBox(height: spacing16),
                HowXpEarnedSection(),
                SizedBox(height: spacing16),
                LevelBenefitsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
