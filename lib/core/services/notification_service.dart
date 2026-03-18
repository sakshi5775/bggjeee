import 'dart:async';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/services/notification_helper.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart';

/// Core notification service using OneSignal.
///
/// Handles SDK initialization, permission management, lifecycle-aware
/// notification handling (foreground, background, terminated), and
/// user identity linking for targeted push from the backend.
///
/// Register as a permanent [GetxService] so it persists across the
/// entire app lifecycle.
class NotificationService extends GetxService {
  // ── Singleton accessor ──────────────────────────────────────────
  static NotificationService get instance => Get.find<NotificationService>();

  // ── Observable state ────────────────────────────────────────────
  final RxBool isPermissionGranted = false.obs;
  final RxString playerId = ''.obs;
  final RxBool isInitialized = false.obs;

  // ── Initialisation ──────────────────────────────────────────────

  bool _isMissingOneSignalPlugin(Object error) {
    // MissingPluginException text can differ by platform/device; treat any
    // MissingPluginException (or OneSignal-related missing method) as non-fatal.
    if (error is MissingPluginException) return true;
    return error.toString().contains('MissingPluginException') ||
        error.toString().contains('OneSignal');
  }

  void _logNonFatalPluginError(Object error, StackTrace stackTrace) {
    debugPrint('[NotificationService] Non-fatal plugin error: $error');
    debugPrint('[NotificationService] Stack: $stackTrace');
  }

  /// Call once from [main.dart] after dependency injection.
  Future<NotificationService> init() async {
    try {
      // Enable verbose logging in debug mode only
      if (kDebugMode) {
        try {
          OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
        } catch (e, st) {
          if (_isMissingOneSignalPlugin(e)) {
            _logNonFatalPluginError(e, st);
            return this;
          }
          rethrow;
        }
      }

      // Initialise SDK
      try {
        OneSignal.initialize(AppConstant.oneSignalAppId);
      } catch (e, st) {
        if (_isMissingOneSignalPlugin(e)) {
          _logNonFatalPluginError(e, st);
          return this;
        }
        rethrow;
      }

      // Setup all notification handlers
      try {
        _setupNotificationHandlers();
        _setupPermissionObserver();
        _setupSubscriptionObserver();
      } catch (e, st) {
        if (_isMissingOneSignalPlugin(e)) {
          _logNonFatalPluginError(e, st);
          return this;
        }
        rethrow;
      }

      // Fetch initial subscription / permission state
      _syncInitialState();

      isInitialized.value = true;
      debugPrint('[NotificationService] Initialised successfully');
    } catch (e, stackTrace) {
      debugPrint('[NotificationService] Init error: $e');
      debugPrint('[NotificationService] Stack: $stackTrace');
    }
    return this;
  }

  // ── Permission ──────────────────────────────────────────────────

