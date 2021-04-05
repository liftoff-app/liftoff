import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import 'markdown_mode_icon.dart';
import 'markdown_text.dart';

/// Modal for writing a comment to a given post/comment (aka reply)
/// on submit pops the navigator stack with a [CommentView]
/// or `null` if cancelled
class WriteComment extends HookWidget {
  final Post post;
  final Comment comment;

  const WriteComment.toPost(this.post) : comment = null;
  const WriteComment.toComment({@required this.comment, @required this.post})
      : assert(comment != null),
        assert(post != null);

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final showFancy = useState(false);
    final delayed = useDelayedLoading();
    final accStore = useAccountsStore();

    final preview = () {
      final body = () {
        final text = comment?.content ?? post.body;
        if (text == null) return const SizedBox.shrink();
        return MarkdownText(text, instanceHost: post.instanceHost);
      }();

      if (post != null) {
        return Column(
          children: [
            Text(
              post.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            body,
          ],
        );
      }

      return body;
    }();

    handleSubmit() async {
      final api = LemmyApiV3(post.instanceHost);

      final token = accStore.defaultTokenFor(post.instanceHost);

      delayed.start();
      try {
        final res = await api.run(CreateComment(
          content: controller.text,
          postId: post.id,
          parentId: comment?.id,
          auth: token.raw,
        ));
        Navigator.of(context).pop(res.commentView);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to post comment')));
      }
      delayed.cancel();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: markdownModeIcon(fancy: showFancy.value),
            onPressed: () => showFancy.value = !showFancy.value,
          ),
        ],
      ),
      body: ListView(
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
          IndexedStack(
            index: showFancy.value ? 1 : 0,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                minLines: 5,
                maxLines: null,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: MarkdownText(
                  controller.text,
                  instanceHost: post.instanceHost,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: delayed.pending ? () {} : handleSubmit,
                child: delayed.loading
                    ? const CircularProgressIndicator()
                    : Text(L10n.of(context).post),
              )
            ],
          ),
        ],
      ),
    );
  }
}
