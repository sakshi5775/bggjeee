import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Helper for consistent 12-hour AM/PM time display and picker across the app.
class TimePickerHelper {
  TimePickerHelper._();

  /// Format 24-hour (0-23) hour and minute for display as simple 12-hour AM/PM.
  /// Example: (14, 30) -> "02:30 PM", (0, 0) -> "12:00 AM".
  static String formatTime24To12Display(int hour24, int minute) {
    final h = hour24.clamp(0, 23);
    final m = minute.clamp(0, 59);
    final period = h < 12 ? 'AM' : 'PM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '${hour12.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $period';
  }

  /// Parse 12-hour display string (e.g. "02:30 PM") to 24h "HH:mm" for API.
  /// If input has no AM/PM, returns it as-is (assumed already 24h). Returns null only if invalid.
  static String? parseTime12To24(String display12h) {
    final s = display12h.trim();
    if (s.isEmpty) return null;
    final i = s.lastIndexOf(' ');
    if (i <= 0 || i >= s.length - 1) return s; // no space = assume HH:mm
    final timePart = s.substring(0, i).trim();
    final period = s.substring(i + 1).toUpperCase();
    if (period != 'AM' && period != 'PM') return s;
    final parts = timePart.split(':');
    if (parts.length < 2) return null;
    int? hour = int.tryParse(parts[0].trim());
    int? minute = int.tryParse(parts[1].trim());
    if (hour == null || minute == null) return null;
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    hour = hour.clamp(0, 23);
    minute = minute.clamp(0, 59);
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Show time picker in 12-hour AM/PM format with App styling.
  static Future<TimeOfDay?> showTimePicker12h(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              dayPeriodBorderSide: BorderSide(
                color: AppColors.deepOrange,
                width: 1.5,
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              dialHandColor: AppColors.deepOrange,
              dialBackgroundColor: AppColors.deepOrange.withValues(alpha: 0.1),
              hourMinuteColor: WidgetStateColor.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? AppColors.deepOrange.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.1);
              }),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? AppColors.deepOrange
                    : Colors.black;
              }),
              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? AppColors.deepOrange
                    : Colors.transparent;
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.black;
              }),
            ),
            colorScheme: ColorScheme.light(
              primary: AppColors.deepOrange, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.deepOrange, // Button text color
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  /// Show date picker with App styling.
  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String? helpText,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.deepOrange, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
              surface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.deepOrange, // Button text color
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: AppColors.deepOrange,
              headerForegroundColor: Colors.white,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.deepOrange;
                }
                return null;
              }),
              todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.deepOrange;
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(color: AppColors.deepOrange),
              todayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return AppColors.deepOrange;
              }),
            ),
          ),
          child: DatePickerDialog(
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            helpText: helpText,
            initialCalendarMode: initialDatePickerMode,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
          ),
        );
      },
    );
  }
}

