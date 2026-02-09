import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import 'enable_notifications_page.dart';

class EnableLocationPage extends StatelessWidget {
  const EnableLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with ASCII globe
          Positioned.fill(
            child: Image.asset(
              'assets/png/globe-ascii.png',
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

                  // Location icon with glow effect
                  Center(
                    child: Image.asset(
                      'assets/png/location-pin-glowing.png',
                      width: 150,
                      height: 150,
                    ),
                  ),

                  const SizedBox(height: spacing32),

                  // Title
                  Text(
                    'Enable Location',
                    style: h1Style.copyWith(
                        color: context.colors.textPrimary, fontSize: 36),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: spacing16),

                  // Subtitle
                  Text(
                    'We use your location to show nearby\nplaces, quests, and community activity.',
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
                        text: 'Confirm quest completion',
                      ),
                      SizedBox(height: spacing16),
                      _FeatureItem(
                        text: 'Verified XP rewards',
                      ),
                      SizedBox(height: spacing16),
                      _FeatureItem(
                        text: 'Anti-cheat protection',
                      ),
                    ],
                  ),

                  const SizedBox(height: spacing32),

                  // Buttons
                  Column(
                    children: [
                      // Allow Location button
                      PrimaryButton(
                        text: 'Allow Location',
                        backgroundColor: const Color(0xFF9D4EDD), // Purple
                        onPressed: () {
                          // TODO: Request location permission
                          // Then navigate to notifications page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EnableNotificationsPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: spacing16),

                      // Maybe Later button
                      SecondaryButton(
                        text: 'Maybe Later',
                        onPressed: () {
                          // Skip location permission and proceed to notifications
                          Navigator.of(context).pushReplacementNamed('/enable-notifications');
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
