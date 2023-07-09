import 'dart:convert';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart';

import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
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
        final isRedgif = store.urlDomain == 'redgifs.com';
        if (!store.hasMedia && !isRedgif) return const SizedBox();

        final url = post.url!; // hasMedia returns false if url is null
        final path = File(url);

        _logger.info(
            'MEDIA URL: extension: ${extension(path.path)} host: ${store.urlDomain}');

        if ('.mp4' == extension(path.path) || isRedgif) {
          //TODO Add mp4 support
          final videoUrl = getRedgifUrl(url);
          return FutureBuilder(
              future: videoUrl,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final videoController =
                      VideoPlayerController.networkUrl(snapshot.data!);
                  return VideoPlayer(videoController);
                } else if (snapshot.hasError) {
                  return const Text('UNABLE TO GET VIDEO');
                } else {
                  return const CircularProgressIndicator();
                }
              });
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

Future<String> getRedgifAuthtoken() async {
  final response =
      await http.get(Uri.parse('https://api.redgifs.com/v2/auth/temporary'));
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['token'];
  } else {
    throw Exception('Unable to request a redgif token');
  }
}

Future<Uri> getRedgifUrl(String url) async {
  final token = await getRedgifAuthtoken();
  final id = basename(File(url).path);

  final response = await http.get(
      Uri.parse('https://api.redgifs.com/v2/gifs/${id}'),
      headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Uri.parse(json['gif']['urls']['sd']);
  } else {
    throw Exception("Unable to query redgifs for url");
  }
}
