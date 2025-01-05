class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  // Your changeable variable
  String fCMNewToken = "";
  String fCMToken = "";
}