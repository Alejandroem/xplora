import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adventure_providers.dart';
import 'quest_providers.dart';

import 'dart:math';

final searchItemsProvider =
    FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final nearbyAdventures = await ref.watch(nearbyAdventuresProvider.future);
  final nearbyQuest = await ref.watch(nearbyQuestProvider.future);

  // Assuming both nearbyAdventures and nearbyQuest are lists
  final mixedResults = [...(nearbyAdventures ?? []), ...(nearbyQuest ?? [])];

  // Shuffle the mixed results to get them in random order
  mixedResults.shuffle(Random());

  return mixedResults;
});
