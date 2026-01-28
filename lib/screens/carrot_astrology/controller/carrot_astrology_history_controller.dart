import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/carrot_astrology_model.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/service/carrot_astrology_service.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarrotAstrologyHistoryController extends GetxController {
  final CarrotAstrologyService _carrotAstrologyService = CarrotAstrologyService();
  
  // State variables
  final RxList<CarrotAstrologyData> historyList = <CarrotAstrologyData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = RxString('');
  
  // Pagination
  final RxInt _currentPage = 1.obs;
  final RxInt _totalPages = 1.obs;
  final RxBool _hasMore = false.obs;
  final RxInt _totalItems = 0.obs;
  
  // Filters
  final RxString selectedStatus = ''.obs;
  final RxString selectedZodiacSign = ''.obs;
  
  // Zodiac signs
  final List<String> zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];
  
  // Status options
  final List<String> statusOptions = ['', 'PROCESSING', 'COMPLETED', 'FAILED'];
  
  String get statusDisplayText {
    switch (selectedStatus.value) {
      case 'PROCESSING':
        return 'Processing';
      case 'COMPLETED':
        return 'Completed';
      case 'FAILED':
        return 'Failed';
      default:
        return 'All Status';
    }
  }
  
  String get zodiacSignDisplayText {
    return selectedZodiacSign.value.isEmpty ? 'All Zodiac Signs' : selectedZodiacSign.value;
  }
  
  bool get hasMore => _hasMore.value;
  int get totalItems => _totalItems.value;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  
  @override
  void onInit() {
    super.onInit();
    loadHistory(reset: true);
  }
  
  Future<void> loadHistory({bool reset = false}) async {
    if (reset) {
      _currentPage.value = 1;
      historyList.clear();
      _hasMore.value = false;
    }
    
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _carrotAstrologyService.getCarrotAstrologyHistory(
        page: _currentPage.value,
        limit: 10,
        status: selectedStatus.value.isEmpty ? null : selectedStatus.value,
        zodiacSign: selectedZodiacSign.value.isEmpty ? null : selectedZodiacSign.value,
      );
      
      if (reset) {
        historyList.value = response.data;
      } else {
        historyList.addAll(response.data);
      }
      
      if (response.pagination != null) {
        _currentPage.value = response.pagination!.currentPage;
        _totalPages.value = response.pagination!.totalPages;
        _totalItems.value = response.pagination!.totalReadings;
        _hasMore.value = response.pagination!.hasNextPage;
      } else {
        _hasMore.value = false;
      }
    } catch (e) {
      errorMessage.value = ErrorFormatter.formatError(e);
      if (reset) {
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMore() async {
    if (!isLoading.value && _hasMore.value) {
      _currentPage.value++;
      await loadHistory();
    }
  }
  
  void onStatusFilterChanged(String? status) {
    selectedStatus.value = status ?? '';
    loadHistory(reset: true);
  }
  
  void onZodiacSignFilterChanged(String? zodiacSign) {
    selectedZodiacSign.value = zodiacSign ?? '';
    loadHistory(reset: true);
  }
  
  void clearFilters() {
    selectedStatus.value = '';
    selectedZodiacSign.value = '';
    loadHistory(reset: true);
  }
  
  Future<void> viewReading(String readingId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      final reading = await _carrotAstrologyService.getCarrotAstrologyById(readingId);
      
      Get.back(); // Close loading dialog
      
      Get.toNamed(
        AppRoutes.carrotAstrologyResults,
        arguments: {'result': reading},
      );
    } catch (e) {
      Get.back(); // Close loading dialog if still open
      Get.snackbar(
        'Error',
        ErrorFormatter.formatError(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
  
  String getZodiacSymbol(String sign) {
    final symbols = {
      'Aries': '♈',
      'Taurus': '♉',
      'Gemini': '♊',
      'Cancer': '♋',
      'Leo': '♌',
      'Virgo': '♍',
      'Libra': '♎',
      'Scorpio': '♏',
      'Sagittarius': '♐',
      'Capricorn': '♑',
      'Aquarius': '♒',
      'Pisces': '♓',
    };
    return symbols[sign] ?? '♍';
  }
}

