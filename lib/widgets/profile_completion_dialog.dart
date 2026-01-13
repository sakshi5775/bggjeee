import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_profile_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Dialog to show profile completion form before starting chat/call
class ProfileCompletionDialog extends StatefulWidget {
  final VoidCallback? onProfileComplete;
  final VoidCallback? onCancel;

  const ProfileCompletionDialog({
    Key? key,
    this.onProfileComplete,
    this.onCancel,
  }) : super(key: key);

  @override
  State<ProfileCompletionDialog> createState() =>
      _ProfileCompletionDialogState();
}

class _ProfileCompletionDialogState extends State<ProfileCompletionDialog> {
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();
  final UserProfileController _profileController = Get.put(
    UserProfileController(),
  );

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? _selectedGender;
  String? _selectedMaritalStatus;
  String? _selectedOccupation;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];
  final List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Prefer not to say',
  ];
  final List<String> _occupationOptions = [
    'Student',
    'Employee',
    'Business',
    'Professional',
    'Homemaker',
    'Retired',
    'Other',
  ];

  Map<String, dynamic> _verificationStatus = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    // Load verification status
    _verificationStatus = await _profileHelper.getContactVerificationStatus();

    // Load profile
    await _profileController.loadProfile();

    // Populate fields if profile exists
    if (_profileController.profile.value != null) {
      final profile = _profileController.profile.value!;

      // Personal info
      if (profile.personalInfo != null) {
        // Normalize Gender
        final rawGender = profile.personalInfo!.gender?.toUpperCase();
        if (rawGender == 'MALE')
          _selectedGender = 'Male';
        else if (rawGender == 'FEMALE')
          _selectedGender = 'Female';
        else if (rawGender == 'OTHER')
          _selectedGender = 'Other';
        else if (_genderOptions.contains(profile.personalInfo!.gender)) {
          _selectedGender = profile.personalInfo!.gender;
        }

        // Normalize Marital Status
        final rawMarital = profile.personalInfo!.maritalStatus?.toLowerCase();
        if (rawMarital == 'single')
          _selectedMaritalStatus = 'Single';
        else if (rawMarital == 'married')
          _selectedMaritalStatus = 'Married';
        else if (rawMarital == 'divorced')
          _selectedMaritalStatus = 'Divorced';
        else if (rawMarital == 'widowed')
          _selectedMaritalStatus = 'Widowed';
        else if (_maritalStatusOptions.contains(
          profile.personalInfo!.maritalStatus,
        )) {
          _selectedMaritalStatus = profile.personalInfo!.maritalStatus;
        }

        // Safe check for Occupation
        if (_occupationOptions.contains(profile.personalInfo!.occupation)) {
          _selectedOccupation = profile.personalInfo!.occupation;
        }
      }

      // Birth chart
      if (profile.birthChart?.birthTime != null) {
        final hour = profile.birthChart!.birthTime!.hour ?? 0;
        final minute = profile.birthChart!.birthTime!.minute ?? 0;
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
        _timeController.text =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${(profile.birthChart!.birthTime!.second ?? 0).toString().padLeft(2, '0')}';
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFDFB343),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF5F2221),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFDFB343),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF5F2221),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Please select date of birth',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'Please select time of birth',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Update personal info
      _profileController.fullNameController.text =
          _profileController.fullNameController.text.isEmpty
          ? _profileController.fullNameController.text
          : _profileController.fullNameController.text;
      _profileController.genderController.text = _selectedGender ?? '';
      _profileController.maritalStatusController.text =
          _selectedMaritalStatus ?? '';
      _profileController.occupationController.text = _selectedOccupation ?? '';

      // Update birth chart
      _profileController.birthHourController.text = _selectedTime!.hour
          .toString();
      _profileController.birthMinuteController.text = _selectedTime!.minute
          .toString();
      _profileController.birthSecondController.text = '0';

      // Auto-fetch coordinates for birth place
      if (_profileController.birthCityController.text.trim().isNotEmpty) {
        await _profileController.onBirthCityChanged();
      }

      // Save profile
      final success = await _profileController.updateProfile();

      setState(() => _isSaving = false);

      if (success) {
        Get.back();
        if (widget.onProfileComplete != null) {
          widget.onProfileComplete!();
        }
      }
    } catch (e) {
      setState(() => _isSaving = false);
      Get.showSnackbar(
        GetSnackBar(
          message: 'Failed to save profile: $e',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFDFB343)),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          'Share Birth Details',
                          style: AppTypography.h2.copyWith(
                            color: const Color(0xFF5F2221),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 24.w,
                          color: const Color(0xFF5F2221),
                        ),
                        onPressed: () {
                          Get.back();
                          if (widget.onCancel != null) {
                            widget.onCancel!();
                          }
                        },
                      ),
                    ],
                  ),

                  Spacing.h(8),

                  // Subtitle
                  AutoTranslateText(
                    'To share it with your astrologer, to save time on consultation',
                    style: AppTypography.body2.copyWith(
                      color: const Color(0xFF666666),
                    ),
                  ),

                  Spacing.h(16),

                  // Email/Phone Verification Status
                  if (!_verificationStatus['emailVerified']! ||
                      !_verificationStatus['phoneVerified']!)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F0),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: const Color(0xFFFF6B35),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoTranslateText(
                            'Contact Verification Required',
                            style: AppTypography.h3.copyWith(
                              color: const Color(0xFF5F2221),
                            ),
                          ),
                          Spacing.h(8),
                          if (!_verificationStatus['emailVerified']!)
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16.w,
                                  color: Colors.red,
                                ),
                                Spacing.w(8),
                                Expanded(
                                  child: AutoTranslateText(
                                    'Email: ${_verificationStatus['email'] ?? 'Not verified'}',
                                    style: AppTypography.body2.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (!_verificationStatus['phoneVerified']!) ...[
                            if (!_verificationStatus['emailVerified']!)
                              Spacing.h(4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16.w,
                                  color: Colors.red,
                                ),
                                Spacing.w(8),
                                Expanded(
                                  child: AutoTranslateText(
                                    'Phone: ${_verificationStatus['phone'] ?? 'Not verified'}',
                                    style: AppTypography.body2.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          Spacing.h(8),
                          AutoTranslateText(
                            'Please verify your email and phone number in account settings.',
                            style: AppTypography.label.copyWith(
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            AutoTranslateText(
                              'Name',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            TextFormField(
                              controller: _profileController.fullNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter your full name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),

                            Spacing.h(16),

                            // Gender
                            AutoTranslateText(
                              'Gender',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            DropdownButtonFormField<String>(
                              value: _selectedGender,
                              decoration: InputDecoration(
                                hintText: 'Select gender',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              items: _genderOptions.map((gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: AutoTranslateText(gender),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select gender';
                                }
                                return null;
                              },
                            ),

                            Spacing.h(16),

                            // Date of Birth
                            AutoTranslateText(
                              'Date of Birth',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: _selectDate,
                              decoration: InputDecoration(
                                hintText: 'DD/MM/YYYY',
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  size: 20.w,
                                  color: const Color(0xFFDFB343),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select date of birth';
                                }
                                return null;
                              },
                            ),

                            Spacing.h(16),

                            // Time of Birth
                            AutoTranslateText(
                              'Time of Birth',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              onTap: _selectTime,
                              decoration: InputDecoration(
                                hintText: 'HH:MM:SS',
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  size: 20.w,
                                  color: const Color(0xFFDFB343),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select time of birth';
                                }
                                return null;
                              },
                            ),

                            Spacing.h(16),

                            // Place of Birth
                            AutoTranslateText(
                              'Place of Birth',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            TextFormField(
                              controller:
                                  _profileController.birthCityController,
                              decoration: InputDecoration(
                                hintText: 'Birth Place',
                                suffixIcon: Icon(
                                  Icons.location_on,
                                  size: 20.w,
                                  color: const Color(0xFFDFB343),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty) {
                                  _profileController.onBirthCityChanged();
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter place of birth';
                                }
                                return null;
                              },
                            ),

                            Spacing.h(16),

                            // Marital Status
                            AutoTranslateText(
                              'Marital Status',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            DropdownButtonFormField<String>(
                              value: _selectedMaritalStatus,
                              decoration: InputDecoration(
                                hintText: 'Select marital status',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              items: _maritalStatusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: AutoTranslateText(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMaritalStatus = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select marital status';
                                }
                                return null;
                              },
                            ),

                            Spacing.h(16),

                            // Occupation
                            AutoTranslateText(
                              'Occupation',
                              style: AppTypography.h3.copyWith(
                                color: const Color(0xFF5F2221),
                              ),
                            ),
                            Spacing.h(8),
                            DropdownButtonFormField<String>(
                              value: _selectedOccupation,
                              decoration: InputDecoration(
                                hintText: 'Select occupation',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFDFB343),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 12.h,
                                ),
                              ),
                              items: _occupationOptions.map((occupation) {
                                return DropdownMenuItem(
                                  value: occupation,
                                  child: AutoTranslateText(occupation),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedOccupation = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select occupation';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Spacing.h(16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  Get.back();
                                  if (widget.onCancel != null) {
                                    widget.onCancel!();
                                  }
                                },
                          child: AutoTranslateText(
                            'Cancel',
                            style: AppTypography.h3.copyWith(
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ),
                      ),
                      Spacing.w(12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDFB343),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : AutoTranslateText(
                                  'Proceed',
                                  style: AppTypography.h3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
