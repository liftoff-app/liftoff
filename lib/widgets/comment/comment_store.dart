import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../comment_tree.dart';
import '../../stores/accounts_store.dart';
import '../../util/async_store.dart';

part 'comment_store.g.dart';

class CommentStore = _CommentStore with _$CommentStore;

abstract class _CommentStore with Store {
  @observable
  CommentView comment;

  final ObservableList<CommentTree> children;

  final int? userMentionId;
  final int depth;
  final bool canBeMarkedAsRead;
  final bool detached;
  final bool hideOnRead;

  @observable
  bool selectable = false;

  @observable
  bool collapsed = false;

  @observable
  bool showRaw = false;

  final votingState = AsyncStore<FullCommentView>();
  final deletingState = AsyncStore<FullCommentView>();
  final savingState = AsyncStore<FullCommentView>();
  final markPersonMentionAsReadState = AsyncStore<PersonMentionView>();
  final markAsReadState = AsyncStore<FullCommentReplyView>();
  final blockingState = AsyncStore<BlockedPerson>();
  final reportingState = AsyncStore<CommentReportView>();

  @computed
  bool get isMine =>
      comment.comment.creatorId ==
      _accountsStore.defaultUserDataFor(comment.instanceHost)?.userId;

  @computed
  VoteType get myVote => comment.myVote ?? VoteType.none;

  @computed
  bool get isOP => comment.comment.creatorId == comment.post.creatorId;

  final AccountsStore _accountsStore;

  _CommentStore(
    this._accountsStore, {
    required CommentTree commentTree,
    // ignore: unused_element
    this.userMentionId,
    required this.depth,
    required this.canBeMarkedAsRead,
    required this.detached,
    required this.hideOnRead,
  })  : comment = commentTree.comment,
        children = commentTree.children.asObservable();

  @action
  void toggleShowRaw() {
    showRaw = !showRaw;
  }

  @action
  void toggleSelectable() {
    selectable = !selectable;
  }

  @action
  void toggleCollapsed() {
    collapsed = !collapsed;
  }

  @action
  Future<void> report(Jwt token, String reason) async {
    if (reason.trim().isEmpty) throw ArgumentError('reason must not be empty');

    await reportingState.runLemmy(
      comment.instanceHost,
      CreateCommentReport(
        commentId: comment.comment.id,
        reason: reason,
        auth: token.raw,
      ),
    );
  }

  @action
  Future<void> delete(Jwt token) async {
    final result = await deletingState.runLemmy(
      comment.instanceHost,
      DeleteComment(
        commentId: comment.comment.id,
        deleted: !comment.comment.deleted,
        auth: token.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> save(Jwt token) async {
    final result = await savingState.runLemmy(
      comment.instanceHost,
      SaveComment(
        commentId: comment.comment.id,
        save: !comment.saved,
        auth: token.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> block(Jwt token) async {
    final result = await blockingState.runLemmy(
      comment.instanceHost,
      BlockPerson(
        personId: comment.creator.id,
        block: !comment.creatorBlocked,
        auth: token.raw,
      ),
    );
    if (result != null) {
      comment = comment.copyWith(creatorBlocked: result.blocked);
    }
  }

  @action
  Future<void> markAsRead(Jwt token) async {
    if (userMentionId != null) {
      final result = await markPersonMentionAsReadState.runLemmy(
        comment.instanceHost,
        MarkPersonMentionAsRead(
          personMentionId: userMentionId!,
          read: !comment.comment.distinguished,
          auth: token.raw,
        ),
      );

      if (result != null) {
        comment = comment.copyWith(comment: result.comment);
      }
    } else {
      if (comment.commentReply?.id != null) {
        final result = await markAsReadState.runLemmy(
          comment.instanceHost,
          MarkCommentAsRead(
            commentReplyId: comment.commentReply!.id,
            read: !comment.comment.distinguished,
            auth: token.raw,
          ),
        );

        if (result != null) {
          comment = CommentView.fromJson(result.commentReplyView.toJson());
        }
      }
    }
  }

  @action
  Future<void> _vote(VoteType voteType, Jwt token) async {
    final result = await votingState.runLemmy(
      comment.instanceHost,
      CreateCommentLike(
        commentId: comment.comment.id,
        score: voteType,
        auth: token.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> upVote(Jwt token) async {
    await _vote(
      myVote == VoteType.up ? VoteType.none : VoteType.up,
      token,
    );
  }

  @action
  Future<void> downVote(Jwt token) async {
    await _vote(
      myVote == VoteType.down ? VoteType.none : VoteType.down,
      token,
    );
  }

  @action
  void addReply(CommentView commentView) {
    children.insert(0, CommentTree(commentView));
  }
}
