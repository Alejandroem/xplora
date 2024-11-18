import 'package:freezed_annotation/freezed_annotation.dart';

part 'quest.freezed.dart';
part 'quest.g.dart';

enum QuestType {
  location,
  timeLocation,
  qr,
}

@freezed
class Quest with _$Quest {
  const factory Quest({
    required String? id,
    required String? userId,
    required String? questId,
    required String? category,
    required String title,
    required String shortDescription,
    required String longDescription,
    required String imageUrl,
    required double experience,
    required QuestType stepType,
    required int? timeInSeconds,
    required double? stepLatitude,
    required double? stepLongitude,
    required String? stepCode,
    required bool? hasNotified,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}
