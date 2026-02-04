import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/auth_providers.dart';
import '../application/providers/local_storage_providers.dart';
import '../application/providers/settings_providers.dart';
import '../theme.dart';
import 'home.dart';
import 'pages/categories.dart';
import 'pages/splash_screen.dart';

/// Determines which screen to show first based on onboarding and categories status
class InitialRouteHandler extends ConsumerWidget {
  const InitialRouteHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if settings are being initialized (empty on first load before Firestore loads)
    final authUser = ref.watch(currentAuthUserIdStreamProvider);
    final settings = ref.watch(settingsStateNotifierProvider);

    final isLoadingSettings = authUser.whenOrNull(
          data: (userId) => userId != null && settings.isEmpty,
        ) ??
        false;

    // If settings are still loading, show splash screen without button
    if (isLoadingSettings) {
      return const SplashScreen();
    }

    // Get user's theme preference from settings
    final isDarkModeSetting =
        settings.where((s) => s.key == 'isDarkMode').firstOrNull;
    final isDarkMode = isDarkModeSetting?.value as bool?;

    // Get current theme brightness from context
    final currentBrightness = Theme.of(context).brightness;

    // Check if theme has been applied correctly
    final bool themeApplied;
    if (isDarkMode == null) {
      // User has no preference - using system theme, which is already applied
      themeApplied = true;
    } else {
      // Check if current theme matches user preference
      final expectedBrightness =
          isDarkMode ? Brightness.dark : Brightness.light;
      themeApplied = currentBrightness == expectedBrightness;
    }

    // If theme hasn't been applied yet, continue showing splash screen without button
    if (!themeApplied) {
      return const SplashScreen();
    }

    // return const Home();

    final hasFinishedOnboardingAsync = ref.watch(hasFinishedOnboardingProvider);

    return hasFinishedOnboardingAsync.when(
      data: (hasFinishedOnboarding) {
        if (!hasFinishedOnboarding) {
          // User hasn't finished onboarding - show splash screen with Get Started button
          return const SplashScreen(showGetStarted: true);
        }

        // User has finished onboarding - check categories
        // final hasSelectedInitialCategoriesAsync = ref.watch(hasSelectedInitialCategoriesProvider);
        //
        // return hasSelectedInitialCategoriesAsync.when(
        //   data: (hasSelectedInitialCategories) {
        //     if (!hasSelectedInitialCategories) {
        //       // User hasn't selected categories - show categories page
        //       return const ChooseCategories();
        //     }
        //     // User has completed everything - show home
        //     return const Home();
        //   },
        //   loading: () => const _LoadingScreen(),
        //   error: (_, __) => const Home(), // Fallback to home on error
        // );
        return const Home();
      },
      loading: () => const SplashScreen(),
      error: (_, __) => const Home(), // Fallback to home on error
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/png/xplora-logo.png',
                width: 120,
                height: 120,
                gaplessPlayback: true,
              ),
              const SizedBox(height: 24),
              Text(
                'XPLRA',
                style: h1Style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
