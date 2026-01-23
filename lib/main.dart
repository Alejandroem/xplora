import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers/auth_providers.dart';
import 'application/providers/settings_providers.dart';
import 'theme.dart';
import 'ui/home.dart';
import 'ui/initial_route_handler.dart';
import 'ui/pages/categories.dart';
import 'ui/pages/lora_ai_assistant.dart';
import 'ui/pages/onboarding.dart';
import 'ui/pages/quest_main_screen.dart';
import 'ui/pages/signin_page.dart';
import 'ui/pages/signup_page.dart';
import 'ui/pages/complete_profile_page.dart';
import 'ui/pages/welcome_mission.dart';
import 'ui/pages/privacy_consent_summary.dart';
import 'ui/pages/xp_boost_onboarding_page.dart';
import 'ui/pages/submit_place_page.dart';
import 'ui/pages/submissions_page.dart';
import 'ui/pages/achievements_page.dart';
import 'ui/pages/account_settings_page.dart';
import 'ui/pages/security_settings_page.dart';
import 'ui/pages/notification_settings_page.dart';
import 'ui/pages/permission_settings_page.dart';
import 'ui/pages/game_xp_page.dart';
import 'ui/pages/privacy_settings_page.dart';
import 'package:device_preview_plus/device_preview_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the settings state (not .notifier) to rebuild when settings change
    final settings = ref.watch(settingsStateNotifierProvider);

    // Get dark mode preference from settings
    final isDarkModeSetting =
        settings.where((s) => s.key == 'isDarkMode').firstOrNull;
    final isDarkMode = isDarkModeSetting?.value as bool?;

    print('isDarkMode: $isDarkMode');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xplra',
      theme: getTheme(), // Light theme
      darkTheme: getDarkTheme(), // Dark theme
      themeMode: isDarkMode == null
          ? ThemeMode.system // No preference - follow system
          : (isDarkMode ? ThemeMode.dark : ThemeMode.light),
      routes: {
        '/': (context) => const InitialRouteHandler(),
        '/home': (context) => const Home(),
        '/onboarding': (context) => const OnboardingPage(),
        '/categories': (context) => const ChooseCategories(),
        '/welcome-mission': (context) => const WelcomeMissionPage(),
        '/privacy-consent-summary': (context) => const PrivacyConsentSummary(),
        '/xp-onboarding': (context) => const XpBoostOnboardingPage(),
        '/lora-assistant': (context) => const LoraAiAssistant(),
        '/quest-main': (context) => const QuestMainScreen(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/complete-profile': (context) => const CompleteProfilePage(),
        '/submit-place': (context) => const SubmitPlacePage(),
        '/submissions': (context) => const SubmissionsPage(),
        '/achievements': (context) => const AchievementsPage(),
        '/account-settings': (context) => const AccountSettingsPage(),
        '/security-settings': (context) => const SecuritySettingsPage(),
        '/notification-settings': (context) => const NotificationSettingsPage(),
        '/permission-settings': (context) => const PermissionSettingsPage(),
        '/game-xp': (context) => const GameXpPage(),
        '/privacy-settings': (context) => const PrivacySettingsPage(),
      },
    );
  }
}
