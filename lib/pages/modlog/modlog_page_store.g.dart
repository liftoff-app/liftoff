// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modlog_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ModlogPageStore on _ModlogPageStore, Store {
  Computed<bool>? _$hasPreviousPageComputed;

  @override
  bool get hasPreviousPage =>
      (_$hasPreviousPageComputed ??= Computed<bool>(() => super.hasPreviousPage,
              name: '_ModlogPageStore.hasPreviousPage'))
          .value;
  Computed<bool>? _$hasNextPageComputed;

  @override
  bool get hasNextPage =>
      (_$hasNextPageComputed ??= Computed<bool>(() => super.hasNextPage,
              name: '_ModlogPageStore.hasNextPage'))
          .value;

  late final _$pageAtom = Atom(name: '_ModlogPageStore.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$fetchPageAsyncAction =
      AsyncAction('_ModlogPageStore.fetchPage', context: context);

  @override
  Future<void> fetchPage() {
    return _$fetchPageAsyncAction.run(() => super.fetchPage());
  }

  late final _$_ModlogPageStoreActionController =
      ActionController(name: '_ModlogPageStore', context: context);

  @override
  void previousPage() {
    final _$actionInfo = _$_ModlogPageStoreActionController.startAction(
        name: '_ModlogPageStore.previousPage');
    try {
      return super.previousPage();
    } finally {
      _$_ModlogPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPage() {
    final _$actionInfo = _$_ModlogPageStoreActionController.startAction(
        name: '_ModlogPageStore.nextPage');
    try {
      return super.nextPage();
    } finally {
      _$_ModlogPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
page: ${page},
hasPreviousPage: ${hasPreviousPage},
hasNextPage: ${hasNextPage}
    ''';
  }
}
