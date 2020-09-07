import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

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
      : fullPost = LemmyApi(post.communityActorId.split('/')[2])
            .v1
            .getPost(id: post.id);

  void sharePost() => Share.text('Share post', post.apId, 'text/plain');

  void savePost() {
    //
  }

  @override
  Widget build(BuildContext context) {
    final fullPostSnap = useFuture(this.fullPost);
    final fullPost = fullPostSnap.data;

    final savedIcon = () {
      if (fullPostSnap.hasData) {
        if (fullPost.post.saved == null || !fullPost.post.saved) {
          return Icons.bookmark_border;
        } else {
          return Icons.bookmark;
        }
      }

      if (post != null) {
        if (post.saved == null || !post.saved) {
          return Icons.bookmark_border;
        } else {
          return Icons.bookmark;
        }
      }

      return Icons.bookmark_border;
    }();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: sharePost),
          IconButton(icon: Icon(savedIcon), onPressed: savePost),
          IconButton(
              icon: Icon(Icons.more_vert), onPressed: () {}), // TODO: more menu
        ],
      ),
      body: fullPostSnap.hasData || post != null
          // FUTURE SUCCESS
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (fullPostSnap.hasData)
                  Post(fullPost.post, fullPost: true)
                else if (post != null)
                  Post(post, fullPost: true)
                else
                  CircularProgressIndicator(),
                if (fullPostSnap.hasData)
                  CommentSection(fullPost.comments,
                      postCreatorId: fullPost.post.creatorId)
                else
                  Container(
                    child: Center(child: CircularProgressIndicator()),
                    padding: EdgeInsets.only(top: 40),
                  ),
              ],
            )
          : fullPostSnap.hasError
              // FUTURE FAILURE
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 30),
                      Padding(padding: EdgeInsets.all(5)),
                      Text('ERROR: ${fullPostSnap.error.toString()}'),
                    ],
                  ),
                )
              // FUTURE IN PROGRESS
              : Container(
                  child: Center(child: CircularProgressIndicator()),
                  color: Theme.of(context).canvasColor),
    );
  }
}
