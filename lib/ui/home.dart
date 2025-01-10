import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../application/providers/achievements_providers.dart';
import '../application/providers/adventure_providers.dart';
import '../application/providers/deep_links_providers.dart';
import '../application/providers/navigation_providers.dart';
import '../application/providers/auth_providers.dart';
import '../application/providers/local_storage_providers.dart';
import '../application/providers/notifications_provider.dart';
import '../application/providers/notifications_providers.dart';
import '../application/providers/profile_providers.dart';
import '../application/providers/quest_providers.dart';
import '../domain/models/achievement.dart';
import '../domain/models/xplora_profile.dart';
import 'components/feed_components.dart';
import 'components/notification_adventure_card.dart';
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
  bool showNotification = false;
  Icon? currentIcon;

  @override
  void initState() {
    super.initState();
    log('Home: initState');

    requestLocationPermissions();

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

  Future<void> requestLocationPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> _handleDeepLinkCode(String code) async {
    //Code should have the schema xplora://quest?code=123 get the code
    var questCode = code;
    if (code.startsWith('quest?code=')) {
      questCode = code.substring(11);
    }

    final questCrudService = ref.watch(questCrudServiceProvider);
    final authService = ref.watch(authServiceProvider);
    final user = await authService.getAuthUser();

    if (user != null) {
      final quest = await questCrudService.readByFilters(
        [
          {
            'field': 'stepCode',
            'operator': '==',
            'value': questCode,
          },
          {
            'field': 'userId',
            'operator': 'unset',
          }
        ],
      );
      final userHasThisQuest = await questCrudService.readByFilters(
        [
          {
            'field': 'userId',
            'operator': '==',
            'value': user.id,
          },
          {
            'field': 'stepCode',
            'operator': '==',
            'value': questCode,
          }
        ],
      );
      // Check if the user has already completed this quest
      if (userHasThisQuest != null && userHasThisQuest.isNotEmpty) {
        return;
      }
      // Award the quest by updating the userId and refreshing the list
      if (quest != null &&
          quest.isNotEmpty &&
          quest.first.stepCode == questCode) {
        //create new quest
        await questCrudService.create(quest.first.copyWith(
          id: null,
          questId: quest.first.id,
          userId: user.id,
        ));

        final xploraProfileService = ref.watch(profileServiceProvider);

        //update the user with the experience points
        final userProfile = await xploraProfileService.readByFilters([
          {
            'field': 'userId',
            'operator': '==',
            'value': user.id,
          },
        ]);

        if (userProfile != null && userProfile.isNotEmpty) {
          final userExperience = userProfile.first.experience;
          final updatedExperience = userExperience + quest.first.experience;
          await xploraProfileService.update(
            userProfile.first.copyWith(
              experience: updatedExperience.ceil(),
            ),
            userProfile.first.id!,
          );
          log('User experience updated to: $updatedExperience');

          final achievementsCrudService =
              ref.watch(achievementsServiceProvider);
          //get all achievements with no userID
          var allAchievements =
              await achievementsCrudService.readByFilters([]);

          allAchievements?.removeWhere(
            (achievement) =>
                achievement.userId != null && achievement.userId != '',
          );

          //first check achievements with a trigger quest and whose triggerValue belongs to the current id of the quest
          //if not check then the experience and level achievements
          if (allAchievements != null && allAchievements.isNotEmpty) {
            final questAchievements = allAchievements.where((achievement) {
              return achievement.trigger == Trigger.quest &&
                  achievement.triggerValue == quest.first.id;
            }).toList();

            final experienceAchievements = allAchievements.where((achievement) {
              return achievement.trigger == Trigger.experience &&
                  int.parse(achievement.triggerValue) <= updatedExperience;
            }).toList();

            final levelAchievements = allAchievements.where((achievement) {
              return achievement.trigger == Trigger.level &&
                  int.parse(achievement.triggerValue) <=
                      userProfile.first.profileLevel();
            }).toList();

            final achievementsToAward = [
              ...questAchievements,
              ...experienceAchievements,
              ...levelAchievements,
            ];

            if (achievementsToAward.isNotEmpty) {
              for (final achievement in achievementsToAward) {
                await achievementsCrudService.create(
                  achievement.copyWith(
                    userId: user.id,
                    dateAchieved: DateTime.now(),
                  ),
                );
                log('Achievement awarded: ${achievement.title}');
              }
            }
          }
        }

        if (context.mounted) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Quest Awarded!'),
                  content: const Text(
                      'You have been awarded a new quest!\nCheck your notifications to see your new quest.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    }
  }

  PreferredSizeWidget? getAppBar() {
    if (ref.watch(bottomNavigationBarProvider) == NavigationItem.home) {
      return const XplorAppBar();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentAuthUserIdStreamProvider, (previous, next) {
      if (next.value != null) {
        ref.watch(notificationsServiceProvider).saveToken(next.value!);
      }
    });

    ref.watch(adventureInProgressTrackerProvider);
    ref.watch(questInProgressTrackerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(userPreviousAdventuresProviderStream).whenData((adventures) {
        if (adventures != null) {
          for (final adventure in adventures) {
            if ((adventure.hasNotified ?? false) == false &&
                !showNotification) {
              setState(() {
                showNotification = true;
              });
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: const EdgeInsets.all(0),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NotificationAdventureCard(adventure: adventure),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final adventuresService = ref.read(
                            adventuresCrudServiceProvider,
                          );
                          await adventuresService.update(
                            adventure.copyWith(
                              hasNotified: true,
                            ),
                            adventure.id!,
                          );
                          setState(() {
                            showNotification = false;
                          });
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      });
    });

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
      appBar: getAppBar(),
      bottomNavigationBar: const XploraBottomNavigationBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (ref.watch(bottomNavigationBarProvider) == NavigationItem.home)
              const FeedComponents(),
            if (ref.watch(bottomNavigationBarProvider) == NavigationItem.search)
              const SearchComponents(),
            if (ref.watch(bottomNavigationBarProvider) ==
                NavigationItem.notifications)
              const NotificationComponents(),
            if (ref.watch(bottomNavigationBarProvider) == NavigationItem.xpc ||
                ref.watch(bottomNavigationBarProvider) == NavigationItem.store)
              Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Center(
                    child: Text(
                      'Comming Soon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  if (ref.watch(bottomNavigationBarProvider) ==
                      NavigationItem.store)
                    const Icon(
                      Icons.store,
                      size: 100,
                    ),
                  if (ref.watch(bottomNavigationBarProvider) ==
                      NavigationItem.xpc)
                    const Text(
                      'XPC',
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (ref.watch(bottomNavigationBarProvider) ==
                      NavigationItem.xpc)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'XPC is the digital currency powering the XPLRA ecosystem. Earn XPC by exploring your surroundings, completing quests, and engaging with the app. With the XPC Wallet, securely manage your rewards, track your balance, buy XPC to increase its value, and use XPC to unlock exclusive content, collectibles, and more. Stay tuned for its release!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
