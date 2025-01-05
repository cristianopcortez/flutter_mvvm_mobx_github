import 'package:flutter/material.dart';
import 'package:flutter_mvvm_mobx_github/features/view/PostHomePage.dart';
import 'package:video_player/video_player.dart';

class OverlappingButtonVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const OverlappingButtonVideoPlayer({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  State<OverlappingButtonVideoPlayer> createState() =>
      _OverlappingButtonVideoPlayerState();
}

class _OverlappingButtonVideoPlayerState
    extends State<OverlappingButtonVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.videoUrl != null) {
      // Load video from network
      _controller = VideoPlayerController.network(widget.videoUrl!);
    } else {
      // Load video from assets
      _controller = VideoPlayerController.asset('VID-20241229-WA0000.mp4');
    }

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostHomePage(),
                  ),
                );
              },
              child: const Text(
                'INICIAR',
                style: TextStyle(fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Remove border radius
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}