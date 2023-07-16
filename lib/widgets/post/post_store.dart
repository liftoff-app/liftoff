import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../stores/accounts_store.dart';
import '../../util/async_store.dart';
import '../../util/cleanup_url.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

extension PostStoreMapping on Future<List<PostView>> {
  Future<List<PostStore>> mapToPostStore() async =>
      then((posts) => posts.map(PostStore.new).toList());
}

abstract class _PostStore with Store {
  _PostStore(this.postView);

  final votingState = AsyncStore<PostView>();
  final savingState = AsyncStore<PostView>();
  final userBlockingState = AsyncStore<BlockedPerson>();
  final communityBlockingState = AsyncStore<BlockedCommunity>();
  final reportingState = AsyncStore<PostReportView>();
  final deletingState = AsyncStore<PostView>();

  @observable
  PostView postView;

  @observable
  ObservableList<CommentView> newComments = ObservableList<CommentView>();

  @computed
  String? get urlDomain =>
      postView.post.url != null ? urlHost(postView.post.url!) : null;

  @computed
  bool get hasMedia {
    final url = postView.post.url;
    if (url == null || url.isEmpty) return false;

    // TODO: detect video
    // this is how they do it in lemmy-ui:
    // https://github.com/LemmyNet/lemmy-ui/blob/018c10c9193082237b5f8036e215a40325591acb/src/shared/utils.ts#L291

    if (!url.startsWith('https://') && !url.startsWith('http://')) {
      return false;
    }

    return url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif') ||
        url.endsWith('.webp') ||
        url.endsWith('.bmp') ||
        url.endsWith('.svg') ||
        url.endsWith('.wbpm');
  }

  @action
  Future<void> save(UserData userData) async {
    final result = await savingState.runLemmy(
        postView.instanceHost,
        SavePost(
            postId: postView.post.id,
            save: !postView.saved,
            auth: userData.jwt.raw));

    if (result != null) postView = result;
  }

  @action
  Future<void> report(UserData userData, String reason) async {
    if (reason.trim().isEmpty) throw ArgumentError('reason must not be empty');

    await reportingState.runLemmy(
      postView.instanceHost,
      CreatePostReport(
        postId: postView.post.id,
        reason: reason,
        auth: userData.jwt.raw,
      ),
    );
  }

  @action
  Future<void> delete(UserData userData) async {
    final result = await deletingState.runLemmy(
      postView.instanceHost,
      DeletePost(
        postId: postView.post.id,
        deleted: !postView.post.deleted,
        auth: userData.jwt.raw,
      ),
    );

    if (result != null) postView = result;
  }

  @action
  Future<void> blockUser(UserData userData) async {
    final result = await userBlockingState.runLemmy(
        postView.post.instanceHost,
        BlockPerson(
          personId: postView.creator.id,
          block: !postView.creatorBlocked,
          auth: userData.jwt.raw,
        ));

    if (result != null) {
      postView = postView.copyWith(creatorBlocked: result.blocked);
    }
  }

  @action
  Future<void> blockCommunity(UserData userData) async {
    await communityBlockingState.runLemmy(
        postView.post.instanceHost,
        BlockCommunity(
            communityId: postView.community.id,
            block: true,
            auth: userData.jwt.raw));
  }

  @action
  // ignore: use_setters_to_change_properties
  void updatePostView(PostView postView) {
    this.postView = postView;
  }

  // VOTING

  @action
  Future<void> _vote(UserData userData, VoteType voteType) async {
    final result = await votingState.runLemmy(
      postView.instanceHost,
      CreatePostLike(
          postId: postView.post.id, score: voteType, auth: userData.jwt.raw),
    );

    if (result != null) postView = result;
  }

  @action
  Future<void> upVote(UserData userData) => _vote(
      userData, postView.myVote == VoteType.up ? VoteType.none : VoteType.up);

  @action
  Future<void> downVote(UserData userData) => _vote(userData,
      postView.myVote == VoteType.down ? VoteType.none : VoteType.down);

  @action
  void addComment(CommentView commentView) =>
      newComments.insert(0, commentView);
}
