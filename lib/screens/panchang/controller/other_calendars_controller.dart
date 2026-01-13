import 'package:astrobharataiuser/core/base/baseController.dart';
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
      'icon': Icons.auto_awesome,
      'symbol': 'ॐ',
      'route': AppRoutes.hinduCalendarMonthlyPanchang,
    },
    {
      'title': 'Islamic Calendar',
      'icon': Icons.nightlight_round,
      'symbol': '☪',
      'route': null,
    },
    {
      'title': 'Jain Calendar',
      'icon': Icons.pan_tool,
      'symbol': '🕉',
      'route': AppRoutes.jainCalendar,
    },
    {
      'title': 'Tamil Calendar',
      'icon': Icons.text_fields,
      'symbol': 'த',
      'route': null,
    },
    {
      'title': 'Indian Calendar',
      'icon': Icons.people,
      'symbol': '🇮🇳',
      'route': null,
    },
    {
      'title': 'Telugu Calendar',
      'icon': Icons.text_fields,
      'symbol': 'వి',
      'route': null,
    },
    {
      'title': 'Moon Calendar',
      'icon': Icons.nightlight_round,
      'symbol': '🌙',
      'route': AppRoutes.moonCalendar,
    },
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

