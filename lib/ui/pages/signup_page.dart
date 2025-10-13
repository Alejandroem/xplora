import 'package:flutter/material.dart';
import '../../theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  
                  // Username field
                  XploraTextField(
                    controller: _usernameController,
                    labelText: 'Username',
                    hintText: 'Choose a unique username',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: textSecondary,
                      size: 20,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // First and Last name fields in same row
                  Row(
                    children: [
                      Expanded(
                        child: XploraTextField(
                          controller: _firstNameController,
                          labelText: 'First Name',
                          hintText: 'First name',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: textSecondary,
                            size: 20,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: XploraTextField(
                          controller: _lastNameController,
                          labelText: 'Last Name',
                          hintText: 'Last name',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: textSecondary,
                            size: 20,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Confirm Password field
                  XploraTextField(
                    controller: _confirmPasswordController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Sign Up button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      text: 'Sign Up',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Implement sign up logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sign up functionality coming soon!'),
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
                  
                  // Social sign up buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialIconButton(
                        iconPath: 'assets/png/google-icon.png',
                        onPressed: () {
                          // TODO: Implement Google sign up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Google sign up coming soon!'),
                            ),
                          );
                        },
                      ),
                      _buildSocialIconButton(
                        icon: Icons.apple,
                        onPressed: () {
                          // TODO: Implement Apple sign up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Apple sign up coming soon!'),
                            ),
                          );
                        },
                      ),
                      _buildSocialIconButton(
                        iconPath: 'assets/png/github-icon.png',
                        onPressed: () {
                          // TODO: Implement GitHub sign up
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('GitHub sign up coming soon!'),
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
                        Navigator.of(context).pushNamed('/signin');
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: bodyTextStyle.copyWith(
                                color: textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In',
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

