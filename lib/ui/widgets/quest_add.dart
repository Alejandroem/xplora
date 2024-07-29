import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestAdd extends ConsumerStatefulWidget {
  const QuestAdd({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestAddState();
}

class _QuestAddState extends ConsumerState<QuestAdd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      child: const Placeholder(
        child: Text('Add space'),
      ),
    );
  }
}
