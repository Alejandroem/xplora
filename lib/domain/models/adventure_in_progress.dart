import 'package:freezed_annotation/freezed_annotation.dart';

import 'adventure.dart';

part 'adventure_in_progress.freezed.dart';
part 'adventure_in_progress.g.dart';

@freezed
class AdventureInProgress with _$AdventureInProgress {
  const factory AdventureInProgress({
    required Adventure adventure,
    required DateTime enteredPlaceAt,
    required int completeness,
  }) = _AdventureInProgress;

  factory AdventureInProgress.fromJson(Map<String, dynamic> json) =>
      _$AdventureInProgressFromJson(json);
}
