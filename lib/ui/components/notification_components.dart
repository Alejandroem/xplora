import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/notifications_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../../theme.dart';
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
          child: GradientBackground(
            child: Scaffold(
              appBar: const GlassAppBar(
                // actions: [
                //   IconButton(
                //     icon: const Icon(Icons.settings),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const SettingsPage(),
                //         ),
                //       );
                //     },
                //   ),
                // ],
                title: 'Notifications'
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ...ref.watch(userPreviousActivitiesProviderStream).when(
                          data: (items) {
                            print('items: $items');
                            if (items.isEmpty) {
                              return [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.8,
                                  child: Center(
                                    child: Text('No notifications found', style: bodyTextStyle.copyWith(color: textSecondary, fontSize: 16)),
                                  ),
                                ),
                              ];
                            }
                            return items.map(
                              (item) {
                                if (item is Adventure) {
                                  return NotificationAdventureCard(
                                      adventure: item);
                                } else if (item is Quest) {
                                  return NotificationQuestCard(quest: item);
                                }
                                return const SizedBox();
                              },
                            ).toList();
                          },
                          loading: () => [
                            SizedBox(
                              height: MediaQuery.of(context).size.height*0.8,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                          error: (err, stack) => [
                            Center(child: Text('Error: $err')),
                          ],
                        ),
                    // const SizedBox(
                    //   height: kBottomNavigationBarHeight,
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// AdventureCard widget to display each adventure

