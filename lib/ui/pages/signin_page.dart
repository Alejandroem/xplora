import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../application/providers/location_providers.dart';
import '../../theme.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../utils/snackbar_utils.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(loginFormNotifierProvider);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _refreshProvidersAfterSignIn() {
    ref.invalidate(settingsStateNotifierProvider);
    ref.invalidate(autoEnableLocationTrackingProvider);
  }

  Future<void> _handleOAuthSignIn(Future<void> Function() signIn) async {
    await signIn();

    final finalState = ref.read(loginFormNotifierProvider);

    if (finalState.errors.isNotEmpty) {
      if (mounted) {
        showXploraSnackBar(context, finalState.errors.first, isError: true);
      }
      return;
    }

    final currentUser = await ref.read(authServiceProvider).getAuthUser();
    if (currentUser == null || !mounted) return;

    if (finalState.needsProfileCompletion) {
      ref.invalidate(settingsStateNotifierProvider);
      showXploraSnackBar(context, 'Signed up successfully!');
      Navigator.pushReplacementNamed(context, '/choose-username');
    } else {
      _refreshProvidersAfterSignIn();
      showXploraSnackBar(context, 'Signed in successfully!');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: spacing16, vertical: spacing32),
          child: Form(
            // autovalidateMode: AutovalidateMode.onUnfocus,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: spacing48),

                // Welcome back title
                Text(
                  'Welcome back',
                  style: h1Style.copyWith(
                    color: context.colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacing8),

                // Subtitle
                Text(
                  'Sign in to continue',
                  style: h3Style.copyWith(
                    color: context.colors.textPrimary.withValues(alpha: 0.6),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: spacing32),

                // Email or Username field
                XploraTextField(
                  controller: _emailController,
                  hintText: 'Email or Username',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(spacing12),
                      child: Icon(
                        LucideIcons.user,
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.5),
                        size: 22,
                      )),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email or Username is required';
                    } else if (value.trim().length < 3) {
                      return 'Email or Username must be at least 3 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    ref
                        .read(loginFormNotifierProvider.notifier)
                        .setEmail(value.trim());
                  },
                ),
                const SizedBox(height: spacing16),

                // Password field
                Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginFormNotifierProvider);
                    return XploraTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: loginState.obscureText,
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
                                .read(loginFormNotifierProvider.notifier)
                                .toggleObscureText();
                          },
                          icon: Icon(
                            loginState.obscureText
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
                            .read(loginFormNotifierProvider.notifier)
                            .setPassword(value.trim());
                      },
                    );
                  },
                ),
                const SizedBox(height: spacing12),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Implement forgot password
                      showXploraSnackBar(
                        context,
                        'Forgot password feature coming soon!',
                      );
                    },
                    child: Text(
                      'Forgot password?',
                      style: bodySmallStyle.copyWith(
                        color: brandSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: spacing32),

                // Log In button
                Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginFormNotifierProvider);
                    return PrimaryButton(
                      text: loginState.isLoading ? 'Logging in...' : 'Log In',
                      onPressed: loginState.isLoading
                          ? null
                          : () async {
                              // Validate form
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              final loginNotifier =
                                  ref.read(loginFormNotifierProvider.notifier);

                              try {
                                // Perform login
                                await loginNotifier.login();

                                // Check for server-side errors
                                final finalState =
                                    ref.read(loginFormNotifierProvider);
                                if (finalState.errors.isNotEmpty) {
                                  if (context.mounted) {
                                    showXploraSnackBar(
                                      context,
                                      finalState.errors.first,
                                      isError: true,
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    _refreshProvidersAfterSignIn();
                                    showXploraSnackBar(
                                      context,
                                      'Signed in successfully!',
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }
                              } catch (e) {
                                // General error in snackbar
                                final finalState =
                                    ref.read(loginFormNotifierProvider);
                                if (context.mounted) {
                                  final errorMessage =
                                      finalState.errors.isNotEmpty
                                          ? finalState.errors.first
                                          : 'Sign in failed. Please try again.';
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
                const SizedBox(height: spacing32),

                // Divider with "or" text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.15),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: spacing16),
                      child: Text(
                        'or',
                        style: bodyTextStyle.copyWith(
                          color:
                              context.colors.textPrimary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color:
                            context.colors.textPrimary.withValues(alpha: 0.15),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: spacing32),

                // Social sign-in buttons
                Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginFormNotifierProvider);
                    final isLoading = loginState.isLoading;

                    return Column(
                      children: [
                        // Continue with Google
                        SecondaryButton(
                          height: 50,
                          text: 'Continue with Google',
                          icon: SvgPicture.asset(
                            'assets/svg/google.svg',
                            width: 20,
                            height: 20,
                          ),
                          onPressed: isLoading
                              ? null
                              : () => _handleOAuthSignIn(
                                    ref
                                        .read(loginFormNotifierProvider.notifier)
                                        .loginWithGoogle,
                                  ),
                        ),
                        const SizedBox(height: spacing16),

                        // Continue with Apple
                        if (!kIsWeb &&
                            defaultTargetPlatform == TargetPlatform.iOS) ...[
                          SecondaryButton(
                            height: 50,
                            text: 'Continue with Apple',
                            icon: Icon(
                              Icons.apple,
                              color: context.colors.textPrimary,
                              size: 20,
                            ),
                            onPressed: isLoading
                                ? null
                                : () => _handleOAuthSignIn(
                                      ref
                                          .read(loginFormNotifierProvider.notifier)
                                          .loginWithApple,
                                    ),
                          ),
                          const SizedBox(height: spacing16),
                        ],

                        // Continue as Guest
                        SecondaryButton(
                          height: 50,
                          text: 'Continue as Guest',
                          icon: Icon(
                            LucideIcons.user,
                            color: context.colors.textPrimary
                                .withValues(alpha: 0.7),
                            size: 20,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.of(context).pop();
                                },
                        ),

                        const SizedBox(height: spacing16),

                        // Footer text
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  Navigator.of(context)
                                      .pushNamed('/signup');
                                },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: h3Style.copyWith(
                                      color: context.colors.textPrimary
                                          .withValues(alpha: 0.7),
                                      fontSize: 14),
                                ),
                                TextSpan(
                                  text: 'Sign up',
                                  style: h3Style.copyWith(
                                      color: brandSecondary, fontSize: 14),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
