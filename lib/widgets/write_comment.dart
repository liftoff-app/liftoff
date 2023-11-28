import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../l10n/l10n.dart';
import '../stores/accounts_store.dart';
import '../util/text_color.dart';
import 'editor/editor.dart';
import 'markdown_mode_icon.dart';
import 'markdown_text.dart';

/// Modal for writing/editing a comment to a given post/comment (aka reply)
/// on submit pops the navigator stack with a [CommentView]
/// or `null` if cancelled
class WriteComment extends HookWidget {
  final Post post;
  final Comment? comment;
  final bool _isEdit;

  const WriteComment.toPost(this.post, {super.key})
      : comment = null,
        _isEdit = false;
  const WriteComment.toComment({
    super.key,
    required Comment this.comment,
    required this.post,
  }) : _isEdit = false;
  const WriteComment.edit({
    super.key,
    required Comment this.comment,
    required this.post,
  }) : _isEdit = true;

  @override
  Widget build(BuildContext context) {
    final showFancy = useState(false);
    final delayed = useDelayedLoading();
    final loggedInAction = useLoggedInAction(post.instanceHost);

    final editorController = useEditorController(
      instanceHost: post.instanceHost,
      text: _isEdit ? comment?.content : null,
    );

    final preview = () {
      final body = () {
        final text = comment?.content ?? post.body;
        if (text == null) return const SizedBox.shrink();
        return MarkdownText(
          text,
          instanceHost: post.instanceHost,
          selectable: true,
        );
      }();

      return Column(
        children: [
          SelectableText(
            '${post.instanceHost} > "${post.name}"',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          body,
        ],
      );
    }();

    handleSubmit(UserData userData) async {
      final api = LemmyApiV3(post.instanceHost);

      delayed.start();
      try {
        final res = await () {
          if (_isEdit) {
            return api.run(EditComment(
              commentId: comment!.id,
              content: editorController.textEditingController.text,
              auth: userData.jwt.raw,
            ));
          } else {
            return api.run(CreateComment(
              content: editorController.textEditingController.text,
              postId: post.id,
              parentId: comment?.id,
              auth: userData.jwt.raw,
            ));
          }
        }();
        if (context.mounted) {
          Navigator.of(context).pop(res.commentView);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to post comment')));
        }
      }
      delayed.cancel();
    }

    final titleText = _isEdit
        ? 'Editing comment'
        : ('Replying to ${comment == null ? 'post' : 'comment'}');

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: markdownModeIcon(fancy: showFancy.value),
            onPressed: () => showFancy.value = !showFancy.value,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            children: [
              ListView(
                reverse: true,
                children: [
                  preview,
                  const Divider(),
                  Editor(
                    controller: editorController,
                    autofocus: true,
                    fancy: showFancy.value,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                        onPressed: delayed.pending
                            ? () {}
                            : loggedInAction(handleSubmit),
                        child: delayed.loading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      textColorBasedOnBackground(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                ))
                            : Text(_isEdit
                                ? L10n.of(context).edit
                                : L10n.of(context).post),
                      )
                    ],
                  ),
                  EditorToolbar.safeArea,
                ].reversed.toList(),
              ),
              BottomSticky(
                child: EditorToolbar(editorController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Route<CommentView> toPostRoute(Post post) => MaterialPageRoute(
        builder: (context) => WriteComment.toPost(post),
        fullscreenDialog: true,
      );

  static Route<CommentView> toCommentRoute({
    required Comment comment,
    required Post post,
  }) =>
      MaterialPageRoute(
        builder: (context) =>
            WriteComment.toComment(comment: comment, post: post),
        fullscreenDialog: true,
      );

  static Route<CommentView> editRoute({
    required Comment comment,
    required Post post,
  }) =>
      MaterialPageRoute(
        builder: (context) => WriteComment.edit(comment: comment, post: post),
        fullscreenDialog: true,
      );
}
