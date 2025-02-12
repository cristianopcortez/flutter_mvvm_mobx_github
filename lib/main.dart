import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:provider/provider.dart';
import 'features/view-model/cart_store.dart';
import 'features/view-model/video_player_controller_store.dart';
import 'features/view/OverlappingButtonNativeVideoPlayer.dart';
import 'package:logger/logger.dart';

void main() async {

  BindingBase.debugZoneErrorsAreFatal = true; // Makes zone errors fatal during debugging

  // // Ensure Flutter bindings are initialized before anything else
  // WidgetsFlutterBinding.ensureInitialized();

  // final logger = Logger();
  final logger = Logger(
    printer: PrettyPrinter(),
    output: ConsoleOutput(), // Ensure logs are sent to the console
  );

  logger.i("Info message"); // Information
  logger.e("Error message"); // Error
  logger.d("Debug message"); // Debug

  // stderr.writeln("This should appear in logcat.");

  // Temporary local error logger
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log to your backend or analytics
    // if (kDebugMode) {
    //   print(details.exceptionAsString());
    logger.e(details.exceptionAsString());
    // }
  };

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

  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized before anything else
    WidgetsFlutterBinding.ensureInitialized();

    // if (kDebugMode) {
    debugPrint("Firebase.initializeApp");
    // }
    try {
      await Firebase.initializeApp(
        name: appID,
        options: firebaseOptions(
          apiKey,
          firebaseMessagingSenderID,
          appID,
          firebaseProjectID,
          firebaseProjectStorageBucket,
        ),
      );

      // Firebase initialization succeeded
      logger.d("Firebase initialization completed");
      debugPrint("Firebase initialization completed");

      // Ensure Crashlytics Logs During Debugging
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      // Enable Crashlytics
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      runApp(
        MultiProvider(
          providers: [
            Provider<VideoPlayerControllerStore>(create: (_) => VideoPlayerControllerStore()),
            Provider<CartStore>(create: (_) => CartStore()),
          ],
          child: const MyApp(),
        ),
      );

    } catch (e, stackTrace) {
      // Handle Firebase initialization failure
      debugPrint("Error caught: $e");
      logger.e(
        "Error during Firebase.initializeApp",
        time: DateTime.now(),
        error: e,
        stackTrace: stackTrace,
      );
    }

  }, (error, stackTrace) {
    // Log to your backend or analytics
    // print('Caught by runZonedGuarded: $error');
    // print('Stack trace: $stackTrace');
    debugPrint("Error caught: $error");
    logger.e(
      "Caught by runZonedGuarded: ",
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
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

