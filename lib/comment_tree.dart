import 'package:lemmy_api_client/v3.dart';

import 'util/hot_rank.dart';

enum CommentSortType {
  hot,
  top,
  // ignore: constant_identifier_names
  new_,
  old,
  chat,
}

extension on CommentSortType {
  /// returns a compare function for sorting a CommentTree according
  /// to the comment sort type
  int Function(CommentTree a, CommentTree b) get sortFunction {
    switch (this) {
      case CommentSortType.chat:
        throw Exception('Sorting a CommentTree in chat mode is not supported'
            ' because it would restructure the whole tree');

      case CommentSortType.hot:
        return (b, a) =>
            a.comment.computedHotRank.compareTo(b.comment.computedHotRank);

      case CommentSortType.new_:
        return (b, a) =>
            a.comment.comment.published.compareTo(b.comment.comment.published);

      case CommentSortType.old:
        return (b, a) =>
            b.comment.comment.published.compareTo(a.comment.comment.published);

      case CommentSortType.top:
        return (b, a) =>
            a.comment.counts.score.compareTo(b.comment.counts.score);
    }
  }
}

extension SortCommentTreeList on List<CommentTree> {
  void sortBy(CommentSortType sortType) {
    sort(sortType.sortFunction);
    for (final el in this) {
      el._sort(sortType.sortFunction);
    }
  }
}

class CommentTree {
  CommentView comment;
  List<CommentTree> children = [];

  CommentTree(this.comment);

  /// takes raw linear comments and turns them into a CommentTree
  static List<CommentTree> fromList(List<CommentView> comments) {
    CommentTree gatherChildren(CommentTree parent) {
      for (final el in comments) {
        if (el.comment.parentId == parent.comment.comment.id) {
          parent.children.add(gatherChildren(CommentTree(el)));
        }
      }
      return parent;
    }

    final topLevelParents =
        comments.where((e) => e.comment.parentId == null).map(CommentTree.new);

    final result = topLevelParents.map(gatherChildren).toList();
    return result;
  }

  /// recursive sorter
  void _sort(int compare(CommentTree a, CommentTree b)) {
    children.sort(compare);
    for (final el in children) {
      el._sort(compare);
    }
  }
}
