// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocks_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

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

  final _$_blockedUsersAtom = Atom(name: '_BlocksStore._blockedUsers');

  @override
  List<UserBlockStore>? get _blockedUsers {
    _$_blockedUsersAtom.reportRead();
    return super._blockedUsers;
  }

  @override
  set _blockedUsers(List<UserBlockStore>? value) {
    _$_blockedUsersAtom.reportWrite(value, super._blockedUsers, () {
      super._blockedUsers = value;
    });
  }

  final _$_blockedCommunitiesAtom =
      Atom(name: '_BlocksStore._blockedCommunities');

  @override
  List<CommunityBlockStore>? get _blockedCommunities {
    _$_blockedCommunitiesAtom.reportRead();
    return super._blockedCommunities;
  }

  @override
  set _blockedCommunities(List<CommunityBlockStore>? value) {
    _$_blockedCommunitiesAtom.reportWrite(value, super._blockedCommunities, () {
      super._blockedCommunities = value;
    });
  }

  final _$refreshAsyncAction = AsyncAction('_BlocksStore.refresh');

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
