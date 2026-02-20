import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/dasha_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VimshottariDashaWidget extends StatelessWidget {
  final DashaController controller;

  const VimshottariDashaWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: "#ed6f30".toColor()),
        );
      }

      final currentList = controller.getCurrentList();

      if (currentList.isEmpty) {
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
                      Icons.table_chart,
                      color: AppColors.textLight,
                      size: 18.w,
                    ),
                  ),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      controller.getLevelTitle(),
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
                  // Header
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

                  // List Items
                  ...currentList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isLast = index == currentList.length - 1;
                    final planetName = item['name'] as String? ?? '';
                    final endDate = item['end'] as String? ?? '';
                    final formattedDate = endDate.isNotEmpty
                        ? controller.formatDate(endDate)
                        : '';
                    final planetShort = controller.getPlanetShortName(
                      planetName,
                    );
                    final fullPath = controller.getFullPath(planetShort);
                    final hasNextLevel = controller.getNextLevel() != null;

                    return GestureDetector(
                      onTap: hasNextLevel
                          ? () => controller.onDashaItemTap(index)
                          : null,
                      child: Container(
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
                              flex: 2,
                              child: AutoTranslateText(
                                fullPath,
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
                                planetName,
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
                                formattedDate,
                                textAlign: TextAlign.right,
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            Spacing.h(12),

            // BACK Button (only show when not at top level)
            if (controller.canGoBack())
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12.h),
                child: ElevatedButton(
                  onPressed: () => controller.navigateBack(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepOrange,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                  child: AutoTranslateText(
                    'BACK',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),

            // Note
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.deepOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Note:- ',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  Expanded(
                    child: AutoTranslateText(
                      controller.getNextLevel() != null
                          ? 'Dates shown are dasha ending dates. Please tap any row to show ${_getNextLevelName(controller)}.'
                          : 'Dates shown are dasha ending dates.',
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  String _getNextLevelName(DashaController controller) {
    final nextLevel = controller.getNextLevel();
    switch (nextLevel) {
      case 'antardasha':
        return 'Antar Dasha';
      case 'paryantardasha':
        return 'Paryantar Dasha';
      case 'shookshamadasha':
        return 'Shooksham Dasha';
      case 'pranadasha':
        return 'Pran Dasha';
      default:
        return 'next level';
    }
  }
}
