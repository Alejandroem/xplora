import 'package:flutter/material.dart';
import '../../theme.dart';
import 'how_it_works_page.dart';

class EnableNotificationsPage extends StatelessWidget {
  const EnableNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with ASCII loop
          Positioned.fill(
            child: Image.asset(
              'assets/png/loop-ascii.png',
            ),
          ),

          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: context.colors.bgPrimary.withValues(alpha: 0.4),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: spacing24,
                vertical: spacing32,
              ),
              child: Column(
                children: [
                  const SizedBox(height: spacing48),

                  // Notification icon with glow effect
                  Center(
                    child: Image.asset(
                      'assets/png/notification-glowing.png',
                      width: 170,
                      height: 170,
                    ),
                  ),

                  const SizedBox(height: spacing32),

                  // Title
                  Text(
                    'Stay in the loop',
                    style: h1Style.copyWith(
                      color: context.colors.textPrimary,
                      fontSize: 36,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: spacing16),

                  // Subtitle
                  Text(
                    'Get notified about quest progress, nearby\ndiscoveries, and important updates.',
                    style: bodyTextStyle.copyWith(
                      color: context.colors.textPrimary.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: spacing32),

                  // Features list
                  const Column(
                    children: [
                      _FeatureItem(
                        text: 'Quest progress updated',
                      ),
                      SizedBox(height: spacing16),
                      _FeatureItem(
                        text: 'New places discovered nearby',
                      ),
                      SizedBox(height: spacing16),
                      _FeatureItem(
                        text: 'Important updates & reminders',
                      ),
                    ],
                  ),

                  const SizedBox(height: spacing32),

                  // Buttons
                  Column(
                    children: [
                      // Enable Notifications button
                      PrimaryButton(
                        text: 'Enable Notifications',
                        backgroundColor: const Color(0xFF9D4EDD), // Purple
                        onPressed: () {
                          // TODO: Request notification permission
                          // Then navigate to How it Works page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HowItWorksPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: spacing16),

                      // Skip for now button
                      SecondaryButton(
                        text: 'Skip for now',
                        onPressed: () {
                          // Skip notification permission and proceed to How it Works
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HowItWorksPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: spacing24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Feature item with checkmark icon
class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkmark icon with glow
        Image.asset(
          'assets/png/checkmark-glowing.png',
          width: 28,
          height: 28,
        ),
        const SizedBox(width: spacing12),
        // Text
        Expanded(
          child: Text(
            text,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
