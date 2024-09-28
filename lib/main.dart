import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';


import 'theme.dart';
import 'ui/home.dart';
import 'ui/pages/categories.dart';
import 'ui/pages/onboarding.dart';

final Location location = Location();

Future<bool> requestLocationPermission() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // Check if location services are enabled
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false; // Service not enabled
    }
  }

  // Check for location permissions
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return false; // Permission not granted
    }
  }

  return true; // Permissions granted
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getTheme(),
      routes: {
        '/': (context) => const Home(),
        '/onboarding': (context) => const OnboardingPage(),
        '/categories': (context) => const ChooseCategories(),
      },
    );
  }
}
