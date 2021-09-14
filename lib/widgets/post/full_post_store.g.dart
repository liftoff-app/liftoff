// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FullPostStore on _FullPostStore, Store {
  Computed<PostView?>? _$postViewComputed;

  @override
  PostView? get postView =>
      (_$postViewComputed ??= Computed<PostView?>(() => super.postView,
              name: '_FullPostStore.postView'))
          .value;
  Computed<List<CommentView>?>? _$commentsComputed;

  @override
  List<CommentView>? get comments =>
      (_$commentsComputed ??= Computed<List<CommentView>?>(() => super.comments,
              name: '_FullPostStore.comments'))
          .value;

  final _$fullPostViewAtom = Atom(name: '_FullPostStore.fullPostView');

  @override
  FullPostView? get fullPostView {
    _$fullPostViewAtom.reportRead();
    return super.fullPostView;
  }

  @override
  set fullPostView(FullPostView? value) {
    _$fullPostViewAtom.reportWrite(value, super.fullPostView, () {
      super.fullPostView = value;
    });
  }

  final _$newCommentsAtom = Atom(name: '_FullPostStore.newComments');

  @override
  List<CommentView> get newComments {
    _$newCommentsAtom.reportRead();
    return super.newComments;
  }

  @override
  set newComments(List<CommentView> value) {
    _$newCommentsAtom.reportWrite(value, super.newComments, () {
      super.newComments = value;
    });
  }

  final _$postStoreAtom = Atom(name: '_FullPostStore.postStore');

  @override
  PostStore? get postStore {
    _$postStoreAtom.reportRead();
    return super.postStore;
  }

  @override
  set postStore(PostStore? value) {
    _$postStoreAtom.reportWrite(value, super.postStore, () {
      super.postStore = value;
    });
  }

  final _$refreshAsyncAction = AsyncAction('_FullPostStore.refresh');

  @override
  Future<void> refresh([Jwt? token]) {
    return _$refreshAsyncAction.run(() => super.refresh(token));
  }

  final _$blockCommunityAsyncAction =
      AsyncAction('_FullPostStore.blockCommunity');

  @override
  Future<void> blockCommunity(Jwt token) {
    return _$blockCommunityAsyncAction.run(() => super.blockCommunity(token));
  }

  final _$_FullPostStoreActionController =
      ActionController(name: '_FullPostStore');

  @override
  void addComment(CommentView commentView) {
    final _$actionInfo = _$_FullPostStoreActionController.startAction(
        name: '_FullPostStore.addComment');
    try {
      return super.addComment(commentView);
    } finally {
      _$_FullPostStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fullPostView: ${fullPostView},
newComments: ${newComments},
postStore: ${postStore},
postView: ${postView},
comments: ${comments}
    ''';
  }
}
