import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceMigration {
  /// One-time migration: computes and writes `categoryIds` to every place
  /// document by flattening all `categorySelections[].path` arrays.
  ///
  /// After running once, remove the call from main.dart.
  static Future<void> migrateCategoryIds() async {
    final firestore = FirebaseFirestore.instance;
    final placesCollection = firestore.collection('places');

    print('🔄 Starting categoryIds migration...');

    final snapshot = await placesCollection.get();
    final docs = snapshot.docs;

    print('📦 Found ${docs.length} places to migrate');

    // Firestore batch limit is 500 writes per commit
    const batchSize = 500;
    int migrated = 0;

    for (int i = 0; i < docs.length; i += batchSize) {
      final batch = firestore.batch();
      final chunk = docs.skip(i).take(batchSize);

      for (final doc in chunk) {
        final data = doc.data();
        final categorySelections =
            data['categorySelections'] as List<dynamic>? ?? [];

        final categoryIds = categorySelections
            .expand((sel) {
              final path = (sel as Map<String, dynamic>)['path'] as List<dynamic>? ?? [];
              return path.map((id) => id as String);
            })
            .toSet()
            .toList();

        batch.update(doc.reference, {'categoryIds': categoryIds});
      }

      await batch.commit();
      migrated += chunk.length;
      print('✅ Migrated $migrated/${docs.length} places');
    }

    print('🎉 Migration complete! $migrated places updated.');
  }
}
