import 'package:freezed_annotation/freezed_annotation.dart';

part 'filters_state.freezed.dart';
part 'filters_state.g.dart';

@freezed
class FiltersState with _$FiltersState {
  const factory FiltersState({
    @Default('All') String selectedType,
    @Default(500000) int minimumDistance,
    @Default(false) bool filtersEnabled,
  }) = _FiltersState;

  factory FiltersState.fromJson(Map<String, dynamic> json) =>
      _$FiltersStateFromJson(json);
      
}
