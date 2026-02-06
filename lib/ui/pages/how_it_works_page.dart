import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spacing24,
            vertical: spacing32,
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              // Title
              Text(
                'How it Works',
                style: h1Style.copyWith(
                  color: context.colors.textPrimary,
                  fontSize: 32,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              // Feature 1: Explore & discover
              const _FeatureRow(
                svgPath: 'assets/png/building-pin.svg',
                title: 'Explore & discover\nthe world',
              ),

              const SizedBox(height: spacing48),

              // Feature 2: Complete quests
              const _FeatureRow(
                svgPath: 'assets/svg/checked-clipboard.svg',
                title: 'Complete quests\n& activities',
              ),

              const SizedBox(height: spacing48),

              // Feature 3: Earn XP
              const _FeatureRow(
                svgPath: 'assets/svg/xp.svg',
                title: 'Earn XP and\nunlock access',
              ),

              const Spacer(),

              // Get Started button
              PrimaryButton(
                text: 'Get Started',
                backgroundColor: const Color(0xFF9D4EDD), // Purple
                onPressed: () {
                  // Navigate to home or main screen
                  Navigator.of(context).pop();
                },
              ),

              const SizedBox(height: spacing32),
            ],
          ),
        ),
      ),
    );
  }
}

/// Feature row with icon and text
class _FeatureRow extends StatelessWidget {
  final String svgPath;
  final String title;

  const _FeatureRow({
    required this.svgPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        SvgPicture.asset(
          svgPath,
          width: 80,
          height: 80,
        ),
        const SizedBox(width: spacing24),
        // Text
        Expanded(
          child: Text(
            title,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary.withValues(alpha: 0.9),
              fontSize: 20
            ),
          ),
        ),
      ],
    );
  }
}
