import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_form_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';

class NumerologyFormView extends BasePage<NumerologyFormController> {
  const NumerologyFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header
            CommonHeader(title: 'Numerology'),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.h(20),
                    // Form Card
                    _buildFormCard(),
                    Spacing.h(20),
                    // Submit Button
                    _buildSubmitButton(),
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

  Widget _buildFormCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'Enter Your Details',
              style: MyTextTheme.largeBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(20),
            // Name Field (Optional)
            _buildNameField(),
            Spacing.h(16),
            // Phone Field (Optional)
            _buildPhoneField(),
            Spacing.h(16),
            // Date of Birth Field
            _buildDateField(),
            Spacing.h(16),
            // Gender Field
            _buildGenderField(),
            Spacing.h(16),
            // Language Field
            _buildLanguageField(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person, size: 18.w, color: "#6F221E".toColor()),
            Spacing.w(8),
            AutoTranslateText(
              'Name (Optional)',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Spacing.h(8),
        TextField(
          controller: controller.nameController,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: "#6F221E".toColor(), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.phone, size: 18.w, color: "#6F221E".toColor()),
            Spacing.w(8),
            AutoTranslateText(
              'Phone Number (Optional)',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Spacing.h(8),
        TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Enter your phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: "#6F221E".toColor(), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.05),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 18.w, color: "#6F221E".toColor()),
            Spacing.w(8),
            AutoTranslateText(
              'Date of Birth *',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Spacing.h(8),
        Obx(
          () => GestureDetector(
            onTap: () => _showDatePicker(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: controller.selectedDate.value != null
                      ? "#6F221E".toColor()
                      : Colors.grey.withOpacity(0.3),
                  width: controller.selectedDate.value != null ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    controller.selectedDate.value != null
                        ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(controller.selectedDate.value!)
                        : 'Select date of birth',
                    style: MyTextTheme.mediumBCN.copyWith(
                      color: controller.selectedDate.value != null
                          ? "#6F221E".toColor()
                          : Colors.grey,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 20.w,
                    color: "#6F221E".toColor(),
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
            Icon(Icons.person_outline, size: 18.w, color: "#6F221E".toColor()),
            Spacing.w(8),
            AutoTranslateText(
              'Gender *',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Spacing.h(8),
        Obx(
          () => Row(
            children: controller.genders.map((gender) {
              final isSelected =
                  controller.selectedGender.value == gender['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectGender(gender['value']!),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: gender != controller.genders.last ? 8.w : 0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? "#6F221E".toColor().withOpacity(0.2)
                          : Colors.grey.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? "#6F221E".toColor()
                            : Colors.grey.withOpacity(0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: AutoTranslateText(
                      gender['label']!,
                      textAlign: TextAlign.center,
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: isSelected
                                ? "#6F221E".toColor()
                                : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          )
                          .merge(AppTypography.body2),
                    ),
                  ),
                ),
              );
            }).toList(),
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
            Icon(Icons.language, size: 18.w, color: "#6F221E".toColor()),
            Spacing.w(8),
            AutoTranslateText(
              'Language *',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#6F221E".toColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Spacing.h(8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedLanguage.value.isEmpty
                ? null
                : controller.selectedLanguage.value,
            decoration: InputDecoration(
              hintText: 'Select language',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: "#6F221E".toColor(), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.05),
            ),
            items: controller.languages.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.key,
                child: AutoTranslateText(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectLanguage(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(
        () => Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                "#F38B3B".toColor(),
                "#DD2914".toColor().withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
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
                : () => controller.submitForm(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: controller.isLoading.value
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoTranslateText(
                        'Continue...',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacing.w(8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate: controller.selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }
}
