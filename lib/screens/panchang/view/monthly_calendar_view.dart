import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/monthly_calendar_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
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
        // endDrawer: const CommonEndDrawer(),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: "#6F221E".toColor().withValues(alpha: 0.7),
                    height: 1.33,
                  ),
                ),
              ),

              // Date and Location Selectors
              _buildDateLocationSelectors(),

              Spacing.h(10),

              // Tithi / Selected date info banner (like reference)
              _buildTithiBanner(),

              Spacing.h(12),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Calendar Grid
                      _buildCalendarGrid(),
                      Spacing.h(20),

                      // Hindu Calendar (Festival) Section
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

  /// Tithi / selected date info banner using primaryGradient.
  /// Shows Hindu month, paksha | tithi for selected date and date + location on right.
  Widget _buildTithiBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Obx(() {
        final isFetching = controller.isFetchingPanchang.value;
        final hinduDetails = controller.getCurrentHinduDetails();
        final pakshaTithi = controller.getPakshaTithi();
        final sel = controller.selectedDate.value;
        final dateStr = DateFormat('d MMM, yyyy (EEEE)').format(sel);
        final location = controller.selectedLocation.value;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.nightlight_round,
                  color: AppColors.gradientBackground.colors.first,
                  size: 32.w,
                ),
                Spacing.w(12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Column(
                      key: ValueKey('${sel.year}-${sel.month}-${sel.day}'),
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isFetching)
                          AutoTranslateText(
                            'Loading...',
                            style: MyTextTheme.smallBCN.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          )
                        else ...[
                          AutoTranslateText(
                            hinduDetails,
                            style: MyTextTheme.smallBCB.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacing.h(4),
                          AutoTranslateText(
                            pakshaTithi,
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: AppColors.gradientBackground.colors.first,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Spacing.w(8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      dateStr,
                      style: MyTextTheme.smallBCB.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                    Spacing.h(2),
                    AutoTranslateText(
                      location,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
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
            color: Colors.black.withValues(alpha: 0.1),
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
    final days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        gradient: AppColors.gradientBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.asMap().entries.map((entry) {
          final isSunday = entry.key == 0;
          return Container(
            width: dayWidth,
            height: 28.h,
            alignment: Alignment.center,
            child: AutoTranslateText(
              entry.value,
              textAlign: TextAlign.center,
              style: MyTextTheme.smallBCB.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSunday
                    ? AppColors.primaryGradient.colors.first
                    : Color.fromRGBO(107, 27, 26, 0.85),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.05.w, vertical: 0),
      height: 44.11.h,
      decoration: BoxDecoration(
        gradient: AppColors.orangeGradient,
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
                size: 20.05.h,
              ),
            ),
          ),
          // Month/Year text
          Obx(
            () => AutoTranslateText(
              controller.getMonthYearString(),
              style: MyTextTheme.mediumBCB.copyWith(
                fontSize: 14.04,
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
                size: 20.05.h,
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
    final isSunday = date.weekday == DateTime.sunday;

    // Styling: selected/today = orangeGradient, default = gradientBackground tint, Sunday = primary
    Color? backgroundColor;
    Color textColor;
    Border? border;
    Gradient? gradient;

    if (!isCurrentMonth) {
      backgroundColor = AppColors.gradientBackground.colors.last;
      textColor = Colors.grey.shade600;
      gradient = null;
    } else if (isSelected) {
      backgroundColor = null;
      textColor = Colors.white;
      border = Border.all(
        color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.8),
        width: 0.8,
      );
      gradient = AppColors.orangeGradient;
    } else if (isToday) {
      backgroundColor = null;
      textColor = Colors.white;
      border = null;
      gradient = AppColors.orangeGradient;
    } else {
      backgroundColor = AppColors.gradientBackground.colors[1];
      textColor = isSunday
          ? AppColors.primaryGradient.colors.first
          : Color(0xFF6B1B1A);
      gradient = null;
    }

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth) {
          controller.selectedDate.value = date;
          controller.fetchMonthlyCalendar();
          controller.fetchPanchangForSelectedDate();
        }
      },
      child: TweenAnimationBuilder<double>(
        key: ValueKey('${date.millisecondsSinceEpoch}-$isSelected'),
        tween: Tween(begin: isSelected ? 0.92 : 1.0, end: 1.0),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, scale, child) => Transform.scale(
          scale: scale,
          child: child,
        ),
        child: Container(
          width: dayWidth,
          height: 42.8.h,
          padding: EdgeInsets.only(top: 6.h, left: 2.w, right: 2.w, bottom: 4.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            border: border,
            gradient: gradient,
          ),
          child: Stack(
            children: [
              // Date number
              Positioned(
                top: 2.h,
                left: 0,
                right: 0,
                child: AutoTranslateText(
                  day.toString(),
                  textAlign: TextAlign.center,
                  style: MyTextTheme.mediumBCB.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.2,
                  ),
                ),
              ),
              // Festival dot for any date with festivals
              if (hasFestival)
                Positioned(
                  bottom: 4.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 5.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF2D7A3E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15.04,
            offset: const Offset(0, 3.01),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Hindu Calendar (festival list)
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              gradient: AppColors.gradientBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: AppColors.orangeGradient.colors.first,
                  size: 22.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Hindu Calendar',
                  style: MyTextTheme.largeBCB.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGradient.colors.first,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          //Spacing.h(1),
          // Festivals List
          Obx(() {
            if (controller.calendarData.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Center(
                  child: AutoTranslateText(
                    'No festivals found for this month',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor().withValues(alpha: 0.6),
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
                      color: "#6F221E".toColor().withValues(alpha: 0.6),
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
    } catch (_) {}
    eventDate ??= DateTime.now();

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              _navigateToFestivalDetail(festival, dateStr, dayNumber, dayName),
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.gradientBackground.colors[1],
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date badge (orange)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        dayNumber.toString().padLeft(2, '0'),
                        style: MyTextTheme.mediumBCB.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                // Festival name & description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoTranslateText(
                        festival['name']?.toString() ?? 'Festival',
                        style: MyTextTheme.mediumBCB.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B1B1A),
                          height: 1.3,
                        ),
                      ),
                      if (festival['description'] != null) ...[
                        Spacing.h(4),
                        AutoTranslateText(
                          festival['description']?.toString() ?? '',
                          style: MyTextTheme.smallBCN.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(107, 27, 26, 0.65),
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Add to calendar (simple icon) + View arrow
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showAddToCalendarDialog(
                        festival,
                        eventDate!,
                        dayNumber,
                        dayName,
                      ),
                      icon: Icon(
                        Icons.calendar_today,
                        size: 20.w,
                        color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.85),
                      ),
                      tooltip: 'Add to calendar',
                      padding: EdgeInsets.all(6.w),
                      constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.h,
                      color: AppColors.primaryGradient.colors.first.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Simple dialog to add festival to calendar (replaces heavy bottom sheet).
  void _showAddToCalendarDialog(
    Map<String, dynamic> festival,
    DateTime eventDate,
    int dayNumber,
    String dayName,
  ) {
    final name = festival['name']?.toString() ?? 'Festival';
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: AutoTranslateText(
          'Add to Calendar',
          style: MyTextTheme.mediumBCB.copyWith(fontSize: 18),
        ),
        content: AutoTranslateText(
          'Add "$name" on ${DateFormat('MMM d, yyyy').format(eventDate)} to your device calendar?',
          style: MyTextTheme.smallBCN.copyWith(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText('Cancel', style: MyTextTheme.smallBCB),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _addToCalendar(festival, eventDate);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: "#DFB343".toColor(),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: AutoTranslateText('Add'),
          ),
        ],
      ),
      barrierDismissible: true,
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
