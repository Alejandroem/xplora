import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/notifications_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../pages/settings_page.dart';
import 'notification_adventure_card.dart';
import 'notification_quest_card.dart';

class NotificationComponents extends ConsumerStatefulWidget {
  const NotificationComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationComponentsState();
}

class _NotificationComponentsState
    extends ConsumerState<NotificationComponents> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
      child: SafeArea(
        child: DefaultTabController(
          length: 2, // Two tabs: Adventures and Quests
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
              title: const Row(
                children: [
                  Text('Notifications'),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ...ref.watch(userPreviousActivitiesProviderStream).when(
                        data: (items) {
                          return items.map(
                            (item) {
                              if (item is Adventure) {
                                return AdventureCard(adventure: item);
                              } else if (item is Quest) {
                                return QuestCard(quest: item);
                              }
                              return const SizedBox();
                            },
                          ).toList();
                        },
                        loading: () => [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                        error: (err, stack) => [
                          Center(child: Text('Error: $err')),
                        ],
                      ),
                  const SizedBox(
                    height: kBottomNavigationBarHeight,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// AdventureCard widget to display each adventure

