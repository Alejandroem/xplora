import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adventure_providers.dart';
import 'quest_providers.dart';

final searchItemsProvider =
    StreamProvider.autoDispose<List<dynamic>>((ref) async* {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final questCrudService = ref.watch(questCrudServiceProvider);

  // Stream all adventures where userId is unset
  final allAvailableAdventuresStream = adventureCrudService.streamByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);

  // Stream all quests where userId is unset
  final allAvailableQuestsStream = questCrudService.streamByFilters([
    {
      'field': 'userId',
      'operator': 'unset',
    }
  ]);

  // Combine the streams and emit a mixed list of adventures and quests
  await for (final availableAdventures in allAvailableAdventuresStream) {
    final availableQuests = await allAvailableQuestsStream.first;

    // Combine adventures and quests
    final mixedResults = [...?availableAdventures, ...?availableQuests];
    mixedResults.shuffle(Random()); // Shuffle for random order
    yield mixedResults;
  }
});
