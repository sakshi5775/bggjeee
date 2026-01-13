import 'package:astrobharataiuser/app_manager/widgets/phone_field_with_country_code.dart';
import 'package:astrobharataiuser/data_model/address_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _AddressSuggestion {
  const _AddressSuggestion({
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
  }) : country = 'India';

  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;

  bool matches(String query) {
    if (query.trim().isEmpty) return false;
    final lower = query.toLowerCase();
    return label.toLowerCase().contains(lower) ||
        addressLine1.toLowerCase().contains(lower) ||
        (addressLine2?.toLowerCase().contains(lower) ?? false) ||
        city.toLowerCase().contains(lower);
  }
}

const List<_AddressSuggestion> _addressSuggestions = [
  _AddressSuggestion(
    label: 'Vibhuti Khand, Gomti Nagar, Lucknow',
    addressLine1: 'Vibhuti Khand',
    addressLine2: 'Gomti Nagar',
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    pincode: '226010',
  ),
  _AddressSuggestion(
    label: 'Gomti Nagar Extension, Lucknow',
    addressLine1: 'Gomti Nagar Extension',
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    pincode: '226010',
  ),
  _AddressSuggestion(
    label: 'Hazratganj, Lucknow',
    addressLine1: 'Hazratganj',
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    pincode: '226001',
  ),
  _AddressSuggestion(
    label: 'Indira Nagar, Lucknow',
    addressLine1: 'Indira Nagar',
    city: 'Lucknow',
    state: 'Uttar Pradesh',
    pincode: '226016',
  ),
];

class AddressFormResult {
  AddressFormResult({
    required this.address,
    required this.setAsDefault,
  });

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
  final altPhoneCtrl = TextEditingController(text: initial?.alternatePhone ?? '');
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

  List<_AddressSuggestion> activeSuggestions = const [];

  List<_AddressSuggestion> _searchSuggestions(String query) {
    if (query.trim().length < 3) return const [];
    return _addressSuggestions
        .where((suggestion) => suggestion.matches(query))
        .take(5)
        .toList();
  }

  final result = await showModalBottomSheet<AddressFormResult>(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          void updateSuggestions(String value) {
            setState(() {
              activeSuggestions = _searchSuggestions(value);
            });
          }

          void applySuggestion(_AddressSuggestion suggestion) {
            setState(() {
              line1Ctrl.text = suggestion.addressLine1;
              if (suggestion.addressLine2 != null) {
                line2Ctrl.text = suggestion.addressLine2!;
              }
              cityCtrl.text = suggestion.city;
              stateCtrl.text = suggestion.state;
              pincodeCtrl.text = suggestion.pincode;
              countryCtrl.text = suggestion.country;
              activeSuggestions = const [];
            });
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              16.h,
              16.w,
              MediaQuery.of(context).viewInsets.bottom + 24.h,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AutoTranslateText(
                      initial == null ? 'Add New Address' : 'Edit Address',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _AddressField(
                      label: 'Full Name',
                      controller: fullNameCtrl,
                      validator: _requiredValidator,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: PhoneFieldWithCountryCode(
                        controller: phoneCtrl,
                        headerText: 'Phone',
                        hintText: 'Enter phone number',
                        validator: _requiredValidator,
                        onCountryChanged: (CountryCode code) {
                          setState(() {
                            phoneCountryCode = code;
                          });
                        },
                        initialCountry: phoneCountryCode,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: PhoneFieldWithCountryCode(
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
                    ),
                    _AddressField(
                      label: 'Email (optional)',
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: line1Ctrl,
                            validator: _requiredValidator,
                            onChanged: updateSuggestions,
                            decoration: InputDecoration(
                              labelText: 'Address Line 1',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: AppColors.saffron),
                              ),
                            ),
                          ),
                          if (activeSuggestions.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: activeSuggestions.length,
                                separatorBuilder: (_, __) => Divider(
                                  height: 1,
                                  color: AppColors.textSecondary.withOpacity(0.1),
                                ),
                                itemBuilder: (context, index) {
                                  final suggestion = activeSuggestions[index];
                                  return ListTile(
                                    dense: true,
                                    title: AutoTranslateText(
                                      suggestion.label,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    onTap: () => applySuggestion(suggestion),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    _AddressField(
                      label: 'Address Line 2 (optional)',
                      controller: line2Ctrl,
                    ),
                    _AddressField(
                      label: 'Landmark (optional)',
                      controller: landmarkCtrl,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _AddressField(
                            label: 'City',
                            controller: cityCtrl,
                            validator: _requiredValidator,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _AddressField(
                            label: 'State',
                            controller: stateCtrl,
                            validator: _requiredValidator,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _AddressField(
                            label: 'Pincode',
                            controller: pincodeCtrl,
                            keyboardType: TextInputType.number,
                            validator: _requiredValidator,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _AddressField(
                            label: 'Country',
                            controller: countryCtrl,
                            validator: _requiredValidator,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      children: ['home', 'office', 'other'].map((type) {
                        final isSelected = addressType == type;
                        return ChoiceChip(
                          label: AutoTranslateText(type.toUpperCase()),
                          selected: isSelected,
                          onSelected: (_) => setState(() => addressType = type),
                          selectedColor: AppColors.saffron.withOpacity(0.15),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.saffron : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),
                    if (showDefaultToggle) ...[
                      SizedBox(height: 8.h),
                      CheckboxListTile(
                        value: setDefault,
                        onChanged: (value) => setState(() => setDefault = value ?? false),
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.saffron,
                        title: AutoTranslateText(
                          'Set as default address',
                          style: AppTypography.body2,
                        ),
                      ),
                    ],
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) return;
                          final model = AddressModel(
                            id: initial?.id,
                            type: addressType,
                            fullName: fullNameCtrl.text.trim(),
                            phone: '${phoneCountryCode.dialCode}${phoneCtrl.text.trim()}',
                            alternatePhone: altPhoneCtrl.text.trim().isEmpty 
                                ? null 
                                : '${altPhoneCountryCode.dialCode}${altPhoneCtrl.text.trim()}',
                            email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                            addressLine1: line1Ctrl.text.trim(),
                            addressLine2:
                                line2Ctrl.text.trim().isEmpty ? null : line2Ctrl.text.trim(),
                            landmark:
                                landmarkCtrl.text.trim().isEmpty ? null : landmarkCtrl.text.trim(),
                            city: cityCtrl.text.trim(),
                            state: stateCtrl.text.trim(),
                            pincode: pincodeCtrl.text.trim(),
                            country: countryCtrl.text.trim(),
                            isDefault: setDefault,
                          );
                          Navigator.of(context).pop(AddressFormResult(
                            address: model,
                            setAsDefault: setDefault,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.saffron,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: AutoTranslateText(
                          initial == null ? 'Save Address' : 'Update Address',
                          style: TextStyle(
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  return result;
}

class _AddressField extends StatelessWidget {
  const _AddressField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.saffron),
          ),
        ),
      ),
    );
  }
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

