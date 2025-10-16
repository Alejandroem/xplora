import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/complete_profile_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../theme.dart';

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
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
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
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.7), // Darker backdrop than GlassContainer
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassContainer(
              borderRadius: 20,
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Location icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: accentPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: accentPrimary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: accentPrimary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Title
                  Text(
                    'Enable Location Access',
                    style: h1Style.copyWith(
                      color: textPrimary,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'We use your location to recommend places, validate XP, and unlock quests.',
                    style: bodyTextStyle.copyWith(
                      color: textSecondary,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  
                  // Warning text
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: feedbackAlert.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: feedbackAlert.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: feedbackAlert,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Some XP features won\'t work without location.',
                            style: bodyTextStyle.copyWith(
                              color: feedbackAlert,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Buttons
                  Row(
                    children: [
                      // Skip button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isRequesting ? null : _skipLocationPermission,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: textSecondary.withOpacity(0.3),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: bodyTextStyle.copyWith(
                              color: textSecondary,
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
                            backgroundColor: accentPrimary,
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
              ),
            ),
          ),
        ),
      ),
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
