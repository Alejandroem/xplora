import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../theme.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/social_icon_button.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'logo',
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sign In title
                Center(
                  child: Text(
                    'Sign In',
                    style: h1Style,
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'Welcome back! Sign in to continue your adventure',
                    style: bodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                // Email field
                XploraTextField(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: context.colors.textSecondary,
                    size: 20,
                  ),
                  onChanged: (value) {
                    ref
                        .read(loginFormNotifierProvider.notifier)
                        .setEmail(value.trim());
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginFormNotifierProvider);
                    return XploraTextField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: loginState.obscureText,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: context.colors.textSecondary,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          ref
                              .read(loginFormNotifierProvider.notifier)
                              .toggleObscureText();
                        },
                        icon: Icon(
                          loginState.obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: context.colors.textSecondary,
                          size: 20,
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(loginFormNotifierProvider.notifier)
                            .setPassword(value.trim());
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Sign In button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final loginState = ref.watch(loginFormNotifierProvider);
                      return PrimaryButton(
                        text:
                            loginState.isLoading ? 'Signing in...' : 'Sign in',
                        onPressed: loginState.isLoading
                            ? null
                            : () async {
                                final loginNotifier = ref
                                    .read(loginFormNotifierProvider.notifier);

                                try {
                                  await loginNotifier.login();

                                  // Check for errors
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
                                    // Success - refresh settings and navigate
                                    if (context.mounted) {
                                      // Refresh settings to ensure they're loaded
                                      ref.invalidate(
                                          settingsStateNotifierProvider);

                                      // Refresh location to ensure it's loaded
                                      ref.invalidate(nearbyAdventuresProvider);

                                      // Refresh auto enable location provider
                                      ref.invalidate(
                                          autoEnableLocationTrackingProvider);

                                      showXploraSnackBar(
                                        context,
                                        'Signed in successfully!',
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  }
                                } catch (e) {
                                  // Get the current state to show the actual error
                                  final finalState =
                                      ref.read(loginFormNotifierProvider);
                                  if (context.mounted) {
                                    showXploraSnackBar(
                                      context,
                                      finalState.errors.isNotEmpty
                                          ? finalState.errors.first
                                          : 'Sign in failed. Please try again.',
                                      isError: true,
                                    );
                                  }
                                }
                              },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Divider with "or" text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: context.colors.border,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or continue with',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: context.colors.border,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Social sign in buttons
                Consumer(
                  builder: (context, ref, child) {
                    final loginState = ref.watch(loginFormNotifierProvider);
                    final isLoading = loginState.isLoading;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialIconButton(
                          iconPath: 'assets/png/google-icon.png',
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final loginNotifier = ref
                                      .read(loginFormNotifierProvider.notifier);

                                  // Trigger Google Sign-In
                                  await loginNotifier.loginWithGoogle();

                                  // Check for errors and handle navigation
                                  final finalState =
                                      ref.read(loginFormNotifierProvider);

                                  if (finalState.errors.isNotEmpty) {
                                    // Show error message in UI (user cancellation won't have errors)
                                    if (context.mounted) {
                                      showXploraSnackBar(
                                        context,
                                        finalState.errors.first,
                                        isError: true,
                                      );
                                    }
                                  } else {
                                    // Success - verify by checking if we have a user
                                    final authService = ref.read(authServiceProvider);
                                    final currentUser = await authService.getAuthUser();
                                    
                                      if (currentUser != null && context.mounted) {
                                      // Success - refresh settings and navigate
                                      // Refresh settings to ensure they're loaded
                                      ref.invalidate(
                                          settingsStateNotifierProvider);

                                      // Show appropriate message based on whether it's a new user
                                      showXploraSnackBar(
                                        context,
                                        finalState.needsProfileCompletion
                                            ? 'Signed up successfully!'
                                            : 'Signed in successfully!',
                                      );

                                      // Navigate to complete profile if new user, otherwise pop
                                      if (finalState.needsProfileCompletion) {
                                        print('Navigating to complete-profile page');
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                '/complete-profile');
                                      } else {
                                        // Refresh location to ensure it's loaded
                                        ref.invalidate(nearbyAdventuresProvider);

                                        // Refresh auto enable location provider
                                        ref.invalidate(
                                            autoEnableLocationTrackingProvider);

                                        print('UI - Navigating back (existing user)');
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }
                                },
                        ),
                        SocialIconButton(
                          icon: Icons.apple,
                          onPressed: isLoading
                              ? null
                              : () {
                                  // TODO: Implement Apple sign in
                                  showXploraSnackBar(
                                    context,
                                    'Apple sign in coming soon!',
                                  );
                                },
                        ),
                        SocialIconButton(
                          iconPath: 'assets/png/github-icon.png',
                          onPressed: isLoading
                              ? null
                              : () {
                                  // TODO: Implement GitHub sign in
                                  showXploraSnackBar(
                                    context,
                                    'GitHub sign in coming soon!',
                                  );
                                },
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 48),

                // Footer text
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/signup');
                    },
                    child: Text.rich(
                      style: bodyTextStyle,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: bodyTextStyle
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: bodyTextStyle.copyWith(
                              color: brandPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
