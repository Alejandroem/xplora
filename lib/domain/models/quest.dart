import 'package:freezed_annotation/freezed_annotation.dart';

import 'quest_step.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

@freezed
class Quest with _$Quest {
  const factory Quest({
    required String title,
    required String shortDescription,
    required String longDescription,
    required double experience,
    required int timeInSeconds,
    required int priceLevel,
    required List<QuestStep> steps,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
