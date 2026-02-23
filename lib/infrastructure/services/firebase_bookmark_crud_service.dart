import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/bookmark.dart';
import '../../domain/services/boomark_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseBookmarkCrudService extends FirebaseCrudService<Bookmark>
    implements BookmarkCrudService {
  final String userId;

  FirebaseBookmarkCrudService(this.userId)
      : super(
          FirebaseFirestore.instance
              .doc('users/$userId')
              .collection('bookmarks')
              .withConverter<Bookmark>(
                fromFirestore: (snapshot, _) =>
                    Bookmark.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );

  @override
  Future<Bookmark> create(Bookmark entity) async {
    final withTimestamp = entity.copyWith(createdAt: Timestamp.now());
    final docRef = collection.doc(entity.id);
    await docRef.set(withTimestamp);
    final snapshot = await docRef.get();
    return snapshot.data()!;
  }
}
