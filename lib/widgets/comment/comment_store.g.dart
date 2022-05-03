// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CommentStore on _CommentStore, Store {
  Computed<bool>? _$isMineComputed;

  @override
  bool get isMine => (_$isMineComputed ??=
          Computed<bool>(() => super.isMine, name: '_CommentStore.isMine'))
      .value;
  Computed<VoteType>? _$myVoteComputed;

  @override
  VoteType get myVote => (_$myVoteComputed ??=
          Computed<VoteType>(() => super.myVote, name: '_CommentStore.myVote'))
      .value;
  Computed<bool>? _$isOPComputed;

  @override
  bool get isOP => (_$isOPComputed ??=
          Computed<bool>(() => super.isOP, name: '_CommentStore.isOP'))
      .value;

  late final _$commentAtom =
      Atom(name: '_CommentStore.comment', context: context);

  @override
  CommentView get comment {
    _$commentAtom.reportRead();
    return super.comment;
  }

  @override
  set comment(CommentView value) {
    _$commentAtom.reportWrite(value, super.comment, () {
      super.comment = value;
    });
  }

  late final _$selectableAtom =
      Atom(name: '_CommentStore.selectable', context: context);

  @override
  bool get selectable {
    _$selectableAtom.reportRead();
    return super.selectable;
  }

  @override
  set selectable(bool value) {
    _$selectableAtom.reportWrite(value, super.selectable, () {
      super.selectable = value;
    });
  }

  late final _$collapsedAtom =
      Atom(name: '_CommentStore.collapsed', context: context);

  @override
  bool get collapsed {
    _$collapsedAtom.reportRead();
    return super.collapsed;
  }

  @override
  set collapsed(bool value) {
    _$collapsedAtom.reportWrite(value, super.collapsed, () {
      super.collapsed = value;
    });
  }

  late final _$showRawAtom =
      Atom(name: '_CommentStore.showRaw', context: context);

  @override
  bool get showRaw {
    _$showRawAtom.reportRead();
    return super.showRaw;
  }

  @override
  set showRaw(bool value) {
    _$showRawAtom.reportWrite(value, super.showRaw, () {
      super.showRaw = value;
    });
  }

  late final _$reportAsyncAction =
      AsyncAction('_CommentStore.report', context: context);

  @override
  Future<void> report(Jwt token, String reason) {
    return _$reportAsyncAction.run(() => super.report(token, reason));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_CommentStore.delete', context: context);

  @override
  Future<void> delete(Jwt token) {
    return _$deleteAsyncAction.run(() => super.delete(token));
  }

  late final _$saveAsyncAction =
      AsyncAction('_CommentStore.save', context: context);

  @override
  Future<void> save(Jwt token) {
    return _$saveAsyncAction.run(() => super.save(token));
  }

  late final _$blockAsyncAction =
      AsyncAction('_CommentStore.block', context: context);

  @override
  Future<void> block(Jwt token) {
    return _$blockAsyncAction.run(() => super.block(token));
  }

  late final _$markAsReadAsyncAction =
      AsyncAction('_CommentStore.markAsRead', context: context);

  @override
  Future<void> markAsRead(Jwt token) {
    return _$markAsReadAsyncAction.run(() => super.markAsRead(token));
  }

  late final _$_voteAsyncAction =
      AsyncAction('_CommentStore._vote', context: context);

  @override
  Future<void> _vote(VoteType voteType, Jwt token) {
    return _$_voteAsyncAction.run(() => super._vote(voteType, token));
  }

  late final _$upVoteAsyncAction =
      AsyncAction('_CommentStore.upVote', context: context);

  @override
  Future<void> upVote(Jwt token) {
    return _$upVoteAsyncAction.run(() => super.upVote(token));
  }

  late final _$downVoteAsyncAction =
      AsyncAction('_CommentStore.downVote', context: context);

  @override
  Future<void> downVote(Jwt token) {
    return _$downVoteAsyncAction.run(() => super.downVote(token));
  }

  late final _$_CommentStoreActionController =
      ActionController(name: '_CommentStore', context: context);

  @override
  void toggleShowRaw() {
    final _$actionInfo = _$_CommentStoreActionController.startAction(
        name: '_CommentStore.toggleShowRaw');
    try {
      return super.toggleShowRaw();
    } finally {
      _$_CommentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleSelectable() {
    final _$actionInfo = _$_CommentStoreActionController.startAction(
        name: '_CommentStore.toggleSelectable');
    try {
      return super.toggleSelectable();
    } finally {
      _$_CommentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleCollapsed() {
    final _$actionInfo = _$_CommentStoreActionController.startAction(
        name: '_CommentStore.toggleCollapsed');
    try {
      return super.toggleCollapsed();
    } finally {
      _$_CommentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addReply(CommentView commentView) {
    final _$actionInfo = _$_CommentStoreActionController.startAction(
        name: '_CommentStore.addReply');
    try {
      return super.addReply(commentView);
    } finally {
      _$_CommentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
comment: ${comment},
selectable: ${selectable},
collapsed: ${collapsed},
showRaw: ${showRaw},
isMine: ${isMine},
myVote: ${myVote},
isOP: ${isOP}
    ''';
  }
}
