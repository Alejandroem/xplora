import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/bookmark.dart';
import '../../domain/models/place.dart';
import '../../domain/services/boomark_crud_service.dart';
import '../../infrastructure/services/firebase_bookmark_crud_service.dart';
import 'auth_service_providers.dart';
import 'place_providers.dart';

final bookmarkToggleProvider =
    AsyncNotifierProvider.family<BookmarkToggleNotifier, void, String>(
        BookmarkToggleNotifier.new);

class BookmarkToggleNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String placeId) async {}

  Future<void> toggle(Bookmark? current) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final user = await authService.getAuthUser();
      if (user == null) return;

      final service = ref.read(bookmarkCrudServiceProvider(user.id!));
      if (current == null) {
        await service.create(Bookmark(id: arg, type: BookmarkType.place));
      } else {
        await service.delete(current.id);
      }
    });
  }
}

final bookmarkCrudServiceProvider =
    Provider.family<BookmarkCrudService, String>((ref, userId) {
  return FirebaseBookmarkCrudService(userId);
});

final currentUserBookmarksStreamProvider =
    StreamProvider<List<Bookmark>?>((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.getAuthUserStreamUserId().asyncExpand<List<Bookmark>?>(
    (userId) {
      if (userId == null) return Stream.value(null);
      return ref.read(bookmarkCrudServiceProvider(userId)).streamByFilters([]);
    },
  );
});

/// Streams only [BookmarkType.place] bookmarks for the current user.
/// The filter is applied at the Firestore query level, so no unnecessary
/// bookmark documents are fetched when other types exist.
final currentUserPlaceBookmarksStreamProvider =
    StreamProvider<List<Bookmark>?>((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.getAuthUserStreamUserId().asyncExpand<List<Bookmark>?>(
    (userId) {
      if (userId == null) return Stream.value(null);
      return ref.read(bookmarkCrudServiceProvider(userId)).streamByFilters([
        {'field': 'type', 'operator': '==', 'value': 'place'},
      ]);
    },
  );
});

final savedPlacesProvider = FutureProvider<List<Place>>((ref) async {
  final bookmarks =
      ref.watch(currentUserPlaceBookmarksStreamProvider).valueOrNull;

  if (bookmarks == null || bookmarks.isEmpty) return [];

  final sorted = [...bookmarks]..sort((a, b) {
      final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
      final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });

  final placeCrudService = ref.read(placeCrudServiceProvider);
  final places =
      await Future.wait(sorted.map((b) => placeCrudService.read(b.id)));

  return places.whereType<Place>().toList();
});

final placeBookmarkProvider =
    StreamProvider.family<Bookmark?, String>((ref, placeId) {
  final authService = ref.watch(authServiceProvider);

  return authService.getAuthUserStreamUserId().asyncExpand<Bookmark?>(
    (userId) {
      if (userId == null) return Stream.value(null);
      return ref.read(bookmarkCrudServiceProvider(userId)).getStream(placeId);
    },
  );
});
