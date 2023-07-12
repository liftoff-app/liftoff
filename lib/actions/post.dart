import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../stores/accounts_store.dart';
import '../widgets/comment/comment_store.dart';
import '../widgets/post/post_store.dart';
import 'abstract_action.dart';

abstract class UpvoteAction implements LiftoffAction {
  final BuildContext context;

  const UpvoteAction({
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

class PostUpvoteAction extends UpvoteAction {
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

class CommentUpvoteAction extends UpvoteAction {
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

class PostSaveAction implements LiftoffAction {
  final PostStore post;
  final BuildContext context;

  const PostSaveAction({
    required this.post,
    required this.context,
  });

  @override
  Color get activeColor => Colors.green;

  @override
  IconData get icon => Icons.bookmark;

  @override
  Future<void> Function(UserData userData) get invoke => post.save;

  @override
  bool get isActivated => post.postView.saved;

  @override
  String get name => 'Save';

  @override
  String get tooltip => 'save';
}
