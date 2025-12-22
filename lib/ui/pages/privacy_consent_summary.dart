import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../infrastructure/constants.dart';
import '../../application/providers/local_storage_providers.dart';
import '../../theme.dart';
import '../dialogs/first_session_dialog.dart';
import '../widgets/primary_button.dart';
import '../dialogs/xp_boost_onboarding_dialog.dart';

class PrivacyConsentSummary extends ConsumerStatefulWidget {
  const PrivacyConsentSummary({super.key});

  @override
  ConsumerState<PrivacyConsentSummary> createState() => _PrivacyConsentSummaryState();
}

class _PrivacyConsentSummaryState extends ConsumerState<PrivacyConsentSummary> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Check if location permission was granted
    final locationPermissionAsync = ref.watch(locationPermissionProvider);

    return WillPopScope(
      onWillPop: () async {
        showFirstSessionDialogIfLocationEnabled(context, ref);
        return true;
      },
      child: GradientBackground(
        child: Scaffold(
          appBar: const GlassAppBar(title: 'logo', centerTitle: true,),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    'Privacy & Consent Summary',
                    style: h1Style.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 38),

                // Consent items with checkboxes
                locationPermissionAsync.when(
                  data: (hasLocationPermission) {
                    return Column(
                      children: [
                        // Location usage - only shown if permission granted
                        if (hasLocationPermission)
                          const _ConsentItem(
                            icon: Icons.location_on,
                            text: 'Location usage',
                            isChecked: true,
                          ),
                        if (hasLocationPermission) const SizedBox(height: 16),

                        // Terms & Privacy
                        const _ConsentItem(
                          icon: Icons.shield_outlined,
                          text: 'Terms & Privacy',
                          isChecked: true,
                        ),
                        const SizedBox(height: 16),

                        // XP rules
                        const _ConsentItem(
                          icon: Icons.timer_outlined,
                          text: 'XP rules (cooldowns, fair play)',
                          isChecked: true,
                        ),
                      ],
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(color: accentPrimary),
                  ),
                  error: (_, __) {
                    // On error, just show Terms & Privacy and XP rules
                    return const Column(
                      children: [
                        _ConsentItem(
                          icon: Icons.shield_outlined,
                          text: 'Terms & Privacy',
                          isChecked: true,
                        ),
                        SizedBox(height: 16),
                        _ConsentItem(
                          icon: Icons.timer_outlined,
                          text: 'XP rules (cooldowns, fair play)',
                          isChecked: true,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 48),

                // Start Exploring button
                Center(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.83,
                    child: PrimaryButton(
                      height: 50,
                      onPressed: _isLoading ? null : () async {
                        // setState(() {
                        //   _isLoading = true;
                        // });
                        //
                        // // Request notification permission
                        // final messaging = FirebaseMessaging.instance;
                        // final settings = await messaging.requestPermission(
                        //   alert: true,
                        //   announcement: false,
                        //   badge: true,
                        //   carPlay: false,
                        //   criticalAlert: false,
                        //   provisional: false,
                        //   sound: true,
                        // );
                        //
                        // // Save notification settings based on user's choice
                        // final settingsNotifier = ref.read(settingsStateNotifierProvider.notifier);
                        // final isNotificationGranted = settings.authorizationStatus == AuthorizationStatus.authorized ||
                        //     settings.authorizationStatus == AuthorizationStatus.provisional;
                        //
                        // await settingsNotifier.setNotificationsEnabled(isNotificationGranted);
                        //
                        // setState(() {
                        //   _isLoading = false;
                        // });

                        // Show XP Boost onboarding dialog
                        final shouldContinue = await showXpBoostOnboardingDialog(context);

                        if (context.mounted) {
                          // If user chose "Let's Go!", navigate to XP onboarding screen
                          if (shouldContinue == true) {
                            Navigator.of(context).pushReplacementNamed('/xp-onboarding');
                          } else {
                            // User skipped - close screen then show first session dialog
                            final isLocationEnabled = ref.read(locationTrackingEnabledProvider);
                            final navigator = Navigator.of(context);
                            final overlayContext = navigator.overlay?.context;

                            // Pop the screen first
                            navigator.pop();

                            // Show dialog on the previous screen after pop completes
                            if (isLocationEnabled && overlayContext != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showFirstSessionDialog(overlayContext);
                              });
                            }
                          }
                        }
                      },
                      text: _isLoading ? 'Loading...' : 'Start Exploring',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsentItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isChecked;

  const _ConsentItem({
    required this.icon,
    required this.text,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Custom checkbox styled to match the app
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isChecked ? accentPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isChecked ? accentPrimary : textSecondary.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: isChecked
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 16),

          // Icon
          Icon(
            icon,
            color: accentPrimary,
            size: 24,
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Text(
              text,
              style: bodyTextStyle.copyWith(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
