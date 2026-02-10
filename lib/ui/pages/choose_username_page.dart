import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/notifiers/username_notifier.dart';
import '../../application/providers/username_providers.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/username_validator.dart';
import 'choose_interests_page.dart';

class ChooseUsernamePage extends ConsumerStatefulWidget {
  const ChooseUsernamePage({super.key});

  @override
  ConsumerState<ChooseUsernamePage> createState() => _ChooseUsernamePageState();
}

class _ChooseUsernamePageState extends ConsumerState<ChooseUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  /// Whether to show availability message (hide during checking or invalid state)
  bool _shouldShowAvailabilityMessage(UsernameState state) {
    if (state.isCheckingUsername || state.username.isEmpty) {
      return false;
    }

    // Show error message if there's an error
    if (state.hasError) {
      return true;
    }

    // Only show availability message if:
    // 1. Username passes validation AND
    // 2. We've actually checked availability (not null)
    return UsernameValidator.isValid(state.username) && state.hasBeenChecked;
  }

  /// Get the availability status message
  String _availabilityMessage(UsernameState state) {
    // Show error message if present
    if (state.hasError) {
      return state.errorMessage!;
    }

    return state.isUsernameAvailable == true
        ? 'Username available'
        : 'Username is already taken';
  }

  /// Get the color for availability message
  Color _availabilityMessageColor(UsernameState state, BuildContext context) {
    // Error state - use error color
    if (state.hasError) {
      return errorColor;
    }

    // Available - use primary text color
    // Taken - use error color
    return state.isUsernameAvailable == true
        ? context.colors.textPrimary
        : errorColor;
  }

  @override
  Widget build(BuildContext context) {
    final usernameState = ref.watch(usernameNotifierProvider);
    final usernameNotifier = ref.read(usernameNotifierProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: spacing16, vertical: spacing32),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: spacing48),

                      // Title
                      Text(
                        'Choose a username',
                        style: h1Style.copyWith(
                          color: context.colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: spacing4),

                      // Subtitle
                      Text(
                        'This is how others will see you',
                        style: h3Style.copyWith(
                          color:
                              context.colors.textPrimary.withValues(alpha: 0.6),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: spacing32),

                      // Username field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text field
                          XploraTextField(
                            controller: _usernameController,
                            hintText: 'Username',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            suffixIcon: usernameState.isCheckingUsername
                                ? Padding(
                                    padding: const EdgeInsets.all(spacing12),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            brandPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                            validator: UsernameValidator.validate,
                            onChanged: (value) {
                              usernameNotifier.setUsername(value.trim());
                              usernameNotifier
                                  .checkUsernameAvailability(value.trim());
                            },
                          ),

                          // Availability status message
                          if (_shouldShowAvailabilityMessage(
                              usernameState)) ...{
                            const SizedBox(height: spacing8),
                            Padding(
                              padding: const EdgeInsets.only(left: spacing8),
                              child: Text(
                                _availabilityMessage(usernameState),
                                style: captionStyle.copyWith(
                                  color: _availabilityMessageColor(
                                      usernameState, context),
                                  fontSize: 12,
                                ),
                              ),
                            )
                          },
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Continue button at bottom
            Padding(
              padding: const EdgeInsets.all(spacing16),
              child: PrimaryButton(
                text: usernameState.isSavingUsername ? 'Saving...' : 'Continue',
                onPressed: usernameState.isSavingUsername
                    ? null
                    : () async {
                        // Validate form
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        // Check for errors
                        if (usernameState.hasError) {
                          showXploraSnackBar(
                            context,
                            usernameState.errorMessage!,
                            isError: true,
                          );
                          return;
                        }

                        if (usernameState.isCheckingUsername) {
                          showXploraSnackBar(
                            context,
                            'Please wait while we check username availability',
                          );
                          return;
                        }

                        // Check if username is available
                        if (usernameState.isUsernameAvailable != true) {
                          showXploraSnackBar(
                            context,
                            usernameState.isUsernameAvailable == null
                                ? 'Please wait while we check username availability'
                                : 'Username is already taken',
                            isError: usernameState.isUsernameAvailable == false,
                          );
                          return;
                        }

                        // Save username to backend
                        final success = await usernameNotifier.saveUsername();

                        if (context.mounted) {
                          if (success) {
                            // Show success message
                            showXploraSnackBar(
                              context,
                              'Username saved successfully!',
                            );

                            // Navigate to interests selection screen
                            Navigator.pushReplacementNamed(
                                context, '/choose-interests');
                          } else {
                            // Show error
                            showXploraSnackBar(
                              context,
                              'Failed to save username. Please try again.',
                              isError: true,
                            );
                          }
                        }
                      },
              ),
            ),

            const SizedBox(height: spacing48),
          ],
        ),
      ),
    );
  }
}
