import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme.dart';

class QuestList extends ConsumerStatefulWidget {
  final bool isHero;
  const QuestList({
    this.isHero = false,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestListState();
}

class _QuestListState extends ConsumerState<QuestList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          widget.isHero ? const EdgeInsets.all(0) : const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!widget.isHero)
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.flag,
                    color: raisingBlack,
                  ),
                  Text(
                    'Quest',
                    style: TextStyle(
                      fontSize: 20,
                      color: raisingBlack,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: widget.isHero
                    ? BorderRadius.circular(0)
                    : BorderRadius.circular(10),
              ),
              child: Card(
                shape: widget.isHero
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      )
                    : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.all(0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 100,
                  itemExtent: widget.isHero ? 50 : 27,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color:
                            index.isEven ? Colors.grey.shade100 : Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Text(
                                'Quest $index',
                                style: TextStyle(
                                  fontSize: widget.isHero ? 20 : 14,
                                ), // Reduced font size
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Colors.grey, // Line color
                              margin: const EdgeInsets.only(
                                left: 8,
                              ),
                            ),
                            Container(
                              width: 30,
                              decoration: BoxDecoration(
                                color:
                                    index.isEven ? Colors.blue : Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
