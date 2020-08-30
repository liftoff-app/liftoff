import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import 'comment.dart';
import 'comment_tree.dart';

/// Manages comments section, sorts them
class CommentsWidget extends HookWidget {
  final List<CommentView> rawComments;
  final List<CommentTree> comments;

  CommentsWidget(this.rawComments)
      : comments = CommentTree.fromList(rawComments);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // sorting menu goes here
      for (var com in comments) CommentWidget(com),
    ]);
  }
}
