import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'features/view-model/video_player_controller_store.dart';
import 'features/view/OverlappingButtonNativeVideoPlayer.dart';
import 'package:logger/logger.dart';

import 'features/view/ProductHomePage.dart';

void main() async {

  final logger = Logger();

  logger.i("Info message"); // Information
  logger.e("Error message"); // Error
  logger.d("Debug message"); // Debug

  stderr.writeln("This should appear in logcat.");

  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.presentError(details);
  //   // Log to your backend or analytics
  //   // if (kDebugMode) {
  //     print(details.exceptionAsString());
  //   // }
  // };

  WidgetsFlutterBinding.ensureInitialized();
    String apiKey = Platform.isAndroid
        ? const String.fromEnvironment('FIREBASE_API_KEY') ?? ''
        : '';
    String appID = Platform.isAndroid
        ? const String.fromEnvironment('FIREBASE_APP_ID') ?? ''
        : '';
    String firebaseMessagingSenderID = Platform.isAndroid
        ? const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID') ?? ''
        : '';
    String firebaseProjectID = Platform.isAndroid
        ? const String.fromEnvironment('FIREBASE_PROJECT_ID') ?? ''
        : '';
    String firebaseProjectStorageBucket = Platform.isAndroid
        ? const String.fromEnvironment('FIREBASE_STORAGE_BUCKET') ?? ''
        : '';
    // if (kDebugMode) {
      debugPrint("Firebase.initializeApp");
    // }
    await Firebase.initializeApp(
      options: firebaseOptions(
        apiKey,
        firebaseMessagingSenderID,
        appID,
        firebaseProjectID,
        firebaseProjectStorageBucket,
      ),
    ).catchError((e) {
      // if (kDebugMode) {
        debugPrint("Exception Type: ${e.runtimeType}");
      // }
      if (e is FirebaseException) {
        // if (kDebugMode) {
          debugPrint("Firebase Error Code: ${e.code}");
          debugPrint("Firebase Error Message: ${e.message}");
        // }
      } else {
        // if (kDebugMode) {
          debugPrint("Unknown Error:");
          debugPrint(e.toString());
        // }
      }
    }).whenComplete(() {
      // if (kDebugMode) {
        debugPrint("Initialization completed");
      // }
    });

  // Enable Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runZonedGuarded(() async {
      runApp(
        Provider<VideoPlayerControllerStore>(
          create: (_) => VideoPlayerControllerStore(),
          child: const MyApp(),
        ),
      );
    }, (error, stackTrace) {
      // Log to your backend or analytics
      print('Caught by runZonedGuarded: $error');
      print('Stack trace: $stackTrace');
    });
}

FirebaseOptions firebaseOptions(
    String apiKey, String firebaseMessagingSenderID,
    String appID,
    String firebaseProjectID, String firebaseProjectStorageBucket) {
  return FirebaseOptions(
      apiKey: apiKey,
      projectId: firebaseProjectID,
      storageBucket: firebaseProjectStorageBucket,
      messagingSenderId: firebaseMessagingSenderID,
      appId: appID
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory, // Remove splash effects
      ),
      home: const OverlappingButtonNativeVideoPlayer(videoPath: '',),
    );
  }
}

