import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LocationPromptHelper {
  /// Checks if location services are enabled and permissions are granted.
  /// If services are disabled, shows a prompt to redirect to settings.
  /// If user enables it and returns, it automatically fetches and returns the position.
  static Future<Position?> checkAndGetLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      bool? result = await showLocationPrompt();
      if (result == true) {
        await Geolocator.openLocationSettings();

        // Polling to detect when user turns it on (max 60 seconds)
        int count = 0;
        while (!await Geolocator.isLocationServiceEnabled() && count < 60) {
          await Future.delayed(const Duration(seconds: 1));
          count++;
        }

        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return null;
      } else {
        return null;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null; // Denied by user
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // We could show another prompt to open app settings here if needed.
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      debugPrint('Error getting current position: $e');
      return null;
    }
  }

  /// Shows the location prompt dialog.
  static Future<bool?> showLocationPrompt() async {
    return await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Icons.location_off, color: AppColors.deepOrange, size: 24.w),
            SizedBox(width: 8.w),
            Expanded(
              child: AutoTranslateText(
                'Location Required',
                style: MyTextTheme.largeBCB.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.textColorMaroon,
                ),
              ),
            ),
          ],
        ),
        content: AutoTranslateText(
          'Your location is off. Do you want to turn on your location to fetch the data automatically?',
          style: MyTextTheme.mediumBCN.copyWith(
            fontSize: 14.sp,
            color: AppColors.gray,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: AutoTranslateText(
              'No',
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.gray,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: AutoTranslateText(
              'Yes',
              style: MyTextTheme.mediumBCN.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
