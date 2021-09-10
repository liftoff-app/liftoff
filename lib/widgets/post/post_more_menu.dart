import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../../pages/create_post.dart';
import '../../pages/full_post/full_post.dart';
import '../../stores/accounts_store.dart';
import '../../util/goto.dart';
import '../../util/icons.dart';
import '../../util/observer_consumers.dart';
import '../bottom_modal.dart';
import '../info_table_popup.dart';
import 'post_store.dart';

class PostMoreMenuButton extends StatelessWidget {
  const PostMoreMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () => showPostMoreMenu(
            context: context,
            store: context.read<PostStore>(),
          ),
          icon: Icon(moreIcon),
          padding: const EdgeInsets.all(0),
          visualDensity: VisualDensity.compact,
        )
      ],
    );
  }
}

void showPostMoreMenu({
  required BuildContext context,
  required PostStore store,
  bool fullPost = false,
}) {
  final isMine = context
          .read<AccountsStore>()
          .defaultUserDataFor(store.postView.instanceHost)
          ?.userId ==
      store.postView.creator.id;

  // TODO: add blocking!
  showBottomModal(
    context: context,
    builder: (context) => ObserverBuilder<PostStore>(
        store: store,
        builder: (context, store) {
          final post = store.postView;

          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open in browser'),
                onTap: () async => await ul.canLaunch(post.post.apId)
                    ? ul.launch(post.post.apId)
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("can't open in browser"))),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Nerd stuff'),
                onTap: () {
                  showInfoTablePopup(context: context, table: {
                    '% of upvotes':
                        '${(100 * (post.counts.upvotes / (post.counts.upvotes + post.counts.downvotes))).toInt()}%',
                    ...post.toJson(),
                  });
                },
              ),
              if (isMine)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () async {
                    final postView = await showCupertinoModalPopup<PostView>(
                      context: context,
                      builder: (_) => CreatePostPage.edit(post.post),
                    );

                    if (postView != null) {
                      Navigator.of(context).pop();
                      if (fullPost) {
                        await goToReplace(
                          context,
                          (_) => FullPostPage.fromPostView(postView),
                        );
                      } else {
                        await goTo(
                          context,
                          (_) => FullPostPage.fromPostView(postView),
                        );
                      }
                    }
                  },
                ),
            ],
          );
        }),
  );
}
