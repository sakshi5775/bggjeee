import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

class NamasteHomeController extends GetxController {
  final selectedIndex = 0.obs;
  final PageController darshanController = PageController();
  final currentDarshanIndex = 0.obs;

  final List<String> darshanImages = [
    AppConstant.eMandirLiveDarshan,
    AppConstant.eMandirLiveDarshan,
    AppConstant.eMandirLiveDarshan,
    AppConstant.eMandirLiveDarshan,
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
