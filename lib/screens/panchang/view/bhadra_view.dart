import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/panchang/controller/bhadra_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:intl/intl.dart';

class BhadraView extends BasePage<BhadraController> {
  const BhadraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildFormSection(),
              Spacing.h(16),
              // Daily Bhadrakaal
              Obx(
                () => controller.dailyPanchang.value != null
                    ? _buildDailyBhadrakaal()
                    : const SizedBox.shrink(),
              ),
              // Monthly Bhadrakaal list
              Obx(
                () => controller.monthlyBhadrakaal.isNotEmpty
                    ? _buildMonthlyBhadrakaal()
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
      title: "Bhadra",
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Bhadrakaal timings for the selected date',
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showLocationBottomSheet(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.templeGold,
                          width: 1.5,
                        ),
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
                                  color: AppColors.templeGold,
                                  fontSize: 14,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.templeGold,
                          width: 1.5,
                        ),
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
                                  color: AppColors.templeGold,
                                  fontSize: 14,
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
              fontSize: 18,
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
          // Spacing.h(12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _buildTextField(
          //         controller: controller.latitudeController,
          //         label: 'Latitude',
          //         icon: Icons.location_on,
          //       ),
          //     ),
          //     Spacing.w(12),
          //     Expanded(
          //       child: _buildTextField(
          //         controller: controller.longitudeController,
          //         label: 'Longitude',
          //         icon: Icons.location_on,
          //       ),
          //     ),
          //   ],
          // ),
          // Spacing.h(12),
          // Obx(
          //   () => SizedBox(
          //     width: double.infinity,
          //     child: GestureDetector(
          //       onTap: controller.isFetchingLocation.value
          //           ? null
          //           : controller.getCurrentLocation,
          //       child: Container(
          //         decoration: BoxDecoration(
          //           gradient: AppColors.orangeGradient,
          //           borderRadius: BorderRadius.circular(12.r),
          //         ),
          //         padding: EdgeInsets.symmetric(vertical: 14.h),
          //         alignment: Alignment.center,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             controller.isFetchingLocation.value
          //                 ? SizedBox(
          //                     width: 20.w,
          //                     height: 20.w,
          //                     child: CircularProgressIndicator(
          //                       strokeWidth: 2,
          //                       valueColor: AlwaysStoppedAnimation<Color>(
          //                         Colors.white,
          //                       ),
          //                     ),
          //                   )
          //                 : Icon(
          //                     Icons.my_location,
          //                     size: 20.w,
          //                     color: Colors.white,
          //                   ),
          //             Spacing.w(8),
          //             AutoTranslateText(
          //               controller.isFetchingLocation.value
          //                   ? 'Getting Location...'
          //                   : 'Get Current Location',
          //               style: MyTextTheme.mediumBCB.copyWith(
          //                 color: Colors.white,
          //                 fontSize: 14,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Spacing.h(20),
          _buildLanguageDropdown(),
          Spacing.h(20),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: controller.isLoading.value
                    ? null
                    : controller.fetchBhadrakaalData,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  alignment: Alignment.center,
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
                          'Get Bhadrakaal',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: Colors.white,
                            fontSize: 16,
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
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: "#68171E".toColor()),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: "#68171E".toColor().withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: "#68171E".toColor().withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: "#68171E".toColor(), width: 2),
        ),
        labelStyle: MyTextTheme.smallBCN.copyWith(
          color: "#68171E".toColor().withValues(alpha: 0.7),
        ),
      ),
      style: MyTextTheme.mediumBCN.copyWith(color: "#68171E".toColor()),
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
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.language,
            color: "#68171E".toColor().withValues(alpha: 0.7),
            size: 20.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: "#68171E".toColor().withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: "#68171E".toColor().withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#68171E".toColor(), width: 2),
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
                    fontSize: 14,
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
          size: 20.w,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        style: MyTextTheme.mediumBCN.copyWith(
          color: "#68171E".toColor(),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDailyBhadrakaal() {
    final data = controller.dailyPanchang.value;
    if (data == null) return const SizedBox.shrink();

    final bhadra = data['bhadrakaal']?.toString() ?? '';
    final dayName = data['day']?['name']?.toString() ?? '';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            "Today's Bhadrakaal",
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18,
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
                  color: Colors.black.withValues(alpha: 0.06),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                if (dayName.isNotEmpty) Spacing.h(12),
                _timingRow(
                  'Bhadrakaal',
                  bhadra.isEmpty ? 'Not Available' : bhadra,
                  AppColors.orangeGradient.colors.first,
                ),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacing.h(2),
              AutoTranslateText(
                value,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: "#68171E".toColor(),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyBhadrakaal() {
    final items = controller.monthlyBhadrakaal;
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Monthly Bhadrakaal',
            style: MyTextTheme.mediumBCB.copyWith(
              color: "#68171E".toColor(),
              fontSize: 18,
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
    final bhadra = item['bhadrakaal']?.toString() ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                    fontSize: 14,
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
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: AutoTranslateText(
                    day,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (bhadra.isNotEmpty) ...[
            Spacing.h(10),
            _timingRow(
              'Bhadrakaal',
              bhadra,
              AppColors.orangeGradient.colors.first,
            ),
          ] else ...[
            Spacing.h(10),
            AutoTranslateText(
              'No Bhadrakaal',
              style: MyTextTheme.smallBCN.copyWith(
                color: "#68171E".toColor().withValues(alpha: 0.5),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
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
