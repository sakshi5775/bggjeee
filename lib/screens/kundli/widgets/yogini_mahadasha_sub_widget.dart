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

class YoginiMahadashaSubWidget extends StatelessWidget {
  final DashaController controller;

  const YoginiMahadashaSubWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYoginiSub.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.yoginiSubData.value;

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

      final response = data['response'] as List<dynamic>?;
      if (response == null || response.isEmpty) {
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
                      Icons.import_contacts,
                      color: AppColors.textLight,
                      size: 18.w,
                    ),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      'Yogini Dasha Sub',
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

            // Main Dasha Items
            ...response.map((item) {
              final mainDasha = item['main_dasha'] as String? ?? '';
              final mainDashaLord = item['main_dasha_lord'] as String? ?? '';
              final subDashaList =
                  item['sub_dasha_list'] as List<dynamic>? ?? [];
              final subDashaEndDates =
                  item['sub_dasha_end_dates'] as List<dynamic>? ?? [];
              final subDashaStartDate =
                  item['sub_dasha_start_dates'] as String? ?? '';

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.deepOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.r),
                          topRight: Radius.circular(12.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Main Dasha: $mainDasha',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                          Spacing.h(4),
                          AutoTranslateText(
                            'Lord: $mainDashaLord',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: AppColors.deepOrange,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                          ),
                          if (subDashaStartDate.isNotEmpty) ...[
                            Spacing.h(4),
                            AutoTranslateText(
                              'Start: ${_formatDate(subDashaStartDate)}',
                              style: MyTextTheme.smallBCN.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    ...List.generate(subDashaList.length, (index) {
                      final isLast = index == subDashaList.length - 1;
                      final subDasha = subDashaList[index].toString();
                      final endDate = index < subDashaEndDates.length
                          ? subDashaEndDates[index].toString()
                          : '';

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AutoTranslateText(
                                subDasha,
                                style: MyTextTheme.smallBCB.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                            AutoTranslateText(
                              _formatDate(endDate),
                              style: MyTextTheme.smallBCN.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      // Try parsing formats like "Sat, Mar 5, 2022, 06:00:00 PM"
      final formats = [
        'EEE, MMM d, yyyy, hh:mm:ss a',
        'EEE, MMM d, yyyy, h:mm:ss a',
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
