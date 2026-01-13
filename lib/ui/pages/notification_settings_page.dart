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
          height: 65,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: spacing8),
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
              onChanged: notifier.toggleQuestUpdates,
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
              onChanged: notifier.toggleStreakReminders,
            ),
            SettingsSwitchTile(
              title: 'Nearby Activity Alerts',
              subtitle: 'Places, quests, and events around you.',
              value: notificationSettings.nearbyActivityAlerts,
              onChanged: notifier.toggleNearbyActivityAlerts,
            ),
            SettingsSwitchTile(
              title: 'Social Interactions',
              subtitle: 'Friends and social activity.',
              value: notificationSettings.socialInteractions,
              onChanged: notifier.toggleSocialInteractions,
            ),
            SettingsSwitchTile(
              title: 'App Updates & News',
              subtitle: 'Promotions and important updates.',
              value: notificationSettings.appUpdatesNews,
              onChanged: notifier.toggleAppUpdatesNews,
            ),
          ],
        ),
      ),
    );
  }
}
