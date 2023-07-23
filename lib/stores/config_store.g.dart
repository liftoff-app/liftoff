// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigStore _$ConfigStoreFromJson(Map<String, dynamic> json) => ConfigStore()
  ..disableAnimations = json['disableAnimations'] as bool? ?? false
  ..useInAppBrowser = json['useInAppBrowser'] as bool? ?? true
  ..convertWebpToPng = json['convertWebpToPng'] as bool? ?? false
  ..locale = const LocaleConverter().fromJson(json['locale'] as String?)
  ..compactPostView = json['compactPostView'] as bool? ?? false
  ..postRoundedCornersV2 = json['postRoundedCornersV2'] as bool? ?? false
  ..postCardShadowV2 = json['postCardShadowV2'] as bool? ?? false
  ..showAvatars = json['showAvatars'] as bool? ?? true
  ..showScores = json['showScores'] as bool? ?? true
  ..blurNsfw = json['blurNsfw'] as bool? ?? true
  ..showThumbnail = json['showThumbnail'] as bool? ?? true
  ..autoPlayVideo = json['autoPlayVideo'] as bool? ?? true
  ..autoMuteVideo = json['autoMuteVideo'] as bool? ?? true
  ..titleFontSize = (json['titleFontSize'] as num?)?.toDouble() ?? 16
  ..postHeaderFontSize = (json['postHeaderFontSize'] as num?)?.toDouble() ?? 15
  ..postBodySize = (json['postBodySize'] as num?)?.toDouble() ?? 15
  ..commentTitleSize = (json['commentTitleSize'] as num?)?.toDouble() ?? 15
  ..commentBodySize = (json['commentBodySize'] as num?)?.toDouble() ?? 15
  ..commentIndentWidth = (json['commentIndentWidth'] as num?)?.toDouble() ?? 3
  ..commentPillSize = (json['commentPillSize'] as num?)?.toDouble() ?? 8
  ..commentTimestampSize =
      (json['commentTimestampSize'] as num?)?.toDouble() ?? 14
  ..showEverythingFeed = json['showEverythingFeed'] as bool? ?? false
  ..defaultSortType = _sortTypeFromJson(json['defaultSortType'] as String?)
  ..defaultCommentSort =
      _commentSortTypeFromJson(json['defaultCommentSort'] as String?)
  ..defaultListingType =
      _postListingTypeFromJson(json['defaultListingType'] as String?);

