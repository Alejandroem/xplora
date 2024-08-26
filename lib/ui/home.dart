import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/navigation_providers.dart';
import '../infrastructure/providers/auth_providers.dart';
import '../infrastructure/providers/local_storage_providers.dart';
import '../infrastructure/providers/quest_providers.dart';
import 'pages/categories.dart';
import 'pages/onboarding.dart';
import 'widgets/categories_chips.dart';
import 'widgets/current_quest.dart';
import 'widgets/quest_add.dart';
import 'widgets/quest_carousel.dart';
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
              onPressed: () async {
                /* final questService = ref.watch(questCrudServiceProvider);
                final questStepService =
                    ref.watch(questStepCrudServiceProvider);
                //create a quest with steps to test how it will look on the backend
                const quest = Quest(
                  id: null,
                  userId: null,
                  isActive: null,
                  experience: 100,
                  imageUrl: 'https://via.placeholder.com/150',
                  title: 'Test Quest',
                  shortDescription: 'Lorem ipsum dolor sit amet',
                  longDescription:
                      'Lorem ipsum dolor sit amet, c-onsectetur adipiscing elit.',
                  priceLevel: 1,
                  timeInSeconds: 3600,
                  /* steps: [
                    ,
                  ], */
                );
                Quest newQuest = await questService.create(quest);
                QuestStep step = QuestStep(
                  id: null,
                  completed: null,
                  questId: newQuest.id!,
                  stepName: 'step 1',
                  stepCode: 'step1',
                  stepDescription: 'step 1 description',
                  stepLatitude: 0.0,
                  stepLongitude: 0.0,
                );

                await questStepService.create(step); */

                /* Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const QRCodeScanPage(),
                  ),
                ); */
              },
              child: const Icon(Icons.qr_code),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      bottomNavigationBar: const XploraBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (ref.watch(bottomNavigationBarProvider) == 0)
              Column(
                children: [
                  const QuestAdd(),
                  ref.watch(currentAuthUserIdStreamProvider).when(
                      data: (userId) {
                    if (userId == null) {
                      return const SizedBox();
                    }
                    return ref.watch(currentQuestForUserProvider(userId!)).when(
                        data: (quest) {
                      if (quest != null) {
                        return CurrentQuest(quest);
                      } else {
                        return const SizedBox();
                      }
                    }, error: (Object error, StackTrace stackTrace) {
                      return const SizedBox();
                    }, loading: () {
                      return const SizedBox();
                    });
                  }, error: (Object error, StackTrace stackTrace) {
                    return const SizedBox();
                  }, loading: () {
                    return const SizedBox();
                  }),
                  const QuestCarousel(),
                  const CategoriesChips(),
                ],
              )
          ],
        ),
      ),
    );
  }
}
