import 'package:get_storage/get_storage.dart';

/// Manages guest session state in the app.
/// Tracks whether user is browsing as a guest.
class GuestSessionManager {
  static final GetStorage _storage = GetStorage('guestSession');
  static const String _isGuestKey = 'isGuest';

  /// Check if user is currently in guest mode
  static bool get isGuestMode {
    return _storage.read(_isGuestKey) ?? false;
  }

  /// Set guest mode to true
  static Future<void> enableGuestMode() async {
    await _storage.write(_isGuestKey, true);
  }

  /// Disable guest mode (when user logs in)
  static Future<void> disableGuestMode() async {
    await _storage.write(_isGuestKey, false);
  }

  /// Clear guest session data
  static Future<void> clearGuestSession() async {
    await _storage.remove(_isGuestKey);
  }
}
