import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../util/api_extensions.dart';

class SavePostButton extends HookWidget {
  final PostView post;

  SavePostButton(this.post);

  @override
  Widget build(BuildContext context) {
    final isSaved = useState(post.saved ?? false);
    final savedIcon = isSaved.value ? Icons.bookmark : Icons.bookmark_border;
    final loading = useDelayedLoading(Duration(milliseconds: 500));
    final accStore = useAccountsStore();

    savePost() async {
      final api = LemmyApi(post.instanceUrl).v1;
      final token = accStore.defaultTokenFor(post.instanceUrl);
      if (token == null) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text("can't save if you ain't logged in")));
        return;
      }

      loading.start();
      try {
        final res = await api.savePost(
            postId: post.id, save: !isSaved.value, auth: token.raw);
        isSaved.value = res.saved;
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('saving failed :(')));
        return;
      }
      loading.cancel();
    }

    if (loading.loading) return CircularProgressIndicator();

    return IconButton(icon: Icon(savedIcon), onPressed: savePost);
  }
}
