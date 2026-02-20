import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/widgets/phone_field_with_country_code.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressFormResult {
  AddressFormResult({required this.address, required this.setAsDefault});

  final AddressModel address;
  final bool setAsDefault;
}

Future<AddressFormResult?> showAddressFormSheet({
  required BuildContext context,
  AddressModel? initial,
  bool showDefaultToggle = true,
}) async {
  final formKey = GlobalKey<FormState>();
  final fullNameCtrl = TextEditingController(text: initial?.fullName ?? '');
  final phoneCtrl = TextEditingController(text: initial?.phone ?? '');
  final altPhoneCtrl = TextEditingController(
    text: initial?.alternatePhone ?? '',
  );
  final emailCtrl = TextEditingController(text: initial?.email ?? '');
  final line1Ctrl = TextEditingController(text: initial?.addressLine1 ?? '');
  final line2Ctrl = TextEditingController(text: initial?.addressLine2 ?? '');
  final landmarkCtrl = TextEditingController(text: initial?.landmark ?? '');
  final cityCtrl = TextEditingController(text: initial?.city ?? '');
  final stateCtrl = TextEditingController(text: initial?.state ?? '');
  final pincodeCtrl = TextEditingController(text: initial?.pincode ?? '');
  final countryCtrl = TextEditingController(text: initial?.country ?? 'India');
  bool setDefault = showDefaultToggle ? (initial?.isDefault ?? false) : false;
  String addressType = initial?.type ?? 'home';

  // Country codes for phone fields
  CountryCode phoneCountryCode = CountryCode.fromCountryCode('IN');
  CountryCode altPhoneCountryCode = CountryCode.fromCountryCode('IN');

  final result = await showModalBottomSheet<AddressFormResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, '#FEF6C3'.toColor().withValues(alpha: 0.3)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoTranslateText(
                              initial == null
                                  ? 'Add New Address'
                                  : 'Edit Address',
                              style: TextStyle(
                                fontFamily: 'Baloo 2',
                                fontWeight: FontWeight.w700,
                                fontSize: 22.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            AutoTranslateText(
                              'Fill in your delivery details',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Form Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      20.h,
                      20.w,
                      MediaQuery.of(context).viewInsets.bottom + 20.h,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Section
                          _SectionHeader(
                            icon: Icons.person_rounded,
                            title: 'Personal Information',
                          ),
                          SizedBox(height: 16.h),
                          _AddressField(
                            label: 'Full Name',
                            controller: fullNameCtrl,
                            validator: _requiredValidator,
                            icon: Icons.person_outline_rounded,
                          ),
                          SizedBox(height: 12.h),
                          PhoneFieldWithCountryCode(
                            controller: phoneCtrl,
                            headerText: 'Phone Number',
                            hintText: 'Enter phone number',
                            validator: _requiredValidator,
                            onCountryChanged: (CountryCode code) {
                              setState(() {
                                phoneCountryCode = code;
                              });
                            },
                            initialCountry: phoneCountryCode,
                          ),
                          SizedBox(height: 12.h),
                          PhoneFieldWithCountryCode(
                            controller: altPhoneCtrl,
                            headerText: 'Alternate Phone (optional)',
                            hintText: 'Enter alternate phone number',
                            onCountryChanged: (CountryCode code) {
                              setState(() {
                                altPhoneCountryCode = code;
                              });
                            },
                            initialCountry: altPhoneCountryCode,
                          ),
                          SizedBox(height: 12.h),
                          _AddressField(
                            label: 'Email (optional)',
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            icon: Icons.mail_outline_rounded,
                          ),
                          SizedBox(height: 24.h),
                          // Address Information Section
                          _SectionHeader(
                            icon: Icons.location_on_rounded,
                            title: 'Address Information',
                          ),
                          SizedBox(height: 16.h),
                          // Address Line 1 with Suggestions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _AddressField(
                                label: 'Address Line 1',
                                controller: line1Ctrl,
                                validator: _requiredValidator,
                                icon: Icons.home_rounded,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _AddressField(
                            label: 'Address Line 2 (optional)',
                            controller: line2Ctrl,
                            icon: Icons.home_work_rounded,
                          ),
                          SizedBox(height: 12.h),
                          _AddressField(
                            label: 'Landmark (optional)',
                            controller: landmarkCtrl,
                            icon: Icons.place_rounded,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _AddressField(
                                  label: 'City',
                                  controller: cityCtrl,
                                  validator: _requiredValidator,
                                  icon: Icons.location_city_rounded,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _AddressField(
                                  label: 'State',
                                  controller: stateCtrl,
                                  validator: _requiredValidator,
                                  icon: Icons.map_rounded,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _AddressField(
                                  label: 'Pincode',
                                  controller: pincodeCtrl,
                                  keyboardType: TextInputType.number,
                                  validator: _requiredValidator,
                                  icon: Icons.pin_rounded,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _AddressField(
                                  label: 'Country',
                                  controller: countryCtrl,
                                  validator: _requiredValidator,
                                  icon: Icons.public_rounded,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // Address Type Section
                          _SectionHeader(
                            icon: Icons.category_rounded,
                            title: 'Address Type',
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              for (final type in ['home', 'office', 'other'])
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    child: _AddressTypeButton(
                                      type: type,
                                      isSelected: addressType == type,
                                      onTap: () =>
                                          setState(() => addressType = type),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (showDefaultToggle) ...[
                            SizedBox(height: 20.h),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.saffron.withValues(alpha: 0.1),
                                    AppColors.saffron.withValues(alpha: 0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.saffron.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.saffron.withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      size: 20.sp,
                                      color: AppColors.saffron,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: AutoTranslateText(
                                      'Set as default address',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: '#68171E'.toColor(),
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: setDefault,
                                    onChanged: (value) =>
                                        setState(() => setDefault = value),
                                    activeColor: AppColors.saffron,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: 24.h),
                          // Save Button
                          Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.orangeGradient,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: '#F38B3B'.toColor().withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  if (formKey.currentState?.validate() != true)
                                    return;
                                  final model = AddressModel(
                                    id: initial?.id,
                                    type: addressType,
                                    fullName: fullNameCtrl.text.trim(),
                                    phone:
                                        '${phoneCountryCode.dialCode}${phoneCtrl.text.trim()}',
                                    alternatePhone:
                                        altPhoneCtrl.text.trim().isEmpty
                                        ? null
                                        : '${altPhoneCountryCode.dialCode}${altPhoneCtrl.text.trim()}',
                                    email: emailCtrl.text.trim().isEmpty
                                        ? null
                                        : emailCtrl.text.trim(),
                                    addressLine1: line1Ctrl.text.trim(),
                                    addressLine2: line2Ctrl.text.trim().isEmpty
                                        ? null
                                        : line2Ctrl.text.trim(),
                                    landmark: landmarkCtrl.text.trim().isEmpty
                                        ? null
                                        : landmarkCtrl.text.trim(),
                                    city: cityCtrl.text.trim(),
                                    state: stateCtrl.text.trim(),
                                    pincode: pincodeCtrl.text.trim(),
                                    country: countryCtrl.text.trim(),
                                    isDefault: setDefault,
                                  );
                                  Navigator.of(context).pop(
                                    AddressFormResult(
                                      address: model,
                                      setAsDefault: setDefault,
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(20.r),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        initial == null
                                            ? Icons.add_location_alt_rounded
                                            : Icons.check_circle_rounded,
                                        size: 20.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8.w),
                                      AutoTranslateText(
                                        initial == null
                                            ? 'Save Address'
                                            : 'Update Address',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  return result;
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 20.sp, color: '#E3B341'.toColor()),
        ),
        SizedBox(width: 12.w),
        AutoTranslateText(
          title,
          style: TextStyle(
            fontFamily: 'Baloo 2',
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: '#68171E'.toColor(),
          ),
        ),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.icon,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData? icon;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: '#68171E'.toColor(),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
          prefixIcon: icon != null
              ? Icon(icon, size: 20.sp, color: AppColors.saffron)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.saffron, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.sacredRed, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: AppColors.sacredRed, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}

class _AddressTypeButton extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressTypeButton({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : '#68171E'.toColor().withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: '#68171E'.toColor().withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                _getAddressTypeIcon(type),
                size: 24.sp,
                color: isSelected
                    ? '#E3B341'.toColor()
                    : AppColors.textSecondary,
              ),
              SizedBox(height: 6.h),
              AutoTranslateText(
                type.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: isSelected ? '#E3B341'.toColor() : '#68171E'.toColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _getAddressTypeIcon(String type) {
  switch (type.toLowerCase()) {
    case 'home':
      return Icons.home_rounded;
    case 'office':
      return Icons.work_rounded;
    case 'other':
      return Icons.location_city_rounded;
    default:
      return Icons.location_on_rounded;
  }
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

