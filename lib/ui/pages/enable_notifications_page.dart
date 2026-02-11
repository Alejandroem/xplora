import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../application/providers/settings_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';

// State provider to track which button is loading
final _notificationLoadingStateProvider = StateProvider.autoDispose<String?>((ref) => null);

class EnableNotificationsPage extends ConsumerWidget {
  const EnableNotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
    final loadingState = ref.watch(_notificationLoadingStateProvider);

    final isEnableLoading = loadingState == 'enable';
    final isSkipLoading = loadingState == 'skip';

    return Scaffold(
      body: Stack(
        children: [
          // Background with ASCII loop
          Positioned.fill(
            child: Image.asset(
              'assets/png/loop-ascii.png',
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
              
                    // Notification icon with glow effect
                    Center(
                      child: Image.asset(
                        'assets/png/notification-glowing.png',
                        width: 170,
                        height: 170,
                      ),
                    ),
              
                    const SizedBox(height: spacing32),
              
                    // Title
                    Text(
                      'Stay in the loop',
                      style: h1Style.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 36,
                      ),
                      textAlign: TextAlign.center,
                    ),
              
                    const SizedBox(height: spacing16),
              
                    // Subtitle
                    Text(
                      'Get notified about quest progress, nearby\ndiscoveries, and important updates.',
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
                          text: 'Quest progress updated',
                        ),
                        SizedBox(height: spacing16),
                        _FeatureItem(
                          text: 'New places discovered nearby',
                        ),
                        SizedBox(height: spacing16),
                        _FeatureItem(
                          text: 'Important updates & reminders',
                        ),
                      ],
                    ),
              
                    const SizedBox(height: spacing32),
              
                    // Buttons
                    Column(
                      children: [
                        // Enable Notifications button
                        PrimaryButton(
                          text: isEnableLoading ? 'Loading...' : 'Enable Notifications',
                          onPressed: loadingState != null ? null : () async {
                            // Set loading state
                            ref.read(_notificationLoadingStateProvider.notifier).state = 'enable';
              
                            try {
                              // Request notification permission
                              PermissionStatus status;
                              try {
                                status = await Permission.notification.request();
                                print('Notification permission status: $status');
                              } catch (e) {
                                // Show permission request error
                                if (context.mounted) {
                                  showXploraSnackBar(
                                    context,
                                    'Failed to request notification permission',
                                    isError: true,
                                  );
                                }
                                return;
                              }
              
                              // Update settings based on permission result
                              try {
                                await settingsNotifier.setNotificationsEnabled(
                                  status.isGranted,
                                );
                              } catch (e) {
                                // Show save error
                                if (context.mounted) {
                                  showXploraSnackBar(
                                    context,
                                    'Failed to save notification settings',
                                    isError: true,
                                  );
                                }
                                return;
                              }
              
                              // Navigate to How it Works page
                              if (context.mounted) {
                                Navigator.of(context).pushReplacementNamed(
                                  '/how-it-works',
                                );
                              }
                            } finally {
                              // Clear loading state
                              ref.read(_notificationLoadingStateProvider.notifier).state = null;
                            }
                          },
                        ),
              
                        const SizedBox(height: spacing16),
              
                        // Skip for now button
                        SecondaryButton(
                          text: isSkipLoading ? 'Loading...' : 'Skip for now',
                          onPressed: loadingState != null ? null : () async {
                            // Set loading state
                            ref.read(_notificationLoadingStateProvider.notifier).state = 'skip';
              
                            try {
                              // Set notification permission to false in settings
                              await settingsNotifier.setNotificationsEnabled(false);
              
                              // Skip notification permission and proceed to How it Works
                              if (context.mounted) {
                                Navigator.of(context).pushReplacementNamed(
                                  '/how-it-works',
                                );
                              }
                            } catch (e) {
                              // Show error in snackbar
                              if (context.mounted) {
                                showXploraSnackBar(
                                  context,
                                  'Failed to save notification settings',
                                  isError: true,
                                );
                              }
                            } finally {
                              // Clear loading state
                              ref.read(_notificationLoadingStateProvider.notifier).state = null;
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