Map<String, dynamic> _$ConfigStoreToJson(ConfigStore instance) =>
    <String, dynamic>{
      'disableAnimations': instance.disableAnimations,
      'useInAppBrowser': instance.useInAppBrowser,
      'convertWebpToPng': instance.convertWebpToPng,
      'locale': const LocaleConverter().toJson(instance.locale),
      'compactPostView': instance.compactPostView,
      'postRoundedCornersV2': instance.postRoundedCornersV2,
      'postCardShadowV2': instance.postCardShadowV2,
      'showAvatars': instance.showAvatars,
      'showScores': instance.showScores,
      'blurNsfw': instance.blurNsfw,
      'showThumbnail': instance.showThumbnail,
      'autoPlayVideo': instance.autoPlayVideo,
      'autoMuteVideo': instance.autoMuteVideo,
      'titleFontSize': instance.titleFontSize,
      'postHeaderFontSize': instance.postHeaderFontSize,
      'postBodySize': instance.postBodySize,
      'commentTitleSize': instance.commentTitleSize,
      'commentBodySize': instance.commentBodySize,
      'commentIndentWidth': instance.commentIndentWidth,
      'commentPillSize': instance.commentPillSize,
      'commentTimestampSize': instance.commentTimestampSize,
      'showEverythingFeed': instance.showEverythingFeed,
      'defaultSortType': instance.defaultSortType,
      'defaultCommentSort': instance.defaultCommentSort,
      'defaultListingType': instance.defaultListingType,
    };

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfigStore on _ConfigStore, Store {
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

  late final _$convertWebpToPngAtom =
      Atom(name: '_ConfigStore.convertWebpToPng', context: context);

  @override
  bool get convertWebpToPng {
    _$convertWebpToPngAtom.reportRead();
    return super.convertWebpToPng;
  }

  @override
  set convertWebpToPng(bool value) {
    _$convertWebpToPngAtom.reportWrite(value, super.convertWebpToPng, () {
      super.convertWebpToPng = value;
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

  late final _$postRoundedCornersV2Atom =
      Atom(name: '_ConfigStore.postRoundedCornersV2', context: context);

  @override
  bool get postRoundedCornersV2 {
    _$postRoundedCornersV2Atom.reportRead();
    return super.postRoundedCornersV2;
  }

  @override
  set postRoundedCornersV2(bool value) {
    _$postRoundedCornersV2Atom.reportWrite(value, super.postRoundedCornersV2,
        () {
      super.postRoundedCornersV2 = value;
    });
  }

  late final _$postCardShadowV2Atom =
      Atom(name: '_ConfigStore.postCardShadowV2', context: context);

  @override
  bool get postCardShadowV2 {
    _$postCardShadowV2Atom.reportRead();
    return super.postCardShadowV2;
  }

  @override
  set postCardShadowV2(bool value) {
    _$postCardShadowV2Atom.reportWrite(value, super.postCardShadowV2, () {
      super.postCardShadowV2 = value;
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

  late final _$autoPlayVideoAtom =
      Atom(name: '_ConfigStore.autoPlayVideo', context: context);

  @override
  bool get autoPlayVideo {
    _$autoPlayVideoAtom.reportRead();
    return super.autoPlayVideo;
  }

  @override
  set autoPlayVideo(bool value) {
    _$autoPlayVideoAtom.reportWrite(value, super.autoPlayVideo, () {
      super.autoPlayVideo = value;
    });
  }

  late final _$autoMuteVideoAtom =
      Atom(name: '_ConfigStore.autoMuteVideo', context: context);

  @override
  bool get autoMuteVideo {
    _$autoMuteVideoAtom.reportRead();
    return super.autoMuteVideo;
  }

  @override
  set autoMuteVideo(bool value) {
    _$autoMuteVideoAtom.reportWrite(value, super.autoMuteVideo, () {
      super.autoMuteVideo = value;
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

  late final _$postBodySizeAtom =
      Atom(name: '_ConfigStore.postBodySize', context: context);

  @override
  double get postBodySize {
    _$postBodySizeAtom.reportRead();
    return super.postBodySize;
  }

  @override
  set postBodySize(double value) {
    _$postBodySizeAtom.reportWrite(value, super.postBodySize, () {
      super.postBodySize = value;
    });
  }

  late final _$commentTitleSizeAtom =
      Atom(name: '_ConfigStore.commentTitleSize', context: context);

  @override
  double get commentTitleSize {
    _$commentTitleSizeAtom.reportRead();
    return super.commentTitleSize;
  }

  @override
  set commentTitleSize(double value) {
    _$commentTitleSizeAtom.reportWrite(value, super.commentTitleSize, () {
      super.commentTitleSize = value;
    });
  }

  late final _$commentBodySizeAtom =
      Atom(name: '_ConfigStore.commentBodySize', context: context);

  @override
  double get commentBodySize {
    _$commentBodySizeAtom.reportRead();
    return super.commentBodySize;
  }

  @override
  set commentBodySize(double value) {
    _$commentBodySizeAtom.reportWrite(value, super.commentBodySize, () {
      super.commentBodySize = value;
    });
  }

  late final _$commentIndentWidthAtom =
      Atom(name: '_ConfigStore.commentIndentWidth', context: context);

  @override
  double get commentIndentWidth {
    _$commentIndentWidthAtom.reportRead();
    return super.commentIndentWidth;
  }

  @override
  set commentIndentWidth(double value) {
    _$commentIndentWidthAtom.reportWrite(value, super.commentIndentWidth, () {
      super.commentIndentWidth = value;
    });
  }

  late final _$commentPillSizeAtom =
      Atom(name: '_ConfigStore.commentPillSize', context: context);

  @override
  double get commentPillSize {
    _$commentPillSizeAtom.reportRead();
    return super.commentPillSize;
  }

  @override
  set commentPillSize(double value) {
    _$commentPillSizeAtom.reportWrite(value, super.commentPillSize, () {
      super.commentPillSize = value;
    });
  }

  late final _$commentTimestampSizeAtom =
      Atom(name: '_ConfigStore.commentTimestampSize', context: context);

  @override
  double get commentTimestampSize {
    _$commentTimestampSizeAtom.reportRead();
    return super.commentTimestampSize;
  }

  @override
  set commentTimestampSize(double value) {
    _$commentTimestampSizeAtom.reportWrite(value, super.commentTimestampSize,
        () {
      super.commentTimestampSize = value;
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

  late final _$defaultCommentSortAtom =
      Atom(name: '_ConfigStore.defaultCommentSort', context: context);

  @override
  CommentSortType get defaultCommentSort {
    _$defaultCommentSortAtom.reportRead();
    return super.defaultCommentSort;
  }

  @override
  set defaultCommentSort(CommentSortType value) {
    _$defaultCommentSortAtom.reportWrite(value, super.defaultCommentSort, () {
      super.defaultCommentSort = value;
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
disableAnimations: ${disableAnimations},
useInAppBrowser: ${useInAppBrowser},
convertWebpToPng: ${convertWebpToPng},
locale: ${locale},
compactPostView: ${compactPostView},
postRoundedCornersV2: ${postRoundedCornersV2},
postCardShadowV2: ${postCardShadowV2},
showAvatars: ${showAvatars},
showScores: ${showScores},
blurNsfw: ${blurNsfw},
showThumbnail: ${showThumbnail},
autoPlayVideo: ${autoPlayVideo},
autoMuteVideo: ${autoMuteVideo},
titleFontSize: ${titleFontSize},
postHeaderFontSize: ${postHeaderFontSize},
postBodySize: ${postBodySize},
commentTitleSize: ${commentTitleSize},
commentBodySize: ${commentBodySize},
commentIndentWidth: ${commentIndentWidth},
commentPillSize: ${commentPillSize},
commentTimestampSize: ${commentTimestampSize},
showEverythingFeed: ${showEverythingFeed},
defaultSortType: ${defaultSortType},
defaultCommentSort: ${defaultCommentSort},
defaultListingType: ${defaultListingType}
    ''';
  }
}
