import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/extensions/api.dart';
import '../widgets/comment_section.dart';
import '../widgets/post.dart';

class FullPostPage extends HookWidget {
  final Future<FullPostView> fullPost;
  final PostView post;

  FullPostPage({@required int id, @required String instanceUrl})
      : assert(id != null),
        assert(instanceUrl != null),
        fullPost = LemmyApi(instanceUrl).v1.getPost(id: id),
        post = null;
  FullPostPage.fromPostView(this.post)
      : fullPost = LemmyApi(post.instanceUrl).v1.getPost(id: post.id);

  @override
  Widget build(BuildContext context) {
    final fullPostSnap = useFuture(this.fullPost);

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

    final savedIcon = (post.saved == null || !post.saved)
        ? Icons.bookmark_border
        : Icons.bookmark;

    // FUNCTIONS

    sharePost() => Share.text('Share post', post.apId, 'text/plain');

    savePost() {
      print('SAVE POST');
    }

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          actions: [
            IconButton(icon: Icon(Icons.share), onPressed: sharePost),
            IconButton(icon: Icon(savedIcon), onPressed: savePost),
            IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => Post.showMoreMenu(context, post)),
          ],
        ),
        body: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Post(post, fullPost: true),
            if (fullPostSnap.hasData)
              CommentSection(fullPost.comments,
                  postCreatorId: fullPost.post.creatorId)
            else
              Container(
                child: Center(child: CircularProgressIndicator()),
                padding: EdgeInsets.only(top: 40),
              ),
          ],
        ));
  }
}
