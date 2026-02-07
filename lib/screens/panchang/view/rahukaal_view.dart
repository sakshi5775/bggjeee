import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/rahukaal_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:intl/intl.dart';

class RahukaalView extends BasePage<RahukaalController> {
  const RahukaalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildFormSection(),
              Spacing.h(16),
              // Daily Rahukaal
              Obx(
                () => controller.dailyPanchang.value != null
                    ? _buildDailyRahukaal()
                    : const SizedBox.shrink(),
              ),
              // Monthly Rahukaal list
              Obx(
                () => controller.monthlyRahukaal.isNotEmpty
                    ? _buildMonthlyRahukaal()
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
      title: 'Rahu Kaal',
      subtitle: Padding(
        padding: EdgeInsets.only(top: 4.h),
        child: Column(
          children: [
            AutoTranslateText(
              'Rahu Kaal & inauspicious timings for the selected date',
              style: MyTextTheme.mediumBCN.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.sp,
              ),
            ),
            Spacing.h(8),
            _buildLocationDateSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationDateSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
          _buildTextField(
            controller: controller.dateController,
            label: 'Date (dd/mm/yyyy)',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: controller.selectDate,
          ),
          Spacing.h(12),
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
                      : controller.fetchRahukaalData,
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
                          'Get Rahukaal',
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
        items: controller.languages.entries
            .map(
              (entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: AutoTranslateText(
                  entry.value,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: "#68171E".toColor(),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (val) {
          if (val != null) controller.selectedLanguage.value = val;
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

  Widget _buildDailyRahukaal() {
    final data = controller.dailyPanchang.value;
    if (data == null) return const SizedBox.shrink();

    final rahu = data['rahukaal']?.toString() ?? '';
    final gulika = data['gulika']?.toString() ?? '';
    final yama = data['yamakanta']?.toString() ?? '';
    final bhadra = data['bhadrakaal']?.toString() ?? '';
    final dayName = data['day']?['name']?.toString() ?? '';
    final advanced = data['advanced_details'] as Map<String, dynamic>?;
    final disha = advanced?['disha_shool']?.toString() ?? '';
    final sunrise =
        advanced?['sun_rise']?.toString() ??
        advanced?['sunrise']?.toString() ??
        '';
    final sunset =
        advanced?['sun_set']?.toString() ??
        advanced?['sunset']?.toString() ??
        '';

    String _safe(String v) =>
        (v.isEmpty || v.contains('NaN')) ? 'Not Available' : v;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            "Today's Rahukaal",
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (dayName.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.today,
                        size: 18.w,
                        color: AppColors.templeGold,
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        dayName,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#68171E".toColor(),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                if (dayName.isNotEmpty) Spacing.h(12),
                _timingRow('Rahu Kaal', _safe(rahu), Colors.red),
                Spacing.h(8),
                _timingRow('Gulika', _safe(gulika), Colors.deepOrange),
                Spacing.h(8),
                _timingRow('Yamakanta', _safe(yama), Colors.orange),
                Spacing.h(8),
                _timingRow(
                  'Bhadrakaal',
                  bhadra.isEmpty ? 'Not Available' : bhadra,
                  Colors.brown,
                ),
                if (disha.isNotEmpty) ...[
                  Spacing.h(12),
                  _timingRow('Disha Shool', disha, Colors.blueGrey),
                ],
                if (sunrise.isNotEmpty || sunset.isNotEmpty) ...[
                  Spacing.h(12),
                  Row(
                    children: [
                      Expanded(
                        child: _timingRow(
                          'Sunrise',
                          _safe(sunrise),
                          Colors.green,
                        ),
                      ),
                      Spacing.w(8),
                      Expanded(
                        child: _timingRow(
                          'Sunset',
                          _safe(sunset),
                          Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Spacing.h(20),
        ],
      ),
    );
  }

  Widget _timingRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          margin: EdgeInsets.only(top: 6.h),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Spacing.w(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                label,
                style: MyTextTheme.smallBCB.copyWith(
                  color: "#68171E".toColor().withValues(alpha: 0.7),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.h(2),
              AutoTranslateText(
                value,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyRahukaal() {
    final items = controller.monthlyRahukaal;
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Monthly Rahukaal',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(12),
          ...items.map((item) => _monthlyCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _monthlyCard(Map<String, dynamic> item) {
    final date = item['date']?.toString() ?? '';
    final day = item['day']?['name']?.toString() ?? '';
    final rahu = item['rahukaal']?.toString() ?? '';
    final gulika = item['gulika']?.toString() ?? '';
    final yama = item['yamakanta']?.toString() ?? '';
    final bhadra = item['bhadrakaal']?.toString() ?? '';

    String _safe(String v) =>
        (v.isEmpty || v.contains('NaN')) ? 'Not Available' : v;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: AppColors.templeGold.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, size: 18.w, color: AppColors.templeGold),
              Spacing.w(8),
              Expanded(
                child: AutoTranslateText(
                  date,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#68171E".toColor(),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (day.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.templeGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AutoTranslateText(
                    day,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: "#68171E".toColor(),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          Spacing.h(10),
          _timingRow('Rahu Kaal', _safe(rahu), Colors.red),
          Spacing.h(6),
          _timingRow('Gulika', _safe(gulika), Colors.deepOrange),
          Spacing.h(6),
          _timingRow('Yamakanta', _safe(yama), Colors.orange),
          if (bhadra.isNotEmpty) ...[
            Spacing.h(6),
            _timingRow('Bhadrakaal', bhadra, Colors.brown),
          ],
        ],
      ),
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
