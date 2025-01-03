import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';
part 'achievement.g.dart';

enum Trigger {
  experience,
  level,
  adventure,
  quest,
}

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String? userId,
    required String title,
    required String description,
    required String icon,
    required DateTime? dateAchieved,
    required Trigger trigger,
    required String triggerValue,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}
