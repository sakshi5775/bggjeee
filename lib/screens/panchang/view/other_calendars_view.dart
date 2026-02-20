import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/other_calendars_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class OtherCalendarsView extends BasePage<OtherCalendarsController> {
  const OtherCalendarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //  Spacing.h(24),
                    // Calendar Grid
                    _buildCalendarGrid(),
                    Spacing.h(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return CommonHeader(title: 'Other Calendars');
  }

  Widget _buildCalendarGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Always 4 columns for responsive design
          final crossAxisCount = 3;
          final spacing = 8.w;
          final runSpacing = 16.h;

          // Use a fixed aspect ratio that ensures text visibility
          // Width:Height ratio - smaller number means taller cards

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: runSpacing,
            ),
            itemCount: controller.calendarOptions.length,
            itemBuilder: (context, index) {
              final calendar = controller.calendarOptions[index];
              return _buildCalendarCard(calendar, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildCalendarCard(Map<String, dynamic> calendar, int index) {
    final title = calendar['title'] as String;
    final symbol = calendar['symbol'] as String;

    return GestureDetector(
      onTap: () => controller.onCalendarTap(calendar),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            decoration: BoxDecoration(gradient: AppColors.orangeGradient),
            child: Stack(
              children: [
                // Decorative background circles
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: -40,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content - Centered
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Symbol in elegant circle
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AutoTranslateText(
                              symbol,
                              textAlign: TextAlign.center,
                              style: MyTextTheme.mediumBCB.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: "#68171E".toColor(),
                              ),
                            ),
                          ),
                        ),
                        Spacing.h(6),
                        // Title - Centered
                        AutoTranslateText(
                          title,
                          textAlign: TextAlign.center,
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showYearPicker() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.calendar_month, color: AppColors.templeGold, size: 24.w),
            Spacing.w(8),
            AutoTranslateText(
              'Select Year',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          height: 300.h,
          child: YearPicker(
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            selectedDate: DateTime(controller.selectedYear.value),
            onChanged: (date) {
              controller.selectYear(date.year);
              Get.back();
            },
          ),
        ),
      ),
    );
  }
}

