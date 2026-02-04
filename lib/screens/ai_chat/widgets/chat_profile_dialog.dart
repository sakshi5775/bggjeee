import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
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
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final fieldColor = theme.colorScheme.surface;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 520.w),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white10),
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
                        .copyWith(color: AppColors.saffron.withOpacity(0.8))
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
                                Icons.person,
                                color: AppColors.saffron,
                              ),
                              fillColor: fieldColor,
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
                              fillColor: fieldColor,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedGender = value);
                                }
                              },
                            ),
                          ],
                          spacing: 12,
                        ),
                        Spacing.h(12),
                        _buildResponsiveGroup(
                          children: [
                            _buildLanguageDropdown(),
                            _buildDropdownField(
                              label: 'Marital Status',
                              value: _selectedMaritalStatus,
                              options: _maritalStatusOptions,
                              fillColor: fieldColor,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(
                                    () => _selectedMaritalStatus = value,
                                  );
                                }
                              },
                            ),
                          ],
                          spacing: 12,
                        ),
                        Spacing.h(12),
                        _buildResponsiveGroup(
                          children: [
                            _buildTextField(
                              label: 'Date of Birth',
                              hint: 'DD/MM/YYYY',
                              controller: _birthDateController,
                              fillColor: fieldColor,
                              readOnly: true,
                              onTap: () => _pickBirthDate(context),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: AppColors.saffron,
                              ),
                            ),
                            _buildTextField(
                              label: 'Time of Birth',
                              hint: 'HH:MM:SS',
                              controller: _birthTimeController,
                              fillColor: fieldColor,
                              readOnly: true,
                              onTap: () => _pickBirthTime(context),
                              suffixIcon: Icon(
                                Icons.access_time,
                                color: AppColors.saffron,
                              ),
                            ),
                          ],
                          spacing: 12,
                        ),
                        Spacing.h(16),
                        _buildResponsiveGroup(
                          children: [
                            _buildTextField(
                              label: 'Place of Birth',
                              hint: 'City, State, Country',
                              controller: _birthPlaceController,
                              fillColor: fieldColor,
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: AppColors.saffron,
                              ),
                            ),
                            _buildTextField(
                              label: 'Occupation',
                              controller: _occupationController,
                              hint: 'Occupation',
                              fillColor: fieldColor,
                              prefixIcon: Icon(
                                Icons.work_outline,
                                color: AppColors.saffron,
                              ),
                            ),
                          ],
                          spacing: 12,
                        ),
                      ],
                    ),
                  ),
                  Spacing.h(28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.saffron,
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
                      Spacing.h(12),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: AutoTranslateText(
                          'Cancel Chat',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: AppColors.saffron,
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
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: today,
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.saffron,
              onPrimary: Colors.white,
              onSurface: AppColors.saffron,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.saffron),
            ),
          ),
          child: child,
        );
      },
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
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.saffron,
              onPrimary: Colors.white,
              onSurface: AppColors.saffron,
            ),
          ),
          child: child,
        );
      },
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
    return BirthPlace(city: city, state: state, country: country);
  }

  BirthTime? _buildBirthTime() {
    final timeText = _birthTimeController.text.trim();
    if (timeText.isEmpty) return null;
    final parts = timeText.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final second = parts.length >= 3
        ? int.tryParse(parts[2])
        : _selectedBirthSeconds;
    return BirthTime(hour: hour, minute: minute, second: second);
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
    Color fillColor = const Color(0xFF1F1F26),
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      style: MyTextTheme.smallBCN.copyWith(color: AppColors.saffron),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: MyTextTheme.smallBCN.copyWith(
          color: AppColors.saffron.withOpacity(0.6),
        ),
        labelStyle: MyTextTheme.smallBCN.copyWith(color: AppColors.saffron),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.saffron),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    Color fillColor = const Color(0xFF1F1F26),
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: MyTextTheme.smallBCN.copyWith(color: AppColors.saffron),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.saffron),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: fillColor,
          style: MyTextTheme.smallBCN.copyWith(color: AppColors.saffron),
          iconEnabledColor: AppColors.saffron,
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
    );
  }

  Widget _buildLanguageDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Language',
        labelStyle: MyTextTheme.smallBCN.copyWith(color: AppColors.saffron),
        filled: true,
        fillColor: const Color(0xFFffffff),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.saffron),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguageCode,
          isExpanded: true,
          dropdownColor: const Color(0xFFffffff),
          style: MyTextTheme.smallBCN.copyWith(color: AppColors.saffron),
          iconEnabledColor: AppColors.saffron,
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
    );
  }

  Widget _buildOpenProfileButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.saffron,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder, color: Colors.white, size: 18.w),
          SizedBox(width: 6.w),
          AutoTranslateText(
            'Open Profile',
            style: MyTextTheme.smallBCB.copyWith(color: Colors.white),
          ),
        ],
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
