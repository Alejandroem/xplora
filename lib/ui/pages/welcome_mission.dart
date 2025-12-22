import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/location_providers.dart';
import '../../theme.dart';
import '../dialogs/first_session_dialog.dart';
import '../widgets/total_xp_badge.dart';

class WelcomeMissionPage extends ConsumerStatefulWidget {
  const WelcomeMissionPage({super.key});

  @override
  ConsumerState<WelcomeMissionPage> createState() => _WelcomeMissionPageState();
}

class _WelcomeMissionPageState extends ConsumerState<WelcomeMissionPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showFirstSessionDialogIfLocationEnabled(context, ref);
        return true;
      },
      child: GradientBackground(
        child: Scaffold(
          appBar: const GlassAppBar(title: 'logo', centerTitle: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      // Title
                      Text(
                        'Welcome Mission',
                        style: h1Style.copyWith(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Complete your first quest to get started!',
                        style: bodyTextStyle.copyWith(
                          color: textSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Quest Card
                      GlassContainer(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Quest Badge/Icon
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accentPrimary.withOpacity(0.2),
                                  border: Border.all(
                                    color: accentPrimary.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.rocket,
                                  size: 60,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Quest Title
                            Center(
                              child: Text(
                                'First Quest',
                                style: h2Style.copyWith(fontSize: 28),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Quest Description
                            Text(
                              'To begin your adventure, you need to:',
                              style: bodyTextStyle.copyWith(
                                fontSize: 16,
                                color: textPrimary,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Quest Steps
                            _buildQuestStep(
                              icon: Icons.location_on_rounded,
                              text: 'Check-in at a nearby place',
                            ),

                            const SizedBox(height: 12),

                            Center(
                              child: Text(
                                'OR',
                                style: bodyTextStyle.copyWith(
                                  color: textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            _buildQuestStep(
                              icon: Icons.qr_code_scanner_rounded,
                              text: 'Scan a QR code',
                            ),

                            const SizedBox(height: 32),

                            // Divider
                            Divider(
                              color: strokeDivider,
                              thickness: 1,
                            ),

                            const SizedBox(height: 24),

                            // Rewards Section
                            Center(
                              child: Text(
                                'Your Rewards',
                                style: h3Style.copyWith(fontSize: 20),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // XP Reward
                            TotalXpBadge(xp: 100),

                            const SizedBox(height: 16),

                            // Badge Reward
                            _buildRewardItem(
                              icon: Icons.military_tech_rounded,
                              iconColor: accentPrimary,
                              text: '"Explorer\'s First Step" badge',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      height: 56,
                      onPressed: () {
                        // Navigate to privacy consent summary
                        Navigator.of(context).pushReplacementNamed('/privacy-consent-summary');
                      },
                      text: 'Continue',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestStep({
    required IconData icon,
    required String text,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: bodyTextStyle.copyWith(
                fontSize: 16,
                color: textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              text,
              style: bodyTextStyle.copyWith(
                fontSize: 16,
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
