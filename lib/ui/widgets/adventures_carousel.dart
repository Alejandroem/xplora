import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/navigation_providers.dart';
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
                const Spacer(),
                /* DropdownButton<int>(
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
                ), */
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
                        children: [
                          ...adventures.map(
                            (adventure) => AdventuresCarouselCard(
                              adventure,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              ref
                                  .read(bottomNavigationBarProvider.notifier)
                                  .state = NavigationItem.search;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: raisingBlack,
                                        size: 40,
                                      ),
                                      Text(
                                        "See more",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: raisingBlack,
                                        ),
                                      ),
                                      /* Text(
                                        widget.adventure.shortDescription,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: raisingBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 6.0, right: 6.0),
                                            decoration: BoxDecoration(
                                              color: raisingBlack,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${widget.adventure.experience.toStringAsFixed(2)} exp',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: springBud,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ), */
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
