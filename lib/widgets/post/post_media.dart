import 'package:flutter/material.dart';

import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
import '../scaled_image.dart';
import 'post_status.dart';
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
        final isFullPost = context.read<IsFullPost>();

        final url = post.url!; // hasMedia returns false if url is null
        // Set a max height for image previews based on
        // screen height to ensure that a reasonable
        // amount of other content is visible.
        final maxHeight = MediaQuery.of(context).size.height / 3;

        return FullscreenableImage(
          url: url,
          child: CachedNetworkImage(
            imageUrl: url,
            errorBuilder: (_, ___) => const Center(
              child: Icon(Icons.warning),
            ),
            loadingBuilder: (context, progress) => Center(
              child: CircularProgressIndicator.adaptive(
                value: progress?.progress,
              ),
            ),
            imageBuilder: (context, imageProvider) {
              final im = Image(image: imageProvider);
              if (isFullPost) {
                return im;
              }
              return FitScaledWidget(
                height: maxHeight,
                child: im,
              );
            },
          ),
        );
      },
    );
  }
}
