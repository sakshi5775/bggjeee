import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NamasteHomeController extends BaseController {
  final PageController darshanController = PageController();
  final RxInt currentDarshanIndex = 0.obs;

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
}
