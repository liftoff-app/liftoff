import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

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
                  return VideoPlayerScreen(snapshot.data!);
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

  final details = await http.get(Uri.parse('https://api.redgifs.com/info'));

  _logger.info('DETAILS: ${details.body}');

  final response = await http
      .get(Uri.parse('https://api.redgifs.com/v2/gifs/${id}'), headers: {
    HttpHeaders.authorizationHeader: 'Bearer $token',
    HttpHeaders.userAgentHeader: 'liftoff/1.0'
  });

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Uri.parse(json['gif']['urls']['hd']);
  } else {
    throw Exception("Unable to query redgifs for url");
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

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          leading: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          title: Text(_controller.value.isPlaying ? 'Pause' : 'Play'),
          onTap: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
            });
          }),
      FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })
    ]);
  }
}
