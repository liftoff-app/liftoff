// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigStore _$ConfigStoreFromJson(Map<String, dynamic> json) => ConfigStore()
  ..theme = _$enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ??
      ThemeMode.system
  ..amoledDarkMode = json['amoledDarkMode'] as bool? ?? false
  ..locale = LocaleSerde.fromJson(json['locale'] as String?)
  ..showAvatars = json['showAvatars'] as bool? ?? true
  ..showScores = json['showScores'] as bool? ?? true
  ..defaultSortType = _sortTypeFromJson(json['defaultSortType'] as String?)
  ..defaultListingType =
      _postListingTypeFromJson(json['defaultListingType'] as String?);

Map<String, dynamic> _$ConfigStoreToJson(ConfigStore instance) =>
    <String, dynamic>{
      'theme': _$ThemeModeEnumMap[instance.theme],
      'amoledDarkMode': instance.amoledDarkMode,
      'locale': LocaleSerde.toJson(instance.locale),
      'showAvatars': instance.showAvatars,
      'showScores': instance.showScores,
      'defaultSortType': instance.defaultSortType,
      'defaultListingType': instance.defaultListingType,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
