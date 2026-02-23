import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:get/get.dart';

class AuthService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  Future<bool> refreshAccessToken() async {
    final refreshToken = UserData().getLoginData.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _apiRepository.postApi(EndPoints.refreshToken, {
        'refreshToken': refreshToken,
      }, useAuthHeader: false);

      if (response.body?['success'] == true) {
        final data = response.body?['data'] ?? {};
        final newAccess = data['accessToken']?.toString();
        final newRefresh = data['refreshToken']?.toString();

        if (newAccess != null && newAccess.isNotEmpty) {
          UserData().updateTokens(
            accessToken: newAccess,
            refreshToken: newRefresh,
          );
          return true;
        }
      }
    } catch (e) {
      CrashlyticsService.trackAction(
        "AUTH",
        "TOKEN_REFRESH_FAIL",
        data: e.toString(),
      );
      // Swallow errors here; caller will handle session expiration.
    }
    return false;
  }

  Future<bool> logout({bool logoutFromAllDevices = false}) async {
    try {
      if (logoutFromAllDevices) {
        final response = await _apiRepository.postApi(
          EndPoints.logoutAll,
          const {},
        );
        if (response.body?['success'] == true) {
          forceLogout(message: 'Logged out from all devices successfully.');
          return true;
        } else {
          // Even if API fails, clear local data
          final errorMsg =
              response.body?['message']?.toString() ??
              'Unable to logout from all devices.';
          forceLogout(message: 'Logged out locally. $errorMsg');
          return true;
        }
      } else {
        final refreshToken = UserData().getLoginData.refreshToken;
        if (refreshToken == null || refreshToken.isEmpty) {
          forceLogout();
          return true;
        }

        try {
          final response = await _apiRepository.postApi(EndPoints.logout, {
            'refreshToken': refreshToken,
          });
          if (response.body?['success'] == true) {
            forceLogout(message: 'Logged out successfully.');
            return true;
          } else {
            // Check if it's a token mismatch error (403)
            final statusCode = response.statusCode;
            final errorMsg =
                response.body?['message']?.toString() ?? 'Unable to logout.';

            if (statusCode == 403 ||
                errorMsg.toLowerCase().contains('another user') ||
                errorMsg.toLowerCase().contains('token')) {
              // Token mismatch - clear local data anyway
              forceLogout(message: 'Logged out successfully.');
              return true;
            } else {
              // Other errors - still logout locally
              forceLogout(message: 'Logged out locally. $errorMsg');
              return true;
            }
          }
        } catch (e) {
          // If API call fails (network error, etc.), still logout locally
          final errorStr = e.toString().toLowerCase();
          if (errorStr.contains('403') ||
              errorStr.contains('forbidden') ||
              errorStr.contains('another user') ||
              errorStr.contains('token')) {
            forceLogout(message: 'Logged out successfully.');
            return true;
          }
          // For other errors, still logout locally but show message
          forceLogout(
            message: 'Logged out locally. Please check your connection.',
          );
          return true;
        }
      }
    } catch (e) {
      // If anything fails, still clear local data
      CrashlyticsService.trackAction(
        "AUTH",
        "LOGOUT_EXCEPTION",
        data: e.toString(),
      );
      forceLogout(message: 'Logged out locally.');
      return true;
    }
  }

  void forceLogout({String? message}) {
    // Unlink user from OneSignal notifications
    if (Get.isRegistered<NotificationService>()) {
      NotificationService.instance.removeExternalUserId();
    }

    if (message != null && message.isNotEmpty) {
      showInfoMessage(title: 'Session ended', message: message);
    }
    UserData().removeUserData();
  }
}
