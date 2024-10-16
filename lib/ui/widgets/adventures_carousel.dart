import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../domain/models/adventure.dart';
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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: raisingBlack,
                  size: 20,
                ),
                Text(
                  'Nearest Adventures',
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
            child: FutureBuilder(
              future: ref.watch(nearbyAdventuresProvider.future),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: (snapshot.data as List<Adventure>)
                        .map(
                          (adventure) => AdventuresCarouselCard(
                            adventure,
                          ),
                        )
                        .toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
