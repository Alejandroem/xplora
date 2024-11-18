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
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
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
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Adventures'),
                  Tab(text: 'Quests'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                AdventuresList(),
                QuestsList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdventuresList extends ConsumerWidget {
  const AdventuresList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventures = ref.watch(userPreviousAdventuresProviderStream);

    return adventures.when(
      data: (items) {
        if (items == null || items.isEmpty) {
          return const Center(
            child: Text(
              'No previous adventures.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final adventure = items[index];
            return AdventureCard(adventure: adventure);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class QuestsList extends ConsumerWidget {
  const QuestsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(userPreviousQuestProviderStream);

    return quests.when(
      data: (items) {
        if (items == null || items.isEmpty) {
          return const Center(
            child: Text(
              'No previous quests.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final quest = items[index];
            return QuestCard(quest: quest);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

// AdventureCard widget to display each adventure

