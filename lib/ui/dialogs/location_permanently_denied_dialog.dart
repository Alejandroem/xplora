import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme.dart';
import 'base_dialog.dart';

class LocationPermanentlyDeniedDialog extends StatelessWidget {
  const LocationPermanentlyDeniedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      icon: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: feedbackAlert.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: feedbackAlert.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.location_off,
          color: feedbackAlert,
          size: 40,
        ),
      ),
      title: 'Location Access Blocked',
      description: 'Location permission is permanently denied. To enable location features, please allow location access in your device settings.',
      warningWidget: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accentPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentPrimary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Go to Settings > Apps > Xplora > Permissions > Location',
                style: bodyTextStyle.copyWith(
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            // Cancel button
            Expanded(
              child: SecondaryButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(false),
                fontSize: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(width: 16),

            // Open Settings button
            Expanded(
              flex: 2,
              child: PrimaryButton(
                text: 'Open Settings',
                onPressed: () async {
                  // Open app settings
                  await openAppSettings();
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
                fontSize: 16,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Helper function to show the location permanently denied dialog
Future<bool> showLocationPermanentlyDeniedDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const LocationPermanentlyDeniedDialog();
    },
  ) ?? false;
}
