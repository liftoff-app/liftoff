import 'package:flutter/material.dart';

import '../../url_launcher.dart';
import '../../util/observer_consumers.dart';
import 'post_store.dart';

class PostLinkPreview extends StatelessWidget {
  const PostLinkPreview();

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        if (store.postView.post.url == null ||
            store.postView.post.url!.isEmpty) {
          return const SizedBox();
        }

        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => linkLauncher(
              context: context,
              url: store.postView.post.url!,
              instanceHost: store.postView.instanceHost,
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).iconTheme.color!.withAlpha(170)),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Text('${store.urlDomain} ',
                            style: theme.textTheme.caption
                                ?.apply(fontStyle: FontStyle.italic)),
                        const Icon(Icons.launch, size: 12),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            store.postView.post.embedTitle ?? '',
                            style: theme.textTheme.subtitle1
                                ?.apply(fontWeightDelta: 2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    if (store.postView.post.embedDescription != null &&
                        store.postView.post.embedDescription!.isNotEmpty)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              store.postView.post.embedDescription!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
