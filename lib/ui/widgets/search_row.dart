import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../pages/adventure_detail.dart';
import 'quest_list.dart';

class SearchRow extends ConsumerStatefulWidget {
  final bool leadingFrist;
  final dynamic itemOne;
  final dynamic itemTwo;
  final dynamic itemThree;
  final dynamic itemFour;
  final dynamic itemFive;

  const SearchRow({
    super.key,
    required this.leadingFrist,
    required this.itemOne,
    required this.itemTwo,
    required this.itemThree,
    required this.itemFour,
    required this.itemFive,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchRowState();
}

class _SearchRowState extends ConsumerState<SearchRow> {
  Widget renderWidgetForModel(dynamic model) {
    if (model is Adventure) {
      return Expanded(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AdventureDetail(
                  'other',
                  model,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.imageUrl),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: Center(
              child: Text(
                model.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    } else if (model is Quest) {
      return Expanded(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Quest List'),
                  ),
                  body: const QuestList(
                    isHero: true,
                  ),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(model.imageUrl),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: Center(
              child: Text(
                model.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/png/xplora-logo.png'),
            fit: BoxFit.cover,
            opacity: 0.10,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width / 3;
    final itemHeight = MediaQuery.of(context).size.height / 2.5;
    return Row(
      children: [
        if (widget.leadingFrist)
          SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: renderWidgetForModel(widget.itemFive),
          ),
        SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: renderWidgetForModel(widget.itemOne),
              ),
              Expanded(
                child: renderWidgetForModel(widget.itemTwo),
              ),
            ],
          ),
        ),
        SizedBox(
          width: itemWidth,
          height: itemHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: renderWidgetForModel(widget.itemThree),
              ),
              Expanded(
                child: renderWidgetForModel(widget.itemFour),
              ),
            ],
          ),
        ),
        if (!widget.leadingFrist)
          SizedBox(
            width: itemWidth,
            height: itemHeight,
            child: renderWidgetForModel(widget.itemFive),
          ),
      ],
    );
  }
}
