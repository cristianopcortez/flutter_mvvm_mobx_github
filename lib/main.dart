import 'dart:async';

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

  final logger = Logger(
    printer: PrettyPrinter(),
    output: ConsoleOutput(), // Ensure logs are sent to the console
  );

  // Temporary local error logger
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log to your backend or analytics
    // if (kDebugMode) {
    //   print(details.exceptionAsString());
    logger.e(details.exceptionAsString());
    // }
  };

  // Compile-time secrets for CI / obfuscated builds. If unset, use native config
  // (android/app/google-services.json, ios/Runner/GoogleService-Info.plist) or run:
  // flutter run --dart-define=FIREBASE_API_KEY=... --dart-define=FIREBASE_APP_ID=...
  const apiKey = String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
  const appId = String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '');
  const firebaseMessagingSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '');
  const firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  const firebaseStorageBucket =
      String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: '');

  final useDartDefineOptions = apiKey.isNotEmpty &&
      appId.isNotEmpty &&
      firebaseMessagingSenderId.isNotEmpty &&
      firebaseProjectId.isNotEmpty;

  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized before anything else
    WidgetsFlutterBinding.ensureInitialized();

    // if (kDebugMode) {
    debugPrint("Firebase.initializeApp");
    // }
    try {
      if (useDartDefineOptions) {
        await Firebase.initializeApp(
          options: firebaseOptions(
            apiKey,
            firebaseMessagingSenderId,
            appId,
            firebaseProjectId,
            firebaseStorageBucket,
          ),
        );
      } else {
        // Default app from platform config (no custom instance name).
        await Firebase.initializeApp();
      }

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

