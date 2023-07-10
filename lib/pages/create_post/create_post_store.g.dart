// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreatePostStore on _CreatePostStore, Store {
  Computed<bool>? _$hasUploadedImageComputed;

  @override
  bool get hasUploadedImage => (_$hasUploadedImageComputed ??= Computed<bool>(
          () => super.hasUploadedImage,
          name: '_CreatePostStore.hasUploadedImage'))
      .value;

  late final _$showFancyAtom =
      Atom(name: '_CreatePostStore.showFancy', context: context);

  @override
  bool get showFancy {
    _$showFancyAtom.reportRead();
    return super.showFancy;
  }

  @override
  set showFancy(bool value) {
    _$showFancyAtom.reportWrite(value, super.showFancy, () {
      super.showFancy = value;
    });
  }

  late final _$instanceHostAtom =
      Atom(name: '_CreatePostStore.instanceHost', context: context);

  @override
  String get instanceHost {
    _$instanceHostAtom.reportRead();
    return super.instanceHost;
  }

  @override
  set instanceHost(String value) {
    _$instanceHostAtom.reportWrite(value, super.instanceHost, () {
      super.instanceHost = value;
    });
  }

  late final _$selectedCommunityAtom =
      Atom(name: '_CreatePostStore.selectedCommunity', context: context);

  @override
  CommunityView? get selectedCommunity {
    _$selectedCommunityAtom.reportRead();
    return super.selectedCommunity;
  }

  @override
  set selectedCommunity(CommunityView? value) {
    _$selectedCommunityAtom.reportWrite(value, super.selectedCommunity, () {
      super.selectedCommunity = value;
    });
  }

  late final _$urlAtom = Atom(name: '_CreatePostStore.url', context: context);

  @override
  String get url {
    _$urlAtom.reportRead();
    return super.url;
  }

  @override
  set url(String value) {
    _$urlAtom.reportWrite(value, super.url, () {
      super.url = value;
    });
  }

  late final _$titleAtom =
      Atom(name: '_CreatePostStore.title', context: context);

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$bodyAtom = Atom(name: '_CreatePostStore.body', context: context);

  @override
  String get body {
    _$bodyAtom.reportRead();
    return super.body;
  }

  @override
  set body(String value) {
    _$bodyAtom.reportWrite(value, super.body, () {
      super.body = value;
    });
  }

  late final _$nsfwAtom = Atom(name: '_CreatePostStore.nsfw', context: context);

  @override
  bool get nsfw {
    _$nsfwAtom.reportRead();
    return super.nsfw;
  }

  @override
  set nsfw(bool value) {
    _$nsfwAtom.reportWrite(value, super.nsfw, () {
      super.nsfw = value;
    });
  }

  late final _$submitAsyncAction =
      AsyncAction('_CreatePostStore.submit', context: context);

  @override
  Future<void> submit(UserData token) {
    return _$submitAsyncAction.run(() => super.submit(token));
  }

  late final _$uploadImageAsyncAction =
      AsyncAction('_CreatePostStore.uploadImage', context: context);

  @override
  Future<void> uploadImage(String filePath, UserData userData) {
    return _$uploadImageAsyncAction
        .run(() => super.uploadImage(filePath, userData));
  }

  late final _$_CreatePostStoreActionController =
      ActionController(name: '_CreatePostStore', context: context);

  @override
  Future<List<CommunityView>?> searchCommunities(
      String searchTerm, UserData? userData) {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.searchCommunities');
    try {
      return super.searchCommunities(searchTerm, userData);
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeImage() {
    final _$actionInfo = _$_CreatePostStoreActionController.startAction(
        name: '_CreatePostStore.removeImage');
    try {
      return super.removeImage();
    } finally {
      _$_CreatePostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showFancy: ${showFancy},
instanceHost: ${instanceHost},
selectedCommunity: ${selectedCommunity},
url: ${url},
title: ${title},
body: ${body},
nsfw: ${nsfw},
hasUploadedImage: ${hasUploadedImage}
    ''';
  }
}
