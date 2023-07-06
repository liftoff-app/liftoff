// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountsStore _$AccountsStoreFromJson(Map<String, dynamic> json) =>
    AccountsStore()
      ..accounts = (json['accounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as Map<String, dynamic>).map(
                  (k, e) =>
                      MapEntry(k, UserData.fromJson(e as Map<String, dynamic>)),
                )),
          ) ??
          {'lemmy.world': {}}
      ..defaultAccounts =
          (json['defaultAccounts'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              {}
      ..defaultAccount = json['defaultAccount'] as String?
      ..notificationCount = json['notificationCount'] as int;

Map<String, dynamic> _$AccountsStoreToJson(AccountsStore instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'defaultAccounts': instance.defaultAccounts,
      'defaultAccount': instance.defaultAccount,
      'notificationCount': instance.notificationCount,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      jwt: Jwt.fromJson(json['jwt'] as String),
      userId: json['userId'] as int,
      username: json['username'] as String,
      instanceHost: json['instanceHost'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'jwt': instance.jwt,
      'userId': instance.userId,
      'username': instance.username,
      'instanceHost': instance.instanceHost,
    };
