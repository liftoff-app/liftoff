import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../util/extensions/api.dart';
import 'markdown_text.dart';

/// Modal for writing a comment to a given post/comment (aka reply)
/// on submit pops the navigator stack with a [CommentView]
/// or `null` if cancelled
class WriteComment extends HookWidget {
  final PostView post;
  final CommentView comment;

  final String instanceUrl;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  WriteComment.toPost(this.post)
      : instanceUrl = post.instanceUrl,
        comment = null;
  WriteComment.toComment(this.comment)
      : instanceUrl = comment.instanceUrl,
        post = null;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final showFancy = useState(false);
    final delayed = useDelayedLoading();
    final accStore = useAccountsStore();

    final preview = () {
      final body = MarkdownText(
        comment?.content ?? post.body ?? '',
        instanceUrl: instanceUrl,
      );

      if (post != null) {
        return Column(
          children: [
            Text(
              post.name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            body,
          ],
        );
      }

      return body;
    }();

    handleSubmit() async {
      final api = LemmyApi(instanceUrl).v1;

      final token = accStore.defaultTokenFor(instanceUrl);

      delayed.start();
      try {
        final res = await api.createComment(
            content: controller.text,
            postId: post?.id ?? comment.postId,
            parentId: comment?.id,
            auth: token.raw);
        Navigator.of(context).pop(res);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e);
        scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Failed to post comment')));
      }
      delayed.cancel();
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: Navigator.of(context).pop,
        ),
        actions: [
          IconButton(
            icon: Icon(showFancy.value ? Icons.build : Icons.brush),
            onPressed: () => showFancy.value = !showFancy.value,
          ),
        ],
      ),
      body: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .35),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: preview,
            ),
          ),
          Divider(),
          Expanded(
            child: IndexedStack(
              index: showFancy.value ? 1 : 0,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  expands: true,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: MarkdownText(
                    controller.text,
                    instanceUrl: instanceUrl,
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: delayed.pending ? () {} : handleSubmit,
                child: delayed.loading
                    ? CircularProgressIndicator()
                    : Text('post'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
