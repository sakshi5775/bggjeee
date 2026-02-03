import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/hora_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class HoraView extends BasePage<HoraController> {
  const HoraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.horas.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.templeGold),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Date Selector
                  _buildDateSelector(),

                  Spacing.h(16),

                  // Current Hora Section
                  if (controller.currentHora.value != null)
                    _buildCurrentHoraSection(),

                  Spacing.h(16),

                  // Hora Table
                  _buildHoraTable(),

                  Spacing.h(20),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CommonHeader(title: 'Hora');
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          // Date display
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8.w,
                children: [
                  // Spacing.w(2),
                  GestureDetector(
                    onTap: () => controller.previousDay(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.orangeGradient,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Obx(
                      () => AutoTranslateText(
                        DateFormat(
                          'dd - MMM - yyyy',
                        ).format(controller.selectedDate.value).toUpperCase(),
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#68171E".toColor(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.nextDay(),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.orangeGradient,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 18.w,
                        ),
                      ),
                    ),
                  ),
                  // Spacing.w(2),
                ],
              ),
            ),
          ),
          Spacing.w(16),

          // Today button
          GestureDetector(
            onTap: () => controller.goToToday(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                'Today',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentHoraSection() {
    final hora = controller.currentHora.value!;
    final planet = hora['hora']?.toString() ?? '';
    final startStr = hora['start']?.toString() ?? '';
    final endStr = hora['end']?.toString() ?? '';
    final benefits = hora['benefits']?.toString() ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Current Hora',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            AutoTranslateText(
              planet,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(4),
            AutoTranslateText(
              controller.formatTimeRange(startStr, endStr),
              style: MyTextTheme.smallBCN.copyWith(
                color: "#68171E".toColor().withValues(alpha: 0.7),
                fontSize: 14.sp,
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              benefits.isNotEmpty
                  ? benefits
                  : 'Auspicious for various activities',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#68171E".toColor().withValues(alpha: 0.8),
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoraTable() {
    if (controller.horas.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: AutoTranslateText(
            'No hora data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#68171E".toColor().withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h(8),
          AutoTranslateText(
            'Hora Table',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Planet',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Start Time',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'End Time',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(8),
          // Hora rows (not scrollable, just a list)
          ...controller.horas.asMap().entries.map((entry) {
            return _buildHoraRow(entry.value, entry.key);
          }),
        ],
      ),
    );
  }

  Widget _buildHoraRow(Map<String, dynamic> hora, int index) {
    final planet = hora['hora']?.toString() ?? '';
    final startStr = hora['start']?.toString() ?? '';
    final endStr = hora['end']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _showHoraProperties(hora),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Planet name
            Expanded(
              flex: 2,
              child: AutoTranslateText(
                planet,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacing.w(8),
            // Start time
            Expanded(
              flex: 2,
              child: AutoTranslateText(
                controller.formatTime(startStr),
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#68171E".toColor().withValues(alpha: 0.7),
                  fontSize: 13.sp,
                ),
              ),
            ),
            Spacing.w(8),
            // End time
            Expanded(
              flex: 2,
              child: AutoTranslateText(
                controller.formatTime(endStr),
                style: MyTextTheme.smallBCN.copyWith(
                  color: "#68171E".toColor().withValues(alpha: 0.7),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHoraProperties(Map<String, dynamic> hora) {
    final planet = hora['hora']?.toString() ?? '';
    final benefits = hora['benefits']?.toString() ?? '';
    final luckyGem = hora['lucky_gem']?.toString() ?? '';

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AutoTranslateText(
          'Hora Properties',
          style: MyTextTheme.largeBCB.copyWith(
            color: "#68171E".toColor(),
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                benefits.isNotEmpty
                    ? '$planet hora is $benefits'
                    : '$planet hora properties',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 14.sp,
                ),
              ),
              if (luckyGem.isNotEmpty) ...[
                Spacing.h(12),
                AutoTranslateText(
                  'Lucky Gem: $luckyGem',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#68171E".toColor(),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextButton(
              onPressed: () => Get.back(),
              child: AutoTranslateText(
                'OK',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
