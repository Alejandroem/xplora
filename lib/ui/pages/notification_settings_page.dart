import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/notification_settings_notifier.dart';
import '../../theme.dart';
import '../widgets/settings_switch_tile.dart';

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationSettings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Notifications',
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
              children: [
              SettingsSwitchTile(
                title: 'Allow Notifications',
                subtitle: 'Enable push notifications.',
                value: notificationSettings.allowNotifications,
                onChanged: notifier.toggleAllowNotifications,
              ),
              SettingsSwitchTile(
                title: 'Quest Updates',
                subtitle: 'Alerts for new quest and progress.',
                value: notificationSettings.questUpdates,
                onChanged: null,
              ),
              SettingsSwitchTile(
                title: 'XP Progress',
                subtitle: 'Level-ups and XP milestones.',
                value: notificationSettings.xpProgress,
                onChanged: notifier.toggleXpProgress,
              ),
              SettingsSwitchTile(
                title: 'Streak Reminders',
                subtitle: 'Keep your daily XP streak alive.',
                value: notificationSettings.streakReminders,
                onChanged: null,
              ),
              SettingsSwitchTile(
                title: 'Nearby Activity Alerts',
                subtitle: 'Places, quests, and events around you.',
                value: notificationSettings.nearbyActivityAlerts,
                onChanged: null,
              ),
              SettingsSwitchTile(
                title: 'Social Interactions',
                subtitle: 'Friends and social activity.',
                value: notificationSettings.socialInteractions,
                onChanged: null,
              ),
              SettingsSwitchTile(
                title: 'App Updates & News',
                subtitle: 'Promotions and important updates.',
                value: notificationSettings.appUpdatesNews,
                onChanged: notifier.toggleAppUpdatesNews,
              ),
            ],
            ),
          )),
      ),
    );
  }
}
