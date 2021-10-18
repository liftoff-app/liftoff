import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../url_launcher.dart';
import '../../util/observer_consumers.dart';
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

        return Padding(
          padding: const EdgeInsets.all(10).copyWith(top: 0),
          child: Row(
            children: [
              Expanded(
                flex: 100,
                child: Text(
                  post.name,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (!store.hasMedia && thumbnailUrl != null && url != null) ...[
                const Spacer(),
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
                          errorWidget: (context, url, error) =>
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
            ],
          ),
        );
      },
    );
  }
}
