import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_mvvm_mobx_github/features/view-model/video_player_controller_store.dart';
import 'package:flutter_mvvm_mobx_github/features/view/PostHomePage.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:provider/provider.dart';

import 'ProductHomePage.dart';

final videoPlayerControllerStore = VideoPlayerControllerStore();

class OverlappingButtonNativeVideoPlayer extends StatefulWidget {
  final String videoPath; // Can be asset or network path

  const OverlappingButtonNativeVideoPlayer({super.key, required this.videoPath});

  @override
  State<OverlappingButtonNativeVideoPlayer> createState() =>
      _OverlappingButtonNativeVideoPlayerState();
}

class _OverlappingButtonNativeVideoPlayerState
    extends State<OverlappingButtonNativeVideoPlayer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerControllerStore.disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerAppState = Provider.of<VideoPlayerControllerStore>(context);

    return Scaffold(
      body: SafeArea(
              child: Stack(
                children: [
                  Observer(
                    builder: (_) {
                      if (videoPlayerAppState.fileName.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return _buildVideoPlayerWidgetByFileName(
                          context, videoPlayerAppState.fileName);
                    },
                  ),
                  Positioned(
                    bottom: 100,
                    left: 30,
                    right: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        videoPlayerAppState.disposeController();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductHomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: const Text(
                        'PRODUTOS',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 30,
                    right: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        videoPlayerAppState.disposeController();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostHomePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: const Text(
                        'POSTS',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
            ])
      )
    );
  }
}

Widget _buildVideoPlayerWidgetByFileName(
    BuildContext context, String fileName) {
  final videoPlayerAppState = Provider.of<VideoPlayerControllerStore>(context);

  return Observer(
    builder: (_) {
      // Directly access the observable property
      final currentFileName = videoPlayerAppState.fileName;
      final reloadFlag = videoPlayerAppState.reloadFlag;

      debugPrint('Building video player with fileName: $currentFileName');

      return Container(
        alignment: Alignment.center,
        child: NativeVideoView(
          key: ValueKey(reloadFlag.toString()), // Unique key based on reloadFlag
          keepAspectRatio: false,
          showMediaController: false,
          enableVolumeControl: false,
          onCreated: (controller) {
            debugPrint('NativeVideoView onCreated with fileName: $currentFileName');
            // Use the accessed observable property
            controller.setVideoSource(
              currentFileName,
              sourceType: VideoSourceType.asset,
              requestAudioFocus: true,
            );
            videoPlayerAppState.initializeController(controller);
          },
          onPrepared: (controller, info) {
            debugPrint('NativeVideoView: Video prepared');
            controller.play();
          },
          onError: (controller, what, extra, message) {
            debugPrint(
                'NativeVideoView: Player Error ($what | $extra | $message)');
          },
          onCompletion: (controller) {
            debugPrint('NativeVideoView: Video completed');
            controller.stop();
            controller.dispose();
          },
        ),
      );
    },
  );
}
