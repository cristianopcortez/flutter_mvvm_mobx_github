import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'features/view-model/video_player_controller_store.dart';
import 'features/view/OverlappingButtonNativeVideoPlayer.dart';

import 'features/view/ProductHomePage.dart';

void main() async {

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log to your backend or analytics
    print(details.exceptionAsString());
  };

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
    await Firebase.initializeApp(
      options: firebaseOptions(
        apiKey,
        firebaseMessagingSenderID,
        appID,
        firebaseProjectID,
        firebaseProjectStorageBucket,
      ),
    ).catchError((e) {
      if (kDebugMode) {
        print('Failed with error code: ${e.code}');
        print("Error: ${e.message}");
      }
      // Optionally rethrow the error if you want the error to propagate further.
      // throw e;
    }).whenComplete(() {
      if (kDebugMode) {
        print("Initialization completed");
      }
    });

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: OverlappingButtonNativeVideoPlayer(videoPath: '',),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          var snackBar = SnackBar(content: Text(snapshot.error.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const ProductHomePage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
