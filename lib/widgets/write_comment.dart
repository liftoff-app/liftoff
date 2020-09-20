import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/extensions/api.dart';
import 'markdown_text.dart';

/// on submit pops the navigator stack with a [CommentView]
/// or `null` if cancelled
class WriteComment extends HookWidget {
  final PostView post;
  final CommentView comment;

  final String instanceUrl;

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

    handleSubmit() async {}

    return Scaffold(
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
                maxHeight: MediaQuery.of(context).size.height * .5),
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
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FlatButton(
            onPressed: handleSubmit,
            child: Text('post'),
          )
        ],
      ),
    );
  }
}
