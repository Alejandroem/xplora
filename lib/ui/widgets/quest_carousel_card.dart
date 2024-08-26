import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../pages/quest_detail.dart';

class QuestCarouselCard extends ConsumerStatefulWidget {
  final Quest quest;
  const QuestCarouselCard(this.quest, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestCarouselCardState();
}

class _QuestCarouselCardState extends ConsumerState<QuestCarouselCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuestDetail(widget.quest),
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
              Opacity(
                opacity: 0.4,
                child: Image.network(
                  widget.quest.imageUrl,
                  height: 200,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                      decoration: BoxDecoration(
                        color: raisingBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.quest.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: springBud,
                        ),
                      ),
                    ),
                    Text(
                      widget.quest.shortDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: raisingBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
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
                            '${widget.quest.experience.toStringAsFixed(2)} exp',
                            style: TextStyle(
                              fontSize: 12,
                              color: springBud,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatSeconds(widget.quest.timeInSeconds),
                              style: TextStyle(
                                fontSize: 12,
                                color: majjoreleBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              List<String>.generate(
                                widget.quest.priceLevel,
                                (int index) {
                                  return '\$';
                                },
                              ).join(),
                              style: TextStyle(
                                fontSize: 12,
                                color: majjoreleBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
