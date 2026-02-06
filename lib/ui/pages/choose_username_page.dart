import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import 'choose_interests_page.dart';

// Error/success state provider for username
final usernameErrorProvider = StateProvider.autoDispose<String?>((ref) => null);
final usernameSuccessProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final usernameAvailabilityInfoProvider =
    StateProvider.autoDispose<String?>((ref) => null);

// Loading state for username availability check
final usernameCheckLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class ChooseUsernamePage extends ConsumerStatefulWidget {
  const ChooseUsernamePage({super.key});

  @override
  ConsumerState<ChooseUsernamePage> createState() => _ChooseUsernamePageState();
}

class _ChooseUsernamePageState extends ConsumerState<ChooseUsernamePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset form state when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(usernameErrorProvider);
      ref.invalidate(usernameSuccessProvider);
      ref.invalidate(usernameAvailabilityInfoProvider);
      ref.invalidate(usernameCheckLoadingProvider);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  /// Clears error/success and triggers validation if error exists
  void _clearFeedbackAndValidate() {
    final error = ref.read(usernameErrorProvider);
    final success = ref.read(usernameSuccessProvider);
    final info = ref.read(usernameAvailabilityInfoProvider);

    if (error != null || success != null || info != null) {
      ref.read(usernameErrorProvider.notifier).state = null;
      ref.read(usernameSuccessProvider.notifier).state = null;
      ref.read(usernameAvailabilityInfoProvider.notifier).state = null;

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _formKey.currentState?.validate();
        }
      });
    }
  }

  /// Sets error on username and triggers validation
  void _setErrorAndValidate(String error) {
    ref.read(usernameErrorProvider.notifier).state = error;
    ref.read(usernameSuccessProvider.notifier).state = null;
    ref.read(usernameAvailabilityInfoProvider.notifier).state = null;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _formKey.currentState?.validate();
      }
    });
  }

  /// Check username availability (simulated - replace with actual API call)
  /// Shows availability status automatically, validation errors shown when Continue is pressed
  Future<void> _checkUsernameAvailability(String username) async {
    if (username.isEmpty) {
      _clearFeedbackAndValidate();
      return;
    }

    // Basic validation - but don't show errors yet
    if (username.length < 3) {
      // Clear any previous messages but don't show error
      ref.read(usernameSuccessProvider.notifier).state = null;
      ref.read(usernameAvailabilityInfoProvider.notifier).state = null;
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      // Clear any previous messages but don't show error
      ref.read(usernameSuccessProvider.notifier).state = null;
      ref.read(usernameAvailabilityInfoProvider.notifier).state = null;
      return;
    }

    // Set loading state
    ref.read(usernameCheckLoadingProvider.notifier).state = true;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Simulate availability check (replace with actual API call)
    // For demo purposes, consider usernames with "taken" as unavailable
    final isAvailable = !username.toLowerCase().contains('taken');

    ref.read(usernameCheckLoadingProvider.notifier).state = false;

    if (isAvailable) {
      ref.read(usernameSuccessProvider.notifier).state = 'Username available';
      ref.read(usernameAvailabilityInfoProvider.notifier).state = null;
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _formKey.currentState?.validate();
        }
      });
    } else {
      ref.read(usernameSuccessProvider.notifier).state = null;
      ref.read(usernameAvailabilityInfoProvider.notifier).state = 'Username is already taken';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: spacing16, vertical: spacing32),
                child: Form(
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
                      Consumer(
                        builder: (context, ref, child) {
                          final usernameError =
                              ref.watch(usernameErrorProvider);
                          final usernameSuccess =
                              ref.watch(usernameSuccessProvider);
                          final usernameAvailabilityInfo =
                              ref.watch(usernameAvailabilityInfoProvider);
                          final isChecking =
                              ref.watch(usernameCheckLoadingProvider);

                          final hasError =
                              usernameError != null && usernameError.isNotEmpty;
                          final hasSuccess = usernameSuccess != null &&
                              usernameSuccess.isNotEmpty;
                          final hasAvailabilityInfo = usernameAvailabilityInfo != null &&
                              usernameAvailabilityInfo.isNotEmpty;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text field
                              XploraTextField(
                                controller: _usernameController,
                                hintText: 'Username',
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                suffixIcon: isChecking
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.all(spacing12),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              brandPrimary,
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                                validator: (value) {
                                  if (hasError) return usernameError;
                                  if (hasSuccess) return null;
                                  return null;
                                },
                                onChanged: (value) {
                                  _clearFeedbackAndValidate();
                                  // Debounce username check
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    if (mounted &&
                                        _usernameController.text == value) {
                                      _checkUsernameAvailability(value.trim());
                                    }
                                  });
                                },
                              ),

                              // Availability status messages (shown automatically)
                              if (hasSuccess) ...{
                                const SizedBox(height: spacing8),
                                Padding(
                                  padding: const EdgeInsets.only(left: spacing8),
                                  child: Text(
                                  usernameSuccess,
                                  style: captionStyle.copyWith(
                                    color: context.colors.textPrimary,
                                    fontSize: 12
                                  ),
                                ),
                                )
                              },
                              if (hasAvailabilityInfo) ...{
                                const SizedBox(height: spacing8),
                                Padding(
                                  padding: const EdgeInsets.only(left: spacing8),
                                  child: Text(
                                  usernameAvailabilityInfo,
                                  style: captionStyle.copyWith(
                                    color: errorColor,
                                    fontSize: 12
                                  ),
                                ),
                                )
                              },
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Continue button at bottom
            Padding(
              padding: const EdgeInsets.all(spacing16),
              child: Consumer(
                builder: (context, ref, child) {
                  final usernameError = ref.watch(usernameErrorProvider);
                  final isChecking = ref.watch(usernameCheckLoadingProvider);

                  return PrimaryButton(
                    text: 'Continue',
                    onPressed: () {
                      final username = _usernameController.text.trim();

                      // Validate username and show errors
                      if (username.isEmpty) {
                        _setErrorAndValidate('Please enter a username');
                        return;
                      }

                      if (username.length < 3) {
                        _setErrorAndValidate('Username must be at least 3 characters');
                        return;
                      }

                      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
                        _setErrorAndValidate(
                            'Username can only contain letters, numbers, and underscores');
                        return;
                      }

                      // Check if username is taken (simulated check)
                      if (username.toLowerCase().contains('taken')) {
                        _setErrorAndValidate('Username is already taken');
                        return;
                      }

                      if (usernameError != null && usernameError.isNotEmpty) {
                        // Error already displayed under text field
                        return;
                      }

                      if (isChecking) {
                        showXploraSnackBar(
                          context,
                          'Please wait while we check username availability',
                        );
                        return;
                      }

                      // TODO: Save username to backend
                      // Navigate to interests selection screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ChooseInterestsPage(),
                        ),
                      );
                    },
                  );
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
