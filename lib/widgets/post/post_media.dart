import 'package:flutter/material.dart';

import '../../stores/config_store.dart';
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
        final trimPreviewImage = context.read<ConfigStore>().trimPreviewImage;

        final url = post.url!; // hasMedia returns false if url is null

        final calculatedHeight = MediaQuery.of(context).size.width;

        return FullscreenableImage(
          url: url,
          child: SizedBox(
            height: !isFullPost && trimPreviewImage ? calculatedHeight : null,
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
                if (isFullPost || !trimPreviewImage) {
                  return Image(
                    image: imageProvider,
                  );
                }

                return FitClippedWidget(
                  height: calculatedHeight,
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
