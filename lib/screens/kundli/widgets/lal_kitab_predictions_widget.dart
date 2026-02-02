import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/predictions_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'lal_kitab_debt_predictions_widget.dart';
import 'lal_kitab_remedies_predictions_widget.dart';

/// Lal Kitab Debt and Remedies sections within Predictions view.
/// Composes LalKitabDebtPredictionsWidget and LalKitabRemediesPredictionsWidget.
class LalKitabPredictionsWidget extends StatelessWidget {
  final PredictionsController controller;

  const LalKitabPredictionsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final debtsLoading = controller.isLoadingLalKitabDebts.value;
      final remediesLoading = controller.isLoadingLalKitabRemedies.value;
      final debtsData = controller.lalKitabDebtsData.value;
      final remediesData = controller.lalKitabRemediesData.value;

      if (debtsLoading && remediesLoading && debtsData == null && remediesData == null) {
        return Center(
          child: CircularProgressIndicator(color: '#ed6f30'.toColor()),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LalKitabDebtPredictionsWidget(controller: controller),
            Spacing.h(20),
            LalKitabRemediesPredictionsWidget(controller: controller),
          ],
        ),
      );
    });
  }
}
