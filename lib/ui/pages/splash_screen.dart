import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/local_storage_providers.dart';
import '../../infrastructure/constants.dart';
import '../../theme.dart';

/// Splash screen matching the design mockup
/// - Top: XPLRA text logo
/// - Center: Xplora orbital logo
/// - Bottom: Tagline text + Get Started button (only shown when showGetStarted is true)
/// Supports both light and dark mode with customizable SVG colors
class SplashScreen extends ConsumerStatefulWidget {
  /// When true, shows the "Get Started" button and tagline
  /// When false, only shows the logos (loading state)
  final bool showGetStarted;

  const SplashScreen({
    super.key,
    this.showGetStarted = false,
  });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isLoading = false;

  Future<void> _finishOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    final localStorage = ref.read(localStorageProvider);
    await localStorage.save(
      kHasFinishedOnboardingKey,
      'true',
    );

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: spacing32,
              vertical: spacing24,
            ),
            child: Column(
              children: [
                // Top section: Text logo
                const SizedBox(height: spacing48),
                _buildTextLogo(context),

                // Center section: Main logo (expanded to center it)
                Expanded(
                  child: Center(
                    child: _buildMainLogo(context),
                  ),
                ),

                // Bottom section: Tagline + Button (only when showGetStarted is true)
                _buildBottomSection(context),
                const SizedBox(height: spacing24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the XPLRA text logo at the top
  Widget _buildTextLogo(BuildContext context) {
    return Image.asset(
      'assets/png/xplra-text-logo-no-bg.png',
      height: 114,
      width: MediaQuery.of(context).size.width * 0.6,
      color: context.isDarkMode ? null : context.colors.textPrimary,
    );
  }

  /// Builds the main orbital logo in the center
  Widget _buildMainLogo(BuildContext context) {
    return Image.asset(
      'assets/png/xplra-logo.png',
      width: 250,
      height: 250,
      color: context.isDarkMode ? null : context.colors.textPrimary,
    );
  }

  /// Builds the bottom section with tagline and button (button only when showGetStarted is true)
  Widget _buildBottomSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tagline text - always visible
        Text(
          'Explore. Complete. Unlock.',
          style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        // Get Started button - only shown when showGetStarted is true
        if (widget.showGetStarted) ...[
          const SizedBox(height: spacing24),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: _isLoading ? 'Loading...' : 'Get Started',
              backgroundColor: context.colors.textPrimary,
              onPressed: _isLoading ? null : _finishOnboarding,
              textColor: context.colors.bgPrimary,
            ),
          ),
        ],
      ],
    );
  }
}
