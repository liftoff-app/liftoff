// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InboxStore on _InboxStore, Store {
  late final _$fetchNotificationsAsyncAction =
      AsyncAction('_InboxStore.fetchNotifications', context: context);

  @override
  Future<void> fetchNotifications(Jwt token, {bool refresh = false}) {
    return _$fetchNotificationsAsyncAction
        .run(() => super.fetchNotifications(token, refresh: refresh));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
