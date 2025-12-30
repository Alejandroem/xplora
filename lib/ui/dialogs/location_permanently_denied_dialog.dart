import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
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
          color: errorColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: errorColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.location_off,
          color: errorColor,
          size: 40,
        ),
      ),
      title: 'Location Access Blocked',
      description: 'Location permission is permanently denied. To enable location features, please allow location access in your device settings.',
      warningWidget: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: brandPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: brandPrimary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Go to Settings > Apps > Xplra > Permissions > Location',
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
                  print('Opening app settings...');
                  // Open app settings
                  // final canOpen = await openAppSettings();
                  final canOpen = await Geolocator.openAppSettings();
                  if (canOpen) {
                    print('App settings opened successfully');
                  } else {
                    print('Failed to open app settings');
                    // retry any other method (other than openAppSettings)
                  }
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
