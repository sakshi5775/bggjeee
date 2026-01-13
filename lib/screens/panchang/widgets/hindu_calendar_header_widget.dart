import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/hindu_calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class HinduCalendarHeaderWidget extends StatelessWidget {
  final HinduCalendarController controller;

  const HinduCalendarHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            "#8B1925".toColor(), // rgba(139, 25, 37, 1)
            "#5D1C21".toColor(), // rgba(93, 28, 33, 1)
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5.75,
            offset: const Offset(0, 3.83),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header content
            Padding(
              padding: AppPaddings.all(15),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 34.49.w,
                      height: 34.49.h,
                      padding: EdgeInsets.all(7.67.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.58.r),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: "#E3B341".toColor(),
                        size: 20.w,
                      ),
                    ),
                  ),
                  Spacing.w(12),
                  // Title Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title - white text
                        AutoTranslateText(
                          'Hindu Calendar',
                          style: MyTextTheme.largeBCB.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.48,
                            color: "#E3B341".toColor(),
                            height: 1.34,
                          ),
                        ),
                        Spacing.h(4),
                        // Subtitle - white text
                        AutoTranslateText(
                          'Traditional Indian Calendar System',
                          style: MyTextTheme.mediumBCN.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: "#E3B341".toColor(),
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Month Navigation
            _buildMonthNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Obx(() {
      // Check if "All" is selected (when selectedMonth is 0 or null)
      final isAllSelected = controller.selectedMonth.value == 0;

      return Container(
        margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 15.h),
        height: 60.h,
        decoration: BoxDecoration(color: Colors.transparent),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: controller.monthNames.length + 1, // +1 for "All" option
          itemBuilder: (context, index) {
            if (index == 0) {
              // "All" button
              return GestureDetector(
                onTap: () {
                  // Set month to 0 for "All" - don't fetch, just filter in view
                  controller.selectedMonth.value = 0;
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isAllSelected
                        ? Colors
                              .white // White background when selected
                        : Colors.white.withValues(
                            alpha: 0.3,
                          ), // White with opacity when unselected
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoTranslateText(
                        'All',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: isAllSelected
                              ? "#6B1B1A"
                                    .toColor() // Dark red text when selected
                              : Colors.white, // White text when unselected
                          fontSize: 14.sp,
                          fontWeight: isAllSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Month buttons
            final monthIndex = index; // index 1-12 for months
            final isSelected =
                !isAllSelected && controller.selectedMonth.value == monthIndex;
            // Use abbreviated month names (Jan, Feb, etc.)
            final fullMonthName = controller.monthNames[index - 1];
            final monthName = fullMonthName.length > 3
                ? fullMonthName.substring(0, 3)
                : fullMonthName;

            return GestureDetector(
              onTap: () => controller.selectMonth(monthIndex),
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors
                            .white // White background when selected
                      : Colors.white.withValues(
                          alpha: 0.3,
                        ), // White with opacity when unselected
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AutoTranslateText(
                        monthName,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: isSelected
                              ? "#6B1B1A"
                                    .toColor() // Dark red text when selected
                              : Colors.white, // White text when unselected
                          fontSize: 14.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
