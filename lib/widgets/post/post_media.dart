import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

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
        } else if ('.mp4' == extension(url.path) || isRedgif) {
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

Future<String> getRedgifAuthtoken() async {
  final response = await http.get(
      Uri.parse('https://api.redgifs.com/v2/auth/temporary'),
      headers: {HttpHeaders.userAgentHeader: 'liftoff/1.0'});
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

  final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};
  if (Platform.isAndroid) {
    headers.putIfAbsent(HttpHeaders.userAgentHeader, () => 'ExoPlayer');
  }
  final response = await http
      .get(Uri.parse('https://api.redgifs.com/v2/gifs/$id'), headers: headers);

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Uri.parse(json['gif']['urls']['hd']);
  } else {
    throw Exception('Unable to query redgifs for url');
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Uri url;
  const VideoPlayerScreen(this.url, {super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState(url);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final Uri url;
  _VideoPlayerScreenState(this.url);

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(url,
        httpHeaders: {HttpHeaders.userAgentHeader: 'Dart/3.0 (dart:io)'});
    _controller
      ..play()
      ..setLooping(true)
      ..setVolume(0);

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void toggleMute() {
    if (_controller.value.volume == 0) {
      _controller.setVolume(1);
    } else {
      _controller.setVolume(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ButtonBar(children: [
        IconButton(
            onPressed: () {
              setState(togglePlay);
            },
            icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow)),
        IconButton(
            onPressed: () {
              setState(toggleMute);
            },
            icon: Icon(_controller.value.volume == 0.0
                ? Icons.volume_off
                : Icons.volume_up))
      ]),
      FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                  onTap: () {
                    setState(togglePlay);
                  },
                  child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller)));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })
    ]);
  }
}
