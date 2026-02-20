import 'dart:math';

import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
 


class Ui {
  static int milliseconds = 1500;

  static GetSnackBar SuccessSnackBar({String title = 'Success', required String message}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      titleText: AutoTranslateText(title.tr,style:  MyTextTheme.largeWCB.copyWith(
          color: Colors.white
      )),
      messageText: AutoTranslateText(message, style:  MyTextTheme.mediumWCB.copyWith(
          color: Colors.white
      )),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor: const Color.fromRGBO(0, 128, 0 ,1),
      icon: const Icon(Icons.check_circle_outline, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration:   const Duration(milliseconds: 2000),
    );
  }

  static GetSnackBar ErrorSnackBar({String title = 'Error',
    required String message}) {
    // Filter out "account has been deactivated" messages - don't log or show
    final msgLower = message.toLowerCase();
    if (msgLower.contains('account has been deactivated') ||
        msgLower.contains('no data: your account has been deactivated') ||
        msgLower.contains('error: your account has been deactivated')) {
      // Return a snackbar that won't be shown (empty message)
      return GetSnackBar(
        titleText: const SizedBox.shrink(),
        messageText: const SizedBox.shrink(),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        duration: const Duration(milliseconds: 1),
      );
    }
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: AutoTranslateText(title.tr, style:MyTextTheme.largeWCB.copyWith(
          color: Colors.white
      )
      ),
      messageText: AutoTranslateText(message.substring(0, min(message.length, 200))
          , style:  MyTextTheme.mediumWCB.copyWith(
            color: Colors.white
          )),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: const Color.fromRGBO(239, 95, 85, 1.0),
      icon: const Icon(Icons.error, size: 32,color:   Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration:   Duration(seconds:  3),
    );
  }

  static GetSnackBar InfoSnackBar({String title = 'Info', required String message}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      titleText: AutoTranslateText(
        title.tr,
        style: MyTextTheme.largeWCB.copyWith(color: Colors.white),
      ),
      messageText: AutoTranslateText(
        message,
        style: MyTextTheme.mediumWCB.copyWith(color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: const Color.fromRGBO(47, 128, 237, 1),
      icon: const Icon(Icons.info_outline, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: const Duration(milliseconds: 2000),
    );
  }

  static GetSnackBar defaultSnackBar({String title = 'Alert', required String message}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      titleText: AutoTranslateText(title.tr,
          style: MyTextTheme.largeWCB.copyWith(
              color: Colors.white
          )),
      messageText: AutoTranslateText(message,
          style : MyTextTheme.mediumWCB.copyWith(
              color: Colors.white
          )),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor:const Color.fromRGBO(255, 0, 0 , 1),
      borderColor: Colors.white.withValues(alpha: 0.5),
      icon: const Icon(Icons.warning_amber_rounded, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration:   Duration(milliseconds:  milliseconds),
    );
  }

  static GetSnackBar notificationSnackBar({String title = 'Notification',
    required String message, required OnTap onTap, required Widget mainButton}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      onTap: onTap,
      mainButton: mainButton,
      titleText: AutoTranslateText(title.tr, style: Get.textTheme.bodyLarge?.merge(const TextStyle(color: Colors.white))),
      messageText: AutoTranslateText(message, style: Get.textTheme.bodyMedium?.merge(const TextStyle(color:Colors.white))),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      backgroundColor: const Color.fromRGBO(0,0,255,1),
      borderColor: Get.theme.focusColor.withValues(alpha: 0.1),
      icon: const Icon(Icons.notifications_none, size: 32, color:Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration:   Duration(milliseconds:  milliseconds),
    );
  }

}

