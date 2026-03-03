import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../utils/snackbar_utils.dart';

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

  void _refreshProvidersAfterSignUp() {
    ref.invalidate(settingsStateNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: spacing16, vertical: spacing32),
          child: Form(
            autovalidateMode: AutovalidateMode.onUnfocus,
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
                XploraTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(spacing12),
                      child: Icon(
                        LucideIcons.user,
                        color: context.colors.textPrimary.withValues(alpha: 0.5),
                        size: 22,
                      )),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    if (RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Name cannot contain numbers';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref
                        .read(signupFormNotifierProvider.notifier)
                        .setDisplayName(value.trim());
                  },
                ),
                const SizedBox(height: spacing12),

                // Email field
                XploraTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(spacing12),
                      child: Icon(
                        LucideIcons.mail,
                        color: context.colors.textPrimary.withValues(alpha: 0.5),
                        size: 22,
                      )),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref
                        .read(signupFormNotifierProvider.notifier)
                        .setEmail(value.trim());
                  },
                ),
                const SizedBox(height: spacing12),

                // Password field
                Consumer(
                  builder: (context, ref, child) {
                    final obscurePassword = ref.watch(obscurePasswordProvider);
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
                            context.colors.textPrimary.withValues(alpha: 0.5),
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onChanged: (value) {
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
                    final obscureConfirmPassword =
                        ref.watch(obscureConfirmPasswordProvider);
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
                            context.colors.textPrimary.withValues(alpha: 0.5),
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Confirm password is required';
                        }
                        if (value.trim() != _passwordController.text.trim()) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (value) {
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
                              // Validate form
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final signUpNotifier =
                                  ref.read(signupFormNotifierProvider.notifier);

                              try {
                                // Perform sign up
                                await signUpNotifier.signUp();

                                // Check for server-side errors
                                final finalState =
                                    ref.read(signupFormNotifierProvider);
                                if (finalState.errors.isNotEmpty) {
                                  if (context.mounted) {
                                    showXploraSnackBar(
                                      context,
                                      finalState.errors.first,
                                      isError: true,
                                      // duration: const Duration(seconds: 3)
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    _refreshProvidersAfterSignUp();
                                    showXploraSnackBar(
                                      context,
                                      'Account created successfully!',
                                    );
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacementNamed('/choose-username');
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
