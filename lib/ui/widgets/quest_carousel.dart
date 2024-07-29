import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';
import 'quest_carousel_card.dart';

class QuestCarousel extends ConsumerStatefulWidget {
  const QuestCarousel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestCarouselState();
}

class _QuestCarouselState extends ConsumerState<QuestCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Text(
              'Nearest quests',
              style: TextStyle(
                fontSize: 20,
                color: springBud,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < 5; i++) const QuestCarouselCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
