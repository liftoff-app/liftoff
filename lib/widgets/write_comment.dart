import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../l10n/l10n.dart';
import '../stores/accounts_store.dart';
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

  const WriteComment.toPost(this.post)
      : comment = null,
        _isEdit = false;
  const WriteComment.toComment({
    required Comment this.comment,
    required this.post,
  }) : _isEdit = false;
  const WriteComment.edit({
    required Comment this.comment,
    required this.post,
  }) : _isEdit = true;

  @override
  Widget build(BuildContext context) {
    final showFancy = useState(false);
    final delayed = useDelayedLoading();
    final loggedInAction =
        useLoggedInAction(post.instanceHost, allowAnonymous: true);

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

    handleSubmit(Jwt token) async {
      final api = LemmyApiV3(post.instanceHost);

      delayed.start();
      try {
        final res = await () async {
          if (_isEdit) {
            return api.run(EditComment(
              commentId: comment!.id,
              content: editorController.textEditingController.text,
              auth: token.raw,
            ));
          } else {
            if (token is AnonymousAccountJwt) {
              final originApi = LemmyApiV3(token.originalInstance);

              if (comment != null) {
                // Resolve just the parent comment.
                final response = await originApi
                    .run(ResolveObject(q: comment!.apId, auth: token.raw));

                return originApi.run(CreateComment(
                  content: editorController.textEditingController.text,
                  postId: response.comment!.post.id,
                  parentId: response.comment!.comment.id,
                  auth: token.raw,
                ));
              } else {
                // Resolve the main post.
                final response = await originApi
                    .run(ResolveObject(q: post.apId, auth: token.raw));

                return originApi.run(CreateComment(
                  content: editorController.textEditingController.text,
                  postId: response.post!.post.id,
                  auth: token.raw,
                ));
              }
            }

            return api.run(CreateComment(
              content: editorController.textEditingController.text,
              postId: post.id,
              parentId: comment?.id,
              auth: token.raw,
            ));
          }
        }();
        Navigator.of(context).pop(res.commentView);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to post comment')));
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
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .35),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: preview,
                    ),
                  ),
                  const Divider(),
                  Editor(
                    controller: editorController,
                    autofocus: true,
                    fancy: showFancy.value,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: delayed.pending
                            ? () {}
                            : loggedInAction(handleSubmit),
                        child: delayed.loading
                            ? const CircularProgressIndicator.adaptive()
                            : Text(_isEdit
                                ? L10n.of(context).edit
                                : L10n.of(context).post),
                      )
                    ],
                  ),
                  EditorToolbar.safeArea,
                ],
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
