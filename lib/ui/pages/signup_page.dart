import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/settings_providers.dart';
import '../../utils/snackbar_utils.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


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
                  // Sign Up title
                  Center(
                    child: Text(
                      'Sign Up',
                      style: h1Style.copyWith(
                        color: textPrimary,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Center(
                    child: Text(
                      'Create your account and start exploring',
                      style: bodyTextStyle.copyWith(
                        color: textSecondary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  
                  
                  // Email field
                  XploraTextField(
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: textSecondary,
                      size: 20,
                    ),
                    onChanged: (value) {
                      ref.read(signupFormNotifierProvider.notifier).setEmail(value.trim());
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Password field
                  XploraTextField(
                    labelText: 'Password',
                    hintText: 'Create a strong password',
                    obscureText: _obscurePassword,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: textSecondary,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: textSecondary,
                        size: 20,
                      ),
                    ),
                    onChanged: (value) {
                      ref.read(signupFormNotifierProvider.notifier).setPassword(value.trim());
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password field
                  XploraTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: textSecondary,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: textSecondary,
                        size: 20,
                      ),
                    ),
                    onChanged: (value) {
                      ref.read(signupFormNotifierProvider.notifier).setConfirmPassword(value.trim());
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Consumer(
                      builder: (ctx, ref, child)
                      {
                        final isLoading = ref.watch(signupFormNotifierProvider).isLoading;
                        return PrimaryButton(
                          text: isLoading ? 'Signing up...' : 'Sign up',
                          onPressed: isLoading ? null : () async {
                            final signUpNotifier =
                                ref.read(signupFormNotifierProvider.notifier);


                            // Perform sign up
                            await signUpNotifier.signUp();

                            // Check for errors
                            final finalState =
                                ref.read(signupFormNotifierProvider);
                            if (finalState.errors.isNotEmpty) {
                              if (context.mounted) {
                                showXploraSnackBar(
                                  context,
                                  finalState.errors.first,
                                  isError: true,
                                );
                              }
                            } else {
                              // Success - navigate to profile completion screen
                              if (context.mounted) {
                                // Refresh settings to ensure they're loaded
                                ref.invalidate(settingsStateNotifierProvider);
                                
                                Navigator.of(context).pushReplacementNamed('/complete-profile');
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
                          color: strokeDivider,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or continue with',
                          style: bodyTextStyle.copyWith(
                            color: textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: strokeDivider,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Social sign up buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialIconButton(
                        iconPath: 'assets/png/google-icon.png',
                        onPressed: () {
                          // TODO: Implement Google sign up
                          showXploraSnackBar(
                            context,
                            'Google sign up coming soon!',
                          );
                        },
                      ),
                      _buildSocialIconButton(
                        icon: Icons.apple,
                        onPressed: () {
                          // TODO: Implement Apple sign up
                          showXploraSnackBar(
                            context,
                            'Apple sign up coming soon!',
                          );
                        },
                      ),
                      _buildSocialIconButton(
                        iconPath: 'assets/png/github-icon.png',
                        onPressed: () {
                          // TODO: Implement GitHub sign up
                          showXploraSnackBar(
                            context,
                            'GitHub sign up coming soon!',
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Footer text
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/signin');
                      },
                      child: Text.rich(
                        style: bodyTextStyle,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: bodyTextStyle.copyWith(
                                color: textSecondary,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign in',
                              style: bodyTextStyle.copyWith(
                                color: accentPrimary,
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

  Widget _buildSocialIconButton({
    IconData? icon,
    String? iconPath,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(27),
          border: Border.all(
            color: accentPrimary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: iconPath != null
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                ),
              )
            : Icon(
                icon!,
                color: textPrimary,
                size: 32,
              ),
      ),
    );
  }
}

