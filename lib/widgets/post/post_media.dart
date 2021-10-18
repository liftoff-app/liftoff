import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../util/observer_consumers.dart';
import '../fullscreenable_image.dart';
import 'post_store.dart';

/// assembles image
class PostMedia extends StatelessWidget {
  const PostMedia();

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final post = store.postView.post;
        if (!store.hasMedia) return const SizedBox();

        final url = post.url!; // hasMedia returns false if url is null

        return FullscreenableImage(
          url: url,
          child: CachedNetworkImage(
            imageUrl: url,
            errorWidget: (_, __, ___) => const Icon(Icons.warning),
            progressIndicatorBuilder: (context, url, progress) =>
                CircularProgressIndicator.adaptive(value: progress.progress),
          ),
        );
      },
    );
  }
}
