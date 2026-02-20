import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/service/numerology_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:intl/intl.dart';

import '../../../app_manager/my_text_theme.dart';
import '../../../utils/app_colors.dart';

class NumerologyFormController extends BaseController {
  final NumerologyService _numerologyService = NumerologyService();

  // Form fields
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final selectedDate = Rx<DateTime?>(null);
  final selectedGender = RxString('');
  final selectedLanguage = RxString('en');

  // Selected tab index
  final selectedTabIndex = 0.obs;

  // Loading state
  final isLoading = false.obs;

  // Language options
  final Map<String, String> languages = {
    'en': 'English',
    'hi': 'Hindi',
    'te': 'Telugu',
    'ka': 'Kannada',
    'ml': 'Malayalam',
    'be': 'Bengali',
    'gr': 'Gujarati',
    'mr': 'Marathi',
  };

  // Gender options
  final List<Map<String, String>> genders = [
    {'value': 'male', 'label': 'Male'},
    {'value': 'female', 'label': 'Female'},
    {'value': 'other', 'label': 'Other'},
  ];

  // Tab features
  final List<Map<String, dynamic>> tabs = [
    {
      'title': 'Key Points',
      'icon': Icons.star,
      'key': 'key_points',
      'requires': ['date', 'gender', 'lang'],
    },
    {
      'title': 'Number Analysis',
      'icon': Icons.numbers,
      'key': 'number_analysis',
      'requires': ['name', 'date', 'phone', 'lang'],
    },
    {
      'title': 'Missing Numbers',
      'icon': Icons.auto_awesome,
      'key': 'missing_numbers',
      'requires': ['date', 'gender', 'lang'],
    },
    {
      'title': 'Available Numbers',
      'icon': Icons.badge,
      'key': 'available_numbers',
      'requires': ['date', 'gender', 'lang'],
    },
    {
      'title': 'Mobile Analysis',
      'icon': Icons.phone,
      'key': 'mobile_analysis',
      'requires': ['phone', 'lang'],
    },
    {
      'title': 'Numerology Suggestion',
      'icon': Icons.favorite,
      'key': 'numerology_suggestion',
      'requires': ['date', 'lang'],
    },
    {
      'title': 'Name Analysis',
      'icon': Icons.work,
      'key': 'name_analysis',
      'requires': ['name', 'date', 'gender', 'lang'],
    },
    {
      'title': 'Vehicle Analysis',
      'icon': Icons.directions_car,
      'key': 'vehicle_analysis',
      'requires': ['vehicle', 'lang'],
    },
    {
      'title': 'Lucky Things',
      'icon': Icons.stars,
      'key': 'lucky_things',
      'requires': ['date', 'gender', 'lang'],
    },
    {
      'title': 'Personal Year',
      'icon': Icons.calendar_today,
      'key': 'personal_year',
      'requires': ['date', 'gender', 'lang'],
    },
    {
      'title': 'Karmic Numbers',
      'icon': Icons.auto_awesome,
      'key': 'karmic_number',
      'requires': ['date', 'lang'],
    },
    {
      'title': 'Master Numbers',
      'icon': Icons.auto_fix_high,
      'key': 'master_numbers',
      'requires': ['date', 'lang'],
    },
    {
      'title': 'Lo Shu Grid',
      'icon': Icons.grid_view,
      'key': 'loshu_grid',
      'requires': ['date', 'gender', 'lang'],
    },
    {
      'title': 'Reports',
      'icon': Icons.description,
      'key': 'reports',
      'requires': [],
    },
  ];

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Check if required fields are filled for a tab
  // Required fields are: date, gender, lang (always required if in the requires list)
  // Optional fields (name, phone) are handled separately in getMissingOptionalFields
  List<String> getMissingFields(String tabKey) {
    final tab = tabs.firstWhere((t) => t['key'] == tabKey);
    final required = tab['requires'];
    final missing = <String>[];

    // Safely convert to List<String>
    List<String> requiredFields = [];
    if (required != null) {
      if (required is List) {
        requiredFields = required.map((e) => e.toString()).toList();
      } else if (required is String) {
        requiredFields = [required];
      }
    }

    // Only check for truly required fields (date, gender, lang)
    // Optional fields (name, phone, vehicle) are handled separately
    for (final field in requiredFields) {
      switch (field) {
        case 'date':
          if (selectedDate.value == null) {
            missing.add('Date of Birth');
          }
          break;
        case 'gender':
          if (selectedGender.value.isEmpty) {
            missing.add('Gender');
          }
          break;
        case 'lang':
          if (selectedLanguage.value.isEmpty) {
            missing.add('Language');
          }
          break;
        // Skip optional fields - they're handled in getMissingOptionalFields
        case 'name':
        case 'phone':
        case 'vehicle':
          break;
      }
    }

    return missing;
  }

