import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';

// State provider to track which button is loading
final _locationLoadingStateProvider = StateProvider.autoDispose<String?>((ref) => null);

class EnableLocationPage extends ConsumerWidget {
  const EnableLocationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
    final loadingState = ref.watch(_locationLoadingStateProvider);

    final isAllowLoading = loadingState == 'allow';
    final isLaterLoading = loadingState == 'later';
    return Scaffold(
      body: Stack(
        children: [
          // Background with ASCII globe
          Positioned.fill(
            child: Image.asset(
              'assets/png/globe-ascii.png',
            ),
          ),

          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: context.colors.bgPrimary.withValues(alpha: 0.4),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing24,
                  vertical: spacing32,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 48.h),
              
                    // Location icon with glow effect
                    Center(
                      child: Image.asset(
                        'assets/png/location-pin-glowing.png',
                        width: 150,
                        height: 150,
                      ),
                    ),
              
                    const SizedBox(height: spacing32),
              
                    // Title
                    Text(
                      'Enable Location',
                      style: h1Style.copyWith(
                          color: context.colors.textPrimary, fontSize: 36),
                      textAlign: TextAlign.center,
                    ),
              
                    const SizedBox(height: spacing16),
              
                    // Subtitle
                    Text(
                      'We use your location to show nearby\nplaces, quests, and community activity.',
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textPrimary.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
              
                    const SizedBox(height: spacing32),
              
                    // Features list
                    const Column(
                      children: [
                        _FeatureItem(
                          text: 'Confirm quest completion',
                        ),
                        SizedBox(height: spacing16),
                        _FeatureItem(
                          text: 'Verified XP rewards',
                        ),
                        SizedBox(height: spacing16),
                        _FeatureItem(
                          text: 'Anti-cheat protection',
                        ),
                      ],
                    ),
              
                    const SizedBox(height: spacing32),
              
                    // Buttons
                    Column(
                      children: [
                        // Allow Location button
                        PrimaryButton(
                          text: isAllowLoading ? 'Loading...' : 'Allow Location',
                          onPressed: loadingState != null ? null : () async {
                            // Set loading state
                            ref.read(_locationLoadingStateProvider.notifier).state = 'allow';
              
                            try {
                              // Request location permission
                              PermissionStatus status;
                              try {
                                status = await Permission.location.request();
                                print('Location permission status: $status');
                              } catch (e) {
                                // Show permission request error
                                if (context.mounted) {
                                  showXploraSnackBar(
                                    context,
                                    'Failed to request location permission',
                                    isError: true,
                                  );
                                }
                                return;
                              }
              
                              // Update settings based on permission result
                              try {
                                await settingsNotifier.setLocationEnabled(
                                  status.isGranted,
                                );
                              } catch (e) {
                                // Show save error
                                if (context.mounted) {
                                  showXploraSnackBar(
                                    context,
                                    'Failed to save location settings',
                                    isError: true,
                                  );
                                }
                                return;
                              }

                              if(status.isGranted){
                                // Invalidate auto enable provider to handle permission result
                                // (consistent with signin flow - let provider check and handle)
                                ref.invalidate(autoEnableLocationTrackingProvider);
                              }

                              // Navigate to notifications page
                              if (context.mounted) {
                                Navigator.of(context).pushReplacementNamed(
                                  '/enable-notifications',
                                );
                              }
                            } finally {
                              // Clear loading state
                              ref.read(_locationLoadingStateProvider.notifier).state = null;
                            }
                          },
                        ),
              
                        const SizedBox(height: spacing16),
              
                        // Maybe Later button
                        SecondaryButton(
                          text: isLaterLoading ? 'Loading...' : 'Maybe Later',
                          onPressed: loadingState != null ? null : () async {
                            // Set loading state
                            ref.read(_locationLoadingStateProvider.notifier).state = 'later';
              
                            try {
                              // Set location permission to false in settings
                              await settingsNotifier.setLocationEnabled(false);
              
                              // Skip location permission and proceed to notifications
                              if (context.mounted) {
                                Navigator.of(context).pushReplacementNamed(
                                  '/enable-notifications',
                                );
                              }
                            } catch (e) {
                              // Show error in snackbar
                              if (context.mounted) {
                                showXploraSnackBar(
                                  context,
                                  'Failed to save location settings',
                                  isError: true,
                                );
                              }
                            } finally {
                              // Clear loading state
                              ref.read(_locationLoadingStateProvider.notifier).state = null;
                            }
                          },
                        ),
                      ],
                    ),
              
                    const SizedBox(height: spacing24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Feature item with checkmark icon
class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Checkmark icon with glow
        Image.asset(
          'assets/png/checkmark-glowing.png',
          width: 28,
          height: 28,
        ),
        const SizedBox(width: spacing12),
        // Text
        Expanded(
          child: Text(
            text,
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary.withValues(alpha: 0.8),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
