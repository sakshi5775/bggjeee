import 'dart:convert';
import 'dart:io';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/palm_reading_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/app_manager/common/image_picker.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';

class PalmReadingController extends GetxController {
  // Form fields
  final TextEditingController nameController = TextEditingController();
  final RxString dateOfBirth = ''.obs;
  final RxString selectedLanguage = ''.obs;

  // Birth time
  final RxInt selectedHour = 12.obs;
  final RxInt selectedMinute = 0.obs;
  final RxString selectedAmPm = 'PM'.obs;

  // Hand and gender
  final RxString selectedHand = ''.obs; // 'Left' or 'Right'
  final RxString selectedGender = ''.obs; // 'Male', 'Female', 'Others'

  // Palm image
  final Rx<File?> selectedPalmImage = Rx<File?>(null);

  // Form validation
  final RxBool isFormValid = false.obs;
  final RxBool isTimeValid = false.obs;
  final RxBool isHandGenderValid = false.obs;

  // Scanning state
  final RxBool isScanning = false.obs;
  final RxString scanError = ''.obs;

  // Reading data
  final Rx<PalmReadingData?> palmReadingData = Rx<PalmReadingData?>(null);
  final RxString currentReadingId = ''.obs;
  final RxBool isLoadingReading = false.obs;
  final RxString readingError = ''.obs;

  DateTime? _selectedDate;
  AppLanguageModel? _selectedLanguageModel;
  final ApiRepository _apiRepository = Get.find();
  final UserProfileService _userProfileService = UserProfileService();

  @override
  void onInit() {
    super.onInit();

    // Set default language to first language (index 0)
    _setDefaultLanguage();
    _loadUserProfileData();

    // Listen to form changes
    nameController.addListener(_validateForm);
    ever(dateOfBirth, (_) => _validateForm());
    ever(selectedLanguage, (_) => _validateForm());
    ever(selectedHour, (_) => _validateTime());
    ever(selectedMinute, (_) => _validateTime());
    ever(selectedAmPm, (_) => _validateTime());
    ever(selectedHand, (_) => _validateHandGender());
    ever(selectedGender, (_) => _validateHandGender());
  }

  Future<void> _setDefaultLanguage() async {
    try {
      final languages = await LanguageModelService.getLanguages();
      if (languages.isNotEmpty) {
        // Select the first language (index 0)
        _selectedLanguageModel = languages[0];
        selectedLanguage.value = languages[0].nameEn;
      }
    } catch (e) {
      // If loading fails, keep empty selection
      print('Error loading default language: $e');
    }
  }

