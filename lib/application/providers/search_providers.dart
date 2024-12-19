import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adventure_providers.dart';
import 'quest_providers.dart';

final searchItemsProvider =
    StreamProvider.autoDispose<List<dynamic>>((ref) async* {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final questCrudService = ref.watch(questCrudServiceProvider);

  
  var allAvailableAdventuresStream = adventureCrudService.streamByFilters([]);

  
  var allAvailableQuestsStream = questCrudService.streamByFilters([]);

  // Combine the streams and emit a mixed list of adventures and quests
  await for (final availableAdventures in allAvailableAdventuresStream) {
    final availableQuests = await allAvailableQuestsStream.first;

    availableAdventures?.removeWhere(
      (adventure) => adventure.userId != null && adventure.userId != '',
    );
    availableQuests?.removeWhere(
      (quest) => quest.userId != null && quest.userId != '',
    );

    // Combine adventures and quests
    final mixedResults = [...?availableAdventures, ...?availableQuests];
    mixedResults.shuffle(Random()); // Shuffle for random order
    yield mixedResults;
  }
});
