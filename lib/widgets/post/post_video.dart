import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

//TODO Support for full screen video

class PostVideo extends StatefulWidget {
  final Uri url;
  const PostVideo(this.url, {super.key});

  @override
  State<PostVideo> createState() => _PostVideoState(url);
}

class _PostVideoState extends State<PostVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final Uri url;
  _PostVideoState(this.url);

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(url, httpHeaders: {
      HttpHeaders.userAgentHeader:
          Platform.isAndroid ? 'ExoPlayer' : 'Liftoff/1.0'
    });

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
