import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';

// TODO: sync this button between post and fullpost. the same with voting

class SavePostButton extends HookWidget {
  final PostView post;

  const SavePostButton(this.post);

  @override
  Widget build(BuildContext context) {
    final isSaved = useState(post.saved ?? false);
    final savedIcon = isSaved.value ? Icons.bookmark : Icons.bookmark_border;
    final loading = useDelayedLoading();
    final loggedInAction = useLoggedInAction(post.instanceHost);

    savePost(Jwt token) async {
      final api = LemmyApiV3(post.instanceHost);

      loading.start();
      try {
        final res = await api.run(SavePost(
            postId: post.post.id, save: !isSaved.value, auth: token.raw));
        isSaved.value = res.saved;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('saving failed :(')));
      }
      loading.cancel();
    }

    if (loading.loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).iconTheme.color,
            )),
      );
    }

    return IconButton(
      tooltip: 'Save post',
      icon: Icon(savedIcon),
      onPressed: loggedInAction(loading.pending ? (_) {} : savePost),
    );
  }
}
