// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigStore _$ConfigStoreFromJson(Map<String, dynamic> json) => ConfigStore()
  ..theme =
      $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ?? ThemeMode.system
  ..amoledDarkMode = json['amoledDarkMode'] as bool? ?? false
  ..disableAnimations = json['disableAnimations'] as bool? ?? false
  ..useInAppBrowser = json['useInAppBrowser'] as bool? ?? true
  ..locale = const LocaleConverter().fromJson(json['locale'] as String?)
  ..compactPostView = json['compactPostView'] as bool? ?? false
  ..postRoundedCorners = json['postRoundedCorners'] as bool? ?? true
  ..postCardShadow = json['postCardShadow'] as bool? ?? true
  ..showAvatars = json['showAvatars'] as bool? ?? true
  ..showScores = json['showScores'] as bool? ?? true
  ..blurNsfw = json['blurNsfw'] as bool? ?? true
  ..showThumbnail = json['showThumbnail'] as bool? ?? true
  ..titleFontSize = (json['titleFontSize'] as num?)?.toDouble() ?? 16
  ..postHeaderFontSize = (json['postHeaderFontSize'] as num?)?.toDouble() ?? 15
  ..showEverythingFeed = json['showEverythingFeed'] as bool? ?? false
  ..defaultSortType = _sortTypeFromJson(json['defaultSortType'] as String?)
  ..defaultListingType =
      _postListingTypeFromJson(json['defaultListingType'] as String?);

Map<String, dynamic> _$ConfigStoreToJson(ConfigStore instance) =>
    <String, dynamic>{
      'theme': _$ThemeModeEnumMap[instance.theme]!,
      'amoledDarkMode': instance.amoledDarkMode,
      'disableAnimations': instance.disableAnimations,
      'useInAppBrowser': instance.useInAppBrowser,
      'locale': const LocaleConverter().toJson(instance.locale),
      'compactPostView': instance.compactPostView,
      'postRoundedCorners': instance.postRoundedCorners,
      'postCardShadow': instance.postCardShadow,
      'showAvatars': instance.showAvatars,
      'showScores': instance.showScores,
      'blurNsfw': instance.blurNsfw,
      'showThumbnail': instance.showThumbnail,
      'titleFontSize': instance.titleFontSize,
      'postHeaderFontSize': instance.postHeaderFontSize,
      'showEverythingFeed': instance.showEverythingFeed,
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

  late final _$disableAnimationsAtom =
      Atom(name: '_ConfigStore.disableAnimations', context: context);

  @override
  bool get disableAnimations {
    _$disableAnimationsAtom.reportRead();
    return super.disableAnimations;
  }

  @override
  set disableAnimations(bool value) {
    _$disableAnimationsAtom.reportWrite(value, super.disableAnimations, () {
      super.disableAnimations = value;
    });
  }

  late final _$useInAppBrowserAtom =
      Atom(name: '_ConfigStore.useInAppBrowser', context: context);

  @override
  bool get useInAppBrowser {
    _$useInAppBrowserAtom.reportRead();
    return super.useInAppBrowser;
  }

  @override
  set useInAppBrowser(bool value) {
    _$useInAppBrowserAtom.reportWrite(value, super.useInAppBrowser, () {
      super.useInAppBrowser = value;
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

  late final _$blurNsfwAtom =
      Atom(name: '_ConfigStore.blurNsfw', context: context);

  @override
  bool get blurNsfw {
    _$blurNsfwAtom.reportRead();
    return super.blurNsfw;
  }

  @override
  set blurNsfw(bool value) {
    _$blurNsfwAtom.reportWrite(value, super.blurNsfw, () {
      super.blurNsfw = value;
    });
  }

  late final _$showThumbnailAtom =
      Atom(name: '_ConfigStore.showThumbnail', context: context);

  @override
  bool get showThumbnail {
    _$showThumbnailAtom.reportRead();
    return super.showThumbnail;
  }

  @override
  set showThumbnail(bool value) {
    _$showThumbnailAtom.reportWrite(value, super.showThumbnail, () {
      super.showThumbnail = value;
    });
  }

  late final _$titleFontSizeAtom =
      Atom(name: '_ConfigStore.titleFontSize', context: context);

  @override
  double get titleFontSize {
    _$titleFontSizeAtom.reportRead();
    return super.titleFontSize;
  }

  @override
  set titleFontSize(double value) {
    _$titleFontSizeAtom.reportWrite(value, super.titleFontSize, () {
      super.titleFontSize = value;
    });
  }

  late final _$postHeaderFontSizeAtom =
      Atom(name: '_ConfigStore.postHeaderFontSize', context: context);

  @override
  double get postHeaderFontSize {
    _$postHeaderFontSizeAtom.reportRead();
    return super.postHeaderFontSize;
  }

  @override
  set postHeaderFontSize(double value) {
    _$postHeaderFontSizeAtom.reportWrite(value, super.postHeaderFontSize, () {
      super.postHeaderFontSize = value;
    });
  }

  late final _$showEverythingFeedAtom =
      Atom(name: '_ConfigStore.showEverythingFeed', context: context);

  @override
  bool get showEverythingFeed {
    _$showEverythingFeedAtom.reportRead();
    return super.showEverythingFeed;
  }

  @override
  set showEverythingFeed(bool value) {
    _$showEverythingFeedAtom.reportWrite(value, super.showEverythingFeed, () {
      super.showEverythingFeed = value;
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
disableAnimations: ${disableAnimations},
useInAppBrowser: ${useInAppBrowser},
locale: ${locale},
compactPostView: ${compactPostView},
postRoundedCorners: ${postRoundedCorners},
postCardShadow: ${postCardShadow},
showAvatars: ${showAvatars},
showScores: ${showScores},
blurNsfw: ${blurNsfw},
showThumbnail: ${showThumbnail},
titleFontSize: ${titleFontSize},
postHeaderFontSize: ${postHeaderFontSize},
showEverythingFeed: ${showEverythingFeed},
defaultSortType: ${defaultSortType},
defaultListingType: ${defaultListingType}
    ''';
  }
}
