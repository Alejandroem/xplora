import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/quest.dart';
import '../../theme.dart';

class QuestDetail extends ConsumerStatefulWidget {
  final Quest quest;
  const QuestDetail(this.quest, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestDetailState();
}

class _QuestDetailState extends ConsumerState<QuestDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Text(
              widget.quest.title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            //experience
            const SizedBox(width: 16),
            Text(
              '${widget.quest.experience} XP',
              style: TextStyle(
                color: springBud,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              widget.quest.imageUrl,
              height: 200,
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    widget.quest.longDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.20,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 160,
                              width: 4,
                              color: majjoreleBlue,
                            ),
                            Icon(
                              widget.quest.userId != null
                                  ? Icons.check_circle
                                  : Icons.circle,
                              color: springBud,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.quest.shortDescription,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                if (widget.quest.stepType == QuestType.location)
                                  IconButton(
                                    icon: Icon(
                                      Icons.map,
                                      color: springBud,
                                    ),
                                    onPressed: () {},
                                  ),
                                if (widget.quest.stepType == QuestType.qr)
                                  IconButton(
                                    icon: Icon(
                                      Icons.qr_code,
                                      color: springBud,
                                    ),
                                    onPressed: () {},
                                  ),
                                if (widget.quest.stepType ==
                                    QuestType.timeLocation)
                                  IconButton(
                                    icon: Icon(
                                      Icons.hourglass_bottom,
                                      color: springBud,
                                    ),
                                    onPressed: () {},
                                  ),
                              ],
                            ),
                            Text(
                              widget.quest.longDescription,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
