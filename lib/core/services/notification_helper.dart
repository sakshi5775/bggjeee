import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Static utility class for notification-related helpers.
///
/// Keeps navigation / UI logic separate from the OneSignal service so
/// [NotificationService] stays focused on SDK communication.
class NotificationHelper {
  NotificationHelper._(); // prevent instantiation

  // ── Deep-link navigation ────────────────────────────────────────

  /// Parse the notification payload and navigate to the correct screen.
  ///
  /// The [data] map comes from `notification.additionalData` and
  /// should contain a `type` key (and optionally an `id`) set by your
  /// backend when creating the notification in OneSignal.
  ///
  /// Example payloads from backend:
  /// ```json
  /// { "type": "chat",         "id": "astrologer_123" }
  /// { "type": "booking",      "id": "booking_456"    }
  /// { "type": "horoscope"                             }
  /// { "type": "offer",        "id": "offer_789"      }
  /// ```
  static void handleNotificationNavigation(Map<String, dynamic> data) {
    debugPrint('[NotificationHelper] Handling navigation with data: $data');

    final String type = (data['type'] ?? '').toString().toLowerCase();
    final String? id = data['id']?.toString();

    // Defer navigation until the app is fully ready (covers the
    // terminated → cold-start scenario where GetMaterialApp may not
    // yet have a navigator context).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateByType(type, id, data);
    });
  }

  /// Route to the appropriate screen based on notification [type].
  ///
  /// Extend this switch-case as you add more notification types on
  /// the backend.
  static void _navigateByType(
    String type,
    String? id,
    Map<String, dynamic> data,
  ) {
    try {
      switch (type) {
        // ── Chat notification ──
        case 'chat':
          if (id != null) {
            Get.toNamed(
              AppRoutes.chat,
              arguments: {'astrologerId': id, ...data},
            );
          }
          break;

        // ── Call notification ──
        case 'call':
          if (id != null) {
            Get.toNamed(
              AppRoutes.astrologerVoiceCall,
              arguments: {'channelId': id, ...data},
            );
          }
          break;

        // ── Booking / appointment ──
        case 'booking':
          Get.toNamed(AppRoutes.booking, arguments: {'bookingId': id, ...data});
          break;

        // ── Daily horoscope ──
        case 'horoscope':
          Get.toNamed(AppRoutes.horoscope);
          break;

        // ── Promotional / offer ──
        case 'offer':
        case 'promotion':
          // Navigate to the dashboard; specific offer detail can be
          // added later when an offer-detail screen exists.
          Get.toNamed(AppRoutes.userDashboard);
          break;

        // ── Default: open dashboard ──
        default:
          debugPrint(
            '[NotificationHelper] Unknown notification type: "$type", '
            'navigating to dashboard',
          );
          Get.toNamed(AppRoutes.userDashboard);
          break;
      }
    } catch (e) {
      debugPrint('[NotificationHelper] Navigation error: $e');
      // Fallback: try to open dashboard
      try {
        Get.toNamed(AppRoutes.userDashboard);
      } catch (_) {
        // Navigation system not ready; silently ignore
      }
    }
  }

  // ── In-app notification banner ──────────────────────────────────

  /// Display a styled in-app notification banner (GetX SnackBar)
  /// when a push arrives while the app is in the foreground.
  static void showInAppNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    // Avoid showing empty notifications
    if (title.isEmpty && body.isEmpty) return;

    Get.snackbar(
      title.isNotEmpty ? title : 'Notification',
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderRadius: 12,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      icon: const Padding(
        padding: EdgeInsets.only(left: 12),
        child: Icon(
          Icons.notifications_active_rounded,
          color: Color(0xFFFF9933), // saffron accent
          size: 28,
        ),
      ),
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 400),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      onTap: (_) {
        // When user taps the in-app banner, navigate
        if (data != null && data.isNotEmpty) {
          handleNotificationNavigation(data);
        }
      },
    );
  }
}
