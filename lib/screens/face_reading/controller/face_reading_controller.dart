import 'dart:io';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/screens/face_reading/service/face_reading_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceReadingController extends GetxController {
  final FaceReadingService _faceReadingService = FaceReadingService();
  final UserProfileService _userProfileService = UserProfileService();

  // Form fields (all optional)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final RxString dateOfBirth = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString selectedLanguage = ''.obs;
  DateTime? _selectedDate;
  AppLanguageModel? _selectedLanguageModel;

  // State variables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isDetecting = false.obs;
  final RxBool isScanning = true.obs;
  final Rx<Face?> detectedFace = Rx<Face?>(null);
  final RxList<Offset> meshPoints = <Offset>[].obs;
  final RxString errorMessage = RxString('');
  final RxBool isAnalyzing = false.obs;
  final Rx<FaceReadingData?> analysisResult = Rx<FaceReadingData?>(null);

  /// Null when ML Kit / Play services cannot initialize on this device.
  FaceDetector? _faceDetector;

  @override
  void onInit() {
    super.onInit();
    _initializeFaceDetector();
    _setDefaultLanguage();
    _loadUserProfileData();
  }

  Future<void> _setDefaultLanguage() async {
    try {
      final languages = await LanguageModelService.getLanguages();
      if (languages.isNotEmpty) {
        _selectedLanguageModel = languages[0];
        selectedLanguage.value = languages[0].nameEn;
      }
    } catch (e) {
      debugPrint('Error loading default language: $e');
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
        if (fullName != null && fullName.isNotEmpty && nameController.text.isEmpty) {
          nameController.text = fullName;
        }
        final gender = profile.personalInfo!.gender;
        if (gender != null && gender.isNotEmpty && selectedGender.value.isEmpty) {
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
      // Auto-calculate age
      final age = DateTime.now().year - pickedDate.year;
      ageController.text = age.toString();
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
                    final isSelected = _selectedLanguageModel?.code == language.code;
                    return ListTile(
                      title: AutoTranslateText(
                        language.nameEn,
                        style: TextStyle(
                          color: isSelected ? "#F38B3B".toColor() : const Color(0xFF5F2221),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? Icon(Icons.check, color: "#F38B3B".toColor()) : null,
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
      debugPrint('Error showing language picker: $e');
    }
  }

  void showGenderPicker() {
    final context = Get.context;
    if (context == null) return;

    final genders = ['Male', 'Female', 'Others'];

    showModalBottomSheet(
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
              'Select Gender',
              style: TextStyle(
                color: const Color(0xFF5F2221),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
            const SizedBox(height: 16),
            ...genders.map((gender) {
              final isSelected = selectedGender.value == gender;
              return ListTile(
                title: AutoTranslateText(
                  gender,
                  style: TextStyle(
                    color: isSelected ? "#F38B3B".toColor() : const Color(0xFF5F2221),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected ? Icon(Icons.check, color: "#F38B3B".toColor()) : null,
                onTap: () {
                  selectedGender.value = gender;
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void continueToUpload() {
    UserMainController.pushInCurrentTab(AppRoutes.faceReadingUpload);
  }

  void _initializeFaceDetector() {
    try {
      final options = FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: false,
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.accurate,
      );
      _faceDetector = FaceDetector(options: options);
    } catch (e, st) {
      debugPrint('Face detector init failed: $e\n$st');
      _faceDetector = null;
      errorMessage.value =
          'Face scanning needs Google Play services. Please update Play services or try again later.';
    }
  }

  /// Set selected image and start detection
  void setImage(File image) {
    selectedImage.value = image;
    errorMessage.value = '';
    detectedFace.value = null;
    meshPoints.clear();
    // Don't start scanning immediately - wait for image to load
    isScanning.value = false;
    isDetecting.value = false;
    _detectFace(image);
  }

  /// Detect face using ML Kit
  Future<void> _detectFace(File imageFile) async {
    final detector = _faceDetector;
    if (detector == null) {
      errorMessage.value =
          'Face scanning is unavailable on this device. Check Google Play services.';
      isScanning.value = false;
      isDetecting.value = false;
      return;
    }
    try {
      isDetecting.value = true;
      errorMessage.value = '';

      // Read image
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Detect faces
      final List<Face> faces = await detector.processImage(inputImage);

      if (faces.isEmpty) {
        errorMessage.value = 'No face detected. Please try another photo.';
        isScanning.value = false;
        return;
      }

      // Use the first detected face
      final face = faces.first;
      detectedFace.value = face;

      // Extract mesh points from contours
      await _extractMeshPoints(face, inputImage);

      // Don't stop scanning here - let the view handle the 2-second timer
    } catch (e) {
      errorMessage.value = ErrorFormatter.formatError(e);
      isScanning.value = false;
    } finally {
      isDetecting.value = false;
    }
  }

  /// Extract mesh points dynamically from ML Kit contours
  Future<void> _extractMeshPoints(Face face, InputImage inputImage) async {
    final List<Offset> points = [];

    // Get image dimensions from metadata
    final imageSize = inputImage.metadata?.size;
    if (imageSize == null) {
      return;
    }

    // Extract points from all available contours
    final contourTypes = [
      FaceContourType.face,
      FaceContourType.leftEye,
      FaceContourType.rightEye,
      FaceContourType.leftEyebrowTop,
      FaceContourType.leftEyebrowBottom,
      FaceContourType.rightEyebrowTop,
      FaceContourType.rightEyebrowBottom,
      FaceContourType.noseBridge,
      FaceContourType.noseBottom,
      FaceContourType.upperLipTop,
      FaceContourType.upperLipBottom,
      FaceContourType.lowerLipTop,
      FaceContourType.lowerLipBottom,
    ];

    for (final contourType in contourTypes) {
      final contour = face.contours[contourType];
      if (contour != null) {
        for (final point in contour.points) {
          // Convert ML Kit coordinates to Flutter coordinates
          final x = point.x.toDouble();
          final y = point.y.toDouble();
          points.add(Offset(x, y));
        }
      }
    }

    meshPoints.value = points;
  }

  /// Analyze face reading via API
  Future<void> analyzeFaceReading({
    String? nameOverride,
    String? dobOverride,
    String? genderOverride,
    int? ageOverride,
    String? languageOverride,
  }) async {
    final allowed = await LoginGuard.ensureLoggedIn(
      message: 'Please login to analyze your face reading.',
    );
    if (!allowed) return;

    // Check balance
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      final canProceed = await pricingCtrl.ensureHasSufficientBalance(
        'face_reading',
        showPopup: true,
      );
      if (!canProceed) return;
    }

    if (selectedImage.value == null) {
      // Close loader if open
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }
      Get.snackbar(
        'Error',
        'No image selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isAnalyzing.value = true;
      errorMessage.value = '';

      final storedName = nameController.text.trim();
      final storedDob = dateOfBirth.value.trim();
      final storedGender = selectedGender.value.trim();
      final storedAgeText = ageController.text.trim();
      final storedAge = storedAgeText.isNotEmpty ? int.tryParse(storedAgeText) : null;
      final storedLanguage = selectedLanguage.value.trim();

      final result = await _faceReadingService.analyzeFaceReading(
        faceImage: selectedImage.value!,
        name: (nameOverride?.isNotEmpty == true) ? nameOverride : (storedName.isNotEmpty ? storedName : null),
        dateOfBirth: (dobOverride?.isNotEmpty == true) ? dobOverride : (storedDob.isNotEmpty ? storedDob : null),
        gender: (genderOverride?.isNotEmpty == true) ? genderOverride : (storedGender.isNotEmpty ? storedGender.toLowerCase() : null),
        age: ageOverride ?? storedAge,
        language: languageOverride ?? (storedLanguage.isNotEmpty ? storedLanguage.toLowerCase() : 'english'),
      );

      analysisResult.value = result;

      // Close loader before navigation
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }

      // Navigate to results screen
      UserMainController.pushInCurrentTab(AppRoutes.faceReadingResults, arguments: {'result': result});
    } catch (e) {
      // Close loader on error
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }

      final userFriendlyError = ErrorFormatter.formatError(e);
      errorMessage.value = userFriendlyError;
      Get.snackbar(
        'Error',
        userFriendlyError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isAnalyzing.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    _faceDetector?.close();
    super.onClose();
  }
}
