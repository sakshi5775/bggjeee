import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/monthly_calendar_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

class MonthlyCalendarView extends BasePage<MonthlyCalendarController> {
  const MonthlyCalendarView({super.key});

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
                title: 'Monthly Calendar',
                subtitle: AutoTranslateText(
                  'Traditional Indian Calendar System',
                  style: MyTextTheme.mediumBCN.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: "#6F221E".toColor().withOpacity(0.7),
                    height: 1.33,
                  ),
                ),
              ),

              // Date and Location Selectors
              _buildDateLocationSelectors(),

              Spacing.h(10),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Calendar Grid
                      _buildCalendarGrid(),
                      Spacing.h(20),

                      // Hindu Calendar Events Section
                      _buildFestivalsSection(),
                      Spacing.h(20),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDateLocationSelectors() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        children: [
          // Date Selector
          Expanded(
            child: GestureDetector(
              onTap: controller.selectDate,
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
                    Expanded(
                      child: Obx(
                        () => AutoTranslateText(
                          controller.getMonthYearString(),
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: Color(0xFFE3B341), // 2nd-gold
                            fontSize: 13.41.sp,
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
                            fontSize: 13.41.sp,
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

  Widget _buildCalendarGrid() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.only(
        top: 16.63.h,
        left: 16.63.w,
        right: 16.63.w,
        bottom: 0.58.h,
      ),
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(16.05.r),
        border: Border.all(
          color: Color.fromRGBO(229, 193, 88, 0.2),
          width: 0.58,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15.04,
            offset: const Offset(0, 3.01),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available width (container width - padding)
          final availableWidth = constraints.maxWidth - (16.63.w * 2);
          // Calculate width per day: (availableWidth - (6 * spacing)) / 7
          final dayWidth = (availableWidth - (6 * 8.02.w)) / 7;

          return Column(
            children: [
              // Month Navigation
              _buildMonthNavigation(),
              Spacing.h(15),
              // Days of Week Header
              _buildDaysOfWeekHeader(dayWidth: dayWidth),
              Spacing.h(12.03),
              // Calendar Grid
              Obx(() => _buildCalendarDays(dayWidth: dayWidth)),
              Spacing.h(15),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDaysOfWeekHeader({required double dayWidth}) {
    final days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        return Container(
          width: dayWidth,
          height: 32.08.h,
          alignment: Alignment.center,
          child: AutoTranslateText(
            day,
            textAlign: TextAlign.center,
            style: MyTextTheme.smallBCB.copyWith(
              fontSize: 12.04.sp,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(107, 27, 26, 0.6), // fill_BELX40
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.05.w, vertical: 0),
      height: 44.11.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF38B3B), // rgba(243, 139, 59, 1)
            Color(0xFFDD2914), // rgba(221, 41, 20, 1)
          ],
        ),
        borderRadius: BorderRadius.circular(14.04.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          GestureDetector(
            onTap: controller.previousMonth,
            child: Container(
              width: 28.07.w,
              height: 28.07.h,
              padding: EdgeInsets.all(4.01.w),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20.05.w,
              ),
            ),
          ),
          // Month/Year text
          Obx(
            () => AutoTranslateText(
              controller.getMonthYearString(),
              style: MyTextTheme.mediumBCB.copyWith(
                fontSize: 14.04.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.43,
              ),
            ),
          ),
          // Next month button
          GestureDetector(
            onTap: controller.nextMonth,
            child: Container(
              width: 28.07.w,
              height: 28.07.h,
              padding: EdgeInsets.all(4.01.w),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20.05.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDays({required double dayWidth}) {
    final selectedDate = controller.selectedDate.value;
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDayOfMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday
    final daysInMonth = lastDayOfMonth.day;

    // Previous month days
    final previousMonth = selectedDate.month == 1 ? 12 : selectedDate.month - 1;
    final previousYear = selectedDate.month == 1
        ? selectedDate.year - 1
        : selectedDate.year;
    final lastDayOfPreviousMonth = DateTime(previousYear, previousMonth + 1, 0);
    final daysInPreviousMonth = lastDayOfPreviousMonth.day;

    // Next month days
    final nextMonth = selectedDate.month == 12 ? 1 : selectedDate.month + 1;
    final nextYear = selectedDate.month == 12
        ? selectedDate.year + 1
        : selectedDate.year;

    final today = DateTime.now();
    final currentDay = controller.selectedDate.value.day;

    List<Widget> dayWidgets = [];

    // Previous month days
    for (int i = firstDayWeekday - 1; i >= 0; i--) {
      final day = daysInPreviousMonth - i;
      final date = DateTime(previousYear, previousMonth, day);
      dayWidgets.add(
        _buildCalendarDay(
          day: day,
          date: date,
          isCurrentMonth: false,
          isToday: false,
          isSelected: false,
          dayWidth: dayWidth,
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedDate.year, selectedDate.month, day);
      final isToday =
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isSelected = day == currentDay;

      dayWidgets.add(
        _buildCalendarDay(
          day: day,
          date: date,
          isCurrentMonth: true,
          isToday: isToday,
          isSelected: isSelected,
          dayWidth: dayWidth,
        ),
      );
    }

    // Next month days to fill the grid
    final totalCells = dayWidgets.length;
    final remainingCells = 42 - totalCells; // 6 rows * 7 days
    for (int day = 1; day <= remainingCells; day++) {
      final date = DateTime(nextYear, nextMonth, day);
      dayWidgets.add(
        _buildCalendarDay(
          day: day,
          date: date,
          isCurrentMonth: false,
          isToday: false,
          isSelected: false,
          dayWidth: dayWidth,
        ),
      );
    }

    // Arrange in 7 columns using Row with calculated spacing
    // Group days into rows of 7
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      final rowDays = dayWidgets.sublist(
        i,
        i + 7 > dayWidgets.length ? dayWidgets.length : i + 7,
      );
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8.02.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowDays,
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildCalendarDay({
    required int day,
    required DateTime date,
    required bool isCurrentMonth,
    required bool isToday,
    required bool isSelected,
    required double dayWidth,
  }) {
    final festivals = controller.getFestivalsForDate(date);
    final hasFestival = festivals.isNotEmpty;

    // Determine background color based on Figma design
    Color? backgroundColor;
    Color textColor;
    Border? border;
    Gradient? gradient;

    if (!isCurrentMonth) {
      backgroundColor = "#FAF6F0".toColor(); // fill_NZ04EU
      textColor = "#6B1B1A".toColor(); // fill_54O2QS
      gradient = null;
    } else if (isToday) {
      // Today has orange gradient background
      backgroundColor = null; // No solid color when using gradient
      textColor = "#FFFFFF".toColor();
      border = null;
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF38B3B), // rgba(243, 139, 59, 1)
          Color(0xFFDD2914), // rgba(221, 41, 20, 1)
        ],
      );
    } else if (isSelected) {
      // Selected dates have green background
      backgroundColor = Color(0xFFE8F5E9); // fill_UJ83TC
      textColor = "#6B1B1A".toColor();
      border = Border.all(
        color: Color.fromRGBO(45, 122, 62, 0.2), // stroke_NWIJ0N
        width: 0.58,
      );
      gradient = null;
    } else {
      backgroundColor = "#FAF6F0".toColor(); // fill_NZ04EU
      textColor = "#6B1B1A".toColor(); // fill_54O2QS
      gradient = null;
    }

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth) {
          // Update selected date
          controller.selectedDate.value = date;
          controller.fetchMonthlyCalendar();
          controller.fetchPanchangForSelectedDate();
        }
      },
      child: Container(
        width: dayWidth,
        height: 42.8.h,
        padding: EdgeInsets.only(
          top: 11.36.h,
          left: 4.01.w,
          right: 4.01.w,
          bottom: 0,
        ),
        // padding: AppPaddings.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.03.r),
          border: border,
          gradient: gradient,
        ),
        child: Stack(
          children: [
            // Date number
            Positioned(
              top: 0.74.h,
              left: 0,
              right: 0,
              child: AutoTranslateText(
                day.toString(),
                textAlign: TextAlign.center,
                style: MyTextTheme.mediumBCB.copyWith(
                  fontSize: 14.04.sp,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.43,
                  letterSpacing: -0.15,
                ),
              ),
            ),
            // Festival indicator dot (green dot for selected dates)
            if (hasFestival && isSelected)
              Positioned(
                bottom: 8.36.h,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 4.01.w,
                    height: 4.01.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF2D7A3E), // fill_KF0GMQ
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestivalsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(16.05.r),
        border: Border.all(
          color: Color.fromRGBO(229, 193, 88, 0.2),
          width: 0.58,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15.04,
            offset: const Offset(0, 3.01),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.star_border_outlined,
                color: Color(0xFFFF9933), // 3rd-orange
                size: 20.05.w,
              ),
              Spacing.w(8.02),
              AutoTranslateText(
                'Hindu Calendar',
                style: MyTextTheme.largeBCB.copyWith(
                  fontSize: 18.05.sp,
                  fontWeight: FontWeight.w500,
                  color: "#6B1B1A".toColor(), // fill_54O2QS
                  height: 1.5,
                ),
              ),
            ],
          ),
          Spacing.h(16.05),
          // Festivals List
          Obx(() {
            if (controller.calendarData.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Center(
                  child: AutoTranslateText(
                    'No festivals found for this month',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }

            // Get all festivals sorted by date
            final allFestivals = <Map<String, dynamic>>[];
            for (var item in controller.calendarData) {
              final dateStr = item['date']?.toString() ?? '';
              final festivals = item['festivals'] as List<dynamic>?;
              if (festivals != null) {
                for (var festival in festivals) {
                  allFestivals.add({
                    'date': dateStr,
                    'festival': festival as Map<String, dynamic>,
                  });
                }
              }
            }

            if (allFestivals.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Center(
                  child: AutoTranslateText(
                    'No festivals found for this month',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor().withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allFestivals.length,
              itemBuilder: (context, index) {
                final item = allFestivals[index];
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
                final dayNumber = date != null ? date.day : 0;

                return _buildFestivalCard(
                  dayNumber: dayNumber,
                  dayName: dayName,
                  festival: festival,
                  dateStr: dateStr,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFestivalCard({
    required int dayNumber,
    required String dayName,
    required Map<String, dynamic> festival,
    required String dateStr,
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
                      fontSize: 18.sp,
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
                      fontSize: 10.sp,
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: "#6B1B1A".toColor(), // fill_54O2QS
                      height: 1.43,
                      letterSpacing: -0.15,
                    ),
                  ),
                  Spacing.h(4),
                  if (festival['description'] != null)
                    AutoTranslateText(
                      festival['description']?.toString() ?? '',
                      style: MyTextTheme.smallBCN.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(107, 27, 26, 0.6), // fill_BELX40
                        height: 1.6,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // Right arrow icon
            GestureDetector(
              onTap: () =>
                  _showCalendarOptions(festival, dateStr, dayNumber, dayName),
              child: Icon(
                Icons.arrow_forward_ios,
                color: "#6B1B1A".toColor().withOpacity(0.5),
                size: 16.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show calendar options bottom sheet from right side
  void _showCalendarOptions(
    Map<String, dynamic> festival,
    String dateStr,
    int dayNumber,
    String dayName,
  ) {
    // Parse date
    DateTime? eventDate;
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        eventDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      eventDate = DateTime.now();
    }

    if (eventDate == null) {
      eventDate = DateTime.now();
    }

    // Show bottom sheet
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          _buildCalendarOptionsSheet(festival, eventDate!, dayNumber, dayName),
    );
  }

  /// Calendar Options Bottom Sheet Widget
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
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Spacing.h(12),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  'Add to Calendar',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacing.h(12),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Event Details
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
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.h(8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16.w,
                                  color: "#6F221E".toColor().withOpacity(0.7),
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
                                      fontSize: 14.sp,
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
                                  color: "#6F221E".toColor().withOpacity(0.6),
                                  fontSize: 12.sp,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Spacing.h(16),
                      // Add to Calendar Button
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
                                    fontSize: 16.sp,
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
                      // Note
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: AutoTranslateText(
                          'This will open your default calendar app to save the event',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 12.sp,
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

  /// Add event to calendar
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

      Get.back(); // Close the bottom sheet
      Get.snackbar(
        'Success',
        'Event added to calendar',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back(); // Close the bottom sheet

      // Handle MissingPluginException specifically
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

  void _navigateToFestivalDetail(
    Map<String, dynamic> festival,
    String dateStr,
    int dayNumber,
    String dayName,
  ) {
    Get.toNamed(
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
}

// LocationBottomSheetWidget is now in lib/screens/panchang/widgets/location_bottom_sheet_widget.dart
