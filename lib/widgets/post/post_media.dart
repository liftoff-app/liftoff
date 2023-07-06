import 'package:flutter/material.dart';

import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../clipped_image.dart';
import '../fullscreenable_image.dart';
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

        return FullscreenableImage(
          url: url,
          child: SizedBox(
            height: !isFullPost ? 300 : null,
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
                if (isFullPost) {
                  return Image(
                    image: imageProvider,
                  );
                }

                return FitClippedWidget(
                  child: Image(
                    image: imageProvider,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
