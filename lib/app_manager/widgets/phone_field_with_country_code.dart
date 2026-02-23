import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PhoneFieldWithCountryCode extends StatefulWidget {
  final TextEditingController? controller;
  final String? headerText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<CountryCode>? onCountryChanged;
  final ValueChanged<String>? onPhoneChanged;
  final CountryCode? initialCountry;
  final bool enabled;
  final int? maxLength;

  const PhoneFieldWithCountryCode({
    super.key,
    this.controller,
    this.headerText,
    this.hintText,
    this.validator,
    this.onCountryChanged,
    this.onPhoneChanged,
    this.initialCountry,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<PhoneFieldWithCountryCode> createState() =>
      _PhoneFieldWithCountryCodeState();
}

class _PhoneFieldWithCountryCodeState extends State<PhoneFieldWithCountryCode> {
  CountryCode? _selectedCountry;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedCountry =
        widget.initialCountry ?? CountryCode.fromCountryCode('IN');
    _controller.addListener(_onPhoneNumberChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onPhoneNumberChanged);
    }
    super.dispose();
  }

  void _onPhoneNumberChanged() {
    final phoneNumber = _controller.text;
    if (phoneNumber.isNotEmpty) {
      final detectedCountry = _detectCountryFromPhoneNumber(phoneNumber);
      // Only update if country code actually changed to prevent displacement
      if (detectedCountry != null &&
          detectedCountry.code != _selectedCountry?.code) {
        setState(() {
          _selectedCountry = detectedCountry;
        });
        widget.onCountryChanged?.call(detectedCountry);
      }
    }
    widget.onPhoneChanged?.call(phoneNumber);
  }

  CountryCode? _detectCountryFromPhoneNumber(String phoneNumber) {
    // Remove any spaces or special characters
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Indian numbers: 10 digits starting with 6-9
    if (cleanNumber.length == 10 && RegExp(r'^[6-9]').hasMatch(cleanNumber)) {
      return CountryCode.fromCountryCode('IN');
    }

    // US/Canada numbers: 10 digits
    if (cleanNumber.length == 10 && RegExp(r'^[2-9]').hasMatch(cleanNumber)) {
      // Check if it looks like a US number (area code patterns)
      if (RegExp(r'^[2-9]\d{2}[2-9]\d{2}\d{4}$').hasMatch(cleanNumber)) {
        return CountryCode.fromCountryCode('US');
      }
    }

    // UK numbers: 10-11 digits starting with various patterns
    if (cleanNumber.length >= 10 && cleanNumber.length <= 11) {
      if (RegExp(r'^(7|20|44)').hasMatch(cleanNumber)) {
        return CountryCode.fromCountryCode('GB');
      }
    }

    // Australian numbers: 9 digits starting with 4
    if (cleanNumber.length == 9 && RegExp(r'^4').hasMatch(cleanNumber)) {
      return CountryCode.fromCountryCode('AU');
    }

    // UAE numbers: 9 digits starting with 5
    if (cleanNumber.length == 9 && RegExp(r'^5').hasMatch(cleanNumber)) {
      return CountryCode.fromCountryCode('AE');
    }

    // Singapore numbers: 8 digits starting with 8 or 9
    if (cleanNumber.length == 8 && RegExp(r'^[89]').hasMatch(cleanNumber)) {
      return CountryCode.fromCountryCode('SG');
    }

    // Default to India if no match
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headerText != null) ...[
          AutoTranslateText(
            widget.headerText ?? '',
            style: MyTextTheme.mediumBCB.copyWith(color: AppColors.saffron),
          ),
          Spacing.h(8),
        ],
        // Wrap Row in fixed height container to prevent any size changes
        SizedBox(
          height: 48.h, // Fixed height for entire row
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch to fill height
            mainAxisSize: MainAxisSize.max,
            children: [
              // Country Code Picker - Fixed width and height to prevent displacement
              SizedBox(
                width: 100.w, // Width to accommodate flag + country code
                height: 48.h, // Fixed height to prevent displacement
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.gray.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.white,
                  ),
                  child: CountryCodePicker(
                    key: ValueKey(
                      _selectedCountry?.code ?? 'IN',
                    ), // Key to prevent unnecessary rebuilds
                    onChanged: (CountryCode countryCode) {
                      // Only update if code actually changed to prevent rebuild
                      if (countryCode.code != _selectedCountry?.code) {
                        setState(() {
                          _selectedCountry = countryCode;
                        });
                        widget.onCountryChanged?.call(countryCode);
                      }
                    },
                    initialSelection: _selectedCountry?.code ?? 'IN',
                    favorite: ['+91', 'IN', '+1', 'US'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed:
                        false, // Show flag + country code when closed
                    showFlag: true, // Ensure flag is visible
                    showFlagDialog: true, // Show flag in dialog
                    alignLeft: false,
                    flagDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0),
                    textStyle: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    enabled: widget.enabled,
                    dialogTextStyle: MyTextTheme.mediumBCN.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    dialogBackgroundColor: AppColors.cardLight,
                    barrierColor: AppColors.gray.withValues(alpha: 0.54),
                  ),
                ),
              ),
              Spacing.w(8),
              // Phone Number Field - Use Expanded with fixed height
              Expanded(
                child: SizedBox(
                  height: 48.h,
                  child: TextFormField(
                    controller: _controller,
                    enabled: widget.enabled,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    validator: widget.validator,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      if (widget.maxLength != null)
                        LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? 'Enter phone number',
                      hintStyle: MyTextTheme.mediumBCN.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: AppColors.textSecondary,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      // Hide error text inside field to prevent height changes
                      errorStyle: const TextStyle(
                        height: 0,
                        fontSize: 0,
                        color: Colors.transparent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.gray.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: AppColors.gray.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: AppColors.saffron,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: widget.enabled
                          ? AppColors.white
                          : AppColors.gray.withValues(alpha: 0.1),
                    ),
                    onTapOutside: (val) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // Show error message below the field if validation fails
        Builder(
          builder: (context) {
            final errorText = widget.validator?.call(_controller.text);
            if (errorText != null && errorText.isNotEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 4.h, left: 12.w),
                child: AutoTranslateText(
                  errorText,
                  style: MyTextTheme.smallBCN.copyWith(color: AppColors.error),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
