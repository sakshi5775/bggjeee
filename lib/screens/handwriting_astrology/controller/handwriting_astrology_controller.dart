import 'dart:io';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/handwriting_astrology_model.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/service/handwriting_astrology_service.dart';
import 'package:astrobharataiuser/screens/handwriting_astrology/widgets/handwriting_loading_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HandwritingAstrologyController extends GetxController {
  final HandwritingAstrologyService _handwritingService =
      HandwritingAstrologyService();

  // State variables
  final RxList<File> selectedImages = <File>[].obs;
  final RxString selectedLanguage = 'english'.obs;
  final RxString selectedGender = 'male'.obs;
  final RxString name = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString additionalNotes = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxString errorMessage = RxString('');
  final Rx<HandwritingData?> analysisResult = Rx<HandwritingData?>(null);

  /// Add image to selected images
  void addImage(File image) {
    selectedImages.add(image);
  }

  /// Remove image from selected images
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  /// Clear all selected images
  void clearImages() {
    selectedImages.clear();
  }

  /// Set language
  void setLanguage(String language) {
    selectedLanguage.value = language;
  }

  /// Set gender
  void setGender(String gender) {
    selectedGender.value = gender;
  }

  /// Set name
  void setName(String nameValue) {
    name.value = nameValue;
  }

  /// Set date of birth
  void setDateOfBirth(String dob) {
    dateOfBirth.value = dob;
  }

  /// Set additional notes
  void setAdditionalNotes(String notes) {
    additionalNotes.value = notes;
  }

  /// Analyze handwriting via API
  Future<void> analyzeHandwriting() async {
    if (selectedImages.isEmpty) {
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
        'Please select at least one handwriting image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Check balance
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('handwriting')) {
        pricingCtrl.showInsufficientBalancePopup('handwriting');
        return;
      }
    }

    try {
      isAnalyzing.value = true;
      errorMessage.value = '';

      // Show loading dialog with attractive animation
      if (Get.isDialogOpen == false) {
        Get.dialog(
          const HandwritingLoadingWidget(message: 'Analyzing Handwriting...'),
          barrierDismissible: false,
        );
      }

      final result = await _handwritingService.analyzeHandwriting(
        handwritingImages: selectedImages.toList(),
        name: name.value.isNotEmpty ? name.value : null,
        dateOfBirth: dateOfBirth.value.isNotEmpty ? dateOfBirth.value : null,
        gender: selectedGender.value,
        language: selectedLanguage.value,
        additionalNotes: additionalNotes.value.isNotEmpty
            ? additionalNotes.value
            : null,
        timeout: const Duration(minutes: 5),
      );

      // Close loading dialog before navigation
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (e) {
          // Ignore error
        }
      }

      analysisResult.value = result;

      // Navigate to results screen
      Get.toNamed(
        AppRoutes.handwritingAstrologyResults,
        arguments: {'result': result},
      );
    } catch (e) {
      // Close loading dialog if still open
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

  /// Reset form
  void resetForm() {
    selectedImages.clear();
    selectedLanguage.value = 'english';
    selectedGender.value = 'male';
    name.value = '';
    dateOfBirth.value = '';
    additionalNotes.value = '';
    errorMessage.value = '';
    analysisResult.value = null;
  }
}
