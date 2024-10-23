import 'package:freezed_annotation/freezed_annotation.dart';
import 'quest.dart';

part 'quest_in_progress.freezed.dart';
part 'quest_in_progress.g.dart';

@freezed
class QuestInProgress with _$QuestInProgress {
  const factory QuestInProgress({
    required Quest quest,
    required DateTime startedAt,
    int? timeInArea, // Optional time spent in area (for tracking time-location quests)
  }) = _QuestInProgress;

  factory QuestInProgress.fromJson(Map<String, dynamic> json) =>
      _$QuestInProgressFromJson(json);
}
