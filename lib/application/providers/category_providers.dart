import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/category.dart';
import '../../domain/services/categories_crud_service.dart';
import '../../infrastructure/services/firebase_category_crud_service.dart';

final categoryServiceProvider = Provider<CategoryCrudService>((ref) {
  return FirebaseCategoryCrudService();
});

final allCategories = StreamProvider.autoDispose<List<Category>>((ref) {
  final categoryService = ref.watch(categoryServiceProvider);
  return categoryService.streamByFilters([]).map((list) => list ?? []);
});
