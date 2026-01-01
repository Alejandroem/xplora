import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../theme.dart';
import 'base_dialog.dart';
import 'location_permanently_denied_dialog.dart';

class LocationPermissionDialog extends ConsumerStatefulWidget {
  const LocationPermissionDialog({super.key});

  @override
  ConsumerState<LocationPermissionDialog> createState() => _LocationPermissionDialogState();
}

class _LocationPermissionDialogState extends ConsumerState<LocationPermissionDialog> {
  bool _isRequesting = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      Location location = Location();

      // Check if location services are enabled
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          // Update settings - location denied
          final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
          await settingsNotifier.setLocationEnabled(false);

          if (mounted) {
            Navigator.of(context).pop(false);
          }
          return;
        }
      }

      // Check for location permissions
      PermissionStatus permissionGranted = await location.hasPermission();

      // If permission is permanently denied, show settings dialog
      if (permissionGranted == PermissionStatus.deniedForever) {
        if (mounted) {
          // await showLocationPermanentlyDeniedDialog(context);
          // Update settings - location denied
          final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
          await settingsNotifier.setLocationEnabled(false);
          Navigator.of(context).pop(false);
        }
        return;
      }

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();

        // Check if it became permanently denied after requesting
        if (permissionGranted == PermissionStatus.deniedForever) {
          if (mounted) {
            // await showLocationPermanentlyDeniedDialog(context);
            // Update settings - location denied
            final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
            await settingsNotifier.setLocationEnabled(false);
            Navigator.of(context).pop(false);
          }
          return;
        }

        if (permissionGranted != PermissionStatus.granted &&
            permissionGranted != PermissionStatus.grantedLimited) {
          // Update settings - location denied
          final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
          await settingsNotifier.setLocationEnabled(false);

          if (mounted) {
            Navigator.of(context).pop(false);
          }
          return;
        }
      }

      // Enable location tracking for notifiers
      ref.read(locationTrackingEnabledProvider.notifier).state = true;

      // Initialize location tracking in the location provider
      ref.read(locationProvider.notifier).initializeLocationTracking();

      // Invalidate location permission provider to refresh the permission status
      ref.invalidate(locationPermissionProvider);

      // Invalidate nearby adventures provider to refresh the adventures list
      ref.invalidate(nearbyAdventuresProvider);

      // Update settings - location allowed
      final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
      await settingsNotifier.setLocationEnabled(true);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  void _skipLocationPermission() async {
    // Update settings - location denied/skipped
    final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
    await settingsNotifier.setLocationEnabled(false);

    if (mounted) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      icon: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: brandPrimary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: brandPrimary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.location_on,
          color: brandPrimary,
          size: 40,
        ),
      ),
      title: 'Enable Location Access',
      description: 'We use your location to recommend places, validate XP, and unlock quests.',
      warningWidget: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: errorColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: errorColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Some XP features won\'t work without location.',
                style: bodyTextStyle.copyWith(
                  color: errorColor,
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
            // Skip button
            Expanded(
              child: OutlinedButton(
                onPressed: _isRequesting ? null : _skipLocationPermission,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: context.colors.textSecondary.withOpacity(0.3),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Skip',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Allow button
            Expanded(
              child: ElevatedButton(
                onPressed: _isRequesting ? null : _requestLocationPermission,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: brandPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isRequesting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Allow',
                        style: bodyTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Helper function to show the location permission dialog
Future<bool> showLocationPermissionDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return const LocationPermissionDialog();
    },
  ) ?? false;
}
