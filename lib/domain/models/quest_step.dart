import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_step.freezed.dart';
part 'quest_step.g.dart';

@freezed
class QuestStep with _$QuestStep {
  const factory QuestStep({
    required String? id,
    required String questId,
    required String stepName,
    required String stepDescription,
    required String stepCode,
    required double stepLatitude,
    required double stepLongitude,
  }) = _QuestStep;

  factory QuestStep.fromJson(Map<String, dynamic> json) =>
      _$QuestStepFromJson(json);
}
