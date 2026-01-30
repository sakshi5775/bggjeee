import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_form_controller.dart';
import 'package:astrobharataiuser/screens/kundli/widgets/kundli_header.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class KundliFormView extends BasePage<KundliFormController> {
  const KundliFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: UserDashboardView.buildDrawer(context),
        body: SafeArea(
          child: Column(
            children: [
              KundliHeader(title: 'Generate Kundli'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
                  child: _buildFormSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _formCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: AppColors.deepOrange.withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.deepOrange.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
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
        color: AppColors.textSecondary.withOpacity(0.6),
        fontSize: 13.sp,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Icon(icon, color: AppColors.deepOrange, size: 20.w),
      ),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.deepOrange.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.deepOrange.withOpacity(0.2)),
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
                'Generate your Kundli, get your predictions',
                style: MyTextTheme.mediumBCB.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Spacing.h(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
              //  flex: 2,
                child: SizedBox(
                  height: 50.h,
                  child: _buildCompactField(
                    controller: controller.nameController,
                    hint: 'Full Name',
                    icon: Icons.person_outline,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: _buildGenderDropdown(),
                ),
              ),
            ],
          ),
          Spacing.h(12),
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
              Expanded(
                child: _buildTimeField(),
              ),
            ],
          ),
          Spacing.h(6),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: AutoTranslateText(
              'Accurate birth time improves Kundli accuracy.',
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 11.sp,
              ),
            ),
          ),
          Spacing.h(12),
          _buildCompactLocation(),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildLanguageDropdown(),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildStyleDropdown(),
              ),
            ],
          ),
          Spacing.h(20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  /// Birth time field showing 12-hour AM/PM; timeController still holds 24h for API.
  Widget _buildTimeField() {
    return Obx(
      () {
        final t = controller.selectedTime.value;
        final display = TimePickerHelper.formatTime24To12Display(t.hour, t.minute);
        return GestureDetector(
          onTap: () => _showTimePicker(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.deepOrange.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InputDecorator(
              decoration: _inputDecoration(
                hint: 'Birth Time',
                icon: Icons.access_time,
                suffix: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.deepOrange,
                    size: 12.w,
                  ),
                ),
              ),
              child: Text(
                display,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textColorMaroon,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.deepOrange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.05),
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
          fontSize: 14.sp,
        ),
        decoration: _inputDecoration(
          hint: hint,
          icon: icon,
          suffix: readOnly && onTap != null
              ? Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.deepOrange,
                    size: 12.w,
                  ),
                )
              : null,
        ),
      ),
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
          border: Border.all(color: AppColors.deepOrange.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppColors.deepOrange, size: 20.w),
            SizedBox(width: 10.w),
            Expanded(
              child: Obx(
                () => AutoTranslateText(
                  controller.selectedLocation.value,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.textColorMaroon,
                    fontSize: 14.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.deepOrange, size: 22.w),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Obx(
      () => _buildCompactDropdown<String>(
        value: controller.selectedGender.value,
        hint: 'Gender',
        icon: Icons.person_outline,
        items: controller.genderOptions
            .map((g) => DropdownMenuItem(value: g, child: AutoTranslateText(g)))
            .toList(),
        onChanged: (v) {
          if (v != null) controller.selectedGender.value = v;
        },
        selectedItemBuilder: (context) => controller.genderOptions
            .map(
              (g) => AutoTranslateText(
                g,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textColorMaroon,
                  fontSize: 13.sp,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Obx(
      () => _buildCompactDropdown<String>(
        value: controller.selectedLanguage.value,
        hint: 'Language',
        icon: Icons.language,
        items: controller.languages.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: AutoTranslateText(e.value),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) controller.selectedLanguage.value = v;
        },
      ),
    );
  }

  Widget _buildStyleDropdown() {
    return Obx(
      () => _buildCompactDropdown<String>(
        value: controller.selectedStyle.value,
        hint: 'Chart Style',
        icon: Icons.style,
        items: controller.styles
            .map((s) => DropdownMenuItem(
                  value: s,
                  child: AutoTranslateText(s.toUpperCase()),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) controller.selectedStyle.value = v;
        },
      ),
    );
  }

  Widget _buildCompactDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    List<Widget> Function(BuildContext)? selectedItemBuilder,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.deepOrange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: AutoTranslateText(
          hint,
          style: MyTextTheme.smallBCN.copyWith(
            color: AppColors.textSecondary.withOpacity(0.6),
            fontSize: 13.sp,
          ),
        ),
        decoration: _inputDecoration(
          hint: hint,
          icon: icon,
          suffix: Icon(Icons.arrow_drop_down, color: AppColors.deepOrange, size: 24.w),
        ),
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 52.h,
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
    final pickedTime = await TimePickerHelper.showTimePicker12h(
      Get.context!,
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