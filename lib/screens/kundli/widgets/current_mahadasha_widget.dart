import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CurrentMahadashaWidget extends StatelessWidget {
  final DashaController controller;

  const CurrentMahadashaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCurrentMahadasha.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.currentMahadashaData.value;

      if (data == null || data.isEmpty) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      final response = data['response'] as Map<String, dynamic>?;
      if (response == null) {
        return Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.deepOrange.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.alarm_add_outlined,
                      color: AppColors.textLight,
                      size: 18.w,
                    ),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      'Current Mahadasha',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacing.h(12),

            // Order of Dashas Section
            if (response['order_of_dashas'] != null)
              _buildOrderOfDashasSection(
                response['order_of_dashas'] as Map<String, dynamic>,
              ),

            Spacing.h(12),

            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.deepOrange.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.timeline,
                      color: AppColors.textLight,
                      size: 18.w,
                    ),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      'Current Dashas',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacing.h(12),

            // Current Dashas Table
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.deepOrange.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Dasha',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Planet',
                            textAlign: TextAlign.center,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Start Date',
                            textAlign: TextAlign.center,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'End Date',
                            textAlign: TextAlign.right,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Table Rows
                  ...[
                    if (response['mahadasha'] != null)
                      _buildTableRow(
                        'Mahadasha',
                        response['mahadasha'] as Map<String, dynamic>,
                        response['Pranadasha'] == null &&
                            response['Shookshamadasha'] == null &&
                            response['paryantardasha'] == null &&
                            response['antardasha'] == null,
                      ),
                    if (response['antardasha'] != null)
                      _buildTableRow(
                        'Antar Dasha',
                        response['antardasha'] as Map<String, dynamic>,
                        response['Pranadasha'] == null &&
                            response['Shookshamadasha'] == null &&
                            response['paryantardasha'] == null,
                      ),
                    if (response['paryantardasha'] != null)
                      _buildTableRow(
                        'Paryantar Dasha',
                        response['paryantardasha'] as Map<String, dynamic>,
                        response['Pranadasha'] == null &&
                            response['Shookshamadasha'] == null,
                      ),
                    if (response['Shookshamadasha'] != null)
                      _buildTableRow(
                        'Shooksham Dasha',
                        response['Shookshamadasha'] as Map<String, dynamic>,
                        response['Pranadasha'] == null,
                      ),
                    if (response['Pranadasha'] != null)
                      _buildTableRow(
                        'Pran Dasha',
                        response['Pranadasha'] as Map<String, dynamic>,
                        true,
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderOfDashasSection(Map<String, dynamic> orderOfDashas) {
    // Collect all order items
    final List<Map<String, dynamic>> orderItems = [];

    if (orderOfDashas['major'] != null) {
      orderItems.add({
        'type': 'Major',
        'data': orderOfDashas['major'] as Map<String, dynamic>,
      });
    }
    if (orderOfDashas['minor'] != null) {
      orderItems.add({
        'type': 'Minor',
        'data': orderOfDashas['minor'] as Map<String, dynamic>,
      });
    }
    if (orderOfDashas['sub_minor'] != null) {
      orderItems.add({
        'type': 'Sub Minor',
        'data': orderOfDashas['sub_minor'] as Map<String, dynamic>,
      });
    }
    if (orderOfDashas['sub_sub_minor'] != null) {
      orderItems.add({
        'type': 'Sub Sub Minor',
        'data': orderOfDashas['sub_sub_minor'] as Map<String, dynamic>,
      });
    }
    if (orderOfDashas['sub_sub_sub_minor'] != null) {
      orderItems.add({
        'type': 'Sub Sub Sub Minor',
        'data': orderOfDashas['sub_sub_sub_minor'] as Map<String, dynamic>,
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.deepOrange.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.deepOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.timeline,
                    color: AppColors.textLight,
                    size: 16.w,
                  ),
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    'Order of Dashas',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.deepOrange.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Type',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Planet',
                    textAlign: TextAlign.center,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'Start Date',
                    textAlign: TextAlign.center,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AutoTranslateText(
                    'End Date',
                    textAlign: TextAlign.right,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table Rows
          ...orderItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == orderItems.length - 1;
            final type = item['type'] as String;
            final data = item['data'] as Map<String, dynamic>;
            final name = data['name'] as String? ?? '';
            final start = data['start'] as String? ?? '';
            final end = data['end'] as String? ?? '';

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isLast
                        ? Colors.transparent
                        : AppColors.deepOrange.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.deepOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: AutoTranslateText(
                        type,
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoTranslateText(
                      name,
                      textAlign: TextAlign.center,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoTranslateText(
                      _formatDate(start),
                      textAlign: TextAlign.center,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: AutoTranslateText(
                      _formatDate(end),
                      textAlign: TextAlign.right,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTableRow(String title, Map<String, dynamic> item, bool isLast) {
    final name = item['name'] as String? ?? '';
    final start = item['start'] as String? ?? '';
    final end = item['end'] as String? ?? '';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast
                ? Colors.transparent
                : AppColors.deepOrange.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              title,
              style: MyTextTheme.smallBCB.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              name,
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.deepOrange,
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              _formatDate(start),
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.sp,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoTranslateText(
              _formatDate(end),
              textAlign: TextAlign.right,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final formats = [
        'EEE MMM dd yyyy',
        'EEE, MMM dd yyyy',
        'MMM dd yyyy',
        'dd/MM/yyyy',
      ];

      for (final format in formats) {
        try {
          final date = DateFormat(format).parse(dateStr);
          return DateFormat('dd/MM/yyyy').format(date);
        } catch (e) {
          continue;
        }
      }

      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }
}
