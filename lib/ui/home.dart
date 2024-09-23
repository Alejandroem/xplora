import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/adventure_providers.dart';
import '../application/providers/navigation_providers.dart';
import '../application/providers/auth_providers.dart';
import '../application/providers/local_storage_providers.dart';
//import '../application/providers/quest_providers.dart';
import '../application/providers/quest_providers.dart';
import 'components/search_components.dart';
import 'pages/categories.dart';
import 'pages/onboarding.dart';
import 'widgets/categories_chips.dart';
import 'widgets/current_quest.dart';
import 'widgets/featured_adventure.dart';
import 'widgets/adventures_carousel.dart';
import 'widgets/quest_list.dart';
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

    return Scaffold(
      appBar: ref.watch(bottomNavigationBarProvider) == 0
          ? const XplorAppBar()
          : null,
      bottomNavigationBar: const XploraBottomNavigationBar(),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //final questProvider = ref.read(questCrudServiceProvider);

           await questProvider.create(
            const Quest(
              id: null,
              userId: null,
              title: 'Test QR',
              shortDescription: 'Test Quest Short Description',
              longDescription: 'Test Quest Long Description',
              imageUrl: 'https://picsum.photos/200/300',
              experience: 100,
              stepType: QuestType.qr,
              timeInSeconds: 0,
              stepLatitude: 18.470412,
              stepLongitude: -66.123672,
              stepCode: '123456',
            ),
          ); 
        },
        child: const Icon(Icons.add),
      ),
      */
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(availableAdventuresProvider);
          ref.invalidate(nearbyAdventuresProvider);
          ref.invalidate(nearbyQuestProvider);
          ref.invalidate(createOrReadCurrentUserProfile);
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (ref.watch(bottomNavigationBarProvider) == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FeaturedAdventure(),
                    const NearestAdventures(),
                    const CategoriesChips(),
                    SizedBox(
                      height: 200,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text('Quest List'),
                                      ),
                                      body: const Hero(
                                        tag: 'quest-list',
                                        child: QuestList(
                                          isHero: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Hero(
                                tag: 'quest-list',
                                child: QuestList(
                                  isHero: false,
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: CurrentQuest(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (ref.watch(bottomNavigationBarProvider) == 1)
                const SearchComponents(),
            ],
          ),
        ),
      ),
    );
  }
}
