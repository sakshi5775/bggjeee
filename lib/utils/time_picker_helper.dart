import 'package:flutter/material.dart';

/// Helper for consistent 12-hour AM/PM time display and picker across the app.
class TimePickerHelper {
  TimePickerHelper._();

  /// Format 24-hour (0-23) hour and minute for display as simple 12-hour AM/PM.
  /// Example: (14, 30) -> "2:30 PM", (0, 0) -> "12:00 AM".
  static String formatTime24To12Display(int hour24, int minute) {
    final h = hour24.clamp(0, 23);
    final m = minute.clamp(0, 59);
    final period = h < 12 ? 'AM' : 'PM';
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return '$hour12:${m.toString().padLeft(2, '0')} $period';
  }

  /// Parse 12-hour display string (e.g. "2:30 PM") to 24h "HH:mm" for API.
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

  /// Show time picker in 12-hour AM/PM format so users are not confused.
  /// [initialTime] is in 24h (TimeOfDay uses 0-23 for hour).
  /// Optionally pass [builder] to apply theme (e.g. app colors).
  static Future<TimeOfDay?> showTimePicker12h(
    BuildContext context, {
    required TimeOfDay initialTime,
    Widget Function(BuildContext, Widget?)? builder,
  }) {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        final wrapped = MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
        if (builder != null) {
          return builder(context, wrapped);
        }
        return wrapped;
      },
    );
  }
}
