import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

class TimestampConverter implements JsonConverter<Timestamp?, Object?> {
  const TimestampConverter();

  @override
  Timestamp? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    if (json is String) {
      try {
        return Timestamp.fromDate(DateTime.parse(json));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Object? toJson(Timestamp? timestamp) => timestamp;
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    @Default('') String icon,
    @Default('') String interestName,
    @Default(false) bool isActive,
    @Default(false) bool isVisibleInInterests,
    @Default(0) int interestsOrder,
    @Default(0) int placeOrder,
    @Default(0) int level,
    String? parentId,
    @Default([]) List<String> ancestorIds,
    @TimestampConverter() Timestamp? createdAt,
    @TimestampConverter() Timestamp? updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}