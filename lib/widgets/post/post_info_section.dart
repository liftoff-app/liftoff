import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/api.dart';
import '../../util/extensions/datetime.dart';
import '../../util/goto.dart';
import '../../util/observer_consumers.dart';
import '../avatar.dart';
import 'post_more_menu.dart';
import 'post_status.dart';
import 'post_store.dart';

class PostInfoSection extends StatelessWidget {
  const PostInfoSection();

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(builder: (context, store) {
      final fullPost = context.read<IsFullPost>();
      final post = store.postView;
      final instanceHost = store.postView.instanceHost;
      final theme = Theme.of(context);

      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Avatar(
              url: post.community.icon,
              padding: const EdgeInsets.only(right: 10),
              onTap: () =>
                  goToCommunity.byId(context, instanceHost, post.community.id),
              noBlank: true,
              radius: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                      children: [
                        const TextSpan(
                          text: '!',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: post.community.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => goToCommunity.byId(
                                  context,
                                  instanceHost,
                                  post.community.id,
                                ),
                        ),
                        const TextSpan(
                          text: '@',
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: post.post.originInstanceHost,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => goToInstance(
                                  context,
                                  post.post.originInstanceHost,
                                ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodyText1?.color,
                      ),
                      children: [
                        TextSpan(
                          text: L10n.of(context).by,
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: ' ${post.creator.originPreferredName}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => goToUser.fromPersonSafe(
                                  context,
                                  post.creator,
                                ),
                        ),
                        TextSpan(text: ' · ${post.post.published.fancyShort}'),
                        if (post.post.locked) const TextSpan(text: ' · 🔒'),
                        if (post.post.stickied) const TextSpan(text: ' · 📌'),
                        if (post.post.nsfw) const TextSpan(text: ' · '),
                        if (post.post.nsfw)
                          TextSpan(
                            text: L10n.of(context).nsfw,
                            style: const TextStyle(color: Colors.red),
                          ),
                        if (store.urlDomain != null)
                          TextSpan(text: ' · ${store.urlDomain}'),
                        if (post.post.removed)
                          const TextSpan(text: ' · REMOVED'),
                        if (post.post.deleted)
                          const TextSpan(text: ' · DELETED'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (!fullPost) const PostMoreMenuButton(),
          ],
        ),
      );
    });
  }
}
