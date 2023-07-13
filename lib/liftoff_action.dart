import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import 'stores/accounts_store.dart';
import 'widgets/comment/comment_store.dart';
import 'widgets/post/post_store.dart';

/// An action that can be performed on a post or comment.
/// It is used to build the action buttons in the UI, as
/// swipe actions in a post/comment list.
///
/// They are currently instantiated using their constructors
/// directly, but in the future they will be user configurable.
@immutable
abstract class LiftoffAction {
  /// The name of the action, e.g. "Upvote".
  String get name;

  /// The tooltip of the action, e.g. "upvote".
  String get tooltip;

  /// The icon of the action, e.g. Icons.arrow_upward.
  IconData get icon;

  /// The color of the action.
  /// This is used to color background of the action button, as
  /// well as the area behind the post/comment in a swipe action.
  Color get activeColor;

  /// Whether the action is currently activated.
  /// Will be used to color the action button, and render a
  /// crossed out icon in swipe actions.
  bool get isActivated;

  /// The function that will be invoked when the action is
  /// triggered.
  /// It will be wrapped in a call to [loggedInAction].
  Future<void> Function(UserData userData) get invoke;
}

//////////////////////// Upvote actions ////////////////////////

class PostUpvoteAction extends _UpvoteAction {
  final PostStore post;

  const PostUpvoteAction({
    required this.post,
    required super.context,
  });

  @override
  Future<void> Function(UserData userData) get invoke => post.upVote;

  @override
  bool get isActivated => post.postView.myVote == VoteType.up;
}

class CommentUpvoteAction extends _UpvoteAction {
  final CommentStore comment;

  const CommentUpvoteAction({
    required this.comment,
    required super.context,
  });

  @override
  Future<void> Function(UserData userData) get invoke => comment.upVote;

  @override
  bool get isActivated => comment.comment.myVote == VoteType.up;
}

abstract class _UpvoteAction implements LiftoffAction {
  final BuildContext context;

  const _UpvoteAction({
    required this.context,
  });

  @override
  Color get activeColor => Theme.of(context).colorScheme.secondary;

  @override
  IconData get icon => Icons.arrow_upward;

  @override
  String get name => 'Upvote';

  @override
  String get tooltip => 'upvote';
}

//////////////////////// Save actions ////////////////////////

class PostSaveAction extends _SaveAction {
  final PostStore post;

  const PostSaveAction({
    required this.post,
  });

  @override
  Future<void> Function(UserData userData) get invoke => post.save;

  @override
  bool get isActivated => post.postView.saved;
}

class CommentSaveAction extends _SaveAction {
  final CommentStore comment;

  const CommentSaveAction({
    required this.comment,
  });

  @override
  Future<void> Function(UserData userData) get invoke => comment.save;

  @override
  bool get isActivated => comment.comment.saved;
}

abstract class _SaveAction implements LiftoffAction {
  const _SaveAction();

  @override
  Color get activeColor => Colors.green;

  @override
  IconData get icon => Icons.bookmark;

  @override
  String get name => 'Save';

  @override
  String get tooltip => 'save';
}
