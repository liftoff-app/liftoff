import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';
import '../../util/cleanup_url.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {
  @observable
  PostView postView;

  final votingState = AsyncStore<PostView>();
  final savingState = AsyncStore<PostView>();
  final userBlockingState = AsyncStore<BlockedPerson>();
  final communityBlockingState = AsyncStore<BlockedCommunity>();

  @computed
  bool get wasVoted => (postView.myVote ?? VoteType.none) != VoteType.none;

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
  Future<void> save(Jwt token) async {
    final result = await savingState.runLemmy(
        postView.instanceHost,
        SavePost(
            postId: postView.post.id, save: !postView.saved, auth: token.raw));

    if (result != null) postView = result;
  }

  @action
  Future<void> blockUser(Jwt token) async {
    final result = await userBlockingState.runLemmy(
        postView.post.instanceHost,
        BlockPerson(
          personId: postView.post.id,
          block: !postView.creatorBlocked,
          auth: token.raw,
        ));

    if (result != null) {
      postView = postView.copyWith(creatorBlocked: result.blocked);
    }
  }

  @action
  void updatePostView(PostView postView) {
    this.postView = postView;
  }

  // VOTING

  @action
  Future<void> _vote(Jwt token, VoteType voteType) async {
    final result = await votingState.runLemmy(
      postView.instanceHost,
      CreatePostLike(
          postId: postView.post.id, score: voteType, auth: token.raw),
    );

    if (result != null) postView = result;
  }

  @action
  Future<void> upVote(Jwt token) => _vote(
      token, postView.myVote == VoteType.up ? VoteType.none : VoteType.up);

  @action
  Future<void> downVote(Jwt token) => _vote(
      token, postView.myVote == VoteType.down ? VoteType.none : VoteType.down);

  _PostStore(this.postView);
}
