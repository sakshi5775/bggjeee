import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:get/get.dart';
import 'api_helper_mixin.dart';
import 'navigation_service.dart';

abstract class BaseController extends GetxController
    with NavigationService, ApiHelperMixin {
  /// Centralized error reporting for all child controllers
  void reportError(
    dynamic e,
    StackTrace s, {
    CrashErrorType type = CrashErrorType.unknown,
    String? reason,
    bool fatal = false,
  }) {
    CrashlyticsService.recordError(
      e,
      s,
      type: type,
      reason: reason,
      fatal: fatal,
    );
  }
}

abstract class BasePage<T extends BaseController> extends GetView<T> {
  const BasePage({super.key});
}