  // Submit form and navigate to features page
  Future<void> submitForm() async {
    // Validate required fields
    if (selectedDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select your date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select your gender',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (selectedLanguage.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select a language',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to features selection page
    Get.toNamed('/numerology-features');
  }

  // Handle tab selection
  Future<void> onTabSelected(int index) async {
    final tab = tabs[index];
    final tabKey = tab['key'] as String;

    // Check for missing required fields
    final missingFields = getMissingFields(tabKey);

    // Check for missing optional fields that are needed for this tab
    final missingOptionalFields = getMissingOptionalFields(tabKey);

    // Debug output
    debugPrint('Tab: $tabKey');
    debugPrint('Missing required fields: $missingFields');
    debugPrint('Missing optional fields: $missingOptionalFields');

    // If required fields are missing, show error
    if (missingFields.isNotEmpty) {
      Get.snackbar(
        'Missing Required Fields',
        'Please fill: ${missingFields.join(", ")}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    // If optional fields are missing but needed, show form popup
    if (missingOptionalFields.isNotEmpty) {
      debugPrint(
        'Showing dialog for missing optional fields: $missingOptionalFields',
      );
      await _showOptionalFieldsDialog(missingOptionalFields, tabKey);
      return;
    }

    selectedTabIndex.value = index;

    // Special handling for vehicle analysis
    if (tabKey == 'vehicle_analysis') {
      _showVehicleNumberDialog();
      return;
    }

    // Special handling for reports
    if (tabKey == 'reports') {
      _navigateToReports();
      return;
    }

    // Special handling for key points
    if (tabKey == 'key_points') {
      _showKeyPoints();
      return;
    }

    // Call API for the selected tab
    await _callTabApi(tabKey);
  }

  // Get missing optional fields that are needed for a tab
  // Optional fields are: name, phone (not date, gender, lang which are always required)
  List<String> getMissingOptionalFields(String tabKey) {
    final tab = tabs.firstWhere((t) => t['key'] == tabKey);
    final required = tab['requires'];
    final missing = <String>[];

    List<String> requiredFields = [];
    if (required != null) {
      if (required is List) {
        requiredFields = required.map((e) => e.toString()).toList();
      } else if (required is String) {
        requiredFields = [required];
      }
    }

    // Only check for optional fields (name, phone)
    // Required fields (date, gender, lang) are already checked in getMissingFields
    for (final field in requiredFields) {
      // Skip required fields - they're handled separately
      if (field == 'date' || field == 'gender' || field == 'lang') {
        continue;
      }

      switch (field) {
        case 'name':
          if (nameController.text.trim().isEmpty) {
            missing.add('name');
          }
          break;
        case 'phone':
          if (phoneController.text.trim().isEmpty) {
            missing.add('phone');
          }
          break;
      }
    }

    return missing;
  }

  // Show dialog for missing optional fields
  Future<void> _showOptionalFieldsDialog(
    List<String> missingFields,
    String tabKey,
  ) async {
    final nameController = TextEditingController(
      text: this.nameController.text,
    );
    final phoneController = TextEditingController(
      text: this.phoneController.text,
    );

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: Get.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Additional Information Required',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F221E),
                ).merge(AppTypography.h2),
              ),
              Spacing.h(16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (missingFields.contains('name')) ...[
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name *',
                            labelStyle: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            hintText: 'Enter your name',
                            hintStyle: MyTextTheme.smallBCN.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        Spacing.h(16),
                      ],
                      if (missingFields.contains('phone')) ...[
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,

                          decoration: InputDecoration(
                            labelStyle: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            hintStyle: MyTextTheme.smallBCN.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            labelText: 'Phone Number *',
                            hintText: 'Enter your phone number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        Spacing.h(16),
                      ],
                    ],
                  ),
                ),
              ),
              Spacing.h(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        side: BorderSide(color: AppColors.saffron),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: AutoTranslateText('Cancel'),
                  ),
                  Spacing.w(8),
                  GestureDetector(
                    onTap: () {
                      // Validate fields
                      bool isValid = true;
                      if (missingFields.contains('name') &&
                          nameController.text.trim().isEmpty) {
                        isValid = false;
                        Get.snackbar(
                          'Validation Error',
                          'Please enter your name',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withValues(alpha: 0.8),
                          colorText: Colors.white,
                        );
                        return;
                      }
                      if (missingFields.contains('phone') &&
                          phoneController.text.trim().isEmpty) {
                        isValid = false;
                        Get.snackbar(
                          'Validation Error',
                          'Please enter your phone number',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withValues(alpha: 0.8),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      if (isValid) {
                        // Update form data
                        if (missingFields.contains('name')) {
                          this.nameController.text = nameController.text.trim();
                        }
                        if (missingFields.contains('phone')) {
                          this.phoneController.text = phoneController.text
                              .trim();
                        }
                        Get.back();
                        // Retry the tab selection
                        final tabIndex = tabs.indexWhere(
                          (t) => t['key'] == tabKey,
                        );
                        if (tabIndex >= 0) {
                          onTabSelected(tabIndex);
                        }
                      }
                    },

                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: AutoTranslateText(
                        'Submit',
                        style: MyTextTheme.mediumWCB.copyWith(
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
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _callTabApi(String tabKey) async {
    isLoading.value = true;

    try {
      final dateStr = selectedDate.value != null
          ? formatDate(selectedDate.value!)
          : '';
      final gender = selectedGender.value;
      final lang = selectedLanguage.value;
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();

      Map<String, dynamic>? response;

      switch (tabKey) {
        case 'number_analysis':
          response = await _numerologyService.getNumberAnalysis(
            name: name,
            date: dateStr,
            phone: phone,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'number_analysis',
                'data': response['response'],
              },
            );
          }
          break;

        case 'missing_numbers':
          response = await _numerologyService.getMissingNumbers(
            date: dateStr,
            gender: gender,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'missing_numbers',
                'data': response['response'],
              },
            );
          }
          break;

        case 'available_numbers':
          response = await _numerologyService.getAvailableNumbers(
            date: dateStr,
            gender: gender,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'available_numbers',
                'data': response['response'],
              },
            );
          }
          break;

        case 'mobile_analysis':
          response = await _numerologyService.getMobileAnalysis(
            phone: phone,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'mobile_analysis',
                'data': response['response'],
              },
            );
          }
          break;

