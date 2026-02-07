import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/muhurat_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:intl/intl.dart';

class MuhuratView extends BasePage<MuhuratController> {
  const MuhuratView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(context),

              // Form Section
              _buildFormSection(),
              Spacing.h(16),

              // Abhijit Muhurta (Today's Muhurat)
              Obx(
                () => controller.abhijitMuhurta.value != null
                    ? _buildAbhijitMuhurta()
                    : const SizedBox.shrink(),
              ),

              // Choghadiya Muhurats
              Obx(
                () => controller.choghadiyaMuhurta.value != null
                    ? _buildChoghadiyaMuhurats()
                    : const SizedBox.shrink(),
              ),

              Spacing.h(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CommonHeader(
      title: 'Muhurat',
      subtitle: Column(
        children: [
          AutoTranslateText(
            'Auspicious timings for the selected date',
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ),
          Spacing.h(8),
          _buildLocationDateSelector(),
        ],
      ),
    );
  }

  Widget _buildLocationDateSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showLocationBottomSheet(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.templeGold, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.templeGold,
                      size: 18.w,
                    ),
                    Spacing.w(8),
                    Expanded(
                      child: Obx(
                        () => AutoTranslateText(
                          controller.selectedLocation.value,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#68171E".toColor(),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacing.w(12),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.selectDate(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.templeGold, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.templeGold,
                      size: 18.w,
                    ),
                    Spacing.w(8),
                    Expanded(
                      child: Obx(
                        () => AutoTranslateText(
                          controller.selectedDate.value.day ==
                                      DateTime.now().day &&
                                  controller.selectedDate.value.month ==
                                      DateTime.now().month &&
                                  controller.selectedDate.value.year ==
                                      DateTime.now().year
                              ? 'Today'
                              : DateFormat(
                                  'dd MMM',
                                ).format(controller.selectedDate.value),
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: "#68171E".toColor(),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildFormSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Enter Details',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          // Date field
          _buildTextField(
            controller: controller.dateController,
            label: 'Date (dd/mm/yyyy)',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: controller.selectDate,
          ),
          Spacing.h(12),
          // Time field
          _buildTextField(
            controller: controller.timeController,
            label: 'Time',
            icon: Icons.access_time,
            readOnly: true,
            onTap: () async {
              final now = DateTime.now();
              final picked = await TimePickerHelper.showTimePicker12h(
                Get.context!,
                initialTime: TimeOfDay.fromDateTime(now),
              );
              if (picked != null) {
                controller.timeController.text =
                    TimePickerHelper.formatTime24To12Display(
                      picked.hour,
                      picked.minute,
                    );
              }
            },
          ),
          Spacing.h(12),
          _buildLanguageDropdown(),
          Spacing.h(20),
          // Submit button
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.fetchMuhuratData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : AutoTranslateText(
                          'Get Muhurat',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Spacing.h(20),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedLanguage.value,
        decoration: InputDecoration(
          labelText: 'Language',
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: "#68171E".toColor().withValues(alpha: 0.7),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.language,
            color: "#68171E".toColor().withValues(alpha: 0.7),
            size: 20.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.gray.withValues(alpha: 0.5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.gray.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: AppColors.gray.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.8),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 16.h,
          ),
        ),
        items: controller.languages.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: AutoTranslateText(
              entry.value,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#68171E".toColor(),
                fontSize: 14.sp,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.selectedLanguage.value = newValue;
          }
        },
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: "#68171E".toColor(),
          size: 24.w,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        style: MyTextTheme.mediumBCN.copyWith(
          color: "#68171E".toColor(),
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return MyTextField(
      controller: controller,
      labelText: label,
      prefixIcon: Icon(icon, color: "#68171E".toColor()),
      readOnly: readOnly,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
    );
  }

  Widget _buildAbhijitMuhurta() {
    final muhurta = controller.abhijitMuhurta.value;
    if (muhurta == null) return const SizedBox.shrink();

    final start = muhurta['start']?.toString() ?? '';
    final end = muhurta['end']?.toString() ?? '';

    // Check for NaN values
    final hasValidStart = start.isNotEmpty && !start.contains('NaN');
    final hasValidEnd = end.isNotEmpty && !end.contains('NaN');

    if (!hasValidStart && !hasValidEnd) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            "Today's Muhurat",
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28.w,
                  ),
                ),
                Spacing.w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        'Abhijit Muhurta',
                        style: MyTextTheme.largeBCB.copyWith(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        hasValidStart && hasValidEnd
                            ? '${_formatTime(start)} - ${_formatTime(end)}'
                            : hasValidStart
                            ? 'Starts: ${_formatTime(start)}'
                            : hasValidEnd
                            ? 'Ends: ${_formatTime(end)}'
                            : 'Not Available',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(20),
        ],
      ),
    );
  }

