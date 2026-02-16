import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/accessibility_settings_notifier.dart';
import '../../application/providers/settings_providers.dart';
import '../../theme.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

class AccessibilitySettingsPage extends ConsumerWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessibilitySettings = ref.watch(accessibilitySettingsProvider);
    final notifier = ref.read(accessibilitySettingsProvider.notifier);

    // Settings for dark mode
    final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
    ref.watch(settingsStateNotifierProvider);

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Accessibility',
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
                // Display Settings Section
                Text(
                  'Display Settings',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing12),
                SettingsSwitchTile(
                  title: 'Dark Mode',
                  subtitle: '',
                  value: settingsNotifier.isDarkMode() ?? false,
                  onChanged: (bool value) {
                    settingsNotifier.toggleDarkMode();
                  },
                ),
                SettingsTile(
                  title: 'Text Size',
                  onTap: () {
                    // TODO: Navigate to text size settings
                  },
                ),
                SettingsTile(
                  title: 'High Contrast Mode',
                  onTap: () {
                    // TODO: Navigate to high contrast settings
                  },
                ),
                SettingsTile(
                  title: 'Reduce Motion',
                  onTap: () {
                    // TODO: Navigate to reduce motion settings
                  },
                ),
                const SizedBox(height: spacing16),

                // Interaction Preferences Section
                Text(
                  'Interaction Preferences',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing12),
                SettingsTile(
                  title: 'Haptic Feedback',
                  onTap: () {
                    // TODO: Navigate to haptic feedback settings
                  },
                ),
                SettingsSwitchTile(
                  title: 'Simplified Mode',
                  subtitle: '',
                  value: accessibilitySettings.simplifiedMode,
                  onChanged: notifier.toggleSimplifiedMode,
                ),
                const SizedBox(height: spacing16),

                // Audio Access Section
                Text(
                  'Audio Access',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: spacing12),
                SettingsSwitchTile(
                  title: 'App Sounds',
                  subtitle: '',
                  value: accessibilitySettings.appSounds,
                  onChanged: notifier.toggleAppSounds,
                ),
                SettingsSwitchTile(
                  title: 'Voice Assistance',
                  subtitle: '',
                  value: accessibilitySettings.voiceAssistance,
                  onChanged: notifier.toggleVoiceAssistance,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
