import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:native_video_view/native_video_view.dart';

// Include generated file
part 'video_player_controller_store.g.dart';

// This is the class used by the rest of your codebase
class VideoPlayerControllerStore = _VideoPlayerControllerStore with _$VideoPlayerControllerStore;

// The store-class
abstract class _VideoPlayerControllerStore with Store {
  @observable
  VideoViewController? controller;

  @observable
  bool isInitialized = false;

  @observable
  String fileName = 'videos/VID-20241229-WA0000.mp4';

  @observable
  bool reloadFlag = false;

  @action
  Future<void> initializeController(VideoViewController newController) async {
    controller = newController;
    isInitialized = true;
  }

  @action
  void play() {
    controller?.play();
  }

  @action
  void pause() {
    controller?.pause();
  }

  @action
  void setFileName(String fileName) {
    if (fileName != fileName) {
      fileName = fileName; // Update the observable property
    }
  }

  @action
  bool setReloadFlag(bool boolReloadFlag) {
    reloadFlag = !boolReloadFlag;
    return reloadFlag;
  }

  @action
  Future<void> resetAndPlay() async {
    if (controller != null && isInitialized) {
      await controller!.seekTo(0); // Reset to the beginning
      controller!.play(); // Start playing
    }
  }

  void resetController() {
    if (controller != null) {
      controller?.dispose();
      controller = null;
    }
    ensureControllerInitialized();
  }

  @action
  Future<void> reloadPlayer() async {
    controller?.dispose();
    controller = null;
    isInitialized = false;

    // Ensure the controller is reinitialized
    ensureControllerInitialized();
  }

  @action
  void ensureControllerInitialized() {
    if (controller == null) {
      NativeVideoView(
        keepAspectRatio: false,
        showMediaController: false,
        enableVolumeControl: false,
        onCreated: (controller) {
          controller.setVideoSource(
            'videos/VID-20241229-WA0000.mp4',
            sourceType: VideoSourceType.asset,
            requestAudioFocus: true,
          );
          controller = controller;
        },
        onPrepared: (controller, info) {
          if (kDebugMode) {
            print("Controller on Store is prepared: ${info}");
          }
          controller.play();
        },
        onError: (controller, what, extra, message) {
          if (kDebugMode) {
            print(
                'NativeVideoView on Store: Player Error ($what | $extra | $message)');
          }
        },
        onCompletion: (controller) {
          if (kDebugMode) {
            print('NativeVideoView on Store: Video completed');
          }
        },
      );
      isInitialized = true;
    }
  }

  @action
  void disposeController() {
    if (kDebugMode) {
      print('NativeVideoView on Store: disposed');
    }
    controller?.dispose(); // Dispose the VideoViewController
    controller = null;
    isInitialized = false;
  }

}
