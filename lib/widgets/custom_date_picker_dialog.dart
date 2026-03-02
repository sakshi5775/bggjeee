import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

/// Custom date picker dialog matching Flutter's DatePickerDialog design exactly
/// with month dropdown first, then year dropdown after month selection
class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? helpText;

  const CustomDatePickerDialog({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.helpText,
  }) : super(key: key);

  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String? helpText,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: helpText,
      ),
    );
  }

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _selectedDate;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  bool _showMonthDropdown = false;
  bool _showYearDropdown = false;

  final List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedYear = _selectedDate.year;
    _selectedMonth = _selectedDate.month;
    _selectedDay = _selectedDate.day;
  }

  List<int> get _availableYears {
    final years = <int>[];
    for (int year = widget.firstDate.year; year <= widget.lastDate.year; year++) {
      years.add(year);
    }
    return years.reversed.toList();
  }

  List<int> get _availableDays {
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _updateDate() {
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    if (_selectedDay > daysInMonth) {
      _selectedDay = daysInMonth;
    }
    _selectedDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    
    // Validate date is within range
    if (_selectedDate.isBefore(widget.firstDate)) {
      _selectedDate = widget.firstDate;
      _selectedYear = _selectedDate.year;
      _selectedMonth = _selectedDate.month;
      _selectedDay = _selectedDate.day;
    } else if (_selectedDate.isAfter(widget.lastDate)) {
      _selectedDate = widget.lastDate;
      _selectedYear = _selectedDate.year;
      _selectedMonth = _selectedDate.month;
      _selectedDay = _selectedDate.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: AppColors.deepOrange,
          onPrimary: Colors.white,
          onSurface: Colors.black,
          surface: Colors.white,
        ),
        dialogBackgroundColor: Colors.white,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.deepOrange,
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
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 340,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header (matching Flutter's DatePickerDialog exactly)
              Container(
                height: 64,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Month Dropdown Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showMonthDropdown = !_showMonthDropdown;
                          _showYearDropdown = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _monthNames[_selectedMonth - 1],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              _showMonthDropdown
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Year Dropdown Button (shown after month selection or always visible)
                    if (_showYearDropdown || !_showMonthDropdown)
                      GestureDetector(
                        onTap: () {
                          if (!_showMonthDropdown) {
                            setState(() {
                              _showYearDropdown = !_showYearDropdown;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedYear.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                _showYearDropdown
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Month Dropdown List
              if (_showMonthDropdown)
                Container(
                  constraints: BoxConstraints(maxHeight: 180),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final isSelected = month == _selectedMonth;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedMonth = month;
                            _showMonthDropdown = false;
                            _showYearDropdown = true; // Show year dropdown after month selection
                            _updateDate();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: isSelected
                              ? AppColors.deepOrange.withValues(alpha: 0.1)
                              : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _monthNames[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.deepOrange
                                      : Colors.black87,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: AppColors.deepOrange,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Year Dropdown List
              if (_showYearDropdown)
                Container(
                  constraints: BoxConstraints(maxHeight: 180),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _availableYears.length,
                    itemBuilder: (context, index) {
                      final year = _availableYears[index];
                      final isSelected = year == _selectedYear;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedYear = year;
                            _showYearDropdown = false;
                            _updateDate();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: isSelected
                              ? AppColors.deepOrange.withValues(alpha: 0.1)
                              : Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                year.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.deepOrange
                                      : Colors.black87,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: AppColors.deepOrange,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Calendar Grid with border radius
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Days of week header
                        Row(
                          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                              .map((day) => Expanded(
                                    child: Center(
                                      child: Text(
                                        day,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 12),
                        // Calendar days grid with border radius
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.deepOrange.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                              childAspectRatio: 1,
                            ),
                            itemCount: _availableDays.length + _getFirstDayOfWeek(),
                            itemBuilder: (context, index) {
                              if (index < _getFirstDayOfWeek()) {
                                return SizedBox.shrink();
                              }
                              final day = _availableDays[index - _getFirstDayOfWeek()];
                              final isSelected = day == _selectedDay;
                              final isToday = _isToday(day);
                              final date = DateTime(_selectedYear, _selectedMonth, day);
                              final isDisabled = date.isBefore(widget.firstDate) ||
                                  date.isAfter(widget.lastDate);
                              
                              return GestureDetector(
                                onTap: isDisabled
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedDay = day;
                                          _updateDate();
                                        });
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.deepOrange
                                        : (isToday
                                            ? AppColors.deepOrange.withValues(alpha: 0.15)
                                            : Colors.transparent),
                                    shape: BoxShape.circle,
                                    border: isToday && !isSelected
                                        ? Border.all(
                                            color: AppColors.deepOrange,
                                            width: 1.5,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.toString(),
                                      style: TextStyle(
                                        color: isDisabled
                                            ? Colors.black26
                                            : (isSelected
                                                ? Colors.white
                                                : Colors.black87),
                                        fontSize: 13,
                                        fontWeight: isSelected || isToday
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Action buttons (matching Flutter's DatePickerDialog exactly)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: AppColors.deepOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(_selectedDate),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: AppColors.deepOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getFirstDayOfWeek() {
    final firstDay = DateTime(_selectedYear, _selectedMonth, 1);
    return firstDay.weekday % 7; // 0 = Sunday, 1 = Monday, etc.
  }

  bool _isToday(int day) {
    final today = DateTime.now();
    return _selectedYear == today.year &&
        _selectedMonth == today.month &&
        day == today.day;
  }
}
