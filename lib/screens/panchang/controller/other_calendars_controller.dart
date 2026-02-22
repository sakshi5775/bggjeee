import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtherCalendarsController extends BaseController {
  // Selected year
  final selectedYear = DateTime.now().year.obs;

  // Calendar options data
  final List<Map<String, dynamic>> calendarOptions = [
    {
      'title': 'Hindu Calendar',
      'symbol': '🕉️',
      'route': AppRoutes.hinduCalendarMonthlyPanchang,
    },
    {
      'title': 'Jain Calendar',
      'symbol': '🕉️',
      'route': AppRoutes.jainCalendar,
    },
    {'title': 'Moon Calendar', 'symbol': '🌙', 'route': AppRoutes.moonCalendar},
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void onCalendarTap(Map<String, dynamic> calendar) {
    final route = calendar['route'] as String?;
    if (route != null) {
      Get.toNamed(route);
    } else {
      final title = calendar['title'] as String;
      Get.snackbar(
        'Coming Soon',
        '$title feature will be available soon',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectYear(int year) {
    selectedYear.value = year;
  }
}
