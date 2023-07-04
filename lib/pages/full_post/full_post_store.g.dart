// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_post_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FullPostStore on _FullPostStore, Store {
  Computed<List<CommentTree>?>? _$commentTreeComputed;

  @override
  List<CommentTree>? get commentTree => (_$commentTreeComputed ??=
          Computed<List<CommentTree>?>(() => super.commentTree,
              name: '_FullPostStore.commentTree'))
      .value;
  Computed<List<CommentTree>?>? _$sortedCommentTreeComputed;

  @override
  List<CommentTree>? get sortedCommentTree => (_$sortedCommentTreeComputed ??=
          Computed<List<CommentTree>?>(() => super.sortedCommentTree,
              name: '_FullPostStore.sortedCommentTree'))
      .value;
  Computed<PostView?>? _$postViewComputed;

  @override
  PostView? get postView =>
      (_$postViewComputed ??= Computed<PostView?>(() => super.postView,
              name: '_FullPostStore.postView'))
          .value;
  Computed<Iterable<CommentView>?>? _$commentsComputed;

  @override
  Iterable<CommentView>? get comments => (_$commentsComputed ??=
          Computed<Iterable<CommentView>?>(() => super.comments,
              name: '_FullPostStore.comments'))
      .value;

  late final _$fullPostViewAtom =
      Atom(name: '_FullPostStore.fullPostView', context: context);

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

  late final _$postCommentsAtom =
      Atom(name: '_FullPostStore.postComments', context: context);

  @override
  List<CommentView>? get postComments {
    _$postCommentsAtom.reportRead();
    return super.postComments;
  }

  @override
  set postComments(List<CommentView>? value) {
    _$postCommentsAtom.reportWrite(value, super.postComments, () {
      super.postComments = value;
    });
  }

  late final _$pinnedCommentsAtom =
      Atom(name: '_FullPostStore.pinnedComments', context: context);

  @override
  List<CommentView>? get pinnedComments {
    _$pinnedCommentsAtom.reportRead();
    return super.pinnedComments;
  }

  @override
  set pinnedComments(List<CommentView>? value) {
    _$pinnedCommentsAtom.reportWrite(value, super.pinnedComments, () {
      super.pinnedComments = value;
    });
  }

  late final _$newCommentsAtom =
      Atom(name: '_FullPostStore.newComments', context: context);

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

  late final _$sortingAtom =
      Atom(name: '_FullPostStore.sorting', context: context);

  @override
  CommentSortType get sorting {
    _$sortingAtom.reportRead();
    return super.sorting;
  }

  @override
  set sorting(CommentSortType value) {
    _$sortingAtom.reportWrite(value, super.sorting, () {
      super.sorting = value;
    });
  }

  late final _$postStoreAtom =
      Atom(name: '_FullPostStore.postStore', context: context);

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

  late final _$refreshAsyncAction =
      AsyncAction('_FullPostStore.refresh', context: context);

  @override
  Future<void> refresh([UserData? userData]) {
    return _$refreshAsyncAction.run(() => super.refresh(userData));
  }

  late final _$blockCommunityAsyncAction =
      AsyncAction('_FullPostStore.blockCommunity', context: context);

  @override
  Future<void> blockCommunity(UserData userData) {
    return _$blockCommunityAsyncAction
        .run(() => super.blockCommunity(userData));
  }

  late final _$_FullPostStoreActionController =
      ActionController(name: '_FullPostStore', context: context);

  @override
  void updateSorting(CommentSortType sort) {
    final _$actionInfo = _$_FullPostStoreActionController.startAction(
        name: '_FullPostStore.updateSorting');
    try {
      return super.updateSorting(sort);
    } finally {
      _$_FullPostStoreActionController.endAction(_$actionInfo);
    }
  }

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
postComments: ${postComments},
pinnedComments: ${pinnedComments},
newComments: ${newComments},
sorting: ${sorting},
postStore: ${postStore},
commentTree: ${commentTree},
sortedCommentTree: ${sortedCommentTree},
postView: ${postView},
comments: ${comments}
    ''';
  }
}