        case 'numerology_suggestion':
          response = await _numerologyService.getNumerologySuggestion(
            date: dateStr,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'numerology_suggestion',
                'data': response['response'],
              },
            );
          }
          break;

        case 'name_analysis':
          response = await _numerologyService.getNameAnalysis(
            name: name,
            date: dateStr,
            gender: gender,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'name_analysis',
                'data': response['response'],
              },
            );
          }
          break;

        case 'lucky_things':
          response = await _numerologyService.getLuckyThings(
            date: dateStr,
            gender: gender,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {'type': 'lucky_things', 'data': response['response']},
            );
          }
          break;

        case 'personal_year':
          response = await _numerologyService.getPersonalYear(
            date: dateStr,
            gender: gender,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'personal_year',
                'data': response['response'],
              },
            );
          }
          break;

        case 'karmic_number':
          response = await _numerologyService.getKarmicNumber(
            date: dateStr,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'karmic_number',
                'data': response['response'],
              },
            );
          }
          break;

        case 'master_numbers':
          response = await _numerologyService.getMasterNumbers(
            date: dateStr,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/numerology-result',
              arguments: {
                'type': 'master_numbers',
                'data': response['response'],
              },
            );
          }
          break;

        case 'loshu_grid':
          response = await _numerologyService.getLoShuGrid(
            date: dateStr,
            gender: gender,
            lang: lang,
          );
          if (response != null) {
            Get.toNamed(
              '/loshu-grid-result',
              arguments: {
                ...response['response'],
                '_formData': {'date': dateStr, 'gender': gender, 'lang': lang},
              },
            );
          }
          break;
      }

      if (response == null) {
        Get.snackbar(
          'Error',
          'Failed to fetch data. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showVehicleNumberDialog() {
    final vehicleController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Vehicle Analysis',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F221E),
                ).merge(AppTypography.h2),
              ),
              Spacing.h(16),
              TextField(
                controller: vehicleController,
                decoration: InputDecoration(
                  labelStyle: MyTextTheme.smallBCB.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  hintStyle: MyTextTheme.smallBCN.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  labelText: 'Vehicle Number (Last 4 digits)',
                  hintText: 'Enter last 4 digits',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
              ),
              Spacing.h(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        side: BorderSide(color: AppColors.saffron),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: AutoTranslateText('Cancel'),
                  ),
                  Spacing.w(8),
                  GestureDetector(
                    onTap: () async {
                      if (vehicleController.text.trim().length == 4) {
                        Get.back();
                        await _callVehicleAnalysis(
                          vehicleController.text.trim(),
                        );
                      } else {
                        showErrorMessage(message: 'Please enter 4 digits');
                        return;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: AutoTranslateText(
                        'Submit',
                        style: MyTextTheme.mediumWCB.copyWith(
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
      ),
    );
  }

  Future<void> _callVehicleAnalysis(String vehicle) async {
    isLoading.value = true;

    try {
      final response = await _numerologyService.getVehicleAnalysis(
        vehicle: vehicle,
        lang: selectedLanguage.value,
      );

      if (response != null) {
        Get.toNamed(
          '/numerology-result',
          arguments: {'type': 'vehicle_analysis', 'data': response['response']},
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch vehicle analysis. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _navigateToReports() {
    Get.toNamed('/numerology-reports');
  }

  void _showKeyPoints() async {
    // Fetch all APIs and show Key Points result
    isLoading.value = true;

    try {
      final dateStr = selectedDate.value != null
          ? formatDate(selectedDate.value!)
          : '';
      final gender = selectedGender.value;
      final lang = selectedLanguage.value;
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();

      // Fetch all APIs in parallel
      final results = await Future.wait([
        if (name.isNotEmpty && phone.isNotEmpty)
          _numerologyService.getNumberAnalysis(
            name: name,
            date: dateStr,
            phone: phone,
            lang: lang,
          ),
        _numerologyService.getMissingNumbers(
          date: dateStr,
          gender: gender,
          lang: lang,
        ),
        _numerologyService.getAvailableNumbers(
          date: dateStr,
          gender: gender,
          lang: lang,
        ),
        if (phone.isNotEmpty)
          _numerologyService.getMobileAnalysis(phone: phone, lang: lang),
        _numerologyService.getNumerologySuggestion(date: dateStr, lang: lang),
        if (name.isNotEmpty)
          _numerologyService.getNameAnalysis(
            name: name,
            date: dateStr,
            gender: gender,
            lang: lang,
          ),
        _numerologyService.getLuckyThings(
          date: dateStr,
          gender: gender,
          lang: lang,
        ),
        _numerologyService.getPersonalYear(
          date: dateStr,
          gender: gender,
          lang: lang,
        ),
        _numerologyService.getKarmicNumber(date: dateStr, lang: lang),
        _numerologyService.getMasterNumbers(date: dateStr, lang: lang),
      ]);

      // Combine all data
      final combinedData = <String, dynamic>{};

      int resultIndex = 0;

      // Number Analysis
      if (name.isNotEmpty && phone.isNotEmpty && results[resultIndex] != null) {
        final numberAnalysis = results[resultIndex] as Map<String, dynamic>;
        if (numberAnalysis['response'] != null) {
          combinedData.addAll(
            numberAnalysis['response'] as Map<String, dynamic>,
          );
        }
        resultIndex++;
      }

      // Missing Numbers
      if (results[resultIndex] != null) {
        final missingNumbers = results[resultIndex] as Map<String, dynamic>;
        if (missingNumbers['response'] != null) {
          combinedData['missingNumbersData'] = missingNumbers['response'];
        }
        resultIndex++;
      }

      // Available Numbers
      if (results[resultIndex] != null) {
        final availableNumbers = results[resultIndex] as Map<String, dynamic>;
        if (availableNumbers['response'] != null) {
          combinedData['availableNumbersData'] = availableNumbers['response'];
        }
        resultIndex++;
      }

      // Mobile Analysis
      if (phone.isNotEmpty && results[resultIndex] != null) {
        final mobileAnalysis = results[resultIndex] as Map<String, dynamic>;
        if (mobileAnalysis['response'] != null) {
          combinedData['mobileAnalysisData'] = mobileAnalysis['response'];
        }
        resultIndex++;
      }

      // Numerology Suggestion
      if (results[resultIndex] != null) {
        final numerologySuggestion =
            results[resultIndex] as Map<String, dynamic>;
        if (numerologySuggestion['response'] != null) {
          combinedData['numerologySuggestionData'] =
              numerologySuggestion['response'];
        }
        resultIndex++;
      }

      // Name Analysis
      if (name.isNotEmpty && results[resultIndex] != null) {
        final nameAnalysis = results[resultIndex] as Map<String, dynamic>;
        if (nameAnalysis['response'] != null) {
          combinedData['nameAnalysisData'] = nameAnalysis['response'];
        }
        resultIndex++;
      }

      // Lucky Things
      if (results[resultIndex] != null) {
        final luckyThings = results[resultIndex] as Map<String, dynamic>;
        if (luckyThings['response'] != null) {
          combinedData['luckyThingsData'] = luckyThings['response'];
        }
        resultIndex++;
      }

      // Personal Year
      if (results[resultIndex] != null) {
        final personalYear = results[resultIndex] as Map<String, dynamic>;
        if (personalYear['response'] != null) {
          combinedData['personalYearData'] = personalYear['response'];
        }
        resultIndex++;
      }

      // Karmic Number
      if (results[resultIndex] != null) {
        final karmicNumber = results[resultIndex] as Map<String, dynamic>;
        if (karmicNumber['response'] != null) {
          combinedData['karmicNumberData'] = karmicNumber['response'];
        }
        resultIndex++;
      }

      // Master Numbers
      if (results[resultIndex] != null) {
        final masterNumbers = results[resultIndex] as Map<String, dynamic>;
        if (masterNumbers['response'] != null) {
          combinedData['masterNumbersData'] = masterNumbers['response'];
        }
      }

      // Add form data
      combinedData['_formData'] = {
        'name': name,
        'date': dateStr,
        'gender': gender,
        'lang': lang,
        'phone': phone,
      };

      // Navigate to result view with combined data
      Get.toNamed(
        '/numerology-result',
        arguments: {'type': 'key_points', 'data': combinedData},
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch key points: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}


