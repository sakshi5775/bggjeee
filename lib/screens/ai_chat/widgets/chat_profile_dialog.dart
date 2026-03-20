import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<ChatProfileResult?> showPersonaChatProfileDialog(
  BuildContext context,
  UserProfileModel? initialProfile,
) {
  print('DEBUG: showPersonaChatProfileDialog called');
  return showDialog<ChatProfileResult?>(
    context: context,
    barrierDismissible: false,
    builder: (context) => ChatProfileDialog(initialProfile: initialProfile),
  );
}

class ChatProfileResult {
  final UserProfileModel profile;
  final String languageCode;

  ChatProfileResult({required this.profile, required this.languageCode});
}

class ChatProfileDialog extends StatefulWidget {
  final UserProfileModel? initialProfile;

  const ChatProfileDialog({Key? key, this.initialProfile}) : super(key: key);

  @override
  State<ChatProfileDialog> createState() => _ChatProfileDialogState();
}

class _ChatProfileDialogState extends State<ChatProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  late final TextEditingController _fullNameController;
  late final TextEditingController _occupationController;
  late final TextEditingController _birthPlaceController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _birthTimeController;
  late String _selectedGender;
  late String _selectedMaritalStatus;
  DateTime? _selectedBirthDate;
  TimeOfDay? _selectedBirthTime;
  int _selectedBirthSeconds = 0;
  String _selectedLanguageCode = 'en';
  double? _birthPlaceLat;
  double? _birthPlaceLng;
  double? _birthPlaceTz;
  static const Map<String, String> _languageOptions = {
    'en': 'English',
    'hi': 'Hindi',
    'gu': 'Gujarati',
    'te': 'Telugu',
    'ta': 'Tamil',
    'kn': 'Kannada',
    'mr': 'Marathi',
    'ml': 'Malayalam',
    'bn': 'Bengali',
    'as': 'Assamese',
    'or': 'Odia',
  };

  @override
  void initState() {
    super.initState();
    print('DEBUG: ChatProfileDialog initState');
    final personalInfo = widget.initialProfile?.personalInfo;
    final birthPlace = widget.initialProfile?.birthChart?.birthPlace;
    final birthTime = widget.initialProfile?.birthChart?.birthTime;

    _fullNameController = TextEditingController(
      text: personalInfo?.fullName ?? '',
    );
    _occupationController = TextEditingController(
      text: personalInfo?.occupation ?? '',
    );
    _selectedGender = _matchOption(_genderOptions, personalInfo?.gender);
    _selectedMaritalStatus = _matchOption(
      _maritalStatusOptions,
      personalInfo?.maritalStatus,
    );
    final initialLanguage = widget.initialProfile?.preferences?.language;
    if (initialLanguage != null && initialLanguage.isNotEmpty) {
      final normalized = initialLanguage.toLowerCase();
      if (_languageOptions.containsKey(normalized)) {
        _selectedLanguageCode = normalized;
      }
    }

    final placeParts = <String>[];
    if (birthPlace != null) {
      if (birthPlace.city != null && birthPlace.city!.isNotEmpty) {
        placeParts.add(birthPlace.city!);
      }
      if (birthPlace.state != null && birthPlace.state!.isNotEmpty) {
        placeParts.add(birthPlace.state!);
      }
      if (birthPlace.country != null && birthPlace.country!.isNotEmpty) {
        placeParts.add(birthPlace.country!);
      }
      _birthPlaceLat = birthPlace.latitude;
      _birthPlaceLng = birthPlace.longitude;
      _birthPlaceTz = birthPlace.timezone != null
          ? double.tryParse(birthPlace.timezone!)
          : null;
    }
    _birthPlaceController = TextEditingController(text: placeParts.join(', '));

    // Parse birth date - handle both ISO format and DD/MM/YYYY format
    final existingDateStr = widget.initialProfile?.birthChart?.generatedAt;
    String dateText = '';
    if (existingDateStr != null && existingDateStr.isNotEmpty) {
      try {
        // Try parsing as ISO date
        final isoDate = DateTime.tryParse(existingDateStr);
        if (isoDate != null) {
          _selectedBirthDate = isoDate;
          dateText = _formatDate(isoDate);
        } else {
          // Try parsing as DD/MM/YYYY
          final parts = existingDateStr.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            if (day != null && month != null && year != null) {
              _selectedBirthDate = DateTime(year, month, day);
              dateText = existingDateStr;
            }
          }
        }
      } catch (e) {
        // Keep dateText empty if parsing fails
      }
    }
    _birthDateController = TextEditingController(text: dateText);

    _birthTimeController = TextEditingController();
    if (birthTime != null &&
        birthTime.hour != null &&
        birthTime.minute != null) {
      _selectedBirthSeconds = birthTime.second ?? 0;
      _birthTimeController.text = TimePickerHelper.formatTime24To12Display(
        birthTime.hour!,
        birthTime.minute!,
      );
      _selectedBirthTime = TimeOfDay(
        hour: birthTime.hour!,
        minute: birthTime.minute!,
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _occupationController.dispose();
    _birthPlaceController.dispose();
    _birthDateController.dispose();
    _birthTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520.w,
          maxHeight: MediaQuery.of(context).size.height * 0.94,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.gradientBackground,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOpenProfileButton(),
                  Spacing.h(16),
                  AutoTranslateText(
                    'Share Birth Details',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    'Share them with your persona to avoid typing during chat.',
                    style: MyTextTheme.smallBCN
                        .copyWith(
                          color: AppColors.saffron.withValues(alpha: 0.8),
                        )
                        .merge(AppTypography.body2),
                  ),
                  Spacing.h(20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildResponsiveGroup(
                          children: [
                            _buildTextField(
                              label: 'Full Name',
                              controller: _fullNameController,
                              hint: 'Enter name',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: AppColors.deepOrange,
                              ),
                              fillColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a name';
                                }
                                return null;
                              },
                            ),
                            _buildDropdownField(
                              label: 'Gender',
                              value: _selectedGender,
                              options: _genderOptions,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.wc_outlined,
                                color: AppColors.deepOrange,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedGender = value);
                                }
                              },
                            ),
                          ],
                          spacing: 16,
                        ),
                        Spacing.h(16),
                        _buildResponsiveGroup(
                          children: [
                            _buildLanguageDropdown(),
                            _buildDropdownField(
                              label: 'Marital Status',
                              value: _selectedMaritalStatus,
                              options: _maritalStatusOptions,
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.favorite_border,
                                color: AppColors.deepOrange,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(
                                    () => _selectedMaritalStatus = value,
                                  );
                                }
                              },
                            ),
                          ],
                          spacing: 16,
                        ),
                        Spacing.h(16),
                        _buildResponsiveGroup(
                          children: [
                            _buildTextField(
                              label: 'Date of Birth',
                              hint: 'DD/MM/YYYY',
                              controller: _birthDateController,
                              fillColor: Colors.white,
                              readOnly: true,
                              onTap: () => _pickBirthDate(context),
                              prefixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.deepOrange,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select date of birth';
                                }
                                return null;
                              },
                            ),
                            _buildTextField(
                              label: 'Time of Birth',
                              hint: 'HH:MM:SS',
                              controller: _birthTimeController,
                              fillColor: Colors.white,
                              readOnly: true,
                              onTap: () => _pickBirthTime(context),
                              prefixIcon: Icon(
                                Icons.access_time_outlined,
                                color: AppColors.deepOrange,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please select time of birth';
                                }
                                return null;
                              },
                            ),
                          ],
                          spacing: 16,
                        ),
                        Spacing.h(16),
                        _buildResponsiveGroup(
                          children: [
                            _buildPlaceOfBirthField(context),
                            _buildTextField(
                              label: 'Occupation',
                              controller: _occupationController,
                              hint: 'Occupation',
                              fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.work_outline,
                                color: AppColors.deepOrange,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter occupation';
                                }
                                return null;
                              },
                            ),
                          ],
                          spacing: 16,
                        ),
                      ],
                    ),
                  ),
                  Spacing.h(28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: AutoTranslateText(
                            'Proceed Chat',
                            style: MyTextTheme.mediumBCB
                                .copyWith(color: Colors.white)
                                .merge(AppTypography.h3),
                          ),
                        ),
                      ),
                      Spacing.h(12),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: AutoTranslateText(
                          'Cancel Chat',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: AppColors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickBirthDate(BuildContext context) async {
    final today = DateTime.now();
    final initial = _selectedBirthDate ?? today;
    final picked = await TimePickerHelper.showDatePicker(
      context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (picked != null) {
      _selectedBirthDate = picked;
      _birthDateController.text = _formatDate(picked);
    }
  }

  Future<void> _pickBirthTime(BuildContext context) async {
    final initial = _selectedBirthTime ?? TimeOfDay.now();
    final picked = await TimePickerHelper.showTimePicker12h(
      context,
      initialTime: initial,
    );
    if (picked != null) {
      _selectedBirthTime = picked;
      final seconds = await _pickBirthSeconds(context, _selectedBirthSeconds);
      if (seconds != null) {
        _selectedBirthSeconds = seconds;
      }
      _birthTimeController.text = TimePickerHelper.formatTime24To12Display(
        picked.hour,
        picked.minute,
      );
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    // Create profile with ONLY dialog form data - no existing user data
    // Include preferences.language to override user's stored language preference
    final profile = UserProfileModel(
      personalInfo: PersonalInfo(
        fullName: _fullNameController.text.trim(),
        gender: _selectedGender,
        maritalStatus: _selectedMaritalStatus,
        occupation: _normalize(_occupationController.text),
      ),
      birthChart: _buildBirthChart(),
      contactInfo: null,
      // Explicitly set language preference to override any existing user language
      preferences: Preferences(language: _selectedLanguageCode),
    );

    Navigator.of(context).pop(
      ChatProfileResult(profile: profile, languageCode: _selectedLanguageCode),
    );
  }

  BirthChart? _buildBirthChart() {
    final birthPlace = _buildBirthPlace();
    final birthTime = _buildBirthTime();
    // Use selected date if available, otherwise use controller text (should be DD/MM/YYYY)
    String? dobText;
    if (_selectedBirthDate != null) {
      dobText = _formatDate(_selectedBirthDate!);
    } else {
      final controllerText = _birthDateController.text.trim();
      if (controllerText.isNotEmpty) {
        dobText = controllerText;
      }
    }
    if (birthPlace == null &&
        birthTime == null &&
        (dobText == null || dobText.isEmpty))
      return null;
    return BirthChart(
      birthPlace: birthPlace,
      birthTime: birthTime,
      generatedAt: dobText,
    );
  }

  BirthPlace? _buildBirthPlace() {
    final placeText = _normalize(_birthPlaceController.text);
    if (placeText == null) return null;
    final rawParts = placeText
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    final city = rawParts.isNotEmpty ? rawParts[0] : null;
    final state = rawParts.length > 1 ? rawParts[1] : null;
    final country = rawParts.length > 2 ? rawParts[2] : null;
    if (city == null && state == null && country == null) return null;
    return BirthPlace(
      city: city,
      state: state,
      country: country,
      latitude: _birthPlaceLat,
      longitude: _birthPlaceLng,
      timezone: _birthPlaceTz?.toString(),
    );
  }

  Widget _buildPlaceOfBirthField(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLocationSheet(context),
      child: AbsorbPointer(
        child: _buildTextField(
          label: 'Place of Birth',
          hint: 'Tap to select birth place',
          controller: _birthPlaceController,
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: AppColors.deepOrange,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select place of birth';
            }
            return null;
          },
        ),
      ),
    );
  }

  void _showLocationSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: LocationBottomSheetWidget(
          selectedCity: _birthPlaceController.text.trim().isEmpty
              ? 'Select birth place'
              : _birthPlaceController.text.trim(),
          onCitySelected: (city, state, country, [lat, lng, tz]) {
            final parts = [city, state, country]
                .where((s) => s != null && s.toString().trim().isNotEmpty)
                .toList();
            setState(() {
              _birthPlaceController.text = parts.join(', ');
              _birthPlaceLat = lat;
              _birthPlaceLng = lng;
              _birthPlaceTz = tz;
            });
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  BirthTime? _buildBirthTime() {
    if (_selectedBirthTime == null) {
      final timeText = _birthTimeController.text.trim();
      if (timeText.isEmpty) return null;
      // Fallback parsing logic (less reliable)
      final parts = timeText.split(':');
      if (parts.length < 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      return BirthTime(
        hour: hour,
        minute: minute,
        second: _selectedBirthSeconds,
      );
    }
    return BirthTime(
      hour: _selectedBirthTime!.hour,
      minute: _selectedBirthTime!.minute,
      second: _selectedBirthSeconds,
    );
  }

  Future<int?> _pickBirthSeconds(BuildContext context, int initialSeconds) {
    final controller = TextEditingController(
      text: initialSeconds.toString().padLeft(2, '0'),
    );
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AutoTranslateText('Seconds', style: MyTextTheme.mediumBCB),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 2,
            decoration: InputDecoration(hintText: '00', counterText: ''),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(initialSeconds),
              child: AutoTranslateText('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final value = int.tryParse(controller.text) ?? initialSeconds;
                Navigator.of(context).pop(value.clamp(0, 59));
              },
              child: AutoTranslateText('Save'),
            ),
          ],
        );
      },
    );
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  String _matchOption(List<String> options, String? value) {
    if (value == null) return options.first;
    return options.firstWhere(
      (option) => option.toLowerCase() == value.toLowerCase(),
      orElse: () => options.first,
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    String? hint,
    Color fillColor = Colors.white,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.textColorMaroon,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 4.h),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly,
            onTap: onTap,
            style: MyTextTheme.smallBCN.copyWith(
              color: AppColors.textColorMaroon,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textColorMaroon.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: Colors.transparent, // Controlled by container
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    Color fillColor = Colors.white,
    Widget? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
          child: AutoTranslateText(
            label,
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.textColorMaroon,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent, // Controlled by container
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.deepOrange),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 4.h,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textColorMaroon,
                  fontWeight: FontWeight.w500,
                ),
                iconEnabledColor: AppColors.deepOrange,
                items: options
                    .map(
                      (option) => DropdownMenuItem<String>(
                        value: option,
                        child: AutoTranslateText(option),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 6.h),
          child: AutoTranslateText(
            'Language',
            style: MyTextTheme.smallBCB.copyWith(
              color: AppColors.textColorMaroon,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent, // Controlled by container
              prefixIcon: Icon(Icons.language, color: AppColors.deepOrange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.deepOrange.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.deepOrange),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 4.h,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguageCode,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textColorMaroon,
                  fontWeight: FontWeight.w500,
                ),
                iconEnabledColor: AppColors.deepOrange,
                items: _languageOptions.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: AutoTranslateText(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedLanguageCode = value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenProfileButton() {
    return InkWell(
      onTap: () {
        // Handle open profile or show existing profiles
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.deepOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.folder_open, color: AppColors.deepOrange, size: 18.w),
            SizedBox(width: 8.w),
            AutoTranslateText(
              'Select from saved Profile',
              style: MyTextTheme.smallBCB.copyWith(color: AppColors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveGroup({
    required List<Widget> children,
    double spacing = 12,
  }) {
    final gapW = spacing.w;
    final gapH = spacing.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth;
        final columnWidth = children.length > 1
            ? (available - gapW) / 2
            : available;

        return Wrap(
          spacing: gapW,
          runSpacing: gapH,
          children: children
              .map((child) => SizedBox(width: columnWidth, child: child))
              .toList(),
        );
      },
    );
  }
}
