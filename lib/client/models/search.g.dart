// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search(
    type_: json['type_'] as String,
    comments: (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : CommentView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    posts: (json['posts'] as List)
        ?.map((e) =>
            e == null ? null : PostView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    communities: (json['communities'] as List)
        ?.map((e) => e == null
            ? null
            : CommunityView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    users: (json['users'] as List)
        ?.map((e) =>
            e == null ? null : UserView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
