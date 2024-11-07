import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/bookmark.dart';
import '../../domain/services/boomark_crud_service.dart';
import '../../infrastructure/services/firebase_bookmark_crud_service.dart';
import 'auth_providers.dart';

final boomarkCrudServiceProvider = Provider<BookmarkCrudService>((ref) {
  return FirebaseBookmarkCrudService();
});

final currentUserBoomarksStreamProvider =
    StreamProvider<List<Bookmark>?>((ref) {
  final boomarkService = ref.watch(boomarkCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  return authService.getAuthUserStreamUserId().asyncMap<List<Bookmark>?>(
    (id) async {
      if (id == null) {
        return null;
      } else {
        return await boomarkService.streamByFilters([
          {
            'field': 'userId',
            'operator': '==',
            'value': id,
          }
        ]).first;
      }
    },
  );
});

final adventureBookmarkProvider =
    StreamProvider.family<List<Bookmark>?, String>((ref, id) {
  final boomarkService = ref.watch(boomarkCrudServiceProvider);
  final authService = ref.watch(authServiceProvider);

  return authService.getAuthUserStreamUserId().asyncMap<List<Bookmark>?>(
    (userId) async {
      if (userId == null) {
        return null;
      } else {
        return await boomarkService.streamByFilters([
          {
            'field': 'userId',
            'operator': '==',
            'value': userId,
          },
          {
            'field': 'entityId',
            'operator': '==',
            'value': id,
          }
        ]).first;
      }
    },
  );
});
