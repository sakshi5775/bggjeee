import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/yearly_vrat_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:intl/intl.dart';

class YearlyVratView extends BasePage<YearlyVratController> {
  const YearlyVratView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Obx(() {
          if (controller.isLoading.value && controller.yearlyVratData.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: "#DFB343".toColor()),
            );
          }

          return Column(
            children: [
              // Header with Month Navigation
              CommonHeader(
                title: 'Yearly Vrat',
                subtitle: AutoTranslateText(
                  'Annual Fasting Calendar',
                  style: MyTextTheme.mediumBCN.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                  ),
                ),
              ),

              // Month Navigation
              _buildMonthNavigation(),
              Spacing.h(10),

              // Year and Location Selectors
              _buildYearLocationSelectors(),

              Spacing.h(16),

              // Vrat List
              Expanded(child: _buildVratList()),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(color: Colors.transparent),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: controller.monthNames.length,
        itemBuilder: (context, index) {
          final monthIndex = index + 1;
          final isSelected = controller.selectedMonth.value == monthIndex;
          final monthName = controller.monthNames[index];
          // Abbreviate month name if longer than 3 characters
          final abbreviatedMonth = monthName.length > 3
              ? monthName.substring(0, 3)
              : monthName;

          return GestureDetector(
            onTap: () => controller.selectMonth(monthIndex),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.orangeGradient : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AutoTranslateText(
                      abbreviatedMonth,
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 14,
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
  }

  Widget _buildYearLocationSelectors() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          // Year Selector
          Expanded(
            child: GestureDetector(
              onTap: _showYearPicker,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: "#FFFFFF".toColor(),
                  border: Border.all(
                    color: "#F38B3B".toColor(),
                    // Gold border
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(13.41.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: "#8B1925".toColor(),
                      size: 15.w,
                    ),
                    Spacing.w(6),
                    Obx(
                      () => AutoTranslateText(
                        controller.selectedYear.value.toString(),
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#8B1925".toColor(), // Gold text
                          fontSize: 13.41,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacing.w(6),
          // Location Selector
          Expanded(
            child: GestureDetector(
              onTap: _showLocationBottomSheet,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: "#FFFFFF".toColor(),
                  border: Border.all(
                    color: "#F38B3B".toColor(), // Gold border
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(13.41.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: "#8B1925".toColor(),
                      size: 15.33.w,
                    ),
                    Spacing.w(6),
                    Expanded(
                      child: Obx(
                        () => AutoTranslateText(
                          controller.selectedLocation.value,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#8B1925".toColor(), // Gold text
                            fontSize: 13.41,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVratList() {
    final vratList = controller.yearlyVratData;

    if (vratList.isEmpty) {
      return Center(
        child: AutoTranslateText(
          'No vrat found for this year',
          style: MyTextTheme.mediumBCN.copyWith(
            color: "#6B1B1A".toColor().withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: vratList.length,
      itemBuilder: (context, index) {
        final item = vratList[index];
        final dateStr = item['date'] as String;
        final festival = item['festival'] as Map<String, dynamic>;

        // Parse date
        DateTime? date;
        try {
          final parts = dateStr.split('/');
          if (parts.length == 3) {
            date = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
          }
        } catch (e) {
          // Invalid date format
        }

        final dayName = date != null ? DateFormat('EEEE').format(date) : '';
        final dayNumber = date != null ? date.day : 0;
        final monthName = date != null
            ? DateFormat('MMM').format(date).toUpperCase()
            : '';

        return _buildVratCard(
          dayNumber: dayNumber,
          monthName: monthName,
          dayName: dayName,
          festival: festival,
          dateStr: dateStr,
          date: date,
          index: index,
        );
      },
    );
  }

  Widget _buildVratCard({
    required int dayNumber,
    required String monthName,
    required String dayName,
    required Map<String, dynamic> festival,
    required String dateStr,
    DateTime? date,
    required int index,
  }) {
    return GestureDetector(
      onTap: () =>
          _navigateToFestivalDetail(festival, dateStr, dayNumber, dayName),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: "#FAF6F0".toColor(), // Beige background
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Color.fromRGBO(227, 179, 65, 0.2),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date Badge with orange gradient
            Container(
              // width: 60.w,
              // height: 80.h,
              padding: AppPaddings.symmetric(h: 20, v: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF38B3B), // Orange
                    Color(0xFFDD2914), // Red
                  ],
                ),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    dayNumber.toString(),
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Spacing.h(4),
                  AutoTranslateText(
                    monthName,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.w(16),
            // Festival Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    festival['name']?.toString() ?? 'Vrat',
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#6B1B1A".toColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    dayName,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6B1B1A".toColor().withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.w(8),
            // Right arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: "#6B1B1A".toColor().withValues(alpha: 0.5),
              size: 16.h,
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker() async {
    final picked = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate: DateTime(controller.selectedYear.value, 1, 1),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Year',
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      controller.selectYear(picked.year);
    }
  }

  void _showLocationBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: LocationBottomSheetWidget(
          onCitySelected:
              (city, state, country, [latitude, longitude, timezone]) {
                controller.selectCity(city, state, country);
                Get.back();
              },
          selectedCity: controller.selectedLocation.value,
          onUseCurrentLocation: () => controller.getCurrentLocation(),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _navigateToFestivalDetail(
    Map<String, dynamic> festival,
    String dateStr,
    int dayNumber,
    String dayName,
  ) {
    UserMainController.pushInCurrentTab(
      AppRoutes.festivalDetail,
      arguments: {
        'festival': festival,
        'date': dateStr,
        'dayNumber': dayNumber,
        'dayName': dayName,
        'location': controller.selectedLocation.value,
        'latitude': controller.currentLatitude,
        'longitude': controller.currentLongitude,
        'timezone': controller.currentTimezone,
      },
    );
  }
}
