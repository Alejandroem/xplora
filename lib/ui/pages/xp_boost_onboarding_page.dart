import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/xp_onboarding_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../dialogs/first_session_dialog.dart';
import '../dialogs/invite_friends_dialog.dart';

class XpBoostOnboardingPage extends ConsumerStatefulWidget {
  const XpBoostOnboardingPage({super.key});

  @override
  ConsumerState<XpBoostOnboardingPage> createState() => _XpOnboardingPageState();
}

class _XpOnboardingPageState extends ConsumerState<XpBoostOnboardingPage> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final FocusNode _dummyFocusNode = FocusNode();

  @override
  void dispose() {
    _bioController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _dummyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(xpOnboardingFormNotifierProvider);
    final formNotifier = ref.read(xpOnboardingFormNotifierProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(
            xpOnboardingFormNotifierProvider);
        showFirstSessionDialogIfLocationEnabled(context, ref);
        return true;
      },
      child: GradientBackground(
        child: Scaffold(
          appBar: const GlassAppBar(
            title: 'logo',
            centerTitle: true,
          ),
          body: Focus(
            focusNode: _dummyFocusNode,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        'Boost Your XP!',
                        style: h1Style,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        'Complete your profile and unlock bonus rewards',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textTertiary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Bio Section
                    Text(
                      'Bio',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    XploraTextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _bioController,
                      labelText: 'Tell us about yourself',
                      hintText:
                          'Share your interests, hobbies, or what you love to explore...',
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      maxLength: 500,
                      onChanged: (value) {
                        formNotifier.setBio(value);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Social Links Section
                    Text(
                      'Social Links',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Instagram
                    XploraTextField(
                      controller: _instagramController,
                      labelText: 'Instagram',
                      hintText: '@username',
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icon(
                        Icons.camera_alt_outlined,
                        color: context.colors.textSecondary,
                        size: 20,
                      ),
                      onChanged: (value) {
                        formNotifier.setInstagramHandle(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Twitter
                    XploraTextField(
                      controller: _twitterController,
                      labelText: 'Twitter/X',
                      hintText: '@username',
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icon(
                        Icons.tag,
                        color: context.colors.textSecondary,
                        size: 20,
                      ),
                      onChanged: (value) {
                        formNotifier.setTwitterHandle(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Facebook
                    XploraTextField(
                      textCapitalization: TextCapitalization.words,
                      controller: _facebookController,
                      labelText: 'Facebook',
                      hintText: 'username',
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icon(
                        Icons.facebook,
                        color: context.colors.textSecondary,
                        size: 20,
                      ),
                      onChanged: (value) {
                        formNotifier.setFacebookHandle(value);
                      },
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons Section
                    Text(
                      'Quick Actions',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Enable Notifications Button
                    _ActionButton(
                      icon: Icons.notifications_outlined,
                      title: 'Enable Notifications',
                      description: 'Stay updated on quests',
                      xpReward: '+25 XP',
                      isCompleted: formState.notificationsEnabled,
                      isLoading: formState.isEnablingNotifications,
                      onPressed: formState.notificationsEnabled ||
                              formState.isEnablingNotifications
                          ? null
                          : () async {
                              await formNotifier.enableNotifications();
                              final updatedState =
                                  ref.read(xpOnboardingFormNotifierProvider);
                              if (updatedState.errors.isNotEmpty &&
                                  context.mounted) {
                                showXploraSnackBar(
                                  context,
                                  updatedState.errors.first,
                                  isError: true,
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 12),

                    // Link Wallet/DID Button (Coming Soon)
                    const _ActionButton(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Link Wallet',
                      description: 'Connect your DID',
                      xpReward: '+50 XP',
                      isComingSoon: true,
                      isCompleted: false,
                      onPressed: null,
                    ),
                    const SizedBox(height: 12),

                    // Complete Referral Button
                    _ActionButton(
                      icon: Icons.card_giftcard,
                      title: 'Referral Reward',
                      description: 'Invite friends to earn',
                      xpReward: '+50 XP',
                      isCompleted: formState.referralCompleted,
                      buttonText: 'Refer',
                      onPressed: formState.referralCompleted
                          ? null
                          : () async {
                              await showInviteFriendsDialog(context);
                              // Request focus on dummy node again after dialog closes
                              if (context.mounted) {
                                _dummyFocusNode.requestFocus();
                              }
                              // if (mounted) {
                              //   formNotifier.markReferralCompleted();
                              // }
                            },
                    ),
                    const SizedBox(height: 40),

                    // Save and Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: PrimaryButton(
                        text:
                            formState.isSaving ? 'Saving...' : 'Save & Continue',
                        onPressed: formState.isSaving
                            ? null
                            : () async {
                                await formNotifier.saveProfile();

                                if (formState.errors.isNotEmpty &&
                                    context.mounted) {
                                  showXploraSnackBar(
                                    context,
                                    formState.errors.first,
                                    isError: true,
                                  );
                                  return;
                                }

                                if (context.mounted) {
                                  ref.invalidate(
                                      xpOnboardingFormNotifierProvider);
                                  // Navigate to home
                                  Navigator.of(context).pop();

                                  // Show first session dialog if location is enabled
                                  final isLocationEnabled = ref.read(locationTrackingEnabledProvider);
                                  if (isLocationEnabled) {
                                    showFirstSessionDialog(context);
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String xpReward;
  final bool isCompleted;
  final bool isComingSoon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final String buttonText;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.isCompleted,
    this.isComingSoon = false,
    this.isLoading = false,
    this.onPressed,
    this.buttonText = 'Enable',
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 12,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? brandPrimary.withOpacity(0.2)
                  : context.colors.iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : icon,
              color: context.colors.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: bodyTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isComingSoon) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.textSecondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Soon',
                          style: bodyTextStyle.copyWith(
                            fontSize: 10,
                            color: context.colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: bodyTextStyle.copyWith(
                    fontSize: 13,
                    color: context.colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // XP Reward or Action Button
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: xpColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Done',
                style: bodyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            )
          else if (isComingSoon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: brandPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                xpReward,
                style: bodyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            )
          else if (isLoading)
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
              ),
            )
          else
            PrimaryButton(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onPressed: onPressed,
              text: buttonText,
              fontSize: 14,
            ),
        ],
      ),
    );
  }
}
