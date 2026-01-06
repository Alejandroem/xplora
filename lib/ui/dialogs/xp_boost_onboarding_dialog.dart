import 'package:flutter/material.dart';
import '../../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/total_xp_badge.dart';
import 'base_dialog.dart';

/// XP Boost Onboarding Dialog - Encourages users to complete additional profile setup
class XpBoostOnboardingDialog extends StatelessWidget {
  const XpBoostOnboardingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      icon: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: brandPrimary.withOpacity(0.2),
          border: Border.all(
            color: brandPrimary.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.rocket_launch,
            color: context.colors.textPrimary,
            size: 45,
          ),
        ),
      ),
      title: 'Boost Your XP!',
      description: 'Complete your profile and unlock bonus XP to level up faster on your exploration journey.',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // XP Boost items
          const _BoostItem(
            icon: Icons.person_outline,
            title: 'Complete Profile',
            description: 'Add bio & social links',
            xpReward: '+25 XP',
          ),
          const SizedBox(height: 12),
          const _BoostItem(
            icon: Icons.notifications_outlined,
            title: 'Enable Notifications',
            description: 'Stay updated on quests',
            xpReward: '+25 XP',
          ),
          const SizedBox(height: 12),
          const _BoostItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Link Wallet',
            description: 'Connect your DID (coming soon)',
            xpReward: '+50 XP',
            isComingSoon: true,
          ),
          const SizedBox(height: 12),
          const _BoostItem(
            icon: Icons.card_giftcard,
            title: 'Referral Reward',
            description: 'Invite friends to earn',
            xpReward: '+50 XP',
          ),
          const SizedBox(height: 12),
          const _BoostItem(
            icon: Icons.military_tech_outlined,
            title: 'Badges for onboarding milestones',
            description: 'Unlock special achievements',
            xpReward: '',
          ),
          const SizedBox(height: 24),

          // Total XP Badge
          TotalXpBadge(xp: 200),
        ],
      ),
      actions: [
        Row(
          children: [
            // Skip button
            Expanded(
              child: SecondaryButton(
                text: 'Skip',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(width: 12),

            // Continue button
            Expanded(
              flex: 2,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                text: 'Let\'s Go!',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual boost item widget
class _BoostItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String xpReward;
  final bool isComingSoon;

  const _BoostItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.xpReward,
    this.isComingSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.colors.iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: context.colors.iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: bodySmallStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isComingSoon) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.textSecondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Soon',
                          style: bodyTextStyle.copyWith(
                            fontSize: 10,
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: bodyTextStyle.copyWith(
                    fontSize: 12,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // XP Reward
          if (xpReward.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: xpColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                xpReward,
                style: bodyTextStyle.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper function to show the XP boost onboarding dialog
Future<bool?> showXpBoostOnboardingDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const XpBoostOnboardingDialog();
    },
  );
}