  Future<void> _loadUserProfileData() async {
    try {
      final userId = UserData().getLoginData.user?.userId;
      if (userId == null) return;
      final profile = await _userProfileService.getProfile(userId);
      if (profile == null) return;

      if (profile.personalInfo != null) {
        final fullName = profile.personalInfo!.fullName;
        if (fullName != null &&
            fullName.isNotEmpty &&
            nameController.text.isEmpty) {
          nameController.text = fullName;
        }
        final gender = profile.personalInfo!.gender;
        if (gender != null &&
            gender.isNotEmpty &&
            selectedGender.value.isEmpty) {
          if (gender.toUpperCase() == 'MALE') {
            selectedGender.value = 'Male';
          } else if (gender.toUpperCase() == 'FEMALE') {
            selectedGender.value = 'Female';
          } else {
            selectedGender.value = gender;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void _validateForm() {
    isFormValid.value =
        nameController.text.trim().isNotEmpty &&
        dateOfBirth.value.isNotEmpty &&
        selectedLanguage.value.isNotEmpty;
  }

  void _validateTime() {
    isTimeValid.value =
        selectedHour.value >= 1 &&
        selectedHour.value <= 12 &&
        selectedMinute.value >= 0 &&
        selectedMinute.value <= 59 &&
        (selectedAmPm.value == 'AM' || selectedAmPm.value == 'PM');
  }

  void _validateHandGender() {
    isHandGenderValid.value =
        selectedHand.value.isNotEmpty && selectedGender.value.isNotEmpty;
  }

  Future<void> selectDateOfBirth() async {
    final context = Get.context;
    if (context == null) return;

    final pickedDate = await TimePickerHelper.showDatePicker(
      context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _selectedDate = pickedDate;
      dateOfBirth.value = DateFormat('MMMM dd, yyyy').format(pickedDate);
    }
  }

  Future<void> showLanguagePicker() async {
    final context = Get.context;
    if (context == null) return;

    try {
      final languages = await LanguageModelService.getLanguages();

      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              AutoTranslateText(
                'Select Language',
                style: TextStyle(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.bold,
                ).merge(AppTypography.h2),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    final isSelected =
                        _selectedLanguageModel?.code == language.code;
                    return ListTile(
                      title: AutoTranslateText(
                        language.nameEn,
                        style: TextStyle(
                          color: isSelected
                              ? "#F38B3B".toColor()
                              : const Color(0xFF5F2221),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: "#F38B3B".toColor())
                          : null,
                      onTap: () {
                        _selectedLanguageModel = language;
                        selectedLanguage.value = language.nameEn;
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load languages');
    }
  }

  void onStartReading() {
    UserMainController.pushInCurrentTab(AppRoutes.palmReadingForm);
  }

  // Direct upload method - allows skipping form
  Future<void> uploadPalmImage(BuildContext context) async {
    try {
      final pickedFile = await ImagePickerHelper.pickImage(context);
      if (pickedFile != null) {
        selectedPalmImage.value = pickedFile;
        // Navigate directly to scanning screen
        UserMainController.pushInCurrentTab(AppRoutes.palmReadingScanning);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
    }
  }

  // Take photo directly
  Future<void> takePalmPhoto(BuildContext context) async {
    try {
      final pickedFile = await ImagePickerHelper.pickImage(context);
      if (pickedFile != null) {
        selectedPalmImage.value = pickedFile;
        // Navigate directly to scanning screen
        UserMainController.pushInCurrentTab(AppRoutes.palmReadingScanning);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo');
    }
  }

  void onContinueFromForm() {
    // Form fields are now optional, so we can continue even if not filled
    UserMainController.pushInCurrentTab(AppRoutes.palmReadingTime);
  }

  void onContinueFromTime() {
    // Time is now optional, so we can continue even if not filled
    UserMainController.pushInCurrentTab(AppRoutes.palmReadingHandGender);
  }

  void onContinueFromHandGender() {
    // Hand and gender are now optional, so we can continue even if not selected
    UserMainController.pushInCurrentTab(AppRoutes.palmReadingUpload);
  }

  Future<void> takePhoto(BuildContext context) async {
    // Navigate to camera view instead of using image picker
    UserMainController.pushInCurrentTab(AppRoutes.palmReadingCamera);
  }

  Future<void> uploadFromGallery(BuildContext context) async {
    try {
      final pickedFile = await ImagePickerHelper.pickImage(context);
      if (pickedFile != null) {
        selectedPalmImage.value = pickedFile;
        // Navigate to scanning screen
        UserMainController.pushInCurrentTab(AppRoutes.palmReadingScanning);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload from gallery');
    }
  }

  void onContinueFromUpload() {
    if (selectedPalmImage.value != null) {
      UserMainController.pushInCurrentTab(AppRoutes.palmReadingScanning);
    }
  }

  void selectHand(String hand) {
    selectedHand.value = hand;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // Start scanning process
  Future<void> startScanning() async {
    if (selectedPalmImage.value == null) {
      // Close loader if open
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }
      scanError.value = 'No palm image selected';
      return;
    }

    // Check balance
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('palmistry')) {
        pricingCtrl.showInsufficientBalancePopup('palmistry');
        return;
      }
    }

    isScanning.value = true;
    scanError.value = '';

    try {
      // Call API to analyze palm
      await analyzePalm();
    } catch (e) {
      // Close loader on error
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }
      scanError.value = ErrorFormatter.formatError(e);
      isScanning.value = false;
    } finally {
      isScanning.value = false;
    }
  }

  // Analyze palm using API
  Future<void> analyzePalm() async {
    try {
      final palmImage = selectedPalmImage.value!;

      // Prepare form fields
      final fields = <String, String>{};

      // Add name if available
      if (nameController.text.trim().isNotEmpty) {
        fields['name'] = nameController.text.trim();
      }

      // Add date of birth if available (format: YYYY-MM-DD)
      if (_selectedDate != null) {
        fields['dateOfBirth'] = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      }

      // Add time of birth if available (format: HH:MM)
      if (selectedHour.value > 0 && selectedMinute.value >= 0) {
        // Convert to 24-hour format
        int hour24 = selectedHour.value;
        if (selectedAmPm.value == 'PM' && hour24 != 12) {
          hour24 += 12;
        } else if (selectedAmPm.value == 'AM' && hour24 == 12) {
          hour24 = 0;
        }
        fields['timeOfBirth'] =
            '${hour24.toString().padLeft(2, '0')}:${selectedMinute.value.toString().padLeft(2, '0')}';
      }

      // Add gender if available (convert to lowercase)
      if (selectedGender.value.isNotEmpty) {
        fields['gender'] = selectedGender.value.toLowerCase();
      }

      // Add language if available (get language code)
      if (_selectedLanguageModel != null &&
          _selectedLanguageModel!.code.isNotEmpty) {
        fields['language'] = _selectedLanguageModel!.code.toLowerCase();
      } else if (selectedLanguage.value.isNotEmpty) {
        // Fallback to language name if code not available
        fields['language'] = selectedLanguage.value.toLowerCase();
      }

      final response = await _apiRepository.postDataByFormData(
        uri: EndPoints.palmistryAnalyze,
        fields: fields,
        files: {'palmImage': palmImage},
        timeout: const Duration(minutes: 5),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          if (response.body.isEmpty) {
            // Close loader on error
            if (Get.isDialogOpen == true) {
              try {
                Get.back();
              } catch (e) {
                // Ignore error
              }
            }
            scanError.value = 'Empty response from server. Please try again.';
            isScanning.value = false;
            return;
          }

          final responseBody = json.decode(response.body);

          // Parse response using new structure
          final palmReadingResponse = PalmReadingResponse.fromJson(
            responseBody,
          );

          if (!palmReadingResponse.success ||
              palmReadingResponse.data == null) {
            // Close loader on error
            if (Get.isDialogOpen == true) {
              try {
                Get.back();
              } catch (e) {
                // Ignore error
              }
            }
            scanError.value = palmReadingResponse.message.isNotEmpty
                ? palmReadingResponse.message
                : 'Palm is not clearly visible. Please try with a clearer image.';
            isScanning.value = false;
            return;
          }

          // Store reading data
          palmReadingData.value = palmReadingResponse.data;
          currentReadingId.value = palmReadingResponse.data!.readingId ?? '';

          // Close loader before navigation
          if (Get.isDialogOpen == true) {
            try {
              Get.back();
            } catch (e) {
              // Ignore error
            }
          }

          // Check if hand type is UNKNOWN or status is FAILED
          final handType = palmReadingResponse.data!.handType.toUpperCase();
          final status = palmReadingResponse.data!.status?.toUpperCase() ?? '';
          final hasOnlyOverall =
              palmReadingResponse.data!.readings.isNotEmpty &&
              palmReadingResponse.data!.readings.first.category.toUpperCase() ==
                  'OVERALL';

          if (handType == 'UNKNOWN' || status == 'FAILED' || hasOnlyOverall) {
            // Still navigate to results, but it will show rescan option
            isScanning.value = false;
            scanError.value = '';
            Get.offNamed(AppRoutes.palmReadingResults);
          } else {
            isScanning.value = false;
            scanError.value = '';
            // Navigate to results screen
            Get.offNamed(AppRoutes.palmReadingResults);
          }
        } catch (e) {
          // Close loader on error
          if (Get.isDialogOpen == true) {
            try {
              Get.back();
            } catch (e) {
              // Ignore error
            }
          }
          scanError.value = ErrorFormatter.formatError(e);
          isScanning.value = false;
        }
      } else {
        // Close loader on error
        if (Get.isDialogOpen == true) {
          try {
            Get.back();
          } catch (e) {
            // Ignore error
          }
        }
        try {
          if (response.body.isNotEmpty) {
            final responseBody = json.decode(response.body);
            final serverMessage = responseBody['message']?.toString() ?? '';
            scanError.value = serverMessage.isNotEmpty
                ? serverMessage
                : ErrorFormatter.formatError(
                    'Failed to analyze palm (Status: ${response.statusCode})',
                  );
          } else {
            scanError.value = ErrorFormatter.formatError(
              'Failed to analyze palm (Status: ${response.statusCode})',
            );
          }
        } catch (e) {
          scanError.value = ErrorFormatter.formatError(
            'Failed to analyze palm (Status: ${response.statusCode})',
          );
        }
        isScanning.value = false;
      }
    } catch (e) {
      // Close loader on error
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }
      scanError.value = ErrorFormatter.formatError(e);
      isScanning.value = false;
    }
  }

  // Get prediction - navigate to detail view
  void onGetPrediction() {
    if (palmReadingData.value != null) {
      UserMainController.pushInCurrentTab(AppRoutes.palmReadingDetail);
    } else {
      Get.snackbar('Error', 'No reading data available');
    }
  }

  // Get reading by ID
  Future<PalmReadingData?> getReadingById(String readingId) async {
    try {
      isLoadingReading.value = true;
      readingError.value = '';

      final response = await _apiRepository.getApi(
        EndPoints.palmistryGetById(readingId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        final palmReadingResponse = PalmReadingResponse.fromJson(responseBody);

        if (palmReadingResponse.success && palmReadingResponse.data != null) {
          palmReadingData.value = palmReadingResponse.data;
          currentReadingId.value = readingId;
          isLoadingReading.value = false;
          return palmReadingResponse.data;
        } else {
          readingError.value = palmReadingResponse.message;
          isLoadingReading.value = false;
          return null;
        }
      } else {
        readingError.value = 'Failed to load reading';
        isLoadingReading.value = false;
        return null;
      }
    } catch (e) {
      readingError.value = 'Error loading reading: $e';
      isLoadingReading.value = false;
      return null;
    }
  }

  // Delete reading by ID
  Future<bool> deleteReading(String readingId) async {
    try {
      final response = await _apiRepository.deleteReq(
        EndPoints.palmistryDeleteById(readingId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        if (responseBody['success'] == true) {
          // Clear current reading if it's the one being deleted
          if (currentReadingId.value == readingId) {
            palmReadingData.value = null;
            currentReadingId.value = '';
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Load reading history
  Future<void> loadReadingHistory() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.palmistryHistory);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle history response
        // TODO: Parse and store history
      }
    } catch (e) {
      // Handle error
    }
  }

  // Get statistics
  Future<void> loadStatistics() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.palmistryStats);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle stats response
        // TODO: Parse and store stats
      }
    } catch (e) {
      // Handle error
    }
  }
}
