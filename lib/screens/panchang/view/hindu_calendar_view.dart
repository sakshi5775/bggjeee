import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/hindu_calendar_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';

class HinduCalendarView extends BasePage<HinduCalendarController> {
  const HinduCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (controller.isLoading.value && controller.calendarData.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: "#DFB343".toColor()),
            );
          }

          return Column(
            children: [
              // Header
              CommonHeader(
                title: 'Hindu Calendar',
                subtitle: AutoTranslateText(
                  'Traditional Indian Calendar System',
                  style: MyTextTheme.mediumBCN.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    height: 1.33,
                  ),
                ),
              ),

              // Month Navigation
              _buildMonthNavigation(),

              // Year and Location Selectors
              _buildYearLocationSelectors(),

              Spacing.h(16),

              // Events List
              Expanded(child: _buildEventsList()),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Obx(() {
      // Check if "All" is selected (when selectedMonth is 0 or null)
      final isAllSelected = controller.selectedMonth.value == 0;

      return Container(
        height: 60.h,
        decoration: BoxDecoration(color: Colors.transparent),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                    gradient: isAllSelected ? AppColors.orangeGradient : null,
                    color: isAllSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoTranslateText(
                        'All',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: isAllSelected ? Colors.white : Colors.black,
                          fontSize: 14,
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
                        monthName,
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
    });
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
                    color: Color(0xFFE3B341), // 2nd-gold
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(13.41.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Color(0xFFE3B341),
                      size: 15.w,
                    ),
                    Spacing.w(6),
                    Obx(
                      () => AutoTranslateText(
                        controller.selectedYear.value.toString(),
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Color(0xFFE3B341), // 2nd-gold
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
                    color: Color(0xFFE3B341), // 2nd-gold
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(13.41.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Color(0xFFE3B341),
                      size: 15.33.w,
                    ),
                    Spacing.w(6),
                    Expanded(
                      child: Obx(
                        () => AutoTranslateText(
                          controller.selectedLocation.value,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: Color(0xFFE3B341), // 2nd-gold
                            fontSize: 13.41,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildEventsList() {
    // Get festivals based on selected month (0 = All)
    final allFestivals = controller.getAllFestivals();
    final festivals = controller.selectedMonth.value == 0
        ? allFestivals
        : allFestivals.where((item) {
            final dateStr = item['date'] as String;
            try {
              final parts = dateStr.split('/');
              if (parts.length == 3) {
                final month = int.parse(parts[1]);
                return month == controller.selectedMonth.value;
              }
            } catch (e) {
              // Invalid date format
            }
            return false;
          }).toList();

    if (festivals.isEmpty) {
      return Center(
        child: AutoTranslateText(
          'No festivals found for this month',
          style: MyTextTheme.mediumBCN.copyWith(
            color: "#6F221E".toColor().withValues(alpha: 0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      itemCount: festivals.length,
      itemBuilder: (context, index) {
        final item = festivals[index];
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

        final dayName = date != null
            ? DateFormat('EEE').format(date).toUpperCase()
            : '';
        final dayNameFull = date != null ? DateFormat('EEEE').format(date) : '';
        final dayNumber = date != null ? date.day : 0;

        return _buildEventCard(
          dayNumber: dayNumber,
          dayName: dayName,
          dayNameFull: dayNameFull,
          festival: festival,
          dateStr: dateStr,
          date: date,
        );
      },
    );
  }

  Widget _buildEventCard({
    required int dayNumber,
    required String dayName,
    required String dayNameFull,
    required Map<String, dynamic> festival,
    required String dateStr,
    DateTime? date,
  }) {
    return GestureDetector(
      onTap: () =>
          _navigateToFestivalDetail(festival, dateStr, dayNumber, dayName),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.03.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: "#FAF6F0".toColor(), // fill_NZ04EU
          borderRadius: BorderRadius.circular(14.04.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Badge with orange gradient
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF38B3B), // rgba(243, 139, 59, 1)
                    Color(0xFFDD2914), // rgba(221, 41, 20, 1)
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoTranslateText(
                    dayNumber.toString(),
                    style: MyTextTheme.mediumBCB.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  AutoTranslateText(
                    dayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MyTextTheme.smallBCN.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.w(12),
            // Festival Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    festival['name']?.toString() ?? 'Festival',
                    style: MyTextTheme.mediumBCB.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: "#6B1B1A".toColor(), // fill_54O2QS
                      height: 1.43,
                      letterSpacing: -0.15,
                    ),
                  ),
                  if (festival['description'] != null) ...[
                    Spacing.h(4),
                    AutoTranslateText(
                      festival['description']?.toString() ?? '',
                      style: MyTextTheme.smallBCN.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(107, 27, 26, 0.6), // fill_BELX40
                        height: 1.6,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Right arrow icon
            GestureDetector(
              onTap: () => _showCalendarOptions(
                festival,
                dateStr,
                dayNumber,
                dayName,
                date,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: "#6B1B1A".toColor().withValues(alpha: 0.5),
                size: 16.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker() async {
    final picked = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate: DateTime(
        controller.selectedYear.value,
        controller.selectedMonth.value,
        1,
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select Year and Month',
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      controller.selectYear(picked.year);
      controller.selectMonth(picked.month);
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

  void _showCalendarOptions(
    Map<String, dynamic> festival,
    String dateStr,
    int dayNumber,
    String dayName,
    DateTime? date,
  ) {
    final eventDate = date ?? DateTime.now();

    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          _buildCalendarOptionsSheet(festival, eventDate, dayNumber, dayName),
    );
  }

  Widget _buildCalendarOptionsSheet(
    Map<String, dynamic> festival,
    DateTime eventDate,
    int dayNumber,
    String dayName,
  ) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Spacing.h(16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  'Add to Calendar',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.h(16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutoTranslateText(
                              festival['name']?.toString() ?? 'Festival',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: "#6F221E".toColor(),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.h(8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16.w,
                                  color: "#6F221E".toColor().withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                Spacing.w(8),
                                Flexible(
                                  child: AutoTranslateText(
                                    DateFormat(
                                      'EEEE, MMMM dd, yyyy',
                                    ).format(eventDate),
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: "#6F221E".toColor().withOpacity(
                                        0.7,
                                      ),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (festival['description'] != null) ...[
                              Spacing.h(8),
                              AutoTranslateText(
                                festival['description']?.toString() ?? '',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: "#6F221E".toColor().withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Spacing.h(16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _addToCalendar(festival, eventDate),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: "#DFB343".toColor(),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 20.w,
                              ),
                              Spacing.w(8),
                              Flexible(
                                child: AutoTranslateText(
                                  'Add to Calendar',
                                  style: MyTextTheme.mediumBCB.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacing.h(12),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: AutoTranslateText(
                          'This will open your default calendar app to save the event',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addToCalendar(
    Map<String, dynamic> festival,
    DateTime eventDate,
  ) async {
    try {
      final event = Event(
        title: festival['name']?.toString() ?? 'Hindu Festival',
        description: festival['description']?.toString() ?? '',
        location: controller.selectedLocation.value,
        startDate: DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
          0,
          0,
        ),
        endDate: DateTime(
          eventDate.year,
          eventDate.month,
          eventDate.day,
          23,
          59,
        ),
        allDay: true,
        iosParams: const IOSParams(reminder: Duration(minutes: 15)),
        androidParams: const AndroidParams(emailInvites: []),
      );

      await Add2Calendar.addEvent2Cal(event);

      Get.back();
      Get.snackbar(
        'Success',
        'Event added to calendar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();

      String errorMessage = 'Failed to add event to calendar';
      if (e.toString().contains('MissingPluginException')) {
        errorMessage =
            'Calendar plugin not initialized. Please rebuild the app after running "flutter pub get"';
      } else {
        errorMessage = 'Failed to add event to calendar: ${e.toString()}';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }
}
