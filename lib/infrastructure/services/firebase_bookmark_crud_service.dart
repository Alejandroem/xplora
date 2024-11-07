import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/bookmark.dart';
import '../../domain/services/boomark_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseBookmarkCrudService extends FirebaseCrudService<Bookmark>
    implements BookmarkCrudService {
  FirebaseBookmarkCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('bookmarks')
              .withConverter<Bookmark>(
                fromFirestore: (snapshot, _) =>
                    Bookmark.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
