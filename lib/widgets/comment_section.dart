import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../comment_tree.dart';
import 'comment.dart';

/// Manages comments section, sorts them
class CommentSection extends HookWidget {
  final List<CommentView> rawComments;
  final List<CommentTree> comments;
  final int postCreatorId;

  CommentSection(this.rawComments, {@required this.postCreatorId})
      : comments = CommentTree.fromList(rawComments),
        assert(postCreatorId != null);

  @override
  Widget build(BuildContext context) => Column(children: [
        // sorting menu goes here
        if (comments.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'no comments yet',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        for (var com in comments) Comment(com, postCreatorId: postCreatorId),
      ]);
}
