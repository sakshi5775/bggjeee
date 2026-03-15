import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/address_form/controller/address_form_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddressFormView extends BasePage<AddressFormController> {
  const AddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            // Header
            Obx(
              () => CommonHeader(
                title: controller.isEditMode.value
                    ? 'Edit Address'
                    : 'Add New Address',
                showEndDrawer: false,
              ),
            ),
            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: Personal Details
                      _buildSectionHeader(
                        'Personal Details',
                        Icons.person_outline_rounded,
                      ),
                      SizedBox(height: 16.h),
                      _buildFormCard([
                        // Full Name
                        MyTextField(
                          headerText: 'Full Name *',
                          hintText: 'Enter full name',
                          controller: controller.fullNameController,
                          keyboardType: TextInputType.name,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.saffron,
                          ),
                          validator: (value) =>
                              controller.validateRequired(value, 'Full name'),
                        ),
                        SizedBox(height: 16.h),
                        // Phone
                        MyTextField(
                          headerText: 'Phone Number *',
                          hintText: 'Enter phone number',
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: AppColors.saffron,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: controller.validatePhone,
                        ),
                        SizedBox(height: 16.h),
                        // Alternate Phone
                        MyTextField(
                          headerText: 'Alternate Phone (Optional)',
                          hintText: 'Enter alternate phone',
                          controller: controller.alternatePhoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icon(
                            Icons.phone_android_outlined,
                            color: AppColors.saffron,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Email
                        MyTextField(
                          headerText: 'Email (Optional)',
                          hintText: 'Enter email address',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.saffron,
                          ),
                          validator: controller.validateEmail,
                        ),
                      ]),

                      SizedBox(height: 24.h),

                      // Section: Address Details
                      _buildSectionHeader(
                        'Address Details',
                        Icons.location_on_outlined,
                      ),
                      SizedBox(height: 16.h),
                      _buildFormCard([
                        // Address Line 1
                        MyTextField(
                          headerText: 'Address Line 1 *',
                          hintText: 'House/Flat No., Building Name',
                          controller: controller.addressLine1Controller,
                          keyboardType: TextInputType.streetAddress,
                          prefixIcon: Icon(
                            Icons.home_outlined,
                            color: AppColors.saffron,
                          ),
                          validator: (value) =>
                              controller.validateRequired(value, 'Address'),
                        ),
                        SizedBox(height: 16.h),
                        // Address Line 2
                        MyTextField(
                          headerText: 'Address Line 2 (Optional)',
                          hintText: 'Street, Colony, Area',
                          controller: controller.addressLine2Controller,
                          keyboardType: TextInputType.streetAddress,
                          prefixIcon: Icon(
                            Icons.location_city_outlined,
                            color: AppColors.saffron,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Landmark
                        MyTextField(
                          headerText: 'Landmark (Optional)',
                          hintText: 'Near temple, hospital, etc.',
                          controller: controller.landmarkController,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(
                            Icons.near_me_outlined,
                            color: AppColors.saffron,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // City and State in a row
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                headerText: 'City *',
                                hintText: 'Enter city',
                                controller: controller.cityController,
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    controller.validateRequired(value, 'City'),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: MyTextField(
                                headerText: 'State *',
                                hintText: 'Enter state',
                                controller: controller.stateController,
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    controller.validateRequired(value, 'State'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Pincode and Country in a row
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                headerText: 'Pincode *',
                                hintText: 'Enter pincode',
                                controller: controller.pincodeController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: controller.validatePincode,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: MyTextField(
                                headerText: 'Country',
                                hintText: 'Enter country',
                                controller: controller.countryController,
                              ),
                            ),
                          ],
                        ),
                      ]),

                      SizedBox(height: 24.h),

                      // Section: Address Type & Label
                      _buildSectionHeader(
                        'Address Type',
                        Icons.label_outline_rounded,
                      ),
                      SizedBox(height: 16.h),
                      _buildFormCard([
                        // Address Type Selection
                        AutoTranslateText(
                          'Select Address Type *',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: AppColors.saffron,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Obx(
                          () => Row(
                            children: controller.addressTypes.map((type) {
                              final isSelected =
                                  controller.selectedAddressType.value == type;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.selectAddressType(type),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: EdgeInsets.only(
                                      right:
                                          type != controller.addressTypes.last
                                          ? 8.w
                                          : 0,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? AppColors.orangeGradient
                                          : null,
                                      color: isSelected ? null : Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.transparent
                                            : const Color(0xFFE0E0E0),
                                        width: 1.5,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors
                                                    .orangeGradient
                                                    .colors
                                                    .first
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _getTypeIcon(type),
                                          size: 18.h,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF757575),
                                        ),
                                        SizedBox(width: 6.w),
                                        AutoTranslateText(
                                          type.capitalizeFirst!,
                                          style: MyTextTheme.smallBCB.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF424242),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Label
                        MyTextField(
                          headerText: 'Label (Optional)',
                          hintText: 'e.g., My Home, Work Office',
                          controller: controller.labelController,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icon(
                            Icons.label_outline,
                            color: AppColors.saffron,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Is Default checkbox
                        Obx(
                          () => GestureDetector(
                            onTap: () => controller.toggleDefault(
                              !controller.isDefault.value,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 16.w,
                              ),
                              decoration: BoxDecoration(
                                color: controller.isDefault.value
                                    ? AppColors.orangeGradient.colors.first
                                          .withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: controller.isDefault.value
                                      ? AppColors.orangeGradient.colors.first
                                      : const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: controller.isDefault.value
                                          ? AppColors.orangeGradient
                                          : null,
                                      color: controller.isDefault.value
                                          ? null
                                          : Colors.white,
                                      border: Border.all(
                                        color: controller.isDefault.value
                                            ? Colors.transparent
                                            : const Color(0xFFBDBDBD),
                                        width: 2,
                                      ),
                                    ),
                                    child: controller.isDefault.value
                                        ? Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16.h,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoTranslateText(
                                          'Set as Default Address',
                                          style: MyTextTheme.mediumBCB.copyWith(
                                            color: const Color(0xFF212121),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        AutoTranslateText(
                                          'This address will be pre-selected for orders',
                                          style: MyTextTheme.smallBCN.copyWith(
                                            color: const Color(0xFF757575),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),

                      SizedBox(height: 32.h),

                      // Save Button
                      Obx(
                        () => MyButton(
                          useGradient: true,
                          title: controller.isSaving.value
                              ? 'Saving...'
                              : controller.isEditMode.value
                              ? 'Update Address'
                              : 'Save Address',
                          width: double.infinity,
                          height: 54.h,
                          onPress: controller.isSaving.value
                              ? null
                              : () => controller.saveAddress(),
                          prefixIcon: controller.isSaving.value
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  controller.isEditMode.value
                                      ? Icons.edit
                                      : Icons.add_location_alt,
                                  color: Colors.white,
                                  size: 20.h,
                                ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: Colors.white, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCB.copyWith(
            color: const Color(0xFF5D1C21),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'office':
        return Icons.business_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }
}
