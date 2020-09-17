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

class CommentTree {
  CommentView comment;
  List<CommentTree> children;

  CommentTree(this.comment, [this.children]) {
    children ??= [];
  }

  static List<CommentTree> fromList(List<CommentView> comments) {
    CommentTree gatherChildren(CommentTree parent) {
      for (final el in comments) {
        if (el.parentId == parent.comment.id) {
          parent.children.add(gatherChildren(CommentTree(el)));
        }
      }
      return parent;
    }

    final parents = <CommentTree>[];

    // first pass to get all the parents
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].parentId == null) {
        parents.add(CommentTree(comments[i]));
      }
    }

    final result = parents.map(gatherChildren).toList();
    return result;
  }

  void sort(CommentSortType sortType) {
    switch (sortType) {
      case CommentSortType.chat:
        // throw Exception('i dont do this kinda stuff kido');
        return;
      case CommentSortType.hot:
        return _sort((b, a) =>
            a.comment.computedHotRank.compareTo(b.comment.computedHotRank));
      case CommentSortType.new_:
        return _sort(
            (b, a) => a.comment.published.compareTo(b.comment.published));
      case CommentSortType.old:
        return _sort(
            (b, a) => b.comment.published.compareTo(a.comment.published));
      case CommentSortType.top:
        return _sort((b, a) => a.comment.score.compareTo(b.comment.score));
    }
  }

  void _sort(int compare(CommentTree a, CommentTree b)) {
    children.sort(compare);
    for (final el in children) {
      el._sort(compare);
    }
  }

  static List<CommentTree> sortList(
      CommentSortType sortType, List<CommentTree> comms) {
    switch (sortType) {
      case CommentSortType.chat:
        throw Exception('i dont do this kinda stuff kido');
      case CommentSortType.hot:
        comms.sort((b, a) =>
            a.comment.computedHotRank.compareTo(b.comment.computedHotRank));
        for (var i = 0; i < comms.length; i++) {
          comms[i].sort(sortType);
        }
        return comms;

      case CommentSortType.new_:
        comms
            .sort((b, a) => a.comment.published.compareTo(b.comment.published));
        for (var i = 0; i < comms.length; i++) {
          comms[i].sort(sortType);
        }
        return comms;

      case CommentSortType.old:
        comms
            .sort((b, a) => b.comment.published.compareTo(a.comment.published));
        for (var i = 0; i < comms.length; i++) {
          comms[i].sort(sortType);
        }
        return comms;

      case CommentSortType.top:
        comms.sort((b, a) => a.comment.score.compareTo(b.comment.score));
        for (var i = 0; i < comms.length; i++) {
          comms[i].sort(sortType);
        }
        return comms;
    }
    throw Exception('unreachable');
  }
}
