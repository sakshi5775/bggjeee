
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // ✅ Android 13+ — only need notification for showing progress
      final notification = await Permission.notification.request();
      if (notification.isGranted) {
        print("✅ Notification permission granted (Android 13+).");
      } else {
        print("⚠️ Notification permission denied.");
      }

      // No direct storage permission needed for app-specific folder
      print("✅ Using app-specific storage — no file permission needed.");
      return true;
    } else if (sdkInt >= 30) {
      // ✅ Android 11–12
      final manage = await Permission.manageExternalStorage.request();
      if (manage.isGranted) {
        print("✅ Manage external storage granted.");
        return true;
      } else {
        print("⚠️ Please allow 'All files access' manually.");
        await openAppSettings();
        return false;
      }
    } else {
      // ✅ Android 10 and below
      final storage = await Permission.storage.request();
      if (storage.isGranted) {
        print("✅ Storage permission granted.");
        return true;
      } else {
        print("❌ Storage permission denied.");
        return false;
      }
    }
  }
}
