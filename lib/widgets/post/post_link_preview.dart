import 'package:flutter/material.dart';

import '../../url_launcher.dart';
import '../../util/observer_consumers.dart';
import 'post_store.dart';
import 'post_thumbnail.dart';

class PostLinkPreview extends StatelessWidget {
  const PostLinkPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final url = store.postView.post.url;

        if (store.hasMedia || url == null || url.isEmpty) {
          return const SizedBox();
        }

        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => linkLauncher(
              context: context,
              url: url,
              instanceHost: store.postView.instanceHost,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).iconTheme.color!.withAlpha(170)),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    if (store.postView.post.thumbnailUrl != null)
                      const PostThumbnail(
                        padding: EdgeInsets.only(right: 10),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              Text('${store.urlDomain} ',
                                  style: theme.textTheme.bodySmall
                                      ?.apply(fontStyle: FontStyle.italic)),
                              const Icon(Icons.launch, size: 12),
                            ],
                          ),
                          Text(
                            store.postView.post.embedTitle ?? '',
                            style: theme.textTheme.titleMedium
                                ?.apply(fontWeightDelta: 2),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (store
                                  .postView.post.embedDescription?.isNotEmpty ??
                              false)
                            Text(
                              store.postView.post.embedDescription!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
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
