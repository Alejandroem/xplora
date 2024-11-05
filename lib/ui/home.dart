import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/adventure_providers.dart';
import '../application/providers/deep_links_providers.dart';
import '../application/providers/navigation_providers.dart';
import '../application/providers/auth_providers.dart';
import '../application/providers/local_storage_providers.dart';
import '../application/providers/quest_providers.dart';
import 'components/feed_components.dart';
import 'components/notification_components.dart';
import 'components/search_components.dart';
import 'pages/categories.dart';
import 'pages/onboarding.dart';
import 'widgets/xplora_app_bar.dart';
import 'widgets/xplora_bottom_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Icon? currentIcon;

  @override
  void initState() {
    super.initState();
    log('Home: initState');

    // Access the deepLinkServiceProvider and listen for deep link events
    final deepLinkService = ref.read(deepLinkServiceProvider);

    deepLinkService.codeStream.listen((code) {
      if (code != null) {
        log('Deep link received with code: $code');
        // Add logic here to handle the code
        // Example: Navigate to a specific page based on the code
        _handleDeepLinkCode(code);
      }
    });
  }

  void _handleDeepLinkCode(String code) {
    // Example handling logic, you can adjust based on your requirements
    // Navigate to a different page or handle specific actions
    if (code == "specificCode") {
      //TODO: QR code handling logic
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(adventureInProgressTrackerProvider);
    ref.watch(questInProgressTrackerProvider);

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
      appBar: ref.watch(bottomNavigationBarProvider) == 0
          ? const XplorAppBar()
          : null,
      bottomNavigationBar: const XploraBottomNavigationBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(availableAdventuresProvider);
          ref.invalidate(createOrReadCurrentUserProfile);
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (ref.watch(bottomNavigationBarProvider) == 0)
                const FeedComponents(),
              if (ref.watch(bottomNavigationBarProvider) == 1)
                const SearchComponents(),
              if (ref.watch(bottomNavigationBarProvider) == 2)
                const NotificationComponents(),
            ],
          ),
        ),
      ),
    );
  }
}
