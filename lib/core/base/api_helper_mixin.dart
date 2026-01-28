import 'package:astrobharataiuser/utils/getx_snackbar.dart';
import 'package:get/get.dart';

mixin ApiHelperMixin {
  final RxBool _isLoading = false.obs;

  void setLoadingState(bool loading) {
    _isLoading.value = loading;
  }

  RxBool get isLoading => _isLoading;

  void showErrorMessage({String title = "Error", required String message}) {
    // Filter out "account has been deactivated" messages - don't show snackbar at all
    final msgLower = message.toLowerCase();
    if (msgLower.contains('account has been deactivated') ||
        msgLower.contains('no data: your account has been deactivated') ||
        msgLower.contains('error: your account has been deactivated')) {
      // Don't show snackbar for this message - just return silently
      return;
    }
    Get.showSnackbar(Ui.ErrorSnackBar(title: title, message: message));
  }

  void showSuccessMessage({String title = "Success", required String message}) {
    Get.showSnackbar(Ui.SuccessSnackBar(title: title, message: message));
  }

  void showInfoMessage({String title = "Info", required String message}) {
    Get.showSnackbar(Ui.InfoSnackBar(title: title, message: message));
  }
}
