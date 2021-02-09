import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import 'markdown_text.dart';

/// Modal for writing a comment to a given post/comment (aka reply)
/// on submit pops the navigator stack with a [CommentView]
/// or `null` if cancelled
class WriteComment extends HookWidget {
  final PostView post;
  final CommentView comment;

  final String instanceHost;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  WriteComment.toPost(this.post)
      : instanceHost = post.instanceHost,
        comment = null;
  WriteComment.toComment(this.comment)
      : instanceHost = comment.instanceHost,
        post = null;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final showFancy = useState(false);
    final delayed = useDelayedLoading();
    final accStore = useAccountsStore();

    final preview = () {
      final body = MarkdownText(
        comment?.comment?.content ?? post.post.body ?? '',
        instanceHost: instanceHost,
      );

      if (post != null) {
        return Column(
          children: [
            Text(
              post.post.name,
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
      final api = LemmyApiV2(instanceHost);

      final token = accStore.defaultTokenFor(instanceHost);

      delayed.start();
      try {
        final res = await api.run(CreateComment(
          content: controller.text,
          postId: post?.post?.id ?? comment.post.id,
          parentId: comment?.comment?.id,
          auth: token.raw,
        ));
        Navigator.of(context).pop(res.commentView);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e);
        scaffoldKey.currentState.showSnackBar(
            const SnackBar(content: Text('Failed to post comment')));
      }
      delayed.cancel();
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: Icon(showFancy.value ? Icons.build : Icons.brush),
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
                  instanceHost: instanceHost,
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
                    : const Text('post'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
