import 'package:lemmy_api_client/v3.dart';

import 'util/hot_rank.dart';

extension CommentSortTypeExtension on CommentSortType {
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
  static List<CommentTree> fromList(List<CommentView> comments,
      {int? topLevelCommentId}) {
    CommentTree gatherChildren(CommentTree parent) {
      for (final el in comments) {
        // comments store a parth variable that can be used to traverse the comment tree
        // example: path: "0.{commentId}.{otherCommentId}.{yetAnotherCommentId]"
        final commentHierarchy = el.comment.path.split('.');
        if (commentHierarchy.length - 2 > 0 &&
            int.parse(commentHierarchy[commentHierarchy.length - 2]) ==
                parent.comment.comment.id) {
          parent.children.add(gatherChildren(CommentTree(el)));
        }
      }
      return parent;
    }

    // pinned comment denoted by a path of 0
    final topLevelParents = (topLevelCommentId == null
            ? comments.where((e) =>
                e.comment.path.split('.').length == 2 || e.comment.path == '0')
            : comments.where((e) => e.comment.id == topLevelCommentId))
        .map(CommentTree.new);

    final result = topLevelParents.map(gatherChildren).toList();
    return result;
  }

  /// recursive sorter
  void _sort(int Function(CommentTree a, CommentTree b) compare) {
    children.sort(compare);
    for (final el in children) {
      el._sort(compare);
    }
  }
}
