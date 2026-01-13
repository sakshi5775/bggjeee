import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_form_controller.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KundliFormView extends BasePage<KundliFormController> {
  const KundliFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            '#FF6B35'.toColor(),
            '#FF8C42'.toColor(),
          ],
        ),
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
                color: Colors.white,
                size: 24.w,
              ),
            ),
            Spacing.w(16),
            // Title
            Expanded(
              child: AutoTranslateText(
                'Generate Kundli',
                style: MyTextTheme.largeBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h1),
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
              color: '#F5D7B8'.toColor(),
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
                color: '#FF6B35'.toColor(),
                size: 20.w,
              ),
              Spacing.w(12),
              Expanded(
                child: Obx(() => AutoTranslateText(
                  controller.selectedLocation.value,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                )),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: '#FF6B35'.toColor(),
                size: 16.w,
              ),
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
            'Enter Birth Details',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          
          // Name field (Optional)
          _buildTextField(
            controller: controller.nameController,
            label: 'Name',
            icon: Icons.person,
            readOnly: false,
          ),
          Spacing.h(12),
          
          // Gender dropdown
          _buildGenderField(),
          Spacing.h(12),
          
          // Date field
          _buildTextField(
            controller: controller.dateController,
            label: 'Date of birth (dd/mm/yyyy)',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () => _showDatePicker(),
          ),
          Spacing.h(12),
          
          // Time field
          _buildTextField(
            controller: controller.timeController,
            label: 'Birth time (hh:mm)',
            icon: Icons.access_time,
            readOnly: true,
            onTap: () => _showTimePicker(),
          ),
          Spacing.h(12),
          
          // Latitude and Longitude row
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: controller.latitudeController,
                  label: 'Latitude',
                  icon: Icons.location_on,
                  readOnly: true,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildTextField(
                  controller: controller.longitudeController,
                  label: 'Longitude',
                  icon: Icons.location_on,
                  readOnly: true,
                ),
              ),
            ],
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
          Spacing.h(12),
          
          // Style dropdown
          _buildStyleField(),
          Spacing.h(12),
          
          // Colored planets dropdown
          _buildColoredPlanetsField(),
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
          color: '#3E2723'.toColor(),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#3E2723'.toColor().withOpacity(0.6),
          ),
          prefixIcon: Icon(icon, color: '#FF6B35'.toColor(), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
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
          labelText: 'Language code',
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#3E2723'.toColor().withOpacity(0.6),
          ),
          prefixIcon: Icon(Icons.language, color: '#FF6B35'.toColor(), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
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
                color: '#3E2723'.toColor(),
              ),
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

  Widget _buildGenderField() {
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
        value: controller.selectedGender.value,
        decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#3E2723'.toColor().withOpacity(0.6),
          ),
          prefixIcon: Icon(Icons.person_outline, color: '#FF6B35'.toColor(), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: controller.genderOptions.map((gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: AutoTranslateText(
              gender,
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#3E2723'.toColor(),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.selectedGender.value = value;
          }
        },
      )),
    );
  }

  Widget _buildStyleField() {
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
        value: controller.selectedStyle.value,
        decoration: InputDecoration(
          labelText: 'Chart style (north, south, east)',
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#3E2723'.toColor().withOpacity(0.6),
          ),
          prefixIcon: Icon(Icons.style, color: '#FF6B35'.toColor(), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: controller.styles.map((style) {
          return DropdownMenuItem<String>(
            value: style,
            child: AutoTranslateText(
              style.toUpperCase(),
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#3E2723'.toColor(),
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.selectedStyle.value = value;
          }
        },
      )),
    );
  }

  Widget _buildColoredPlanetsField() {
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
      child: Obx(() => DropdownButtonFormField<bool>(
        value: controller.coloredPlanets.value,
        decoration: InputDecoration(
          labelText: 'Send true for colored font',
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#3E2723'.toColor().withOpacity(0.6),
          ),
          prefixIcon: Icon(Icons.palette, color: '#FF6B35'.toColor(), size: 20.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor(), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#F5D7B8'.toColor().withOpacity(0.5), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: '#FF6B35'.toColor(), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: const [
          DropdownMenuItem<bool>(
            value: true,
            child: AutoTranslateText('True'),
          ),
          DropdownMenuItem<bool>(
            value: false,
            child: AutoTranslateText('False'),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.coloredPlanets.value = value;
          }
        },
      )),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.generateKundli,
        style: ElevatedButton.styleFrom(
          backgroundColor: '#FF6B35'.toColor(),
          foregroundColor: Colors.white,
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
                'Generate Kundli',
                style: MyTextTheme.largeBCB.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ));
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
              primary: '#FF6B35'.toColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: '#3E2723'.toColor(),
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
              primary: '#FF6B35'.toColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: '#3E2723'.toColor(),
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
          onCitySelected: (city, state, country) {
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

