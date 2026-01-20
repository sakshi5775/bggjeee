import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/widgets/offering_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualDarshanController extends BaseController {
  // Method to open offering bottom sheet
  void openOfferingBottomSheet() {
    Get.bottomSheet(
      const OfferingBottomSheetWidget(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.only(topLeft: 20, topRight: 20),
      ),
    );
  }
}
