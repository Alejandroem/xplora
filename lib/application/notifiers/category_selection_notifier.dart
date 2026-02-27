import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySelectionState {
  final Map<String, String?> selections;

  const CategorySelectionState({required this.selections});

  CategorySelectionState copyWith({Map<String, String?>? selections}) =>
      CategorySelectionState(selections: selections ?? this.selections);
}

class CategorySelectionNotifier
    extends StateNotifier<CategorySelectionState> {
  CategorySelectionNotifier()
      : super(const CategorySelectionState(selections: {}));

  void init(Map<String, String?> initialSelections) {
    state = CategorySelectionState(selections: Map.from(initialSelections));
  }

  void selectChild(String parentId, String childId) {
    final selections = Map<String, String?>.from(state.selections);
    selections[parentId] = selections[parentId] == childId ? null : childId;
    state = CategorySelectionState(selections: selections);
  }

  void clearAll() {
    state = const CategorySelectionState(selections: {});
  }
}
