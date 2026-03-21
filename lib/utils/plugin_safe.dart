import 'package:astrobharataiuser/core/services/crashlytics_service.dart';

/// Runs third-party plugin callbacks so exceptions are logged and do not
/// tear down the Flutter isolate.
void guardPluginCallback(
  String reason,
  void Function() action, {
  CrashErrorType type = CrashErrorType.unknown,
}) {
  try {
    action();
  } catch (e, s) {
    CrashlyticsService.recordError(
      e,
      s,
      fatal: false,
      type: type,
      reason: reason,
    );
  }
}
