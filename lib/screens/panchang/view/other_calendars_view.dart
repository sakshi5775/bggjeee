import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/other_calendars_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class OtherCalendarsView extends BasePage<OtherCalendarsController> {
  const OtherCalendarsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Space between header and year selector
            Spacing.h(8),
            
            // Year Selector Section (Yellow Bar)
            _buildYearSelectorSection(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.h(24),
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
    return Container(
      decoration: BoxDecoration(
        color: "#6F221E".toColor(),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
            ),
            Spacing.w(16),
            // Title
            Expanded(
              child: AutoTranslateText(
                'Other Calendars',
                style: MyTextTheme.largeBCB.copyWith(
                  color: const Color(0xFFDFB343),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelectorSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            "#DFB343".toColor(),
            "#F7C443".toColor(),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: "#DFB343".toColor().withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Row(
            children: [
              Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 20.w,
              ),
              Spacing.w(8),
              AutoTranslateText(
                'Calendar ${controller.selectedYear.value}',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )),
          GestureDetector(
            onTap: () => _showYearPicker(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 18.w,
              ),
            ),
          ),
        ],
      ),
    );
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
          final childAspectRatio = 0.85;
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: runSpacing,
              childAspectRatio: childAspectRatio,
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
    
    // Saffron and Temple Gold gradient variations
    final gradientColors = [
      [AppColors.saffron, AppColors.saffronmix], // Dark saffron gradient
      [AppColors.templeGold, AppColors.turmericYellow], // Gold gradient
      [AppColors.saffronmix, AppColors.saffron], // Reversed saffron
      [AppColors.turmericYellow, AppColors.templeGold], // Reversed gold
      [AppColors.saffron, AppColors.templeGold], // Saffron to gold
      [AppColors.templeGold, AppColors.saffronmix], // Gold to saffron
    ];
    
    final cardGradient = gradientColors[index % gradientColors.length];
    
    return GestureDetector(
      onTap: () => controller.onCalendarTap(calendar),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: cardGradient[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: cardGradient,
              ),
            ),
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
                      color: Colors.white.withOpacity(0.15),
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
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            symbol,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Spacing.h(6),
                      // Calendar icon with background
                      Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(7.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 16.w,
                        ),
                      ),
                      Spacing.h(6),
                      // Title - Flexible to prevent overflow
                      Flexible(
                        child: AutoTranslateText(
                          title,
                          style: MyTextTheme.smallBCB.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
            Icon(
              Icons.calendar_month,
              color: "#DFB343".toColor(),
              size: 24.w,
            ),
            Spacing.w(8),
            AutoTranslateText(
              'Select Year',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontSize: 20.sp,
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
