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

class YoginiMahadashaMainWidget extends StatelessWidget {
  final DashaController controller;

  const YoginiMahadashaMainWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingYoginiMain.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final data = controller.yoginiMainData.value;

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

      final dashaList = response['dasha_list'] as List<dynamic>? ?? [];
      final dashaEndDates = response['dasha_end_dates'] as List<dynamic>? ?? [];
      final dashaLordList = response['dasha_lord_list'] as List<dynamic>? ?? [];
      final startDate = response['start_date'] as int? ?? 0;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.import_contacts,
                          color: AppColors.textLight,
                          size: 18.w,
                        ),
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: AutoTranslateText(
                          'Yogini Dasha Main',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (startDate > 0) ...[
                    Spacing.h(6),
                    AutoTranslateText(
                      'Start Date: $startDate',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Spacing.h(12),

            // Dasha List
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
                            'Lord',
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

                  ...List.generate(dashaList.length, (index) {
                    final isLast = index == dashaList.length - 1;
                    final dasha = dashaList[index].toString();
                    final lord = index < dashaLordList.length
                        ? dashaLordList[index].toString()
                        : '';
                    final endDate = index < dashaEndDates.length
                        ? dashaEndDates[index].toString()
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
                        children: [
                          Expanded(
                            flex: 2,
                            child: AutoTranslateText(
                              dasha,
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
                              lord,
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

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      // Try parsing formats like "Sat, Mar 6, 2027, 12:00:00 AM"
      final formats = [
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
