// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

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

  late final _$postViewAtom =
      Atom(name: '_PostStore.postView', context: context);

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

  late final _$newCommentsAtom =
      Atom(name: '_PostStore.newComments', context: context);

  @override
  ObservableList<CommentView> get newComments {
    _$newCommentsAtom.reportRead();
    return super.newComments;
  }

  @override
  set newComments(ObservableList<CommentView> value) {
    _$newCommentsAtom.reportWrite(value, super.newComments, () {
      super.newComments = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_PostStore.save', context: context);

  @override
  Future<void> save(UserData userData) {
    return _$saveAsyncAction.run(() => super.save(userData));
  }

  late final _$reportAsyncAction =
      AsyncAction('_PostStore.report', context: context);

  @override
  Future<void> report(UserData userData, String reason) {
    return _$reportAsyncAction.run(() => super.report(userData, reason));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_PostStore.delete', context: context);

  @override
  Future<void> delete(UserData userData) {
    return _$deleteAsyncAction.run(() => super.delete(userData));
  }

  late final _$blockUserAsyncAction =
      AsyncAction('_PostStore.blockUser', context: context);

  @override
  Future<void> blockUser(UserData userData) {
    return _$blockUserAsyncAction.run(() => super.blockUser(userData));
  }

  late final _$blockCommunityAsyncAction =
      AsyncAction('_PostStore.blockCommunity', context: context);

  @override
  Future<void> blockCommunity(UserData userData) {
    return _$blockCommunityAsyncAction
        .run(() => super.blockCommunity(userData));
  }

  late final _$_voteAsyncAction =
      AsyncAction('_PostStore._vote', context: context);

  @override
  Future<void> _vote(UserData userData, VoteType voteType) {
    return _$_voteAsyncAction.run(() => super._vote(userData, voteType));
  }

  late final _$_PostStoreActionController =
      ActionController(name: '_PostStore', context: context);

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
  Future<void> upVote(UserData userData) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.upVote');
    try {
      return super.upVote(userData);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<void> downVote(UserData userData) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.downVote');
    try {
      return super.downVote(userData);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addComment(CommentView commentView) {
    final _$actionInfo =
        _$_PostStoreActionController.startAction(name: '_PostStore.addComment');
    try {
      return super.addComment(commentView);
    } finally {
      _$_PostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
postView: ${postView},
newComments: ${newComments},
urlDomain: ${urlDomain},
hasMedia: ${hasMedia}
    ''';
  }
}
