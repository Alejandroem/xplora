import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/navigation_providers.dart';
import '../infrastructure/providers/auth_providers.dart';
import '../infrastructure/providers/local_storage_providers.dart';
import 'components/home_component.dart';
import 'pages/categories.dart';
import 'pages/onboarding.dart';
import 'pages/qr_code_scann.dart';
import 'widgets/xplora_app_bar.dart';
import 'widgets/xplora_bottom_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    log('Home: initState');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(hasFinishedOnboardingProvider).whenData(
        (hasFinishedOnboarding) {
          if (!hasFinishedOnboarding) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OnboardingPage(),
              ),
            );
          } else {
            ref.watch(hasSelectedInitialCategoriesProvider).whenData(
              (hasSelectedInitialCategories) {
                if (!hasSelectedInitialCategories) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ChooseCategories(),
                    ),
                  );
                }
              },
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: const XplorAppBar(),
      floatingActionButton: StreamBuilder<bool>(
        stream: ref.watch(authServiceProvider).isSignedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null && snapshot.data!) {
            return FloatingActionButton(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const QRCodeScanPage(),
                  ),
                );
              },
              child: const Icon(Icons.qr_code),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      bottomNavigationBar: const XploraBottomNavigationBar(),
      body: Builder(
        builder: (context) {
          if (ref.watch(bottomNavigationBarProvider) == 0) {
            return const HomeComponent();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
