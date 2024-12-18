import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/profile_providers.dart';
import '../../application/providers/settings_providers.dart';
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
    final settingsProvider = ref.watch(settingsStateNotifierProvider);
    final settingsProviderNotifier = ref.watch(
      settingsStateNotifierProvider.notifier,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: settingsProvider['isDarkMode'],
            onChanged: (bool value) {
              settingsProviderNotifier.toggleDarkMode();
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: settingsProvider['isNotificationsEnabled'],
            onChanged: (bool value) {
              settingsProviderNotifier.toggleNotifications();
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
            },
          ),
        ],
      ),
    );
  }
}
