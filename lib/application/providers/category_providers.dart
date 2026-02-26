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

// Requires composite index: isActive ASC, placeOrder ASC
final placeCategoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  final categoryService = ref.watch(categoryServiceProvider);
  final categories = await categoryService.readByFilters(
    [{'field': 'isActive', 'operator': '==', 'value': true}],
    orderBy: 'placeOrder',
  );
  return categories ?? [];
});

final interestCategoriesProvider =
    FutureProvider.autoDispose<List<Category>>((ref) async {
  final categoryService = ref.watch(categoryServiceProvider);
  final categories = await categoryService.readByFilters([
    {'field': 'isVisibleInInterests', 'operator': '==', 'value': true},
    {'field': 'isActive', 'operator': '==', 'value': true},
  ]);
  final result = List<Category>.from(categories ?? []);
  result.sort((a, b) => a.interestsOrder.compareTo(b.interestsOrder));
  return result;
});
