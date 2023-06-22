import 'package:flutter/material.dart';

import '../../url_launcher.dart';
import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
import 'post_store.dart';

class PostTitle extends StatelessWidget {
  const PostTitle();

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final post = store.postView.post;
        final thumbnailUrl = post.thumbnailUrl;
        final url = post.url;
        print(store.hasMedia);
        return Padding(
          padding: const EdgeInsets.all(10).copyWith(top: 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  post.name,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (!store.hasMedia && thumbnailUrl != null && url != null) ...[
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
              if (store.hasMedia && url != null) ...[
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
