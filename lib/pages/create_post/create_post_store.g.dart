// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreatePostStore on _CreatePostStore, Store {
  final _$showFancyAtom = Atom(name: '_CreatePostStore.showFancy');

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

  final _$instanceHostAtom = Atom(name: '_CreatePostStore.instanceHost');

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

  final _$selectedCommunityAtom =
      Atom(name: '_CreatePostStore.selectedCommunity');

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

  final _$urlAtom = Atom(name: '_CreatePostStore.url');

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

  final _$titleAtom = Atom(name: '_CreatePostStore.title');

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

  final _$bodyAtom = Atom(name: '_CreatePostStore.body');

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

  final _$nsfwAtom = Atom(name: '_CreatePostStore.nsfw');

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

  final _$submitAsyncAction = AsyncAction('_CreatePostStore.submit');

  @override
  Future<void> submit(Jwt token) {
    return _$submitAsyncAction.run(() => super.submit(token));
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
nsfw: ${nsfw}
    ''';
  }
}
