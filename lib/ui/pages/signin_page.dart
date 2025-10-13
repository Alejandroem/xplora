import 'package:flutter/material.dart';
import '../../theme.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/png/xplora-logo.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Xplra',
              style: h2Style.copyWith(
                color: textPrimary,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sign In title
                  Center(
                    child: Text(
                      'Sign In',
                      style: h1Style.copyWith(
                        color: textPrimary,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Center(
                    child: Text(
                      'Welcome back! Sign in to continue your adventure',
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
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email address',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: textSecondary,
                      size: 20,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Password field
                  XploraTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign In button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      text: 'Sign In',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Implement sign in logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign in functionality coming soon!'),
                            ),
                          );
                        }
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
                          'or',
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
                  
                  // Social sign in buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialIconButton(
                        iconPath: 'assets/png/google-icon.png',
                        onPressed: () {
                          // TODO: Implement Google sign in
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google sign in coming soon!'),
                            ),
                          );
                        },
                      ),
                      _buildSocialIconButton(
                        icon: Icons.apple,
                        onPressed: () {
                          // TODO: Implement Apple sign in
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Apple sign in coming soon!'),
                            ),
                          );
                        },
                      ),
                      _buildSocialIconButton(
                        iconPath: 'assets/png/github-icon.png',
                        onPressed: () {
                          // TODO: Implement GitHub sign in
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('GitHub sign in coming soon!'),
                            ),
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
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: bodyTextStyle.copyWith(
                                color: textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign Up',
                              style: bodyTextStyle.copyWith(
                                color: accentPrimary,
                                fontSize: 14,
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
          borderRadius: BorderRadius.circular(32),
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

