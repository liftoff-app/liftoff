import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../comment_tree.dart';
import '../../hooks/stores.dart';
import '../../stores/accounts_store.dart';
import '../../stores/config_store.dart';
import '../../util/async_store.dart';
import '../../widgets/post/post_store.dart';

part 'full_post_store.g.dart';

// Temp ignore until mobx stores are updated to satisfy linting rules
// ignore: library_private_types_in_public_api
class FullPostStore = _FullPostStore with _$FullPostStore;

abstract class _FullPostStore with Store {
  final int postId;
  final String instanceHost;

  _FullPostStore(
      {required this.postId,
      required this.instanceHost,
      // ignore: unused_element
      this.commentId});

  // ignore: unused_element
  _FullPostStore.fromPostView(PostView postView, {this.commentId})
      : postId = postView.post.id,
        instanceHost = postView.instanceHost,
        postStore = PostStore(postView);

  // ignore: unused_element
  _FullPostStore.fromPostStore(PostStore this.postStore)
      : postId = postStore.postView.post.id,
        commentId = null,
        instanceHost = postStore.postView.instanceHost;

  @observable
  FullPostView? fullPostView;

  @observable
  List<CommentView>? postComments;

  @observable
  List<CommentView>? pinnedComments;

  @observable
  ObservableList<CommentView> newComments = ObservableList<CommentView>();

  @observable
  CommentSortType sorting =
      useStore((ConfigStore store) => store.defaultCommentSort);

  @observable
  PostStore? postStore;

  @observable
  int? commentId;

  final fullPostState = AsyncStore<FullPostView>();
  final commentsState = AsyncStore<List<CommentView>>();
  final communityBlockingState = AsyncStore<BlockedCommunity>();

  @action
  // ignore: use_setters_to_change_properties
  void updateSorting(CommentSortType sort) {
    sorting = sort;
  }

  @action
  void getAllComments() {
    commentId = null;
  }

  @computed
  List<CommentTree>? get commentTree {
    if (fullPostView == null) return null;
    if (postComments == null) return null;
    return CommentTree.fromList(postComments!, topLevelCommentId: commentId);
  }

  @computed
  List<CommentTree>? get sortedCommentTree {
    return commentTree?..sortBy(sorting);
  }

  @computed
  PostView? get postView => postStore?.postView;

  @computed
  Iterable<CommentView>? get comments => postComments?.followedBy(newComments);

  @action
  Future<void> refresh([UserData? userData]) async {
    final result =
        await fullPostState.runLemmy(instanceHost, GetPost(id: postId));

    final commentsResult = await commentsState.runLemmy(
        instanceHost,
        GetComments(
            postId: postId,
            type: CommentListingType.all,
            parentId: commentId,
            maxDepth: 10,
            auth: userData?.jwt.raw));

    if (result != null) {
      postStore ??= PostStore(result.postView);
      fullPostView = result;
      postStore!.updatePostView(result.postView);
    }

    if (commentsResult != null) {
      newComments = ObservableList<CommentView>();
      postComments = commentsResult;
      pinnedComments = commentsResult
          .where((element) => element.comment.path == '0')
          .toList();
    }
  }

  @action
  Future<void> blockCommunity(UserData userData) async {
    final result = await communityBlockingState.runLemmy(
        instanceHost,
        BlockCommunity(
            communityId: fullPostView!.communityView.community.id,
            block: !fullPostView!.communityView.blocked,
            auth: userData.jwt.raw));
    if (result != null) {
      fullPostView =
          fullPostView!.copyWith(communityView: result.communityView);
    }
  }

  @action
  void addComment(CommentView commentView) =>
      newComments.insert(0, commentView);
}
