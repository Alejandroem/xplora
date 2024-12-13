import 'package:freezed_annotation/freezed_annotation.dart';

part 'adventure.freezed.dart';
part 'adventure.g.dart';

@freezed
class Adventure with _$Adventure {
  const factory Adventure({
    required String? id,
    required String? userId, //Only set if a user already got through it
    required String?
        adventureId, //Only set if a user already got through it as it should be the old adventure id
    required String? category,
    required bool? featured,
    required String title,
    required String shortDescription,
    required String longDescription,
    required String imageUrl,
    required List<String>? featuredImages,
    required double experience,
    required double latitude,
    required double longitude,
    required int? distance,
    required bool? hasNotified,
    required int? timeInSeconds,
    required DateTime? completedAt,
    required int? hoursToCompleteAgain,
  }) = _Adventure;

  factory Adventure.fromJson(Map<String, dynamic> json) =>
      _$AdventureFromJson(json);
}
