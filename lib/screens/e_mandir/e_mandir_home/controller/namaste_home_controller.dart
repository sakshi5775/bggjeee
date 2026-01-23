import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NamasteHomeController extends GetxController {
  final selectedIndex = 0.obs;
  final PageController darshanController = PageController();
  final currentDarshanIndex = 0.obs;

  final List<String> darshanImages = [
    "assets/images/live_darshan.png",
    "assets/images/live_darshan.png",
    "assets/images/live_darshan.png",
    "assets/images/live_darshan.png",
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    darshanController.dispose();
    super.onClose();
  }

  void onDarshanPageChanged(int index) {
    currentDarshanIndex.value = index;
  }

  void navigateToVirtualDarshan() {
    Get.toNamed('/virtual-darshan');
  }

  void navigateToDevotionalLibrary() {
    Get.toNamed('/devotional-library');
  }

  void navigateToPunyaMudra() {
    Get.toNamed('/punya-mudra');
  }
}
