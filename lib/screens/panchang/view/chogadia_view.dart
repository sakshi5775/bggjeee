import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/chogadia_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class ChogadiaView extends BasePage<ChogadiaController> {
  const ChogadiaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Obx(() {
          if (controller.isLoading.value && controller.allChogadias.isEmpty) {
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

                // Current Chogadia Section
                if (controller.currentChogadia.value != null)
                  _buildCurrentChogadiaSection(),

                Spacing.h(16),

                // Chogadia Table
                _buildChogadiaTable(),

                Spacing.h(20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return CommonHeader(title: 'Chogadia');
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
                          size: 18.h,
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
                          fontSize: 16,
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
                          size: 18.h,
                        ),
                      ),
                    ),
                  ),
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentChogadiaSection() {
    final chogadia = controller.currentChogadia.value!;
    final muhurat = chogadia['muhurat']?.toString() ?? '';
    final startStr = chogadia['start']?.toString() ?? '';
    final endStr = chogadia['end']?.toString() ?? '';
    final type = chogadia['type']?.toString() ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
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
              'Current Chogadia',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            AutoTranslateText(
              muhurat,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(4),
            AutoTranslateText(
              controller.formatTimeRange(startStr, endStr),
              style: MyTextTheme.smallBCN.copyWith(
                color: "#68171E".toColor().withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              type,
              style: MyTextTheme.smallBCN.copyWith(
                color: type.toLowerCase().contains('auspicious')
                    ? Colors.green
                    : type.toLowerCase().contains('inauspicious')
                    ? Colors.red
                    : "#68171E".toColor().withValues(alpha: 0.8),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChogadiaTable() {
    if (controller.allChogadias.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Center(
          child: AutoTranslateText(
            'No chogadia data available',
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
            'Chogadia Table',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18,
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
                    'Chogadia',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 14,
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
                      fontSize: 14,
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(8),
          // Chogadia rows (not scrollable, just a list)
          ...controller.allChogadias.asMap().entries.map((entry) {
            return _buildChogadiaRow(entry.value, entry.key);
          }),
        ],
      ),
    );
  }

  Widget _buildChogadiaRow(Map<String, dynamic> chogadia, int index) {
    final muhurat = chogadia['muhurat']?.toString() ?? '';
    final startStr = chogadia['start']?.toString() ?? '';
    final endStr = chogadia['end']?.toString() ?? '';

    return GestureDetector(
      onTap: () => _showChogadiaProperties(chogadia),
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
            // Chogadia name
            Expanded(
              flex: 2,
              child: AutoTranslateText(
                muhurat,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 15,
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
                  fontSize: 13,
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
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChogadiaProperties(Map<String, dynamic> chogadia) {
    final muhurat = chogadia['muhurat']?.toString() ?? '';
    final type = chogadia['type']?.toString() ?? '';

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AutoTranslateText(
          'Chogadia Properties',
          style: MyTextTheme.largeBCB.copyWith(
            color: "#68171E".toColor(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                '$muhurat chogadia is $type',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 14,
                ),
              ),
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
                  fontSize: 16,
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
