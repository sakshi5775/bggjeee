import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/ramal_shastra_model.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/service/ramal_shastra_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RamalShastraController extends GetxController {
  final RamalShastraService _service = RamalShastraService();

  // Form state
  final RxString question = ''.obs;
  final RxString selectedCategory = 'CAREER'.obs;
  final RxString selectedLanguage = 'english'.obs;
  final RxString name = ''.obs;
  final RxString dateOfBirth = ''.obs;
  final RxString selectedMethod = ''.obs; // 'dice', 'cards', 'dots'

  // Generated points
  final RxList<int> generatedPoints = <int>[].obs;

  // Analysis state
  final RxBool isAnalyzing = false.obs;
  final Rx<RamalShastraData?> analysisResult = Rx<RamalShastraData?>(null);
  final RxString errorMessage = RxString('');

  // History state
  final RxList<RamalShastraData> historyReadings = <RamalShastraData>[].obs;
  final RxBool isLoadingHistory = false.obs;
  final RxInt currentPage = 1.obs;
  final Rx<RamalPagination?> pagination = Rx<RamalPagination?>(null);

  // Stats state
  final Rx<RamalStatsData?> statsData = Rx<RamalStatsData?>(null);
  final RxBool isLoadingStats = false.obs;

  // Casting state
  final RxList<int> diceResults = <int>[].obs;
  final RxList<int> cardResults = <int>[].obs;
  final RxList<int> dotResults = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setQuestion(String value) {
    question.value = value;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setLanguage(String language) {
    selectedLanguage.value = language;
  }

  void setName(String value) {
    name.value = value;
  }

  void setDateOfBirth(String value) {
    dateOfBirth.value = value;
  }

  void setCastingMethod(String method) {
    selectedMethod.value = method;
  }

  /// Generate 16 points from dice (4 rounds × 4 dice)
  void generatePointsFromDice(List<int> diceValues) {
    generatedPoints.clear();
    for (int value in diceValues) {
      generatedPoints.add(value % 2); // Odd = 1, Even = 0
    }
    diceResults.assignAll(diceValues);
  }

  /// Generate 16 points from cards (red = 1, black = 0)
  void generatePointsFromCards(List<bool> isRedCards) {
    generatedPoints.clear();
    for (bool isRed in isRedCards) {
      generatedPoints.add(isRed ? 1 : 0);
    }
    cardResults.assignAll(isRedCards.map((e) => e ? 1 : 0).toList());
  }

  /// Generate 16 points from dots (odd taps = 1, even taps = 0)
  void generatePointsFromDots(List<int> tapCounts) {
    generatedPoints.clear();
    for (int count in tapCounts) {
      generatedPoints.add(count % 2); // Odd = 1, Even = 0
    }
    dotResults.assignAll(tapCounts);
  }

  /// Analyze Ramal Shastra
  Future<void> analyzeRamal() async {
    if (question.value.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a question',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (generatedPoints.length != 16) {
      Get.snackbar(
        'Error',
        'Please complete the casting to generate 16 points',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isAnalyzing.value = true;
      errorMessage.value = '';

      final result = await _service.analyzeRamalShastra(
        question: question.value.trim(),
        points: generatedPoints.toList(),
        category: selectedCategory.value,
        language: selectedLanguage.value,
        name: name.value.isNotEmpty ? name.value : null,
        dateOfBirth: dateOfBirth.value.isNotEmpty ? dateOfBirth.value : null,
      );

      analysisResult.value = result;
      isAnalyzing.value = false;

      // Close any open dialogs (like loading dialog)
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Navigate to results
      Get.offAllNamed(
        AppRoutes.ramalShastraResults,
        arguments: {'result': result},
      );
    } catch (e) {
      isAnalyzing.value = false;
      errorMessage.value = e.toString();
      
      // Close loading dialog if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      
      // Show error message
      String errorMsg = e.toString();
      if (errorMsg.contains('Exception:')) {
        errorMsg = errorMsg.replaceFirst('Exception: ', '');
      }
      
      Get.snackbar(
        'Analysis Failed',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      
      // Re-throw to allow caller to handle if needed
      rethrow;
    }
  }

  /// Load history
  Future<void> loadHistory({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        historyReadings.clear();
      }

      isLoadingHistory.value = true;
      final response = await _service.getRamalHistory(
        page: currentPage.value,
        limit: 10,
      );

      // Handle both cases: data.readings or data as list directly
      List<RamalShastraData>? readings;
      if (response.data?.readings != null && response.data!.readings!.isNotEmpty) {
        readings = response.data!.readings;
      }
      
      if (readings != null && readings.isNotEmpty) {
        if (refresh || currentPage.value == 1) {
          historyReadings.assignAll(readings);
        } else {
          historyReadings.addAll(readings);
        }
      } else if (refresh || currentPage.value == 1) {
        historyReadings.clear();
      }
      
      pagination.value = response.pagination;
      isLoadingHistory.value = false;
    } catch (e) {
      isLoadingHistory.value = false;
      Get.snackbar(
        'Error',
        'Failed to load history: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Load more history
  Future<void> loadMoreHistory() async {
    if (!isLoadingHistory.value && 
        pagination.value != null && 
        pagination.value!.hasNextPage == true) {
      currentPage.value++;
      await loadHistory();
    }
  }

  /// Delete reading
  Future<void> deleteReading(String readingId, int index) async {
    try {
      final success = await _service.deleteRamal(readingId);
      if (success) {
        historyReadings.removeAt(index);
        Get.snackbar(
          'Success',
          'Reading deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete reading',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete reading: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Load stats
  Future<void> loadStats() async {
    try {
      isLoadingStats.value = true;
      final stats = await _service.getRamalStats();
      statsData.value = stats;
      isLoadingStats.value = false;
    } catch (e) {
      isLoadingStats.value = false;
      Get.snackbar(
        'Error',
        'Failed to load statistics: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Reset form
  void resetForm() {
    question.value = '';
    selectedCategory.value = 'CAREER';
    selectedLanguage.value = 'english';
    name.value = '';
    dateOfBirth.value = '';
    selectedMethod.value = '';
    generatedPoints.clear();
    diceResults.clear();
    cardResults.clear();
    dotResults.clear();
    errorMessage.value = '';
  }

  /// Regenerate points (go back to casting method selection)
  void regeneratePoints() {
    generatedPoints.clear();
    diceResults.clear();
    cardResults.clear();
    dotResults.clear();
  }
}

