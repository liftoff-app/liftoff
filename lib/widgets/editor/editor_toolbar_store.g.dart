// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_toolbar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditorToolbarStore on _EditorToolbarStore, Store {
  Computed<bool>? _$hasUploadedImageComputed;

  @override
  bool get hasUploadedImage => (_$hasUploadedImageComputed ??= Computed<bool>(
          () => super.hasUploadedImage,
          name: '_EditorToolbarStore.hasUploadedImage'))
      .value;

  late final _$urlAtom =
      Atom(name: '_EditorToolbarStore.url', context: context);

  @override
  String? get url {
    _$urlAtom.reportRead();
    return super.url;
  }

  @override
  set url(String? value) {
    _$urlAtom.reportWrite(value, super.url, () {
      super.url = value;
    });
  }

  late final _$uploadImageAsyncAction =
      AsyncAction('_EditorToolbarStore.uploadImage', context: context);

  @override
  Future<String?> uploadImage(String filePath, UserData userData) {
    return _$uploadImageAsyncAction
        .run(() => super.uploadImage(filePath, userData));
  }

  late final _$_EditorToolbarStoreActionController =
      ActionController(name: '_EditorToolbarStore', context: context);

  @override
  void removeImage() {
    final _$actionInfo = _$_EditorToolbarStoreActionController.startAction(
        name: '_EditorToolbarStore.removeImage');
    try {
      return super.removeImage();
    } finally {
      _$_EditorToolbarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
url: ${url},
hasUploadedImage: ${hasUploadedImage}
    ''';
  }
}
