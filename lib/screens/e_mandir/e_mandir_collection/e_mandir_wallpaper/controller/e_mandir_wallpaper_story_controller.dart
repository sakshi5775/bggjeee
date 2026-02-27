import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_collection/e_mandir_wallpaper/data_model/e_mandir_wallpaper_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:astrobharataiuser/core/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class EMandirWallpaperStoryController extends BaseController {
  late List<WallpaperItem> wallpapers;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      wallpapers = args['wallpapers'] as List<WallpaperItem>? ?? [];
      currentIndex.value = args['initialIndex'] as int? ?? 0;
    } else {
      wallpapers = [];
    }
  }

  Future<void> saveWallpaper(String imageUrl) async {
    try {
      // Request permission based on Android version
      bool hasPermission = false;
      if (Platform.isAndroid) {
        final androidInfo = await Permission.storage.request();
        final photosInfo = await Permission.photos.request();
        hasPermission = androidInfo.isGranted || photosInfo.isGranted;
      } else if (Platform.isIOS) {
        hasPermission =
            await Permission.photosAddOnly.request().isGranted ||
            await Permission.photos.request().isGranted;
      }

      if (!hasPermission) {
        Get.snackbar(
          'Permission Denied',
          'We need storage permission to save wallpapers to your gallery.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        'Downloading',
        'Please wait...',
        snackPosition: SnackPosition.BOTTOM,
      );

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Save to gallery safely
        final result = await ImageGallerySaverPlus.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 100,
          name: "SriMandir_Wallpaper_${DateTime.now().millisecondsSinceEpoch}",
        );

        if (result != null && result['isSuccess'] == true) {
          Get.snackbar(
            'Success',
            'Wallpaper saved to your Gallery!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save wallpaper to gallery.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to download wallpaper.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on MissingPluginException catch (e) {
      print('Plugin error: $e');
      Get.snackbar(
        'Restart App Required 🔄',
        'We added new save features. Please fully STOP and RESTART the app to load them.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
    } catch (e) {
      print('Save error: $e');
      Get.snackbar(
        'Error',
        'Save failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> shareWallpaper(String imageUrl) async {
    try {
      await ShareService.share(
        title: 'Divine Wallpaper – AstroBharatAI',
        message: 'Check out this beautiful wallpaper from Digital Mandir! 📱',
        path: 'wallpaper',
        queryParams: {
          'url': imageUrl,
        }, // Just an example of how they might share it
      );
    } catch (e) {
      print('Share error: $e');
    }
  }
}
