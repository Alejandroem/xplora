import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

class QuestCarouselCard extends ConsumerStatefulWidget {
  const QuestCarouselCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestCarouselCardState();
}

class _QuestCarouselCardState extends ConsumerState<QuestCarouselCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                'https://placehold.co/600x400/png',
                height: 200,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 6.0, right: 6.0),
                    decoration: BoxDecoration(
                      color: raisingBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Quest title',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: springBud,
                      ),
                    ),
                  ),
                  Text(
                    'Small objectives, cachy phrase',
                    style: TextStyle(
                      fontSize: 12,
                      color: raisingBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 6.0, right: 6.0),
                        decoration: BoxDecoration(
                          color: raisingBlack,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '15 exp',
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
                            '15 min',
                            style: TextStyle(
                              fontSize: 12,
                              color: majjoreleBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$\$',
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
    );
  }
}
