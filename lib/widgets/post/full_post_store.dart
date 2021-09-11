import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';
import 'post_store.dart';

part 'full_post_store.g.dart';

class FullPostStore = _FullPostStore with _$FullPostStore;

abstract class _FullPostStore with Store {
  final int postId;
  final String instanceHost;

  @observable
  FullPostView? fullPostView;

  @observable
  List<CommentView> newComments = [];

  @observable
  PostStore? postStore;

  final fullPostState = AsyncStore<FullPostView>();
  final communityBlockingState = AsyncStore<BlockedCommunity>();

  @computed
  PostView? get postView => fullPostView?.postView ?? postStore?.postView;

  @computed
  List<CommentView>? get comments =>
      fullPostView?.comments.followedBy(newComments).toList(growable: false);

  @action
  Future<void> refresh() async {
    final result =
        await fullPostState.runLemmy(instanceHost, GetPost(id: postId));

    if (result != null) {
      postStore ??= PostStore(result.postView);

      fullPostView = result;
      postStore?.postView = result.postView;
    }
  }

  void addComment(CommentView commentView) =>
      newComments.insert(0, commentView);

  _FullPostStore({
    this.postStore,
    required this.postId,
    required this.instanceHost,
  });

  _FullPostStore.fromPostView(PostView postView)
      : postId = postView.post.id,
        instanceHost = postView.instanceHost,
        postStore = PostStore(postView);

  _FullPostStore.fromPostStore(this.postStore)
      : postId = postStore!.postView.post.id,
        instanceHost = postStore.postView.instanceHost;
}
