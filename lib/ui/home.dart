import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/adventure_providers.dart';
import '../application/providers/navigation_providers.dart';
import '../domain/models/quest.dart';
import '../domain/models/quest_step.dart';
import '../application/providers/auth_providers.dart';
import '../application/providers/local_storage_providers.dart';
import '../application/providers/quest_providers.dart';
import 'pages/categories.dart';
import 'pages/onboarding.dart';
import 'widgets/categories_chips.dart';
import 'widgets/current_quest.dart';
import 'widgets/featured_adventure.dart';
import 'widgets/adventures_carousel.dart';
import 'widgets/xplora_app_bar.dart';
import 'widgets/xplora_bottom_bar.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Quest? currentQuest;
  QuestStep? currentStep;
  Icon? currentIcon;

  @override
  void initState() {
    super.initState();
    log('Home: initState');
  }

  @override
  Widget build(BuildContext context) {
    //Initialize the timers.
    ref.watch(adventureInProgressTrackerProvider);

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
    final currentAuthUserId = ref.watch(currentAuthUserIdStreamProvider);
    currentAuthUserId.whenData((userId) {
      if (userId != null) {
        ref.watch(currentQuestForUserProvider(userId)).whenData((quest) {
          if (quest != null) {
            setState(() {
              currentQuest = quest;
              currentStep = quest.steps.firstWhere(
                (step) => step.completed == false,
                orElse: () => quest.steps.last,
              );
              if (currentStep!.stepType == StepType.qr) {
                currentIcon = const Icon(Icons.qr_code);
              } else if (currentStep!.stepType == StepType.location) {
                currentIcon = const Icon(Icons.location_on);
              } else if (currentStep!.stepType == StepType.timeLocation) {
                currentIcon = const Icon(Icons.hourglass_bottom);
              }
            });
          }
        });
      }
    });

    return Scaffold(
      appBar: const XplorAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: const XploraBottomNavigationBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(availableAdventuresProvider);
          ref.refresh(nearbyAdventuresProvider);
          ref.refresh(createOrReadCurrentUserProfile);
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (ref.watch(bottomNavigationBarProvider) == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    FeaturedAdventure(),
                    NearestAdventures(),
                    CategoriesChips(),
                    SizedBox(
                      height: 200,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Spacer(),
                          Expanded(
                            child: CurrentQuest(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
