import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

enum BookmarkType {
  quest,
  place,
}

@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String id,
    required BookmarkType type,
    @TimestampConverter() Timestamp? createdAt,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}

class TimestampConverter implements JsonConverter<Timestamp?, Object?> {
  const TimestampConverter();

  @override
  Timestamp? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    return null;
  }

  @override
  Object? toJson(Timestamp? timestamp) {
    return timestamp;
  }
}
