import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

/// Economy Hub - XPC wallet and economic information
class EconomyHub extends ConsumerStatefulWidget {
  const EconomyHub({super.key});

  @override
  ConsumerState<EconomyHub> createState() => _EconomyHubState();
}

class _EconomyHubState extends ConsumerState<EconomyHub> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // XPC Logo/Icon
          Text(
            'XPC',
            style: h1Style.copyWith(
              fontSize: 100,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Coming Soon Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.colors.bgSecondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: context.colors.border,
                width: 1,
              ),
            ),
            child: Text(
              'Coming Soon',
              style: h3Style.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // XPC Description
          GlassContainer(
            borderRadius: 16,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'About XPC',
                      style: h3Style.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'XPC is the digital currency powering the XPLRA ecosystem. Earn XPC by exploring your surroundings, completing quests, and engaging with the app.',
                  style: bodyTextStyle.copyWith(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'With the XPC Wallet, securely manage your rewards, track your balance, buy XPC to increase its value, and use XPC to unlock exclusive content, collectibles, and more.',
                  style: bodyTextStyle.copyWith(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Stay tuned for its release!',
                  style: bodyTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Feature Cards
          _buildFeatureCard(
            icon: Icons.trending_up,
            title: 'Earn XPC',
            description: 'Complete quests and explore to earn rewards',
          ),

          const SizedBox(height: 16),

          _buildFeatureCard(
            icon: Icons.store,
            title: 'Spend XPC',
            description: 'Unlock exclusive content and collectibles',
          ),

          const SizedBox(height: 16),

          _buildFeatureCard(
            icon: Icons.analytics,
            title: 'Track Balance',
            description: 'Monitor your XPC wallet and transactions',
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    Color? color,
  }) {
    color = context.colors.iconColor;
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: bodyTextStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: bodyTextStyle.copyWith(
                    fontSize: 13,
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
