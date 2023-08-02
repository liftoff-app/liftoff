import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../comment_tree.dart';
import '../../stores/accounts_store.dart';
import '../../util/async_store.dart';

part 'comment_store.g.dart';

class CommentStore extends _CommentStore with _$CommentStore {
  CommentStore(super.accountsStore,
      {required super.commentTree,
      required super.depth,
      required super.canBeMarkedAsRead,
      required super.detached,
      required super.hideOnRead,
      super.userMentionId,
      super.userData});
}

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
      comment.comment.creatorId == userData?.userId &&
      comment.comment.instanceHost == userData?.instanceHost;

  @computed
  VoteType get myVote => comment.myVote ?? VoteType.none;

  @computed
  bool get isOP => comment.comment.creatorId == comment.post.creatorId;

  final AccountsStore _accountsStore;

  final UserData? userData;

  bool get isAuthenticated {
    return userData != null;
  }

  _CommentStore(
    this._accountsStore, {
    required CommentTree commentTree,
    // ignore: unused_element
    this.userMentionId,
    required this.depth,
    required this.canBeMarkedAsRead,
    required this.detached,
    required this.hideOnRead,
    this.userData,
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
  Future<void> report(String reason) async {
    if (reason.trim().isEmpty) throw ArgumentError('reason must not be empty');

    await reportingState.runLemmy(
      comment.instanceHost,
      CreateCommentReport(
        commentId: comment.comment.id,
        reason: reason,
        auth: userData!.jwt.raw,
      ),
    );
  }

  @action
  Future<void> delete() async {
    final result = await deletingState.runLemmy(
      comment.instanceHost,
      DeleteComment(
        commentId: comment.comment.id,
        deleted: !comment.comment.deleted,
        auth: userData!.jwt.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> save() async {
    final result = await savingState.runLemmy(
      comment.instanceHost,
      SaveComment(
        commentId: comment.comment.id,
        save: !comment.saved,
        auth: userData!.jwt.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> block() async {
    final result = await blockingState.runLemmy(
      comment.instanceHost,
      BlockPerson(
        personId: comment.creator.id,
        block: !comment.creatorBlocked,
        auth: userData!.jwt.raw,
      ),
    );
    if (result != null) {
      comment = comment.copyWith(creatorBlocked: result.blocked);
    }
  }

  @action
  Future<void> markAsRead() async {
    if (userMentionId != null) {
      final result = await markPersonMentionAsReadState.runLemmy(
        comment.instanceHost,
        MarkPersonMentionAsRead(
          personMentionId: userMentionId!,
          read: !comment.comment.distinguished,
          auth: userData!.jwt.raw,
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
            auth: userData!.jwt.raw,
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
  Future<void> _vote(VoteType voteType) async {
    final result = await votingState.runLemmy(
      comment.instanceHost,
      CreateCommentLike(
        commentId: comment.comment.id,
        score: voteType,
        auth: userData!.jwt.raw,
      ),
    );

    if (result != null) comment = result.commentView;
  }

  @action
  Future<void> upVote() async {
    await _vote(myVote == VoteType.up ? VoteType.none : VoteType.up);
  }

  @action
  Future<void> downVote() async {
    await _vote(myVote == VoteType.down ? VoteType.none : VoteType.down);
  }

  @action
  void addReply(CommentView commentView) {
    children.insert(0, CommentTree(commentView));
  }
}