  Widget _buildChoghadiyaMuhurats() {
    final data = controller.choghadiyaMuhurta.value;
    if (data == null) return const SizedBox.shrink();

    final dayMuhurats = data['day'] as List<dynamic>? ?? [];
    final nightMuhurats = data['night'] as List<dynamic>? ?? [];
    final dayOfWeek = data['day_of_week']?.toString() ?? '';
    final selectedDateStr = controller.dateController.text;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected date and day label
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18.w,
                color: "#68171E".toColor(),
              ),
              Spacing.w(8),
              AutoTranslateText(
                selectedDateStr.isNotEmpty ? selectedDateStr : 'Selected date',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (dayOfWeek.isNotEmpty) ...[
                Spacing.w(12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.templeGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.templeGold.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: AutoTranslateText(
                    dayOfWeek,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: "#68171E".toColor(),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Spacing.h(12),

          // Day Muhurats
          if (dayMuhurats.isNotEmpty) ...[
            AutoTranslateText(
              'Day Muhurats',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.h(12),
            ...dayMuhurats.map(
              (muhurat) => _buildMuhuratCard(muhurat as Map<String, dynamic>),
            ),
            Spacing.h(20),
          ],

          // Night Muhurats
          if (nightMuhurats.isNotEmpty) ...[
            AutoTranslateText(
              'Night Muhurats',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#68171E".toColor(),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.h(12),
            ...nightMuhurats.map(
              (muhurat) => _buildMuhuratCard(muhurat as Map<String, dynamic>),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMuhuratCard(Map<String, dynamic> muhurat) {
    final muhuratName = muhurat['muhurat']?.toString() ?? '';
    final type = muhurat['type']?.toString() ?? '';
    final start = muhurat['start']?.toString() ?? '';
    final end = muhurat['end']?.toString() ?? '';

    // Determine color based on type
    Color cardColor;
    Color textColor;
    IconData icon;

    if (type.toLowerCase() == 'auspicious') {
      cardColor = Colors.green.shade50;
      textColor = Colors.green.shade700;
      icon = Icons.check_circle;
    } else if (type.toLowerCase() == 'inauspicious') {
      cardColor = Colors.red.shade50;
      textColor = Colors.red.shade700;
      icon = Icons.cancel;
    } else {
      cardColor = Colors.orange.shade50;
      textColor = Colors.orange.shade700;
      icon = Icons.info;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: textColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: textColor, size: 24.w),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AutoTranslateText(
                        muhuratName,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#68171E".toColor(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: AutoTranslateText(
                        type,
                        style: MyTextTheme.smallBCB.copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.h(8),
                AutoTranslateText(
                  '${_formatDateTime(start)} - ${_formatDateTime(end)}',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#68171E".toColor().withValues(alpha: 0.7),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeStr) {
    if (timeStr.contains('NaN') || timeStr.isEmpty) {
      return 'Not Available';
    }
    // Extract time from format like "12:NaN:NaN PM" or "12:45:30 PM"
    try {
      if (timeStr.contains('PM') || timeStr.contains('AM')) {
        final parts = timeStr.split(' ');
        if (parts.length >= 2) {
          return '${parts[parts.length - 2]} ${parts[parts.length - 1]}';
        }
      }
      return timeStr;
    } catch (e) {
      return timeStr;
    }
  }

  String _formatDateTime(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return '--';
    try {
      // Keep full date and time, but trim spacing if comma separated
      if (dateTimeStr.contains(',')) {
        final parts = dateTimeStr.split(',');
        return parts.map((e) => e.trim()).join(', ');
      }
      return dateTimeStr;
    } catch (e) {
      return dateTimeStr;
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
                // Handle city selection if needed
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
