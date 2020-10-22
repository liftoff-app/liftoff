import 'package:lemmy_api_client/lemmy_api_client.dart';

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
        return (b, a) => a.comment.published.compareTo(b.comment.published);

      case CommentSortType.old:
        return (b, a) => b.comment.published.compareTo(a.comment.published);

      case CommentSortType.top:
        return (b, a) => a.comment.score.compareTo(b.comment.score);
    }

    throw Exception('unreachable');
  }
}

class CommentTree {
  CommentView comment;
  List<CommentTree> children;

  CommentTree(this.comment, [this.children]) {
    children ??= [];
  }

  /// takes raw linear comments and turns them into a CommentTree
  static List<CommentTree> fromList(List<CommentView> comments) {
    CommentTree gatherChildren(CommentTree parent) {
      for (final el in comments) {
        if (el.parentId == parent.comment.id) {
          parent.children.add(gatherChildren(CommentTree(el)));
        }
      }
      return parent;
    }

    final topLevelParents =
        comments.where((e) => e.parentId == null).map((e) => CommentTree(e));

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

  /// Sorts in-place a list of CommentTrees according to a given sortType
  static List<CommentTree> sortList(
      CommentSortType sortType, List<CommentTree> comms) {
    comms.sort(sortType.sortFunction);
    for (final el in comms) {
      el._sort(sortType.sortFunction);
    }
    return comms;
  }
}
