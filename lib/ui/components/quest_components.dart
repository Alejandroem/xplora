import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/current_quest.dart';
import '../widgets/quest_list.dart';

class QuestComponents extends ConsumerStatefulWidget {
  const QuestComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestComponentsState();
}

class _QuestComponentsState extends ConsumerState<QuestComponents> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
