import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/permission_settings_notifier.dart';
import '../../theme.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

class PermissionSettingsPage extends ConsumerWidget {
  const PermissionSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionSettings = ref.watch(permissionSettingsProvider);
    final notifier = ref.read(permissionSettingsProvider.notifier);

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
          height: 65,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: spacing8),
          children: [
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
            SettingsTile(
              title: 'Notifications',
              subtitle: 'Alerts for XP, invites, events, and streaks.',
              onTap: () {
                Navigator.pushNamed(context, '/notification-settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
