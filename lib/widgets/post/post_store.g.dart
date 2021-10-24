// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PostStore on _PostStore, Store {
  Computed<String?>? _$urlDomainComputed;

  @override
  String? get urlDomain =>
      (_$urlDomainComputed ??= Computed<String?>(() => super.urlDomain,
              name: '_PostStore.urlDomain'))
          .value;
  Computed<bool>? _$hasMediaComputed;

  @override
  bool get hasMedia => (_$hasMediaComputed ??=
          Computed<bool>(() => super.hasMedia, name: '_PostStore.hasMedia'))
      .value;

  final _$postViewAtom = Atom(name: '_PostStore.postView');

  @override
  PostView get postView {
    _$postViewAtom.reportRead();
    return super.postView;
  }

  @override
  set postView(PostView value) {
    _$postViewAtom.reportWrite(value, super.postView, () {
      super.postView = value;
    });
  }

  final _$saveAsyncAction = AsyncAction('_PostStore.save');

  @override
  Future<void> save(Jwt token) {
    return _$saveAsyncAction.run(() => super.save(token));
  }

  final _$reportAsyncAction = AsyncAction('_PostStore.report');

  @override
  Future<void> report(Jwt token, String reason) {
    return _$reportAsyncAction.run(() => super.report(token, reason));
  }

  final _$blockUserAsyncAction = AsyncAction('_PostStore.blockUser');

  @override
  Future<void> blockUser(Jwt token) {
    return _$blockUserAsyncAction.run(() => super.blockUser(token));
  }

  final _$_voteAsyncAction = AsyncAction('_PostStore._vote');

  @override
  Future<void> _vote(Jwt token, VoteType voteType) {
    return _$_voteAsyncAction.run(() => super._vote(token, voteType));
  }

  final _$_PostStoreActionController = ActionController(name: '_PostStore');

  @override
  void updatePostView(PostView postView) {
    final _$actionInfo = _$_PostStoreActionController.startAction(
        name: '_PostStore.updatePostView');
    try {
      return super.updatePostView(postView);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> upVote(Jwt token) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.upVote');
    try {
      return super.upVote(token);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> downVote(Jwt token) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.downVote');
    try {
      return super.downVote(token);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
postView: ${postView},
urlDomain: ${urlDomain},
hasMedia: ${hasMedia}
    ''';
  }
}
