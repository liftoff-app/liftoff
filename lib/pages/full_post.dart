import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../util/extensions/api.dart';
import '../widgets/comment_section.dart';
import '../widgets/post.dart';
import '../widgets/save_post_button.dart';
import '../widgets/write_comment.dart';

class FullPostPage extends HookWidget {
  final int id;
  final String instanceUrl;
  final PostView post;

  FullPostPage({@required this.id, @required this.instanceUrl})
      : assert(id != null),
        assert(instanceUrl != null),
        post = null;
  FullPostPage.fromPostView(this.post)
      : id = post.id,
        instanceUrl = post.instanceUrl;

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final fullPostSnap = useMemoFuture(() => LemmyApi(instanceUrl)
        .v1
        .getPost(id: id, auth: accStore.defaultTokenFor(instanceUrl)?.raw));
    final newComments = useState(const <CommentView>[]);

    // FALLBACK VIEW

    if (!fullPostSnap.hasData && this.post == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (fullPostSnap.hasError)
                Text(fullPostSnap.error.toString())
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    // VARIABLES

    final post = fullPostSnap.hasData ? fullPostSnap.data.post : this.post;

    final fullPost = fullPostSnap.data;

    // FUNCTIONS

    sharePost() => Share.text('Share post', post.apId, 'text/plain');

    comment() async {
      final newComment = await showDialog<CommentView>(
        context: context,
        child: WriteComment.toPost(post),
      );
      if (newComment != null) {
        newComments.value = [...newComments.value, newComment];
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          actions: [
            IconButton(icon: Icon(Icons.share), onPressed: sharePost),
            SavePostButton(post),
            IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => Post.showMoreMenu(context, post)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: comment, child: Icon(Icons.comment)),
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Post(post, fullPost: true),
            if (fullPostSnap.hasData)
              CommentSection(
                  newComments.value.followedBy(fullPost.comments).toList(),
                  postCreatorId: fullPost.post.creatorId)
            else if (fullPostSnap.hasError)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  children: [
                    Icon(Icons.error),
                    Text('Error: ${fullPostSnap.error}')
                  ],
                ),
              )
            else
              Container(
                child: Center(child: CircularProgressIndicator()),
                padding: EdgeInsets.only(top: 40),
              ),
          ],
        ));
  }
}
