// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountsStore _$AccountsStoreFromJson(Map<String, dynamic> json) {
  return AccountsStore()
    ..tokens = (json['tokens'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(
              k,
              (e as Map<String, dynamic>).map(
                (k, e) => MapEntry(k, Jwt.fromJson(e as String)),
              )),
        ) ??
        {'lemmy.ml': {}}
    ..defaultAccounts = (json['defaultAccounts'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, e as String),
        ) ??
        {}
    ..defaultAccount = json['defaultAccount'] as String?;
}

Map<String, dynamic> _$AccountsStoreToJson(AccountsStore instance) =>
    <String, dynamic>{
      'tokens': instance.tokens,
      'defaultAccounts': instance.defaultAccounts,
      'defaultAccount': instance.defaultAccount,
    };
