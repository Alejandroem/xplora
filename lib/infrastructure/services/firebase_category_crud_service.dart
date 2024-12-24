import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/category.dart';
import '../../domain/services/categories_crud_service.dart';
import 'firebase_crud_service.dart';

class FirebaseCategoryCrudService extends FirebaseCrudService<Category>
    implements CategoryCrudService {
  FirebaseCategoryCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('categories')
              .withConverter<Category>(
                fromFirestore: (snapshot, _) =>
                    Category.fromJson(snapshot.data()!),
                toFirestore: (entity, _) => entity.toJson(),
              ),
        );
}
