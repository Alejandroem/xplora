import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/filters_state.dart';

final filtersStateProvider = StateProvider<FiltersState>((ref) {
  return const FiltersState(
    selectedType: 'All',
    minimumDistance: 500000,
    filtersEnabled: false,
  );
});
