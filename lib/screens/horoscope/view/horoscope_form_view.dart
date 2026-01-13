import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_form_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeFormView extends BasePage<HoroscopeFormController> {
  const HoroscopeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Location Selector
              _buildLocationSelector(),
              
              Spacing.h(20),
              
              // Form Section
              _buildFormSection(),
              
              Spacing.h(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: "#6F221E".toColor(),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
            ),
            Spacing.w(16),
            // Title
            Expanded(
              child: AutoTranslateText(
                'Horoscope Form',
                style: MyTextTheme.largeBCB.copyWith(
                  color: const Color(0xFFDFB343),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: GestureDetector(
        onTap: () => _showLocationBottomSheet(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFDFB343),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
              Spacing.w(12),
              Expanded(
                child: Obx(() => AutoTranslateText(
                  controller.selectedLocation.value,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: "#6F221E".toColor(),
                  ).merge(AppTypography.body1),
                )),
              ),
              Obx(() => controller.isFetchingLocation.value
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFDFB343),
                        ),
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(0xFFDFB343),
                      size: 16.w,
                    )),
            ],
          ),
        ),
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
            'Birth Details',
            style: MyTextTheme.largeBCB.copyWith(
              color: "#6F221E".toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(16),
          
          // Date field
          _buildTextField(
            controller: controller.dateController,
            label: 'Date of Birth',
            icon: Icons.calendar_today,
            onTap: () => controller.selectDate(Get.context!),
          ),
          Spacing.h(12),
          
          // Time field
          _buildTextField(
            controller: controller.timeController,
            label: 'Time of Birth',
            icon: Icons.access_time,
            onTap: () => controller.selectTime(Get.context!),
          ),
          Spacing.h(12),
          
          // Latitude field
          _buildTextField(
            controller: controller.latitudeController,
            label: 'Latitude',
            icon: Icons.location_on,
            readOnly: true,
          ),
          Spacing.h(12),
          
          // Longitude field
          _buildTextField(
            controller: controller.longitudeController,
            label: 'Longitude',
            icon: Icons.location_on,
            readOnly: true,
          ),
          Spacing.h(12),
          
          // Timezone field
          _buildTextField(
            controller: controller.timezoneController,
            label: 'Timezone offset',
            icon: Icons.access_time,
            readOnly: true,
          ),
          Spacing.h(12),
          
          // Language dropdown
          _buildLanguageField(),
          Spacing.h(20),
          
          // Submit button
          _buildSubmitButton(),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: MyTextTheme.mediumBCN.copyWith(
          color: "#6F221E".toColor(),
        ).merge(AppTypography.body1),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: "#6F221E".toColor().withOpacity(0.6),
          ).merge(AppTypography.body2),
          prefixIcon: Icon(icon, color: const Color(0xFFDFB343), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#DFB343".toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#DFB343".toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#DFB343".toColor(), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLanguageField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => DropdownButtonFormField<String>(
        value: controller.selectedLanguage.value,
        decoration: InputDecoration(
          labelText: 'Language',
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: "#6F221E".toColor().withOpacity(0.6),
          ).merge(AppTypography.body2),
          prefixIcon: Icon(Icons.language, color: const Color(0xFFDFB343), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#DFB343".toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#DFB343".toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: "#DFB343".toColor(), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: controller.languages.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: AutoTranslateText(
              entry.value,
              style: MyTextTheme.mediumBCN.copyWith(
                color: "#6F221E".toColor(),
              ).merge(AppTypography.body1),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.selectedLanguage.value = value;
          }
        },
      )),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDFB343),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 4,
        ),
        child: controller.isLoading.value
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : AutoTranslateText(
                'Continue to Sign Selection',
                style: MyTextTheme.largeBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h3),
              ),
      ),
    ));
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
          onCitySelected: (city, state, country) {
            controller.fetchLocationFromCity(city, state: state, country: country);
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










