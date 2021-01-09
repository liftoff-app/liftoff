import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/logged_in_action.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../util/more_icon.dart';
import '../widgets/comment_section.dart';
import '../widgets/post.dart';
import '../widgets/save_post_button.dart';
import '../widgets/write_comment.dart';

/// Displays a post with its comment section
class FullPostPage extends HookWidget {
  final int id;
  final String instanceHost;
  final PostView post;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  FullPostPage({@required this.id, @required this.instanceHost})
      : assert(id != null),
        assert(instanceHost != null),
        post = null;
  FullPostPage.fromPostView(this.post)
      : id = post.id,
        instanceHost = post.instanceHost;

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final fullPostSnap = useMemoFuture(() => LemmyApi(instanceHost)
        .v1
        .getPost(id: id, auth: accStore.defaultTokenFor(instanceHost)?.raw));
    final loggedInAction = useLoggedInAction(instanceHost);
    final newComments = useState(const <CommentView>[]);
    final updatedPost = useState<FullPostView>(null);
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

    final post = updatedPost.value?.post ??
        (fullPostSnap.hasData ? fullPostSnap.data.post : this.post);

    final fullPost = updatedPost.value ?? fullPostSnap.data;

    // FUNCTIONS

    refresh() async {
      await HapticFeedback.mediumImpact();

      try {
        return await LemmyApi(instanceHost)
            .v1
            .getPost(id: id, auth: accStore.defaultTokenFor(instanceHost)?.raw);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }

    sharePost() => Share.text('Share post', post.apId, 'text/plain');

    comment() async {
      final newComment = await showCupertinoModalPopup<CommentView>(
        context: context,
        builder: (_) => WriteComment.toPost(post),
      );
      if (newComment != null) {
        newComments.value = [...newComments.value, newComment];
      }
    }

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          actions: [
            IconButton(icon: const Icon(Icons.share), onPressed: sharePost),
            SavePostButton(post),
            IconButton(
                icon: Icon(moreIcon),
                onPressed: () => Post.showMoreMenu(context, post)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: loggedInAction((_) => comment()),
            child: const Icon(Icons.comment)),
        body: RefreshIndicator(
          onRefresh: refresh,
          key: _refreshIndicatorKey,
          child: ListView(
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
                      const Icon(Icons.error),
                      Text('Error: ${fullPostSnap.error}')
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ));
  }
}
