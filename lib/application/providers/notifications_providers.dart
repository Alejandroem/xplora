import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import 'adventure_providers.dart';
import 'auth_providers.dart';
import 'quest_providers.dart';

final userPreviousAdventuresProviderStream =
    StreamProvider.autoDispose<List<Adventure>?>((ref) async* {
  final adventureCrudService = ref.watch(adventuresCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  if (!await authService.isSignedInFuture()) {
    yield null;
    return;
  }

  final user = await authService.getAuthUser();
  if (user == null) {
    yield null;
    return;
  }

  // Stream the user's previous adventures based on user ID
  yield* adventureCrudService.streamByFilters([
    {
      'field': 'userId',
      'operator': '==',
      'value': user.id,
    },
  ]);
});

final userPreviousQuestProviderStream =
    StreamProvider.autoDispose<List<Quest>?>((ref) async* {
  final questCrudService = ref.watch(questCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  if (!await authService.isSignedInFuture()) {
    yield [];
    return;
  }

  final user = await authService.getAuthUser();
  if (user == null) {
    yield [];
    return;
  }

  // Stream the user's previous quests based on user ID
  yield* questCrudService.streamByFilters([
    {
      'field': 'userId',
      'operator': '==',
      'value': user.id,
    },
  ]);
});

