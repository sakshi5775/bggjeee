import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_form_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/my_widget/time_info_widget.dart';

class KundliFormView extends BasePage<KundliFormController> {
  const KundliFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header using CommonHeader
              CommonHeader(
                title: 'Generate Kundli',
                titleColor: AppColors.templeGold,
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 24.h,
                  ),
                  child: _buildFormSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepOrange.withOpacity(0.15),
                    AppColors.deepOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.location_on,
                color: AppColors.deepOrange,
                size: 18.w,
              ),
            ),
            SizedBox(width: 8.w),
            AutoTranslateText(
              'Select Location',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => _showLocationBottomSheet(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.grey.shade50],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.deepOrange.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 20.h,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.deepOrange.withOpacity(0.1),
                            AppColors.deepOrange.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.deepOrange,
                        size: 22.w,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 18.h,
                        horizontal: 4.w,
                      ),
                      child: Obx(
                        () => AutoTranslateText(
                          controller.selectedLocation.value,
                          style: MyTextTheme.mediumBCN.copyWith(
                            color: AppColors.textColorMaroon,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.deepOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.deepOrange,
                        size: 14.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Section Title with decorative elements
        Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.deepOrange.withOpacity(0.1),
                      AppColors.templeGold.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.deepOrange.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: AutoTranslateText(
                  'Enter Details',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: AppColors.textColorMaroon,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 3.h,
                width: 60.w,
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ],
          ),
        ),
        Spacing.h(32),

        // Name field (Optional)
        _buildTextField(
          title: 'Enter Full Name',
          hint: 'Enter Full Name',
          controller: controller.nameController,
          icon: Icons.person,
          readOnly: false,
        ),
        Spacing.h(20),

        // Gender dropdown
        _buildGenderField(),
        Spacing.h(20),

        // Date field
        _buildTextField(
          title: 'Enter Date of birth',
          controller: controller.dateController,
          hint: '(dd/mm/yyyy)',
          icon: Icons.calendar_today,
          readOnly: true,
          onTap: () => _showDatePicker(),
        ),
        Spacing.h(10),
        TimeInfoWidget(
          icon: Icons.access_time,
          title: 'correct birth date improve kundli accuracy',
        ),

        Spacing.h(20),

        // Time field
        _buildTextField(
          title: 'Enter Birth time',
          controller: controller.timeController,
          hint: 'Birth time (hh:mm)',
          icon: Icons.access_time,
          readOnly: true,
          onTap: () => _showTimePicker(),
        ),

        Spacing.h(20),

        _buildLocationSelector(),
        Spacing.h(20),

        // Language dropdown
        _buildLanguageField(),
        Spacing.h(20),

        // Style dropdown
        _buildStyleField(),
        Spacing.h(40),

        // Submit button
        _buildSubmitButton(),
        Spacing.h(24),
      ],
    );
  }

  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepOrange.withOpacity(0.15),
                    AppColors.deepOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.deepOrange, size: 16.w),
            ),
            SizedBox(width: 8.w),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
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
              color: AppColors.textColorMaroon,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 22.h,
                horizontal: 20.w,
              ),
              hintText: hint,
              hintStyle: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(14.w),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.deepOrange.withOpacity(0.1),
                        AppColors.deepOrange.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: AppColors.deepOrange, size: 20.w),
                ),
              ),
              suffixIcon: readOnly && onTap != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppColors.deepOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.deepOrange,
                          size: 14.w,
                        ),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withOpacity(0.15),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(color: AppColors.deepOrange, width: 2.5),
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepOrange.withOpacity(0.15),
                    AppColors.deepOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.language,
                color: AppColors.deepOrange,
                size: 18.w,
              ),
            ),
            SizedBox(width: 8.w),
            AutoTranslateText(
              'Select Language',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedLanguage.value,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.w,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deepOrange.withOpacity(0.1),
                          AppColors.deepOrange.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.language,
                      color: AppColors.deepOrange,
                      size: 20.w,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.deepOrange,
                    size: 28.w,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange,
                    width: 2.5,
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              items: controller.languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: AutoTranslateText(
                    entry.value,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: AppColors.textColorMaroon,
                      fontWeight: FontWeight.w500,
                    ),
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
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepOrange.withOpacity(0.15),
                    AppColors.deepOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.deepOrange,
                size: 18.w,
              ),
            ),
            SizedBox(width: 8.w),
            AutoTranslateText(
              'Select Gender',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedGender.value,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.w,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deepOrange.withOpacity(0.1),
                          AppColors.deepOrange.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.deepOrange,
                      size: 20.w,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.deepOrange,
                    size: 28.w,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange,
                    width: 2.5,
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              hint: AutoTranslateText(
                'Select Gender',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
              items: controller.genderOptions.map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: AutoTranslateText(
                    gender,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: AppColors.textColorMaroon,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedGender.value = value;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStyleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.deepOrange.withOpacity(0.15),
                    AppColors.deepOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.style, color: AppColors.deepOrange, size: 18.w),
            ),
            SizedBox(width: 8.w),
            AutoTranslateText(
              'Chart Style',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.textColorMaroon,
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedStyle.value,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.w,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.deepOrange.withOpacity(0.1),
                          AppColors.deepOrange.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.style,
                      color: AppColors.deepOrange,
                      size: 20.w,
                    ),
                  ),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.deepOrange,
                    size: 28.w,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.deepOrange,
                    width: 2.5,
                  ),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              items: controller.styles.map((style) {
                return DropdownMenuItem<String>(
                  value: style,
                  child: AutoTranslateText(
                    style.toUpperCase(),
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: AppColors.textColorMaroon,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedStyle.value = value;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.generateKundli,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: controller.isLoading.value
                  ? LinearGradient(
                      colors: [
                        AppColors.deepOrange.withOpacity(0.5),
                        AppColors.templeGold.withOpacity(0.5),
                      ],
                    )
                  : AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              alignment: Alignment.center,
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.white,
                          size: 22.w,
                        ),
                        SizedBox(width: 12.w),
                        AutoTranslateText(
                          'Generate Kundli',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textColorMaroon,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      controller.selectDate(pickedDate);
    }
  }

  void _showTimePicker() async {
    final pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: controller.selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textColorMaroon,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      controller.selectTime(pickedTime);
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

// Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String label,
  //   required IconData icon,
  //   bool readOnly = false,
  //   VoidCallback? onTap,
  // }) {
  //   return Container(
  //     height: 56.h,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: TextFormField(
  //       controller: controller,
  //       readOnly: readOnly,
  //       onTap: onTap,
  //       style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
  //       decoration: InputDecoration(
  //         labelText: label,
  //         labelStyle: MyTextTheme.smallBCN.copyWith(
  //           color: '#3E2723'.toColor().withOpacity(0.6),
  //         ),
  //         prefixIcon: Container(
  //           padding: EdgeInsets.all(12.w),
  //           child: Icon(icon, color: '#FF6B35'.toColor(), size: 20.w),
  //         ),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12.r),
  //           borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12.r),
  //           borderSide: BorderSide(
  //             color: '#F5D7B8'.toColor().withOpacity(0.5),
  //             width: 1,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12.r),
  //           borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
  //         ),
  //         filled: true,
  //         fillColor: Colors.white,
  //       ),
  //     ),
  //   );
  // }

 // Widget _buildGenderField() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Obx(
  //       () => DropdownButtonFormField<String>(
  //         value: controller.selectedGender.value,
  //         decoration: InputDecoration(
  //           labelText: 'Gender',
  //           labelStyle: MyTextTheme.smallBCN.copyWith(
  //             color: '#3E2723'.toColor().withOpacity(0.6),
  //           ),
  //           prefixIcon: Icon(
  //             Icons.person_outline,
  //             color: '#FF6B35'.toColor(),
  //             size: 20.w,
  //           ),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(
  //               color: '#F5D7B8'.toColor().withOpacity(0.5),
  //               width: 1,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
  //           ),
  //           filled: true,
  //           fillColor: Colors.white,
  //         ),
  //         items: controller.genderOptions.map((gender) {
  //           return DropdownMenuItem<String>(
  //             value: gender,
  //             child: AutoTranslateText(
  //               gender,
  //               style: MyTextTheme.mediumBCN.copyWith(
  //                 color: '#3E2723'.toColor(),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           if (value != null) {
  //             controller.selectedGender.value = value;
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildStyleField() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Obx(
  //       () => DropdownButtonFormField<String>(
  //         value: controller.selectedStyle.value,
  //         decoration: InputDecoration(
  //           labelText: 'Chart style (north, south, east)',
  //           labelStyle: MyTextTheme.smallBCN.copyWith(
  //             color: '#3E2723'.toColor().withOpacity(0.6),
  //           ),
  //           prefixIcon: Icon(
  //             Icons.style,
  //             color: '#FF6B35'.toColor(),
  //             size: 20.w,
  //           ),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(
  //               color: '#F5D7B8'.toColor().withOpacity(0.5),
  //               width: 1,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
  //           ),
  //           filled: true,
  //           fillColor: Colors.white,
  //         ),
  //         items: controller.styles.map((style) {
  //           return DropdownMenuItem<String>(
  //             value: style,
  //             child: AutoTranslateText(
  //               style.toUpperCase(),
  //               style: MyTextTheme.mediumBCN.copyWith(
  //                 color: '#3E2723'.toColor(),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           if (value != null) {
  //             controller.selectedStyle.value = value;
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildColoredPlanetsField() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Obx(
  //       () => DropdownButtonFormField<bool>(
  //         value: controller.coloredPlanets.value,
  //         decoration: InputDecoration(
  //           labelText: 'Send true for colored font',
  //           labelStyle: MyTextTheme.smallBCN.copyWith(
  //             color: '#3E2723'.toColor().withOpacity(0.6),
  //           ),
  //           prefixIcon: Icon(
  //             Icons.palette,
  //             color: '#FF6B35'.toColor(),
  //             size: 20.w,
  //           ),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(
  //               color: '#F5D7B8'.toColor().withOpacity(0.5),
  //               width: 1,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
  //           ),
  //           filled: true,
  //           fillColor: Colors.white,
  //         ),
  //         items: const [
  //           DropdownMenuItem<bool>(
  //             value: true,
  //             child: AutoTranslateText('True'),
  //           ),
  //           DropdownMenuItem<bool>(
  //             value: false,
  //             child: AutoTranslateText('False'),
  //           ),
  //         ],
  //         onChanged: (value) {
  //           if (value != null) {
  //             controller.coloredPlanets.value = value;
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

 // Widget _buildSubmitButton() {
  //   return Obx(
  //     () => SizedBox(
  //       width: double.infinity,
  //       child: ElevatedButton(
  //         onPressed: controller.isLoading.value
  //             ? null
  //             : controller.generateKundli,
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: '#FF6B35'.toColor(),
  //           foregroundColor: Colors.white,
  //           padding: EdgeInsets.symmetric(vertical: 16.h),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //           ),
  //           elevation: 4,
  //         ),
  //         child: controller.isLoading.value
  //             ? SizedBox(
  //                 height: 20.h,
  //                 width: 20.w,
  //                 child: CircularProgressIndicator(
  //                   strokeWidth: 2,
  //                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //                 ),
  //               )
  //             : AutoTranslateText(
  //                 'Generate Kundli',
  //                 style: MyTextTheme.largeBCB.copyWith(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildLanguageField() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12.r),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Obx(
  //       () => DropdownButtonFormField<String>(
  //         value: controller.selectedLanguage.value,
  //         decoration: InputDecoration(
  //           labelText: 'Language code',
  //           labelStyle: MyTextTheme.smallBCN.copyWith(
  //             color: '#3E2723'.toColor().withOpacity(0.6),
  //           ),
  //           prefixIcon: Icon(
  //             Icons.language,
  //             color: '#FF6B35'.toColor(),
  //             size: 20.w,
  //           ),
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(
  //               color: '#F5D7B8'.toColor().withOpacity(0.5),
  //               width: 1,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(12.r),
  //             borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
  //           ),
  //           filled: true,
  //           fillColor: Colors.white,
  //         ),
  //         items: controller.languages.entries.map((entry) {
  //           return DropdownMenuItem<String>(
  //             value: entry.key,
  //             child: AutoTranslateText(
  //               entry.value,
  //               style: MyTextTheme.mediumBCN.copyWith(
  //                 color: '#3E2723'.toColor(),
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (value) {
  //           if (value != null) {
  //             controller.selectedLanguage.value = value;
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }