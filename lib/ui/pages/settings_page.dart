import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../application/providers/profile_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../dialogs/bottom_change_password_card.dart';
import '../widgets/email_verification_banner.dart';
import '../widgets/settings_tile.dart';
import 'privacy_policy.dart';
import 'terms_and_conditions.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProviderNotifier = ref.read(
      settingsStateNotifierProvider.notifier,
    );
    // Watch the state to trigger rebuilds when settings change
    ref.watch(settingsStateNotifierProvider);

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          height: 72,
          title: Text(
            'Settings',
            style: h2Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsTile(
                title: 'Account',
                onTap: () {
                  Navigator.pushNamed(context, '/account-settings');
                },
              ),
              SettingsTile(
                title: 'Security',
                onTap: () {
                  Navigator.pushNamed(context, '/security-settings');
                },
              ),
              SettingsTile(
                title: 'Notifications',
                onTap: () {
                  Navigator.pushNamed(context, '/notification-settings');
                },
              ),
              SettingsTile(
                title: 'Permissions',
                onTap: () {
                  Navigator.pushNamed(context, '/permission-settings');
                },
              ),
              SettingsTile(
                title: 'Game XP',
                onTap: () {
                  Navigator.pushNamed(context, '/game-xp');
                },
              ),
              SettingsTile(
                title: 'Privacy',
                onTap: () {
                  Navigator.pushNamed(context, '/privacy-settings');
                },
              ),
              SettingsTile(
                title: 'Accessibility',
                onTap: () {
                  Navigator.pushNamed(context, '/accessibility-settings');
                },
              ),
              // Test dark and light mode button
              SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: settingsProviderNotifier.isDarkMode() ?? false,
                onChanged: (bool value) {
                  settingsProviderNotifier.toggleDarkMode();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// OLD IMPLEMENTATION - Preserved for reference and logic reuse
/*
class SettingsPageOld extends ConsumerStatefulWidget {
  const SettingsPageOld({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageOldState();
}

class _SettingsPageOldState extends ConsumerState<SettingsPageOld> {
  @override
  Widget build(BuildContext context) {
    final settingsProviderNotifier = ref.watch(
      settingsStateNotifierProvider.notifier,
    );
    // Watch the state to trigger rebuilds when settings change
    ref.watch(settingsStateNotifierProvider);

    return GradientBackground(
      child: Scaffold(
        appBar: const GlassAppBar(
          title: 'Settings',
        ),
        body: ListView(
          children: [
            const EmailVerificationBanner(),
            ListTile(
              title: Text(
                'Account',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AccountSettingsPage(),
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              title: Text(
                'Change Password',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                showBottomChangePasswordCard(context);
              },
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: settingsProviderNotifier.isDarkMode() ?? false,
              onChanged: (bool value) {
                settingsProviderNotifier.toggleDarkMode();
              },
            ),
            SwitchListTile(
              title: Text(
                'Notifications',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: settingsProviderNotifier.isNotificationsEnabled(),
              onChanged: (bool value) {
                settingsProviderNotifier.toggleNotifications();
              },
            ),
            SwitchListTile(
              title: Text(
                'Location',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              value: settingsProviderNotifier.isLocationEnabled(),
              onChanged: (bool value) {
                settingsProviderNotifier.toggleLocation();
              },
            ),
            ListTile(
              title: Text(
                'Privacy',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Terms of Service',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Support',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                final url = Uri.parse('https://www.xplra.com/contact-8');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  // Handle the error here, e.g., show a snackbar or dialog
                  log('Could not launch $url');
                }
              },
            ),
            Divider(
              color: context.colors.border,
              thickness: 1,
            ),
            ListTile(
              trailing: const Icon(Icons.logout),
              title: Text(
                'Logout',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
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
            Divider(
              color: context.colors.border,
              thickness: 1,
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              trailing: const Icon(Icons.delete),
              title: Text(
                'Delete Account',
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                final profileProvider = ref.read(profileServiceProvider);
                final authProvider = ref.read(authServiceProvider);
                await profileProvider.delete(
                  (await authProvider.getAuthUser())!.id!,
                );
                await authProvider.deleteAccount();
                if (context.mounted) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
