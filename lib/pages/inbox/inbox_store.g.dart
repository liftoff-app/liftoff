// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InboxStore on _InboxStore, Store {
  late final _$notificationCountAtom =
      Atom(name: '_InboxStore.notificationCount', context: context);

  @override
  int? get notificationCount {
    _$notificationCountAtom.reportRead();
    return super.notificationCount;
  }

  @override
  set notificationCount(int? value) {
    _$notificationCountAtom.reportWrite(value, super.notificationCount, () {
      super.notificationCount = value;
    });
  }

  late final _$refreshAsyncAction =
      AsyncAction('_InboxStore.refresh', context: context);

  @override
  Future<void> refresh(UserData? userData) {
    return _$refreshAsyncAction.run(() => super.refresh(userData));
  }

  late final _$fetchNotificationsAsyncAction =
      AsyncAction('_InboxStore.fetchNotifications', context: context);

  @override
  Future<void> fetchNotifications(UserData? userData) {
    return _$fetchNotificationsAsyncAction
        .run(() => super.fetchNotifications(userData));
  }

  @override
  String toString() {
    return '''
notificationCount: ${notificationCount}
    ''';
  }
}
