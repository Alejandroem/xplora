import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../pages/adventure_detail.dart';

class AdventuresCarouselCard extends ConsumerStatefulWidget {
  final Adventure adventure;
  const AdventuresCarouselCard(this.adventure, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestCarouselCardState();
}

class _QuestCarouselCardState extends ConsumerState<AdventuresCarouselCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AdventureDetail('carousel', widget.adventure),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          width: 150,
          child: Stack(
            children: [
              Hero(
                tag: 'adventure-image-${widget.adventure.id}-carousel',
                child: Image.network(
                  widget.adventure.imageUrl,
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'adventure-title-${widget.adventure.id}-carousel',
                      child: Text(
                        widget.adventure.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: raisingBlack,
                        ),
                      ),
                    ),
                    Text(
                      widget.adventure.shortDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: raisingBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                          decoration: BoxDecoration(
                            color: raisingBlack,
                            borderRadius: BorderRadius.circular(10),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatSeconds(int timeInSeconds) {
    //return min, sec, h, min, d, h, w, d
    if (timeInSeconds < 60) {
      return '${timeInSeconds}s';
    } else if (timeInSeconds < 3600) {
      return '${(timeInSeconds / 60).floor()}m';
    } else if (timeInSeconds < 86400) {
      return '${(timeInSeconds / 3600).floor()}h';
    } else if (timeInSeconds < 604800) {
      return '${(timeInSeconds / 86400).floor()}d';
    } else if (timeInSeconds < 2419200) {
      return '${(timeInSeconds / 604800).floor()}w';
    } else {
      return '${(timeInSeconds / 2419200).floor()}mon';
    }
  }
}
