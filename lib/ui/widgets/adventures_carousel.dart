import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
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
                Spacer(),
                DropdownButton<int>(
                  value: ref.watch(minimumDistanceProvider),
                  items: const [
                    DropdownMenuItem(value: 1000, child: Text('1 km')),
                    DropdownMenuItem(value: 5000, child: Text('5 km')),
                    DropdownMenuItem(value: 10000, child: Text('10 km')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(minimumDistanceProvider.notifier).state = value;
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ref.watch(nearbyAdventuresProvider).when(
                  data: (adventures) {
                    if (adventures.isNotEmpty) {
                      return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: adventures
                            .map((adventure) =>
                                AdventuresCarouselCard(adventure))
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child: Text('No adventures found nearby'),
                      );
                    }
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
          ),
        ],
      ),
    );
  }
}
