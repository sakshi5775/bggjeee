import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_form_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HoroscopeFormView extends BasePage<HoroscopeFormController> {
  const HoroscopeFormView({super.key});

  // Gradient definitions
  static final LinearGradient gradientBackground = LinearGradient(
    colors: ["#FCE5AA".toColor(), "#FFFCF3".toColor(), "#FFFFFF".toColor()],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final LinearGradient primaryGradient = LinearGradient(
    colors: ["#820B17".toColor(), "#68171E".toColor(), "#5D1C21".toColor()],
  );

  static LinearGradient orangeGradient = LinearGradient(
    colors: ["#F38B3B".toColor(), "#DD2914".toColor()],
  );

  // Helper method to apply gradient to icons
  Widget _buildGradientIcon(IconData icon, double size) {
    return ShaderMask(
      shaderCallback: (bounds) => orangeGradient.createShader(bounds),
      child: Icon(
        icon,
        color: Colors.white,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradientBackground,
        ),
        child: SafeArea(
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: primaryGradient,
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
              color: Colors.transparent,
              width: 1.5,
            ),
            gradient: orangeGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                _buildGradientIcon(Icons.location_on, 24.w),
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
                    : _buildGradientIcon(Icons.arrow_forward_ios, 16.w)),
              ],
            ),
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
        borderRadius: BorderRadius.circular(12.r),
        gradient: orangeGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.5.r),
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
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ).merge(AppTypography.body2),
            prefixIcon: _buildGradientIcon(icon, 20.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.5.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.5.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.5.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: orangeGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.5.r),
        ),
        child: Obx(() => DropdownButtonFormField<String>(
          value: controller.selectedLanguage.value,
          decoration: InputDecoration(
            labelText: 'Language',
            labelStyle: MyTextTheme.smallBCN.copyWith(
              color: "#6F221E".toColor().withValues(alpha: 0.6),
            ).merge(AppTypography.body2),
            prefixIcon: _buildGradientIcon(Icons.language, 20.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.5.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.5.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.5.r),
              borderSide: BorderSide.none,
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: orangeGradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
          onCitySelected: (city, state, country, [latitude, longitude, timezone]) {
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










