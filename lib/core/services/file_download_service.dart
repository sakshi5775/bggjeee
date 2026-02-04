import 'dart:io';

import 'package:astrobharataiuser/core/services/permission_service.dart';
import 'package:astrobharataiuser/utils/error_ui_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadService {
  static Future<void> downloadFile(String url, String fileName) async {
    try {
      // Request storage permission
      bool granted = await PermissionService.requestStoragePermission();
      if (!granted) {
        ErrorUiUtils.showWarningSnackbar(
          "Please grant storage permission to download files.",
        );
        print("Permission not granted!");
        return;
      }

      // ✅ Get directory depending on Android version
      String savedDir;

      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (Platform.isAndroid) {
        if (sdkInt >= 33) {
          // Use app-specific external storage (no MANAGE_EXTERNAL_STORAGE needed)
          final dir = await getExternalStorageDirectory();
          savedDir = dir!.path;
        } else if (sdkInt >= 30) {
          // Android 11–12 (still possible to use Download folder)
          savedDir = "/storage/emulated/0/Download";
        } else {
          // Android 10 and below
          savedDir = "/storage/emulated/0/Download";
        }
      } else {
        // iOS or others
        final dir = await getApplicationDocumentsDirectory();
        savedDir = dir.path;
      }

      // Ensure directory exists
      Directory(savedDir).createSync(recursive: true);

      // Start download
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: savedDir,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      // Show success message
      ErrorUiUtils.showSuccessSnackbar(
        "File download has started successfully",
      );

      print("✅ Download started with Task ID: $taskId");
    } catch (e) {
      // Show error message
      ErrorUiUtils.showWarningSnackbar("File download failed");
      print("Error downloading file: $e");
    }
  }
}
