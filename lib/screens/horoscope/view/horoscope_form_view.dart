import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_form_controller.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeFormView extends BasePage<HoroscopeFormController> {
  final bool hideHeader;
  const HoroscopeFormView({super.key, this.hideHeader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            if (!hideHeader) const CommonHeader(title: 'Horoscope'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                child: _buildFormSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _formCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: AppColors.deepOrange.withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.deepOrange.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      hintText: hint,
      hintStyle: MyTextTheme.smallBCN.copyWith(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
        fontSize: 13.sp,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Icon(icon, color: AppColors.deepOrange, size: 20.w),
      ),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: _formCardDecoration(),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.orangeGradient.createShader(bounds),
              child: AutoTranslateText(
                'Get your daily horoscope predictions',
                style: MyTextTheme.mediumBCB.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Spacing.h(16),
          Row(
            children: [
              Expanded(
                child: _buildCompactField(
                  controller: controller.dateController,
                  hint: 'DOB (dd/mm/yyyy)',
                  icon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () => _showDatePicker(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(child: _buildTimeField()),
            ],
          ),
          Spacing.h(6),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: AutoTranslateText(
              'Accurate birth time improves horoscope accuracy.',
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 11.sp,
              ),
            ),
          ),
          Spacing.h(12),
          _buildCompactLocation(),
          Spacing.h(12),
          _buildLanguageDropdown(),
          Spacing.h(20),
          _buildSubmitButton(),
          Spacing.h(24),
          _buildOrDivider(),
          Spacing.h(24),
          _buildSelectSignSection(),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: AutoTranslateText(
            'OR',
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectSignSection() {
    return Column(
      children: [
        AutoTranslateText(
          'If you already know your sign then proceed here',
          textAlign: TextAlign.center,
          style: MyTextTheme.smallBCN.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
          ),
        ),
        Spacing.h(12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.deepOrange, width: 1.5),
          ),
          child: TextButton(
            onPressed: () {
              Get.toNamed(
                AppRoutes.horoscopeSignSelection,
                arguments: {
                  'formData': {
                    'date': controller.dateController.text,
                    'time':
                        TimePickerHelper.parseTime12To24(
                          controller.timeController.text,
                        ) ??
                        controller.timeController.text,
                    'latitude':
                        double.tryParse(controller.latitudeController.text) ??
                        0.0,
                    'longitude':
                        double.tryParse(controller.longitudeController.text) ??
                        0.0,
                    'timezone':
                        double.tryParse(controller.timezoneController.text) ??
                        0.0,
                    'place': controller.selectedLocation.value,
                    'language': controller.selectedLanguage.value,
                  },
                },
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: AutoTranslateText(
              'Select Zodiac Sign Directly',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Birth time field showing 12-hour AM/PM
  Widget _buildTimeField() {
    return Obx(() {
      final t = controller.selectedTime.value;
      String display = controller.timeController.text.isEmpty
          ? ''
          : TimePickerHelper.formatTime24To12Display(t.hour, t.minute);

      return GestureDetector(
        onTap: () => _showTimePicker(),
        child: AbsorbPointer(
          child: TextFormField(
            controller: TextEditingController(text: display),
            decoration: _inputDecoration(
              hint: 'Time of Birth',
              icon: Icons.access_time,
              suffix: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.deepOrange,
                size: 22.w,
              ),
            ),
            style: MyTextTheme.smallBCN.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCompactField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: MyTextTheme.smallBCN.copyWith(
        color: AppColors.textPrimary,
        fontSize: 13.sp,
      ),
      decoration: _inputDecoration(hint: hint, icon: icon),
    );
  }

  Widget _buildCompactLocation() {
    return GestureDetector(
      onTap: () => _showLocationBottomSheet(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.deepOrange.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppColors.deepOrange, size: 20.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(
                () => AutoTranslateText(
                  controller.selectedLocation.value.isEmpty
                      ? 'Select Birth Place'
                      : controller.selectedLocation.value,
                  style: MyTextTheme.smallBCN.copyWith(
                    color: controller.selectedLocation.value.isEmpty
                        ? AppColors.textSecondary.withValues(alpha: 0.6)
                        : AppColors.textPrimary,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Obx(
              () => controller.isFetchingLocation.value
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.deepOrange,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.deepOrange,
                      size: 22.w,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.deepOrange.withValues(alpha: 0.2)),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedLanguage.value,
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.deepOrange,
              size: 22.w,
            ),
            style: MyTextTheme.smallBCN.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
            ),
            hint: Row(
              children: [
                Icon(Icons.language, color: AppColors.deepOrange, size: 20.w),
                SizedBox(width: 12.w),
                AutoTranslateText(
                  'Select Language',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            items: controller.languages.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: AppColors.deepOrange,
                      size: 20.w,
                    ),
                    SizedBox(width: 12.w),
                    AutoTranslateText(
                      entry.value,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedLanguage.value = value;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : AutoTranslateText(
                  'Continue to get your zodiac sign',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    controller.selectDate(Get.context!);
  }

  void _showTimePicker() {
    controller.selectTime(Get.context!);
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
                controller.fetchLocationFromCity(
                  city,
                  state: state,
                  country: country,
                  latitude: latitude,
                  longitude: longitude,
                  timezone: timezone,
                );
                Get.back();
              },
          selectedCity: controller.selectedLocation.value,
          onUseCurrentLocation: () => controller.useCurrentLocation(),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
