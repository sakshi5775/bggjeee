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

class MahadashaWidget extends StatelessWidget {
  final DashaController controller;

  const MahadashaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingMahadasha.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.mahadashaData.value;

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

      final mahadashaList = response['mahadasha'] as List<dynamic>? ?? [];
      final mahadashaOrder =
          response['mahadasha_order'] as List<dynamic>? ?? [];
      final startYear = response['start_year'] as int?;
      final dashaStartDate = response['dasha_start_date'] as String? ?? '';
      final dashaRemaining =
          response['dasha_remaining_at_birth'] as String? ?? '';

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
                border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.5), width: 1),
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          color: AppColors.textLight,
                          size: 18.w,
                        ),
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: AutoTranslateText(
                          'Mahadasha',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(10),
                  if (startYear != null)
                    _buildInfoCard('Start Year', startYear.toString()),
                  if (dashaStartDate.isNotEmpty)
                    _buildInfoCard(
                      'Dasha Start Date',
                      _formatDate(dashaStartDate),
                    ),
                  if (dashaRemaining.isNotEmpty)
                    _buildInfoCard('Dasha Remaining at Birth', dashaRemaining),
                ],
              ),
            ),

            Spacing.h(12),

            // Mahadasha List
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.5), width: 1),
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
                        Expanded(
                          flex: 2,
                          child: AutoTranslateText(
                            'Planet',
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
                  ...List.generate(mahadashaList.length, (index) {
                    final isLast = index == mahadashaList.length - 1;
                    final planet = mahadashaList[index].toString();
                    final endDate = index < mahadashaOrder.length
                        ? mahadashaOrder[index].toString()
                        : '';

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
                              planet,
                              style: MyTextTheme.smallBCB.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AutoTranslateText(
                              _formatDate(endDate),
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
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.deepOrange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoTranslateText(
              label,
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.sp,
              ),
            ),
          ),
          Spacing.w(8),
          AutoTranslateText(
            value,
            textAlign: TextAlign.right,
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.deepOrange,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
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

