// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocks_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BlocksStore on _BlocksStore, Store {
  Computed<Iterable<UserBlockStore>?>? _$blockedUsersComputed;

  @override
  Iterable<UserBlockStore>? get blockedUsers => (_$blockedUsersComputed ??=
          Computed<Iterable<UserBlockStore>?>(() => super.blockedUsers,
              name: '_BlocksStore.blockedUsers'))
      .value;
  Computed<Iterable<CommunityBlockStore>?>? _$blockedCommunitiesComputed;

  @override
  Iterable<CommunityBlockStore>? get blockedCommunities =>
      (_$blockedCommunitiesComputed ??=
              Computed<Iterable<CommunityBlockStore>?>(
                  () => super.blockedCommunities,
                  name: '_BlocksStore.blockedCommunities'))
          .value;
  Computed<bool>? _$isUsableComputed;

  @override
  bool get isUsable => (_$isUsableComputed ??=
          Computed<bool>(() => super.isUsable, name: '_BlocksStore.isUsable'))
      .value;

  late final _$_blockedUsersAtom =
      Atom(name: '_BlocksStore._blockedUsers', context: context);

  @override
  ObservableList<UserBlockStore>? get _blockedUsers {
    _$_blockedUsersAtom.reportRead();
    return super._blockedUsers;
  }

  @override
  set _blockedUsers(ObservableList<UserBlockStore>? value) {
    _$_blockedUsersAtom.reportWrite(value, super._blockedUsers, () {
      super._blockedUsers = value;
    });
  }

  late final _$_blockedCommunitiesAtom =
      Atom(name: '_BlocksStore._blockedCommunities', context: context);

  @override
  ObservableList<CommunityBlockStore>? get _blockedCommunities {
    _$_blockedCommunitiesAtom.reportRead();
    return super._blockedCommunities;
  }

  @override
  set _blockedCommunities(ObservableList<CommunityBlockStore>? value) {
    _$_blockedCommunitiesAtom.reportWrite(value, super._blockedCommunities, () {
      super._blockedCommunities = value;
    });
  }

  late final _$blockUserAsyncAction =
      AsyncAction('_BlocksStore.blockUser', context: context);

  @override
  Future<void> blockUser(UserData userData, int id) {
    return _$blockUserAsyncAction.run(() => super.blockUser(userData, id));
  }

  late final _$blockCommunityAsyncAction =
      AsyncAction('_BlocksStore.blockCommunity', context: context);

  @override
  Future<void> blockCommunity(UserData userData, int id) {
    return _$blockCommunityAsyncAction
        .run(() => super.blockCommunity(userData, id));
  }

  late final _$refreshAsyncAction =
      AsyncAction('_BlocksStore.refresh', context: context);

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
blockedUsers: ${blockedUsers},
blockedCommunities: ${blockedCommunities},
isUsable: ${isUsable}
    ''';
  }
}
