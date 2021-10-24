import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../comment_tree.dart';
import '../../util/async_store.dart';
import '../../widgets/post/post_store.dart';

part 'full_post_store.g.dart';

class FullPostStore = _FullPostStore with _$FullPostStore;

abstract class _FullPostStore with Store {
  final int postId;
  final String instanceHost;

  _FullPostStore({
    this.postStore,
    required this.postId,
    required this.instanceHost,
  });

  // ignore: unused_element
  _FullPostStore.fromPostView(PostView postView)
      : postId = postView.post.id,
        instanceHost = postView.instanceHost,
        postStore = PostStore(postView);

  // ignore: unused_element
  _FullPostStore.fromPostStore(PostStore this.postStore)
      : postId = postStore.postView.post.id,
        instanceHost = postStore.postView.instanceHost;

  @observable
  FullPostView? fullPostView;

  @observable
  ObservableList<CommentView> newComments = ObservableList<CommentView>();

  @observable
  CommentSortType sorting = CommentSortType.hot;

  @observable
  PostStore? postStore;

  final fullPostState = AsyncStore<FullPostView>();
  final communityBlockingState = AsyncStore<BlockedCommunity>();

  @action
  // ignore: use_setters_to_change_properties
  void updateSorting(CommentSortType sort) {
    sorting = sort;
  }

  @computed
  List<CommentTree>? get commentTree {
    if (fullPostView == null) return null;
    return CommentTree.fromList(fullPostView!.comments);
  }

  @computed
  List<CommentTree>? get sortedCommentTree {
    return commentTree?..sortBy(sorting);
  }

  @computed
  PostView? get postView => postStore?.postView;

  @computed
  Iterable<CommentView>? get comments =>
      fullPostView?.comments.followedBy(newComments);

  @action
  Future<void> refresh([Jwt? token]) async {
    final result = await fullPostState.runLemmy(
        instanceHost, GetPost(id: postId, auth: token?.raw));

    if (result != null) {
      postStore ??= PostStore(result.postView);

      fullPostView = result;
      postStore!.updatePostView(result.postView);
    }
  }

  @action
  Future<void> blockCommunity(Jwt token) async {
    final result = await communityBlockingState.runLemmy(
        instanceHost,
        BlockCommunity(
            communityId: fullPostView!.communityView.community.id,
            block: !fullPostView!.communityView.blocked,
            auth: token.raw));
    if (result != null) {
      fullPostView =
          fullPostView!.copyWith(communityView: result.communityView);
    }
  }

  @action
  void addComment(CommentView commentView) =>
      newComments.insert(0, commentView);
}
