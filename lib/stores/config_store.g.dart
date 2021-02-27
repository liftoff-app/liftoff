// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigStore _$ConfigStoreFromJson(Map<String, dynamic> json) {
  return ConfigStore()
    ..theme = _$enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ??
        ThemeMode.system
    ..amoledDarkMode = json['amoledDarkMode'] as bool ?? false
    ..locale = LocaleSerde.fromJson(json['locale'] as String);
}

Map<String, dynamic> _$ConfigStoreToJson(ConfigStore instance) =>
    <String, dynamic>{
      'theme': _$ThemeModeEnumMap[instance.theme],
      'amoledDarkMode': instance.amoledDarkMode,
      'locale': LocaleSerde.toJson(instance.locale),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
