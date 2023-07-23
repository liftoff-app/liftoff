import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/stores.dart';
import '../../stores/config_store.dart';
import '../../url_launcher.dart';
import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
import 'post_store.dart';

class PostThumbnail extends HookWidget {
  final EdgeInsetsGeometry padding;
  const PostThumbnail({super.key, this.padding = const EdgeInsets.all(10)});

  @override
  Widget build(BuildContext context) {
    final configStore = useStore((ConfigStore store) => store);

    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final post = store.postView.post;
        final thumbnailUrl = post.thumbnailUrl;
        final url = post.url;
        return Padding(
          padding: padding,
          child: Row(
            children: [
              if ((!store.hasMedia && configStore.showThumbnail) &&
                  !(post.nsfw && configStore.blurNsfw) &&
                  thumbnailUrl != null &&
                  url != null) ...[
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => linkLauncher(
                      context: context,
                      url: url,
                      instanceHost: store.postView.instanceHost),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: thumbnailUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error) =>
                              Text(error.toString()),
                        ),
                      ),
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.launch,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ],
              if ((store.hasMedia &&
                      configStore.showThumbnail &&
                      configStore.compactPostView) &&
                  !(post.nsfw && configStore.blurNsfw) &&
                  url != null) ...[
                FullscreenableImage(
                  url: url,
                  child: CachedNetworkImage(
                    width: 70,
                    height: 70,
                    imageUrl: url,
                    errorBuilder: (_, ___) => const Icon(Icons.warning),
                    loadingBuilder: (context, progress) =>
                        CircularProgressIndicator.adaptive(
                            value: progress?.progress),
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
