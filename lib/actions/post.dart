import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../stores/accounts_store.dart';
import '../widgets/post/post_store.dart';
import 'abstract_action.dart';

class PostUpvoteAction implements LiftoffAction {
  final PostStore post;
  final BuildContext context;

  const PostUpvoteAction({
    required this.post,
    required this.context,
  });

  @override
  Color get activeColor => Theme.of(context).colorScheme.secondary;

  @override
  IconData get icon => Icons.arrow_upward;

  @override
  Future<void> Function(UserData userData) get invoke => post.upVote;

  @override
  bool get isActivated => post.postView.myVote == VoteType.up;

  @override
  String get name => 'Upvote';

  @override
  String get tooltip => 'upvote';
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
