import 'package:astrobharataiuser/screens/kundli/controller/kundli_result_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/planets_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Planets tab: PlanetsWidget only (no card, no header).
class PlanetsTabWidget extends StatelessWidget {
  final KundliResultController controller;

  const PlanetsTabWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.planetDetailsData.value == null &&
        !controller.isLoadingPlanetDetails.value) {
      controller.fetchPlanetDetails();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      child: PlanetsWidget(controller: controller, embedded: true),
    );
  }
}
