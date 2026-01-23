import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/privacy_settings_notifier.dart';
import '../../theme.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

class PrivacySettingsPage extends ConsumerWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacySettings = ref.watch(privacySettingsProvider);
    final notifier = ref.read(privacySettingsProvider.notifier);

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy',
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
          height: 94,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Visibility Section
                Text(
                  'Profile Visibility',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing12),
                SettingsSwitchTile(
                  title: 'Public Profile',
                  subtitle: '',
                  value: privacySettings.publicProfile,
                  onChanged: notifier.togglePublicProfile,
                ),
                SettingsSwitchTile(
                  title: 'Search Visibility',
                  subtitle: '',
                  value: privacySettings.searchVisibility,
                  onChanged: notifier.toggleSearchVisibility,
                ),
                SettingsSwitchTile(
                  title: 'Show Online Status',
                  subtitle: '',
                  value: privacySettings.showOnlineStatus,
                  onChanged: notifier.toggleShowOnlineStatus,
                ),
                const SizedBox(height: spacing16),

                // Social Interactions Section
                Text(
                  'Social Interactions',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing12),
                SettingsTile(
                  title: 'Friend Requests',
                  onTap: () {
                    // TODO: Navigate to friend requests settings
                  },
                ),
                SettingsTile(
                  title: 'Clubs & Teams Visibility',
                  onTap: () {
                    // TODO: Navigate to clubs & teams visibility settings
                  },
                ),
                const SizedBox(height: spacing16),

                // Data Preference Section
                Text(
                  'Data Preference',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing12),
                SettingsSwitchTile(
                  title: 'Location Usage',
                  subtitle: '',
                  value: privacySettings.locationUsage,
                  onChanged: notifier.toggleLocationUsage,
                ),
                SettingsSwitchTile(
                  title: 'Analytics & Crash Reports',
                  subtitle: '',
                  value: privacySettings.analyticsAndCrashReports,
                  onChanged: notifier.toggleAnalyticsAndCrashReports,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
