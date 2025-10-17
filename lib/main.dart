import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';
import 'ui/home.dart';
import 'ui/initial_route_handler.dart';
import 'ui/pages/categories.dart';
import 'ui/pages/onboarding.dart';
import 'ui/pages/signin_page.dart';
import 'ui/pages/signup_page.dart';
import 'ui/pages/complete_profile_page.dart';
import 'ui/pages/privacy_consent_summary.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final settingsProvider = ref.watch(settingsStateNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xplra',
      theme: () {
        return getDarkTheme();
        // final index = settingsProvider
        //     .indexWhere((setting) => setting.key == 'isDarkMode');
        // return index >= 0 && (settingsProvider[index].value as bool)
        //     ? getDarkTheme()
        //     : getTheme();
      }(),
      routes: {
        '/': (context) => const InitialRouteHandler(),
        '/home': (context) => const Home(),
        '/onboarding': (context) => const OnboardingPage(),
        '/categories': (context) => const ChooseCategories(),
        '/privacy-consent-summary': (context) => const PrivacyConsentSummary(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/complete-profile': (context) => const CompleteProfilePage(),
      },
    );
  }
}
