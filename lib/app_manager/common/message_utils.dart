import 'package:astrobharataiuser/utils/error_ui_utils.dart';

class MessageUtils {
  static void showSuccess(String message, {String title = 'Success'}) {
    ErrorUiUtils.showSuccessSnackbar(message);
  }

  static void showError(String message, {String title = 'Error'}) {
    ErrorUiUtils.showWarningSnackbar(message);
  }

  static void showInfo(String message, {String title = 'Info'}) {
    ErrorUiUtils.showWarningSnackbar(message);
  }
}
