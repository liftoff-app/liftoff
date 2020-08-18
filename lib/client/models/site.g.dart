// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiteView _$SiteViewFromJson(Map<String, dynamic> json) {
  return SiteView(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    creatorId: json['creator_id'] as int,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    enableDownvotes: json['enable_downvotes'] as bool,
    openRegistration: json['open_registration'] as bool,
    enableNsfw: json['enable_nsfw'] as bool,
    icon: json['icon'] as String,
    banner: json['banner'] as String,
    creatorName: json['creator_name'] as String,
    creatorPreferredUsername: json['creator_preferred_username'] as String,
    creatorAvatar: json['creator_avatar'] as String,
    numberOfUsers: json['number_of_users'] as int,
    numberOfPosts: json['number_of_posts'] as int,
    numberOfComments: json['number_of_comments'] as int,
    numberOfCommunities: json['number_of_communities'] as int,
  );
}

FullSiteView _$FullSiteViewFromJson(Map<String, dynamic> json) {
  return FullSiteView(
    site: json['site'] == null
        ? null
        : SiteView.fromJson(json['site'] as Map<String, dynamic>),
    admins: (json['admins'] as List)
        ?.map((e) =>
            e == null ? null : UserView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    banned: (json['banned'] as List)
        ?.map((e) =>
            e == null ? null : UserView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    online: json['online'] as int,
    version: json['version'] as String,
    myUser: json['my_user'] == null
        ? null
        : UserView.fromJson(json['my_user'] as Map<String, dynamic>),
  );
}
