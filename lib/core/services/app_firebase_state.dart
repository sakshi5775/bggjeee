import 'package:flutter/foundation.dart';

/// True only after [Firebase.initializeApp] succeeds. Crashlytics and Analytics
/// must treat Firebase as unavailable when this is false.
class AppFirebaseState {
  AppFirebaseState._();

  static bool coreReady = false;

  static void markReady() {
    coreReady = true;
    if (kDebugMode) {
      debugPrint('[AppFirebaseState] Firebase core ready');
    }
  }

  static void markNotReady() {
    coreReady = false;
    if (kDebugMode) {
      debugPrint('[AppFirebaseState] Firebase core not available');
    }
  }
}
