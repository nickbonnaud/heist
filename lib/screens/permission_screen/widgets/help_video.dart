import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HelpVideo extends StatefulWidget {
  @override
  State<HelpVideo> createState() => _HelpVideoState();
}

class _HelpVideoState extends State<HelpVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/always_beacon.mov')
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {});
      })
      ..play();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.initialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
        : Container(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}