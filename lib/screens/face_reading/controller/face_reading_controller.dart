import 'dart:io';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/face_reading_model.dart';
import 'package:astrobharataiuser/screens/face_reading/service/face_reading_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceReadingController extends GetxController {
  final FaceReadingService _faceReadingService = FaceReadingService();

  // State variables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isDetecting = false.obs;
  final RxBool isScanning = true.obs;
  final Rx<Face?> detectedFace = Rx<Face?>(null);
  final RxList<Offset> meshPoints = <Offset>[].obs;
  final RxString errorMessage = RxString('');
  final RxBool isAnalyzing = false.obs;
  final Rx<FaceReadingData?> analysisResult = Rx<FaceReadingData?>(null);

  // Face detector
  late FaceDetector _faceDetector;

  @override
  void onInit() {
    super.onInit();
    _initializeFaceDetector();
  }

  void _initializeFaceDetector() {
    final options = FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: false,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.accurate,
    );
    _faceDetector = FaceDetector(options: options);
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
    try {
      isDetecting.value = true;
      errorMessage.value = '';

      // Read image
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Detect faces
      final List<Face> faces = await _faceDetector.processImage(inputImage);

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
    String? name,
    String? dateOfBirth,
    String? gender,
    int? age,
    String? language,
  }) async {
    final allowed = await LoginGuard.ensureLoggedIn(
      message: 'Please login to analyze your face reading.',
    );
    if (!allowed) return;

    // Check balance
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('face_reading')) {
        pricingCtrl.showInsufficientBalancePopup('face_reading');
        return;
      }
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

      final result = await _faceReadingService.analyzeFaceReading(
        faceImage: selectedImage.value!,
        name: name,
        dateOfBirth: dateOfBirth,
        gender: gender,
        age: age,
        language: language ?? 'english',
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
    _faceDetector.close();
    super.onClose();
  }
}
