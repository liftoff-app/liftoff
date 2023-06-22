// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigStore _$ConfigStoreFromJson(Map<String, dynamic> json) => ConfigStore()
  ..theme =
      $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ?? ThemeMode.system
  ..amoledDarkMode = json['amoledDarkMode'] as bool? ?? false
  ..locale = const LocaleConverter().fromJson(json['locale'] as String?)
  ..compactPostView = json['compactPostView'] as bool? ?? false
  ..postRoundedCorners = json['postRoundedCorners'] as bool? ?? false
  ..postCardShadow = json['postCardShadow'] as bool? ?? true
  ..showAvatars = json['showAvatars'] as bool? ?? true
  ..showScores = json['showScores'] as bool? ?? true
  ..defaultSortType = _sortTypeFromJson(json['defaultSortType'] as String?)
  ..defaultListingType =
      _postListingTypeFromJson(json['defaultListingType'] as String?);

Map<String, dynamic> _$ConfigStoreToJson(ConfigStore instance) =>
    <String, dynamic>{
      'theme': _$ThemeModeEnumMap[instance.theme]!,
      'amoledDarkMode': instance.amoledDarkMode,
      'locale': const LocaleConverter().toJson(instance.locale),
      'compactPostView': instance.compactPostView,
      'postRoundedCorners': instance.postRoundedCorners,
      'postCardShadow': instance.postCardShadow,
      'showAvatars': instance.showAvatars,
      'showScores': instance.showScores,
      'defaultSortType': instance.defaultSortType,
      'defaultListingType': instance.defaultListingType,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfigStore on _ConfigStore, Store {
  late final _$themeAtom = Atom(name: '_ConfigStore.theme', context: context);

  @override
  ThemeMode get theme {
    _$themeAtom.reportRead();
    return super.theme;
  }

  @override
  set theme(ThemeMode value) {
    _$themeAtom.reportWrite(value, super.theme, () {
      super.theme = value;
    });
  }

  late final _$amoledDarkModeAtom =
      Atom(name: '_ConfigStore.amoledDarkMode', context: context);

  @override
  bool get amoledDarkMode {
    _$amoledDarkModeAtom.reportRead();
    return super.amoledDarkMode;
  }

  @override
  set amoledDarkMode(bool value) {
    _$amoledDarkModeAtom.reportWrite(value, super.amoledDarkMode, () {
      super.amoledDarkMode = value;
    });
  }

  late final _$localeAtom = Atom(name: '_ConfigStore.locale', context: context);

  @override
  Locale get locale {
    _$localeAtom.reportRead();
    return super.locale;
  }

  @override
  set locale(Locale value) {
    _$localeAtom.reportWrite(value, super.locale, () {
      super.locale = value;
    });
  }

  late final _$compactPostViewAtom =
      Atom(name: '_ConfigStore.compactPostView', context: context);

  @override
  bool get compactPostView {
    _$compactPostViewAtom.reportRead();
    return super.compactPostView;
  }

  @override
  set compactPostView(bool value) {
    _$compactPostViewAtom.reportWrite(value, super.compactPostView, () {
      super.compactPostView = value;
    });
  }

  late final _$postRoundedCornersAtom =
      Atom(name: '_ConfigStore.postRoundedCorners', context: context);

  @override
  bool get postRoundedCorners {
    _$postRoundedCornersAtom.reportRead();
    return super.postRoundedCorners;
  }

  @override
  set postRoundedCorners(bool value) {
    _$postRoundedCornersAtom.reportWrite(value, super.postRoundedCorners, () {
      super.postRoundedCorners = value;
    });
  }

  late final _$postCardShadowAtom =
      Atom(name: '_ConfigStore.postCardShadow', context: context);

  @override
  bool get postCardShadow {
    _$postCardShadowAtom.reportRead();
    return super.postCardShadow;
  }

  @override
  set postCardShadow(bool value) {
    _$postCardShadowAtom.reportWrite(value, super.postCardShadow, () {
      super.postCardShadow = value;
    });
  }

  late final _$showAvatarsAtom =
      Atom(name: '_ConfigStore.showAvatars', context: context);

  @override
  bool get showAvatars {
    _$showAvatarsAtom.reportRead();
    return super.showAvatars;
  }

  @override
  set showAvatars(bool value) {
    _$showAvatarsAtom.reportWrite(value, super.showAvatars, () {
      super.showAvatars = value;
    });
  }

  late final _$showScoresAtom =
      Atom(name: '_ConfigStore.showScores', context: context);

  @override
  bool get showScores {
    _$showScoresAtom.reportRead();
    return super.showScores;
  }

  @override
  set showScores(bool value) {
    _$showScoresAtom.reportWrite(value, super.showScores, () {
      super.showScores = value;
    });
  }

  late final _$defaultSortTypeAtom =
      Atom(name: '_ConfigStore.defaultSortType', context: context);

  @override
  SortType get defaultSortType {
    _$defaultSortTypeAtom.reportRead();
    return super.defaultSortType;
  }

  @override
  set defaultSortType(SortType value) {
    _$defaultSortTypeAtom.reportWrite(value, super.defaultSortType, () {
      super.defaultSortType = value;
    });
  }

  late final _$defaultListingTypeAtom =
      Atom(name: '_ConfigStore.defaultListingType', context: context);

  @override
  PostListingType get defaultListingType {
    _$defaultListingTypeAtom.reportRead();
    return super.defaultListingType;
  }

  @override
  set defaultListingType(PostListingType value) {
    _$defaultListingTypeAtom.reportWrite(value, super.defaultListingType, () {
      super.defaultListingType = value;
    });
  }

  late final _$importLemmyUserSettingsAsyncAction =
      AsyncAction('_ConfigStore.importLemmyUserSettings', context: context);

  @override
  Future<void> importLemmyUserSettings(Jwt token) {
    return _$importLemmyUserSettingsAsyncAction
        .run(() => super.importLemmyUserSettings(token));
  }

  late final _$_ConfigStoreActionController =
      ActionController(name: '_ConfigStore', context: context);

  @override
  void copyLemmyUserSettings(LocalUserSettings localUserSettings) {
    final _$actionInfo = _$_ConfigStoreActionController.startAction(
        name: '_ConfigStore.copyLemmyUserSettings');
    try {
      return super.copyLemmyUserSettings(localUserSettings);
    } finally {
      _$_ConfigStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
theme: ${theme},
amoledDarkMode: ${amoledDarkMode},
locale: ${locale},
compactPostView: ${compactPostView},
postRoundedCorners: ${postRoundedCorners},
postCardShadow: ${postCardShadow},
showAvatars: ${showAvatars},
showScores: ${showScores},
defaultSortType: ${defaultSortType},
defaultListingType: ${defaultListingType}
    ''';
  }
}
