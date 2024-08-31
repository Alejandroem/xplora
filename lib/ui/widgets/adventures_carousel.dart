import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../../application/providers/quest_providers.dart';
import '../../theme.dart';
import 'quest_carousel_card.dart';

class NearestAdventures extends ConsumerStatefulWidget {
  const NearestAdventures({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestCarouselState();
}

class _QuestCarouselState extends ConsumerState<NearestAdventures> {
  @override
  Widget build(BuildContext context) {
    final questervice = ref.watch(questCrudServiceProvider);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: raisingBlack,
                ),
                Text(
                  'Near you',
                  style: TextStyle(
                    fontSize: 20,
                    color: raisingBlack,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: StreamBuilder(
              stream: questervice.streamByFilters([
                {
                  'field': 'isActive',
                  'operator': '==',
                  'value': false,
                },
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'An error occurred',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                if (snapshot.data == null ||
                    (snapshot.data as List<Quest>).isEmpty) {
                  return Center(
                    child: Text(
                      'No quests found...',
                      style: TextStyle(
                        fontSize: 20,
                        color: springBud,
                      ),
                    ),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(5, (index) => Adventure.demo())
                      .map(
                        (adventure) => AdventuresCarouselCard(
                          adventure,
                        ),
                      )
                      .toList(),
                );
                /* return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: (snapshot.data as List<Quest>)
                        .map(
                          (quest) => QuestCarouselCard(
                            quest,
                          ),
                        )
                        .toList(),
                  ); */
              },
            ),
          ),
        ],
      ),
    );
  }
}
