import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import '../../util/observer_consumers.dart';
import '../../util/redgif.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
import 'post_video.dart' as video;
import 'post_store.dart';

final _logger = Logger('postMedia');

/// assembles image
class PostMedia extends StatelessWidget {
  const PostMedia();

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final post = store.postView.post;
        final isRedgif = isRedGif(store.urlDomain);

        if (!store.hasMedia && !isRedgif) return const SizedBox();

        final url =
            Uri.parse(post.url!); // hasMedia returns false if url is null

        _logger.info(
            'MEDIA URL: extension: ${extension(url.path)} host: ${store.urlDomain}');

        if (isRedgif) {
          return video.buildRedGifVideo(url);
        } else if ('.mp4' == extension(url.path)) {
          return video.PostVideo(url);
        } else {
          return FullscreenableImage(
            url: url.toString(),
            child: CachedNetworkImage(
              imageUrl: url.toString(),
              errorBuilder: (_, ___) => const Icon(Icons.warning),
              loadingBuilder: (context, progress) =>
                  CircularProgressIndicator.adaptive(value: progress?.progress),
            ),
          );
        }
      },
    );
  }
}
