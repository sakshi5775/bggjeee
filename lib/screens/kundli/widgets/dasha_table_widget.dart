import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/value/dimension.dart';

class DashaTableWidget extends StatelessWidget {
  final DashaController controller;

  const DashaTableWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Container(
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
                      size: 18.w,
                    ),
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'Dasha Options',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            // Table Rows
            ...controller.dashaTableData.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              final isLast = index == controller.dashaTableData.length - 1;
              final leftText = row['left'] as String;
              final rightText = row['right'] as String;
              final hasRightColumn = rightText.isNotEmpty;

              return InkWell(
                onTap: () {
                  if (leftText == 'Vimshottari Dasha') {
                    controller.navigateToVimshottariDasha();
                  } else if (leftText == 'Current Mahadasha') {
                    controller.navigateToCurrentMahadashaTab();
                  } else if (leftText == 'Yogini Dasha') {
                    controller.navigateToYoginiDasha();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
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
                  child: hasRightColumn
                      ? _buildTwoColumnRow(leftText, rightText)
                      : _buildSingleColumnRow(leftText),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumnRow(String leftText, String rightText) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.timeline, size: 16.w, color: AppColors.deepOrange),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  leftText,
                  style: MyTextTheme.smallBCB.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 1,
          height: 30.h,
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          color: AppColors.deepOrange.withValues(alpha: 0.2),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              if (rightText == 'Mahadasha') {
                controller.navigateToMahadashaTab();
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16.w,
                  color: AppColors.deepOrange,
                ),
                Spacing.w(8),
                Expanded(
                  child: AutoTranslateText(
                    rightText,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleColumnRow(String leftText) {
    return Row(
      children: [
        Icon(
          leftText == 'Current Mahadasha'
              ? Icons.alarm_add_outlined
              : Icons.import_contacts,
          size: 16.w,
          color: AppColors.deepOrange,
        ),
        Spacing.w(8),
        Expanded(
          child: AutoTranslateText(
            leftText,
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
