import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/loshu_grid_form_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LoShuGridFormView extends BasePage<LoShuGridFormController> {
  const LoShuGridFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header
            CommonHeader(title: 'Lo Shu Grid'),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacing.h(20),
                    // Info Card
                    _buildInfoCard(),
                    Spacing.h(20),
                    // Form Card
                    _buildFormCard(),
                    Spacing.h(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            "#DFB343".toColor().withOpacity(0.1),
            "#DFB343".toColor().withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: "#DFB343".toColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: "#DFB343".toColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: "#DFB343".toColor(),
              size: 24.w,
            ),
          ),
          Spacing.w(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  'Discover Your Numerology',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.h(4),
                AutoTranslateText(
                  'Enter your details to generate your personalized Lo Shu Grid',
                  style: MyTextTheme.smallBCN.copyWith(
                    color: "#6F221E".toColor().withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: "#DFB343".toColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.edit_calendar,
                  color: "#DFB343".toColor(),
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  'Enter Your Details',
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: "#6F221E".toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
              ),
            ],
          ),
          Spacing.h(24),
          // Date of Birth
          _buildDateField(),
          Spacing.h(24),
          // Gender
          _buildGenderField(),
          Spacing.h(24),
          // Language
          _buildLanguageField(),
          Spacing.h(32),
          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, color: "#DFB343".toColor(), size: 18.w),
            Spacing.w(8),
            AutoTranslateText(
              'Date of Birth',
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body1),
            ),
          ],
        ),
        Spacing.h(10),
        Obx(
          () => GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: Get.context!,
                initialDate: controller.selectedDate.value ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: "#DFB343".toColor(),
                        onPrimary: Colors.white,
                        surface: Colors.white,
                        onSurface: "#6F221E".toColor(),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                controller.selectDate(picked);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: controller.selectedDate.value != null
                    ? "#DFB343".toColor().withOpacity(0.05)
                    : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: controller.selectedDate.value != null
                      ? "#DFB343".toColor()
                      : Colors.grey.withOpacity(0.3),
                  width: controller.selectedDate.value != null ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AutoTranslateText(
                      controller.selectedDate.value != null
                          ? DateFormat(
                              'dd/MM/yyyy',
                            ).format(controller.selectedDate.value!)
                          : 'Select Date of Birth (DD/MM/YYYY)',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: controller.selectedDate.value != null
                            ? "#6F221E".toColor()
                            : Colors.grey,
                        fontWeight: controller.selectedDate.value != null
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Spacing.w(8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: controller.selectedDate.value != null
                        ? "#DFB343".toColor()
                        : Colors.grey,
                    size: 16.w,
                  ),
                ],
              ),
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
            Icon(Icons.person, color: "#DFB343".toColor(), size: 18.w),
            Spacing.w(8),
            AutoTranslateText(
              'Gender',
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body1),
            ),
          ],
        ),
        Spacing.h(10),
        Row(
          children: [
            Expanded(child: _buildGenderOption('male', 'Male', Icons.male)),
            Spacing.w(12),
            Expanded(
              child: _buildGenderOption('female', 'Female', Icons.female),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    return Obx(() {
      final isSelected = controller.selectedGender.value == value;
      return GestureDetector(
        onTap: () => controller.selectGender(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected
                ? "#DFB343".toColor().withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? "#DFB343".toColor()
                  : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? "#DFB343".toColor() : Colors.grey,
                size: 28.w,
              ),
              Spacing.h(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? "#DFB343".toColor() : Colors.grey,
                    size: 18.w,
                  ),
                  Spacing.w(6),
                  AutoTranslateText(
                    label,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: isSelected ? "#6F221E".toColor() : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLanguageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.language, color: "#DFB343".toColor(), size: 18.w),
            Spacing.w(8),
            AutoTranslateText(
              'Language',
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: "#6F221E".toColor(),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body1),
            ),
          ],
        ),
        Spacing.h(10),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: "#DFB343".toColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: controller.selectedLanguage.value,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              items: controller.languages.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: AutoTranslateText(
                    entry.value,
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: "#6F221E".toColor(),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectLanguage(value);
                }
              },
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down, color: "#DFB343".toColor()),
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
        height: 56.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: controller.isLoading.value
                ? [
                    "#DFB343".toColor().withOpacity(0.5),
                    "#DFB343".toColor().withOpacity(0.3),
                  ]
                : ["#DFB343".toColor(), "#DFB343".toColor().withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: controller.isLoading.value
              ? []
              : [
                  BoxShadow(
                    color: "#DFB343".toColor().withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.generateLoShuGrid(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 20.w),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Generate Lo Shu Grid',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
