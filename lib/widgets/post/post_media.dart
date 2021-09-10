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
    return ObserverBuilder<PostStore>(builder: (context, store) {
      final post = store.postView.post;
      if (!store.hasMedia) return const SizedBox();

      return FullscreenableImage(
        url: post.url!,
        child: CachedNetworkImage(
          imageUrl: post.url!,
          errorWidget: (_, __, ___) => const Icon(Icons.warning),
          progressIndicatorBuilder: (context, url, progress) =>
              CircularProgressIndicator(value: progress.progress),
        ),
      );
    });
  }
}
