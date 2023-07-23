import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../stores/config_store.dart';
import '../../util/observer_consumers.dart';

//TODO Support for full screen video

class PostVideo extends StatefulWidget {
  final Uri url;
  const PostVideo({super.key, required this.url});

  @override
  State<PostVideo> createState() => _PostVideoState();
}

class _PostVideoState extends State<PostVideo> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late Uri url = widget.url;
  bool? isPlaying;
  bool? isMute;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(url,
        httpHeaders: {
          HttpHeaders.userAgentHeader:
              Platform.isAndroid ? 'ExoPlayer' : 'Liftoff/1.0'
        },
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));

    _controller.setLooping(true);

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isMute ??= context.read<ConfigStore>().autoMuteVideo;
    isPlaying ??= context.read<ConfigStore>().autoPlayVideo;

    if (isPlaying!) {
      _controller.play();
    } else {
      _controller.pause();
    }

    _controller.setVolume(isMute! ? 0 : 1);

    return Column(children: [
      ButtonBar(children: [
        IconButton(
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying!;
              });
            },
            icon: Icon(isPlaying! ? Icons.pause : Icons.play_arrow)),
        IconButton(
            onPressed: () {
              setState(() {
                isMute = !isMute!;
              });
            },
            icon: Icon(isMute! ? Icons.volume_off : Icons.volume_up))
      ]),
      FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlaying = !isPlaying!;
                    });
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
