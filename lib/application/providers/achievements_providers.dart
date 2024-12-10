import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/achievements_crud_service.dart';
import '../../infrastructure/services/firebase_achievements_curd_service.dart';
import 'auth_providers.dart';

final achievementsServiceProvider = Provider<AchievementsCrudService>((ref) {
  return FirebaseAchievementsCrudService();
});

final currentUserAchievementsProvider = StreamProvider.autoDispose((ref) {
  final achievementsCrudService = ref.watch(achievementsServiceProvider);
  final currentUserId = ref.watch(currentAuthUserIdStreamProvider);

  return currentUserId.when(
    data: (userId) {
      if (userId == null) {
        return const Stream.empty();
      }
      return achievementsCrudService.streamByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': userId,
        }
      ]);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
