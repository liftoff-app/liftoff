import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
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
        final path = File(url);
        final parsed_url = Uri.parse(url);

        if ('.mp4' == extension(path.path)) {
          //TODO Add mp4 support
          return const Spacer();
        } else if (parsed_url.host.contains('redgif')) {
          //TODO Add redgif support
          return const Spacer();
        } else {
          return FullscreenableImage(
            url: url,
            child: CachedNetworkImage(
              imageUrl: url,
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
