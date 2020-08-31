import 'package:lemmy_api_client/lemmy_api_client.dart';

class CommentTree {
  CommentView comment;
  List<CommentTree> children;

  CommentTree(this.comment, [this.children]) {
    children ??= [];
  }

  static List<CommentTree> fromList(List<CommentView> comments) {
    CommentTree gatherChildren(CommentTree parent) {
      for (var el in comments) {
        if (el.parentId == parent.comment.id) {
          parent.children.add(gatherChildren(CommentTree(el)));
        }
      }
      return parent;
    }

    var parents = <CommentTree>[];

    // first pass to get all the parents
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].parentId == null) {
        parents.add(CommentTree(comments[i]));
      }
    }

    var result = parents.map(gatherChildren).toList();
    return result;
  }
}
