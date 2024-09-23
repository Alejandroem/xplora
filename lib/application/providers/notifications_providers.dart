import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adventure_providers.dart';
import 'quest_providers.dart';

final userAwardedProvider = FutureProvider<List<dynamic>>((ref) async {
  final nearbyAdventures =
      await ref.watch(userPreviousAdventuresProvider.future);
  final nearbyQuest = await ref.watch(userPreviousQuestProvider.future);

  // Assuming both nearbyAdventures and nearbyQuest are lists

  final mixedResults = [...(nearbyAdventures ?? []), ...(nearbyQuest)];
  return mixedResults;
});
