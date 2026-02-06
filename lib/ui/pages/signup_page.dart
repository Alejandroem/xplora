import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../utils/snackbar_utils.dart';
import 'choose_username_page.dart';

// Error state providers
final nameErrorProvider = StateProvider.autoDispose<String?>((ref) => null);
final emailSignupErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final passwordSignupErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);
final confirmPasswordErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

// Obscure text state providers
final obscurePasswordProvider = StateProvider.autoDispose<bool>((ref) => true);
final obscureConfirmPasswordProvider =
    StateProvider.autoDispose<bool>((ref) => true);

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reset form state when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(signupFormNotifierProvider);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Clears error and triggers validation if error exists
  void _clearErrorAndValidate(AutoDisposeStateProvider<String?> errorProvider) {
    final error = ref.read(errorProvider);
    if (error != null) {
      ref.read(errorProvider.notifier).state = null;
      // WidgetsBinding.instance
      //     .addPostFrameCallback((_) => _formKey.currentState?.validate());
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          _formKey.currentState?.validate();
        }
      });
    }
  }

  /// Clears all error providers
  void _clearAllErrors() {
    ref.read(nameErrorProvider.notifier).state = null;
    ref.read(emailSignupErrorProvider.notifier).state = null;
    ref.read(passwordSignupErrorProvider.notifier).state = null;
    ref.read(confirmPasswordErrorProvider.notifier).state = null;
  }

  /// Sets error on a specific provider and triggers validation
  void _setErrorAndValidate(
      AutoDisposeStateProvider<String?> errorProvider, String error) {
    ref.read(errorProvider.notifier).state = error;
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _formKey.currentState?.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: spacing16, vertical: spacing32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: spacing48),

                // Create an Account title
                Text(
                  'Create an Account',
                  style: h1Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacing8),

                // Subtitle
                Text(
                  'Sign up to get started',
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary.withValues(alpha: 0.6),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacing32),

                // Name field
                Consumer(
                  builder: (context, ref, child) {
                    final nameError = ref.watch(nameErrorProvider);
                    final hasError = nameError != null && nameError.isNotEmpty;
                    return XploraTextField(
                      controller: _nameController,
                      hintText: 'Name',
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      prefixIcon: Padding(
                          padding: const EdgeInsets.all(spacing12),
                          child: Icon(
                            LucideIcons.user,
                            color: hasError
                                ? errorColor
                                : context.colors.textPrimary
                                    .withValues(alpha: 0.5),
                            size: 22,
                          )),
                      validator: (value) => nameError,
                      onChanged: (value) {
                        _clearErrorAndValidate(nameErrorProvider);
                        ref
                            .read(signupFormNotifierProvider.notifier)
                            .setDisplayName(value.trim());
                      },
                    );
                  },
                ),
                const SizedBox(height: spacing12),

                // Email field
                Consumer(
                  builder: (context, ref, child) {
                    final emailError = ref.watch(emailSignupErrorProvider);
                    final hasError =
                        emailError != null && emailError.isNotEmpty;
                    return XploraTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Padding(
                          padding: const EdgeInsets.all(spacing12),
                          child: Icon(
                            LucideIcons.mail,
                            color: hasError
                                ? errorColor
                                : context.colors.textPrimary
                                    .withValues(alpha: 0.5),
                            size: 22,
                          )),
                      validator: (value) => emailError,
                      onChanged: (value) {
                        _clearErrorAndValidate(emailSignupErrorProvider);
                        ref
                            .read(signupFormNotifierProvider.notifier)
                            .setEmail(value.trim());
                      },
                    );
                  },
                ),
                const SizedBox(height: spacing12),

                // Password field
                Consumer(
                  builder: (context, ref, child) {
                    final passwordError =
                        ref.watch(passwordSignupErrorProvider);
                    final obscurePassword = ref.watch(obscurePasswordProvider);
                    final hasError =
                        passwordError != null && passwordError.isNotEmpty;
                    return XploraTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: obscurePassword,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(spacing12),
                        child: SvgPicture.asset(
                          'assets/svg/lock.svg',
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            hasError
                                ? errorColor
                                : context.colors.textPrimary
                                    .withValues(alpha: 0.5),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: spacing8),
                        child: IconButton(
                          onPressed: () {
                            ref.read(obscurePasswordProvider.notifier).state =
                                !obscurePassword;
                          },
                          icon: Icon(
                            obscurePassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            color: brandSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) => passwordError,
                      onChanged: (value) {
                        _clearErrorAndValidate(passwordSignupErrorProvider);
                        ref
                            .read(signupFormNotifierProvider.notifier)
                            .setPassword(value.trim());
                      },
                    );
                  },
                ),
                const SizedBox(height: spacing12),

                // Confirm Password field
                Consumer(
                  builder: (context, ref, child) {
                    final confirmPasswordError =
                        ref.watch(confirmPasswordErrorProvider);
                    final obscureConfirmPassword =
                        ref.watch(obscureConfirmPasswordProvider);
                    final hasError = confirmPasswordError != null &&
                        confirmPasswordError.isNotEmpty;
                    return XploraTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(spacing12),
                        child: SvgPicture.asset(
                          'assets/svg/lock.svg',
                          width: 22,
                          height: 22,
                          colorFilter: ColorFilter.mode(
                            hasError
                                ? errorColor
                                : context.colors.textPrimary
                                    .withValues(alpha: 0.5),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: spacing8),
                        child: IconButton(
                          onPressed: () {
                            ref
                                .read(obscureConfirmPasswordProvider.notifier)
                                .state = !obscureConfirmPassword;
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? LucideIcons.eyeOff
                                : LucideIcons.eye,
                            color: brandSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (value) => confirmPasswordError,
                      onChanged: (value) {
                        _clearErrorAndValidate(confirmPasswordErrorProvider);
                        ref
                            .read(signupFormNotifierProvider.notifier)
                            .setConfirmPassword(value.trim());
                      },
                    );
                  },
                ),
                const SizedBox(height: spacing32),

                // Sign up button
                Consumer(
                  builder: (context, ref, child) {
                    final isLoading =
                        ref.watch(signupFormNotifierProvider).isLoading;
                    return PrimaryButton(
                      text: isLoading ? 'Signing up...' : 'Sign up',
                      onPressed: isLoading
                          ? null
                          : () async {
                              // Clear previous errors
                              _clearAllErrors();

                              final signUpNotifier =
                                  ref.read(signupFormNotifierProvider.notifier);

                              try {
                                // Perform sign up
                                await signUpNotifier.signUp();

                                // Check for errors
                                final finalState =
                                    ref.read(signupFormNotifierProvider);
                                if (finalState.errors.isNotEmpty) {
                                  if (context.mounted) {
                                    // Parse and display errors
                                    final errorMessage =
                                        finalState.errors.first.toLowerCase();
                                    if (errorMessage.contains('name') ||
                                        errorMessage.contains('display')) {
                                      // Name-specific error
                                      _setErrorAndValidate(nameErrorProvider,
                                          finalState.errors.first);
                                    } else if (errorMessage.contains('email')) {
                                      // Email-specific error
                                      _setErrorAndValidate(
                                          emailSignupErrorProvider,
                                          finalState.errors.first);
                                    } else if (errorMessage
                                            .contains('password') &&
                                        (errorMessage.contains('confirm') ||
                                            errorMessage.contains('match'))) {
                                      // Confirm password error
                                      _setErrorAndValidate(
                                          confirmPasswordErrorProvider,
                                          finalState.errors.first);
                                    } else if (errorMessage
                                        .contains('password')) {
                                      // Password-specific error
                                      _setErrorAndValidate(
                                          passwordSignupErrorProvider,
                                          finalState.errors.first);
                                    } else {
                                      // General error - show in snackbar
                                      showXploraSnackBar(
                                        context,
                                        finalState.errors.first,
                                        isError: true,
                                      );
                                    }
                                  }
                                } else {
                                  // Success - navigate to profile completion screen
                                  if (context.mounted) {
                                    // Refresh settings to ensure they're loaded
                                    ref.invalidate(
                                        settingsStateNotifierProvider);

                                    showXploraSnackBar(
                                      context,
                                      'Account created successfully!',
                                    );
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context) => const ChooseUsernamePage()));
                                  }
                                }
                              } catch (e) {
                                // General error in snackbar
                                final finalState =
                                    ref.read(signupFormNotifierProvider);
                                if (context.mounted) {
                                  final errorMessage =
                                      finalState.errors.isNotEmpty
                                          ? finalState.errors.first
                                          : 'Sign up failed. Please try again.';
                                  showXploraSnackBar(
                                    context,
                                    errorMessage,
                                    isError: true,
                                  );
                                }
                              }
                            },
                    );
                  },
                ),
                const SizedBox(height: spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
