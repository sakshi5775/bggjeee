import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/controller/match_making_form_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/address_autocomplete_field.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MatchMakingFormView extends BasePage<MatchMakingFormController> {
  const MatchMakingFormView({super.key});

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
                title: 'Match Making',
                titleColor: AppColors.templeGold,
              ),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      AutoTranslateText(
                        'Enter Details',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: '#68171E'.toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h2),
                      ),
                      Spacing.h(20),

                      // Person 1 Section
                      _buildPersonSection(
                        label: 'Person 1',
                        subLabel: 'Groom Details',
                        nameController: controller.person1NameController,
                        dateController: controller.person1DateController,
                        timeController: controller.person1TimeController,
                        placeController: controller.person1PlaceController,
                        onDateTap: () => _showDatePicker(context, true),
                        onTimeTap: () => _showTimePicker(context, true),
                        onPlaceSelected: (place) => controller
                            .setPerson1LocationFromAutocomplete(place),
                        isPerson1: true,
                      ),

                      Spacing.h(16),

                      // Swap Icon
                      Center(
                        child: GestureDetector(
                          onTap: () => controller.swapPersons(),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: '#F38B3B'.toColor().withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.swap_vert,
                              color: Colors.white,
                              size: 24.w,
                            ),
                          ),
                        ),
                      ),

                      Spacing.h(16),

                      // Person 2 Section
                      _buildPersonSection(
                        label: 'Person 2',
                        subLabel: 'Bride',
                        nameController: controller.person2NameController,
                        dateController: controller.person2DateController,
                        timeController: controller.person2TimeController,
                        placeController: controller.person2PlaceController,
                        onDateTap: () => _showDatePicker(context, false),
                        onTimeTap: () => _showTimePicker(context, false),
                        onPlaceSelected: (place) => controller
                            .setPerson2LocationFromAutocomplete(place),
                        isPerson1: false,
                      ),

                      Spacing.h(20),

                      // Language Dropdown
                      _buildLanguageDropdown(),

                      Spacing.h(30),

                      // Compare Kundlis Button
                      _buildCompareButton(),

                      Spacing.h(20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonSection({
    required String label,
    required String subLabel,
    required TextEditingController nameController,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController placeController,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required Function(Map<String, dynamic>) onPlaceSelected,
    required bool isPerson1,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#68171E'.toColor().withOpacity(0.2),
          width: 1,
        ),
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
          // Section Header
          Row(
            children: [
              AutoTranslateText(
                label,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#68171E'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                subLabel,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#68171E'.toColor().withOpacity(0.7),
                ),
              ),
            ],
          ),
          Spacing.h(16),

          // Full Name
          _buildTextField(
            controller: nameController,
            label: 'Full Name',
            icon: Icons.person,
          ),
          Spacing.h(12),

          // Birth Date
          _buildTextField(
            controller: dateController,
            label: 'Birth Date',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: onDateTap,
          ),
          Spacing.h(12),

          // Birth Time
          _buildTextField(
            controller: timeController,
            label: 'Birth Time',
            icon: Icons.access_time,
            readOnly: true,
            onTap: onTimeTap,
          ),
          Spacing.h(12),

          // Birth Place with Google Maps Autocomplete
          AddressAutocompleteField(
            controller: placeController,
            onPlaceSelected: onPlaceSelected,
            country: 'in', // Restrict to India as per controller logic
            decoration: InputDecoration(
              labelText: 'Birth Place',
              hintText: 'Enter birth place',
              labelStyle: MyTextTheme.smallBCN.copyWith(
                color: '#68171E'.toColor().withOpacity(0.6),
              ),
              prefixIcon: Icon(
                Icons.location_on,
                color: AppColors.deepOrange,
                size: 20.w,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: '#68171E'.toColor().withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
              ),
            ),
          ),
          Spacing.h(8),

          // Info AutoTranslateText
          AutoTranslateText(
            'Exact time improves accuracy',
            style: MyTextTheme.smallBCN
                .copyWith(color: '#68171E'.toColor().withOpacity(0.6))
                .merge(AppTypography.label),
          ),
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
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: MyTextTheme.mediumBCN.copyWith(color: '#68171E'.toColor()),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#68171E'.toColor().withOpacity(0.6),
          ),
          prefixIcon: Icon(icon, color: AppColors.deepOrange, size: 20.w),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: '#68171E'.toColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedLanguage.value,
          decoration: InputDecoration(
            labelText: 'Language',
            labelStyle: MyTextTheme.smallBCN.copyWith(
              color: '#68171E'.toColor().withOpacity(0.6),
            ),
            prefixIcon: Icon(
              Icons.language,
              color: AppColors.deepOrange,
              size: 20.w,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
          ),
          items: controller.languages.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: AutoTranslateText(
                entry.value,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#68171E'.toColor(),
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
    );
  }

  Widget _buildCompareButton() {
    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value
            ? null
            : () => controller.compareKundlis(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            gradient: controller.isLoading.value
                ? null
                : AppColors.orangeGradient,
            color: controller.isLoading.value ? Colors.grey[300] : null,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: controller.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: '#F38B3B'.toColor().withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.isLoading.value)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                AutoTranslateText(
                  'Compare Kundlis',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.w(8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20.w),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, bool isPerson1) async {
    final pickedDate = await showDatePicker(
      context: context,

      initialDate: isPerson1
          ? controller.person1Date.value
          : controller.person2Date.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: '#68171E'.toColor(),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (isPerson1) {
        controller.selectPerson1Date(pickedDate);
      } else {
        controller.selectPerson2Date(pickedDate);
      }
    }
  }

  void _showTimePicker(BuildContext context, bool isPerson1) async {
    final pickedTime = await TimePickerHelper.showTimePicker12h(
      context,
      initialTime: isPerson1
          ? (controller.person1Time.value ?? TimeOfDay.now())
          : (controller.person2Time.value ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.deepOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: '#68171E'.toColor(),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      if (isPerson1) {
        controller.selectPerson1Time(pickedTime);
      } else {
        controller.selectPerson2Time(pickedTime);
      }
    }
  }
}
