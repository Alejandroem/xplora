import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/profile_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../dialogs/bottom_change_password_card.dart';
import '../widgets/email_verification_banner.dart';
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
    final settingsProviderState = ref.watch(
      settingsStateNotifierProvider,
    );
    final settingsProviderNotifier = ref.watch(
      settingsStateNotifierProvider.notifier,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const EmailVerificationBanner(),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              showBottomChangePasswordCard(context);
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settingsProviderState
                        .indexWhere((setting) => setting.key == 'isDarkMode') >=
                    0
                ? settingsProviderState[settingsProviderState
                        .indexWhere((setting) => setting.key == 'isDarkMode')]
                    .value as bool
                : false,
            onChanged: (bool value) {
              settingsProviderNotifier.toggleDarkMode();
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: settingsProviderState.indexWhere(
                        (setting) => setting.key == 'isNotificationsEnabled') >=
                    0
                ? settingsProviderState[settingsProviderState.indexWhere(
                        (setting) => setting.key == 'isNotificationsEnabled')]
                    .value as bool
                : false,
            onChanged: (bool value) {
              settingsProviderNotifier.toggleNotifications();
            },
          ),
          SwitchListTile(
            title: const Text('Location'),
            value: settingsProviderState.indexWhere(
                        (setting) => setting.key == 'isLocationEnabled') >=
                    0
                ? settingsProviderState[settingsProviderState.indexWhere(
                        (setting) => setting.key == 'isLocationEnabled')]
                    .value as bool
                : false,
            onChanged: (bool value) {
              settingsProviderNotifier.toggleLocation();
            },
          ),
          ListTile(
            title: const Text('Privacy'),
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
            title: const Text('Terms of Service'),
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
            title: const Text('Support'),
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
          const Divider(),
          ListTile(
            trailing: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final authProvider = ref.read(authServiceProvider);
              await authProvider.signOut();

              //pop until /
              if (context.mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            trailing: const Icon(Icons.delete),
            title: const Text('Delete Account'),
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
    );
  }
}