  /// Request push notification permission.
  ///
  /// On Android 13+ this triggers the runtime dialog; on older Android
  /// versions permission is granted at install. On iOS it always shows
  /// the native prompt.
  Future<bool> requestPermission() async {
    try {
      final granted = await OneSignal.Notifications.requestPermission(true);
      isPermissionGranted.value = granted;
      debugPrint('[NotificationService] Permission granted: $granted');
      return granted;
    } catch (e, st) {
      debugPrint('[NotificationService] Permission request error: $e');
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
      }
      return false;
    }
  }

  // ── User identity ───────────────────────────────────────────────

  /// Link the logged-in user's backend ID so the server can target
  /// notifications to this specific device/user pair.
  Future<void> setExternalUserId(String userId) async {
    if (userId.isEmpty) return;
    try {
      // `login()` can fail asynchronously depending on plugin/native readiness.
      // Await so MissingPluginException stays inside this try/catch.
      await OneSignal.login(userId);
      debugPrint('[NotificationService] External user ID set: $userId');
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
        return;
      }
      debugPrint('[NotificationService] setExternalUserId error: $e');
    }
  }

  /// Unlink the user on logout so the device stops receiving
  /// user-targeted notifications.
  Future<void> removeExternalUserId() async {
    try {
      // `logout()` can also fail asynchronously; keep it inside try/catch.
      await OneSignal.logout();
      debugPrint('[NotificationService] External user ID removed');
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
        return;
      }
      debugPrint('[NotificationService] removeExternalUserId error: $e');
    }
  }

  /// Link user after login using data from [UserData].
  void linkCurrentUser() {
    final userId = UserData().getLoginData.user?.userId;
    if (userId != null && userId.isNotEmpty) {
      setExternalUserId(userId);
    }
  }

  // ── Subscription helpers ────────────────────────────────────────

  /// Get the OneSignal subscription (player) ID.
  /// The backend can use this to target individual devices.
  String? getSubscriptionId() {
    try {
      return OneSignal.User.pushSubscription.id;
    } catch (_) {
      return null;
    }
  }

  /// Get the device push token (FCM on Android, APNs on iOS).
  String? getPushToken() {
    try {
      return OneSignal.User.pushSubscription.token;
    } catch (_) {
      return null;
    }
  }

  // ── Private: Handlers ───────────────────────────────────────────

  /// Register notification event handlers for all lifecycle states.
  void _setupNotificationHandlers() {
    // ── Foreground ──
    // Fires when a notification arrives while the app is in the
    // foreground.  We intercept it to show a custom in-app banner
    // and prevent the default system notification.
    try {
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        try {
          debugPrint('[NotificationService] Foreground notification received');

          final notification = event.notification;
          final title = notification.title ?? '';
          final body = notification.body ?? '';
          final data = notification.additionalData ?? {};

          // Show a styled in-app banner (top snackbar)
          NotificationHelper.showInAppNotification(
            title: title,
            body: body,
            data: data,
          );

          // Also display the system notification in the status bar
          // so the user sees it even if the in-app banner is missed.
          event.notification.display();
        } catch (e, st) {
          if (_isMissingOneSignalPlugin(e)) {
            _logNonFatalPluginError(e, st);
            return;
          }
          // Keep foreground notification handling non-fatal.
          debugPrint('[NotificationService] Foreground listener error: $e');
        }
      });
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
        return;
      }
      rethrow;
    }

    // ── Background / Terminated (notification tapped) ──
    // Fires when user taps a notification that arrived while the app
    // was in background or terminated state.
    try {
      OneSignal.Notifications.addClickListener((event) {
        try {
          debugPrint('[NotificationService] Notification clicked');
          // If you enable deep-link navigation from background notifications,
          // keep it inside a try/catch so missing OneSignal native plugin
          // can't crash the app.
        } catch (e, st) {
          if (_isMissingOneSignalPlugin(e)) {
            _logNonFatalPluginError(e, st);
            return;
          }
          debugPrint('[NotificationService] Click listener error: $e');
        }
      });
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
        return;
      }
      rethrow;
    }
  }

  /// Observe permission state changes at runtime.
  void _setupPermissionObserver() {
    try {
      OneSignal.Notifications.addPermissionObserver((granted) {
        try {
          isPermissionGranted.value = granted;
          debugPrint('[NotificationService] Permission changed: $granted');
        } catch (_) {
          // Keep observer non-fatal.
        }
      });
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
      }
    }
  }

  /// Observe push subscription changes (player ID / push token).
  void _setupSubscriptionObserver() {
    try {
      OneSignal.User.pushSubscription.addObserver((state) {
        try {
          final id = state.current.id;
          final token = state.current.token;
          playerId.value = id ?? '';

          debugPrint('[NotificationService] Subscription changed');
          debugPrint('[NotificationService] Player ID: $id');
          debugPrint('[NotificationService] Push Token: $token');
        } catch (_) {
          // Keep observer non-fatal.
        }
      });
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
      }
    }
  }

  /// Read the current permission & subscription state at startup.
  void _syncInitialState() {
    try {
      isPermissionGranted.value = OneSignal.Notifications.permission;
      playerId.value = OneSignal.User.pushSubscription.id ?? '';
    } catch (e, st) {
      if (_isMissingOneSignalPlugin(e)) {
        _logNonFatalPluginError(e, st);
        return;
      }
      rethrow;
    }

    debugPrint(
      '[NotificationService] Initial permission: ${isPermissionGranted.value}',
    );
    debugPrint('[NotificationService] Initial player ID: ${playerId.value}');
  }

  // ── Lifecycle ───────────────────────────────────────────────────

  @override
  void onClose() {
    // OneSignal handles its own cleanup; nothing special needed.
    super.onClose();
  }
}
