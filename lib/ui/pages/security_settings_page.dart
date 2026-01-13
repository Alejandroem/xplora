import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/settings_tile.dart';

class SecuritySettingsPage extends ConsumerWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: context.colors.iconColor,
              size: iconSizeLarge,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Security',
                style: h2Style.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              Text(
                'Settings',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
          centerTitle: true,
          height: 65, // kToolbarHeight = 56
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: spacing8),
          children: [
            SettingsTile(
              title: 'Change Password',
              subtitle: 'Update your account password.',
              onTap: () {
                // TODO: Navigate to change password screen
              },
            ),
            SettingsTile(
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security.',
              onTap: () {
                // TODO: Navigate to 2FA settings
              },
            ),
            SettingsTile(
              title: 'Login Sessions',
              subtitle: 'Review devices logged into your account.',
              onTap: () {
                // TODO: Navigate to login sessions screen
              },
            ),
            SettingsTile(
              title: 'Recent Activity',
              subtitle: 'View recent sign-ins and actions.',
              onTap: () {
                // TODO: Navigate to recent activity screen
              },
            ),
            SettingsTile(
              title: 'Recovery Email/Phone',
              subtitle: 'Used when you get locked out.',
              onTap: () {
                // TODO: Navigate to recovery settings
              },
            ),
            const SizedBox(height: spacing24),
            // Danger Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacing16),
              child: Text(
                'Danger Section',
                style: h3Style.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: spacing8),
            SettingsTile(
              title: 'Reset Account Access',
              showTrailing: false,
              onTap: () {
                // TODO: Show confirmation dialog for reset account access
              },
            ),
            SettingsTile(
              title: 'Logout All Devices',
              showTrailing: false,
              onTap: () async {
                // TODO: Show confirmation dialog for logout all devices
                final authProvider = ref.read(authServiceProvider);
                await authProvider.signOut();
                ref.invalidate(nearbyAdventuresProvider);

                //pop until /
                if (context.mounted) {
                  showXploraSnackBar(
                    context,
                    'Logged out successfully',
                  );
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ref.read(bottomNavigationBarProvider.notifier).state =
                      NavigationItem.home;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
