import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/local_storage_providers.dart';
import '../theme.dart';
import 'home.dart';
import 'pages/categories.dart';
import 'pages/onboarding.dart';

/// Determines which screen to show first based on onboarding and categories status
class InitialRouteHandler extends ConsumerWidget {
  const InitialRouteHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasFinishedOnboardingAsync = ref.watch(hasFinishedOnboardingProvider);

    return hasFinishedOnboardingAsync.when(
      data: (hasFinishedOnboarding) {
        if (!hasFinishedOnboarding) {
          // User hasn't finished onboarding - show onboarding
          return const OnboardingPage();
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
      loading: () => const _LoadingScreen(),
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
              ),
              const SizedBox(height: 24),
              Text(
                'XPLRA',
                style: h1Style.copyWith(
                  color: textPrimary,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
