import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

enum CrashErrorType { network, socket, payment, auth, ui, unknown }

class CrashlyticsService {
  static final FirebaseCrashlytics _crash = FirebaseCrashlytics.instance;
  static final Map<String, DateTime> _errorCache = {};

  static bool enableVerboseLogs =
      kDebugMode; // Default to debug mode, can be toggled

  /// Initialize with basic session info
  static Future<void> initSession({
    required String appVersion,
    required String platform,
    required String buildMode,
  }) async {
    await setKey("app_version", appVersion);
    await setKey("platform", platform);
    await setKey("build_mode", buildMode);
    await setKey("env", kReleaseMode ? "production" : "staging");
    log("APP_START_COLD");
  }

  /// Fingerprint-based rate limiting to prevent log spam
  static bool _shouldLog(String key) {
    final now = DateTime.now();
    if (_errorCache.containsKey(key)) {
      if (now.difference(_errorCache[key]!) < const Duration(seconds: 30)) {
        return false;
      }
    }
    _errorCache[key] = now;
    return true;
  }

  static String _generateFingerprint(dynamic error) {
    final str = error.toString();
    return str.length > 50 ? str.substring(0, 50) : str;
  }

  /// Log structured breadcrumbs
  static void log(String message) {
    if (!enableVerboseLogs && message.startsWith("DEBUG:")) return;
    _crash.log(message);
  }

  /// Record error with classification
  static void recordError(
    dynamic error,
    StackTrace stack, {
    CrashErrorType type = CrashErrorType.unknown,
    bool fatal = false,
    String? reason,
  }) {
    final fingerprint = _generateFingerprint(error);
    if (!_shouldLog(fingerprint)) return;

    _crash.setCustomKey("error_type", type.name);
    _crash.recordError(error, stack, fatal: fatal, reason: reason);
  }

  /// Flow tracing with correlation ID
  static void logFlow(
    String flow,
    String action, {
    String? data,
    String? flowId,
  }) {
    String message = "FLOW:$flow | ACTION:$action";
    if (data != null) message += " | data:$data";
    if (flowId != null) message += " | flowId:$flowId";
    log(message);
  }

  /// Set user identity
  static void setUser(String userId) {
    _crash.setUserIdentifier(userId);
    setKey("user_state", "logged_in");
  }

  /// Clear user identity
  static void clearUser() {
    _crash.setUserIdentifier('');
    setKey("user_state", "logged_out");
  }

  /// Add custom metadata
  static Future<void> setKey(String key, dynamic value) async {
    await _crash.setCustomKey(key, value);
  }

  /// Global utility to wrap async calls with automatic error reporting
  static Future<T?> safeExecute<T>(
    Future<T> Function() fn, {
    required CrashErrorType type,
    String? reason,
    bool fatal = false,
  }) async {
    try {
      return await fn();
    } catch (e, s) {
      recordError(e, s, type: type, fatal: fatal, reason: reason);
      return null;
    }
  }

  /// Flow-level action tracker (avoids click-spam)
  static void trackAction(String flow, String action, {String? data}) {
    logFlow(flow, action, data: data);
  }
}
