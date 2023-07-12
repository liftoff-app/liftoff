import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
import '../media_providers/liftoff_media_provider.dart';
import '../media_providers/redgif_provider.dart';
import 'post_store.dart';
import 'post_video.dart' as video;

final _logger = Logger('postMedia');

/// assembles image
class PostMedia extends HookWidget {
  const PostMedia();

  static const redgifProvider = RedgifProvider();
  static const mp4Provider = MP4MediaProvider();

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final post = store.postView.post;

        if (!store.hasMedia && post.url == null) return const SizedBox();

        final url =
            Uri.parse(post.url!); // hasMedia returns false if url is null

        _logger.finer(
            'MEDIA URL: extension: ${extension(url.path)} host: ${store.urlDomain}');

        LiftoffMediaProvider? provider;

        if (redgifProvider.providesFor(url)) {
          provider = redgifProvider;
        } else if (mp4Provider.providesFor(url)) {
          provider = mp4Provider;
        }

        if (provider != null) {
          return FutureBuilder(
              future: provider.getMediaUrl(url),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return video.PostVideo(snapshot.data!);
                } else if (snapshot.hasError) {
                  return const Text('Unable to fetch video');
                } else {
                  return const CircularProgressIndicator();
                }
              });
        } else if (store.hasMedia) {
          return FullscreenableImage(
            url: url.toString(),
            child: CachedNetworkImage(
              imageUrl: url.toString(),
              errorBuilder: (_, ___) => const Icon(Icons.warning),
              loadingBuilder: (context, progress) =>
                  CircularProgressIndicator.adaptive(value: progress?.progress),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
