import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/navigation_providers.dart';
import '../domain/models/quest.dart';
import '../domain/models/quest_step.dart';
import '../infrastructure/providers/auth_providers.dart';
import '../infrastructure/providers/local_storage_providers.dart';
import '../infrastructure/providers/quest_providers.dart';
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
              onPressed: () async {
                final questService = ref.watch(questCrudServiceProvider);
                final questStepService =
                    ref.watch(questStepCrudServiceProvider);
                //create a quest with steps to test how it will look on the backend
                const quest = Quest(
                  id: null,
                  experience: 100,
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
                  questId: newQuest.id!,
                  stepName: 'step 1',
                  stepCode: 'step1',
                  stepDescription: 'step 1 description',
                  stepLatitude: 0.0,
                  stepLongitude: 0.0,
                );

                await questStepService.create(step);

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
