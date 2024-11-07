import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

enum BookmarkType {
  quest,
  adventure,
}

@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String? id,
    required String entityId,
    required BookmarkType type,
    required String userId,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}
