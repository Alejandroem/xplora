import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../dialogs/security_settings_page/logout_dialog.dart';
import '../dialogs/security_settings_page/reset_account_access_dialog.dart';
import '../widgets/settings_tile.dart';

class SecuritySettingsPage extends ConsumerWidget {
  const SecuritySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
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
          height: 94, // kToolbarHeight = 56
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(spacing16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SettingsTile(
              leadingIcon: 'assets/svg/lock.svg',
              title: 'Change Password',
              subtitle: 'Update your account password.',
              onTap: () {
                // TODO: Navigate to change password screen
              },
            ),
            SettingsTile(
              leadingIcon: 'assets/svg/shield-check.svg',
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security.',
              onTap: () {
                // TODO: Navigate to 2FA settings
              },
            ),
            SettingsTile(
              leadingIcon: 'assets/svg/monitor.svg',
              title: 'Login Sessions',
              subtitle: 'Review devices logged into your account.',
              onTap: () {
                // TODO: Navigate to login sessions screen
              },
            ),
            SettingsTile(
              leadingIcon: 'assets/svg/clock.svg',
              title: 'Recent Activity',
              subtitle: 'View recent sign-ins and actions.',
              onTap: () {
                // TODO: Navigate to recent activity screen
              },
            ),
            SettingsTile(
              leadingIcon: 'assets/svg/envelope.svg',
              title: 'Recovery Email/Phone',
              subtitle: 'Used when you get locked out.',
              onTap: () {
                // TODO: Navigate to recovery settings
              },
            ),
            const SizedBox(height: spacing24),
            // Danger Section
            Text(
              'Danger Section',
              style: h3Style.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: spacing24),
            PrimaryButton(
              text: 'Reset Account Access',
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showResetAccountAccessDialog(context);

                // if (confirmed == true && context.mounted) {
                //   // TODO: Implement reset account access logic
                //   showXploraSnackBar(
                //     context,
                //     'Account access reset successfully',
                //   );
                // }
              },
            ),
            const SizedBox(height: spacing16),
            SecondaryButton(
              text: 'Logout',
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showLogoutDialog(context);

                if (confirmed == true && context.mounted) {
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
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
