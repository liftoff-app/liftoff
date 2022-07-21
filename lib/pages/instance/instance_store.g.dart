// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$InstanceStore on _InstanceStore, Store {
  late final _$fetchAsyncAction =
      AsyncAction('_InstanceStore.fetch', context: context);

  @override
  Future<void> fetch(Jwt? token, {bool refresh = false}) {
    return _$fetchAsyncAction.run(() => super.fetch(token, refresh: refresh));
  }

  late final _$fetchCommunitesAsyncAction =
      AsyncAction('_InstanceStore.fetchCommunites', context: context);

  @override
  Future<void> fetchCommunites(Jwt? token, {bool refresh = false}) {
    return _$fetchCommunitesAsyncAction
        .run(() => super.fetchCommunites(token, refresh: refresh));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
