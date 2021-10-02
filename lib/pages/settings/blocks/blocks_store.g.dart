// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocks_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BlocksStore on _BlocksStore, Store {
  final _$blockUserAsyncAction = AsyncAction('_BlocksStore.blockUser');

  @override
  Future<void> blockUser(int id) {
    return _$blockUserAsyncAction.run(() => super.blockUser(id));
  }

  final _$blockCommunityAsyncAction =
      AsyncAction('_BlocksStore.blockCommunity');

  @override
  Future<void> blockCommunity(int id) {
    return _$blockCommunityAsyncAction.run(() => super.blockCommunity(id));
  }

  final _$refreshAsyncAction = AsyncAction('_BlocksStore.refresh');

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  final _$_BlocksStoreActionController = ActionController(name: '_BlocksStore');

  @override
  void userUnblocked(int id) {
    final _$actionInfo = _$_BlocksStoreActionController.startAction(
        name: '_BlocksStore.userUnblocked');
    try {
      return super.userUnblocked(id);
    } finally {
      _$_BlocksStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void communityUnblocked(int id) {
    final _$actionInfo = _$_BlocksStoreActionController.startAction(
        name: '_BlocksStore.communityUnblocked');
    try {
      return super.communityUnblocked(id);
    } finally {
      _$_BlocksStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
