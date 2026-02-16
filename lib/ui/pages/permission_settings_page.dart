import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/permission_settings_notifier.dart';
import '../../theme.dart';
import '../widgets/settings_switch_tile.dart';

class PermissionSettingsPage extends ConsumerWidget {
  const PermissionSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionSettings = ref.watch(permissionSettingsProvider);
    final notifier = ref.read(permissionSettingsProvider.notifier);

    return GradientBackground(
      child: Scaffold(
        appBar: GlassAppBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Permissions',
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
            child: Column(children: [
              SettingsSwitchTile(
                title: 'Location Access',
                subtitle: 'Needed to show nearby places.',
                value: permissionSettings.locationAccess,
                onChanged: notifier.toggleLocationAccess,
              ),
              SettingsSwitchTile(
                title: 'Camera Access',
                subtitle: 'Required for quest and scanning.',
                value: permissionSettings.cameraAccess,
                onChanged: notifier.toggleCameraAccess,
              ),
              SettingsSwitchTile(
                title: 'Motion & Activity',
                subtitle: 'Help track your movement',
                value: permissionSettings.motionActivity,
                onChanged: notifier.toggleMotionActivity,
              ),
              SettingsSwitchTile(
                title: 'Background Refresh',
                subtitle: 'Updates progress in the background',
                value: permissionSettings.backgroundRefresh,
                onChanged: notifier.toggleBackgroundRefresh,
              ),
              SettingsSwitchTile(
                title: 'Notifications',
                subtitle: 'Alerts for XP, invites, events, and streaks.',
                value: permissionSettings.notifications,
                onChanged: notifier.toggleNotifications,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
