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
  Future<void> report(UserData userData, String reason) async {
    if (reason.trim().isEmpty) throw ArgumentError('reason must not be empty');

    await reportingState.runLemmy(
      comment.instanceHost,
      CreateCommentReport(
        commentId: comment.comment.id,
        reason: reason,
        auth: userData.jwt.raw,
      ),
    );
  }

  @action
  Future<void> delete(UserData userData) async {
    final result = await deletingState.runLemmy(
      comment.instanceHost,
      DeleteComment(
        commentId: comment.comment.id,
        deleted: !comment.comment.deleted,
        auth: userData.jwt.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> save(UserData userData) async {
    final result = await savingState.runLemmy(
      comment.instanceHost,
      SaveComment(
        commentId: comment.comment.id,
        save: !comment.saved,
        auth: userData.jwt.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> block(UserData userData) async {
    final result = await blockingState.runLemmy(
      comment.instanceHost,
      BlockPerson(
        personId: comment.creator.id,
        block: !comment.creatorBlocked,
        auth: userData.jwt.raw,
      ),
    );
    if (result != null) {
      comment = comment.copyWith(creatorBlocked: result.blocked);
    }
  }

  @action
  Future<void> markAsRead(UserData userData) async {
    if (userMentionId != null) {
      final result = await markPersonMentionAsReadState.runLemmy(
        comment.instanceHost,
        MarkPersonMentionAsRead(
          personMentionId: userMentionId!,
          read: !comment.comment.distinguished,
          auth: userData.jwt.raw,
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
            auth: userData.jwt.raw,
          ),
        );

        if (result != null) {
          comment = CommentView.fromJson(result.commentReplyView.toJson());
        }
      }
    }

    await _accountsStore.checkNotifications(userData);
  }

  @action
  Future<void> _vote(VoteType voteType, UserData userData) async {
    final result = await votingState.runLemmy(
      comment.instanceHost,
      CreateCommentLike(
        commentId: comment.comment.id,
        score: voteType,
        auth: userData.jwt.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> upVote(UserData userData) async {
    await _vote(
      myVote == VoteType.up ? VoteType.none : VoteType.up,
      userData,
    );
  }

  @action
  Future<void> downVote(UserData userData) async {
    await _vote(
      myVote == VoteType.down ? VoteType.none : VoteType.down,
      userData,
    );
  }

  @action
  void addReply(CommentView commentView) {
    children.insert(0, CommentTree(commentView));
  }
}
