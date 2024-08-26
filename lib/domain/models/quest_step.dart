import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest_step.freezed.dart';
part 'quest_step.g.dart';

enum StepType {
  location,
  timeLocation,
  qr,
}

@freezed
class QuestStep with _$QuestStep {
  const factory QuestStep({
    @deprecated required String? id,
    @deprecated required String? questId,
    required bool? completed,
    required String stepName,
    required String stepDescription,
    required StepType stepType,
    required double? stepLatitude,
    required double? stepLongitude,
    required String? stepCode,
    required int? stepTime,
  }) = _QuestStep;

  factory QuestStep.fromJson(Map<String, dynamic> json) =>
      _$QuestStepFromJson(json);
}
