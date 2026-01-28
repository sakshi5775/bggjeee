import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/carrot_astrology_model.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/service/carrot_astrology_service.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarrotAstrologyController extends GetxController {
  final CarrotAstrologyService _carrotAstrologyService = CarrotAstrologyService();
  
  // State variables
  final RxString selectedZodiacSign = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxString errorMessage = RxString('');
  final Rx<CarrotAstrologyData?> analysisResult = Rx<CarrotAstrologyData?>(null);

  final List<String> zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];

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

  void setSelectedZodiacSign(String sign) {
    selectedZodiacSign.value = sign;
  }

  Future<void> analyzeCarrotAstrology() async {
    try {
      isAnalyzing.value = true;
      errorMessage.value = '';
      analysisResult.value = null;

      final result = await _carrotAstrologyService.analyzeCarrotAstrology(
        zodiacSign: selectedZodiacSign.value,
      );

      analysisResult.value = result;
      
      // Navigate to results page
      Get.toNamed(
        AppRoutes.carrotAstrologyResults,
        arguments: {'result': result},
      );
    } catch (e) {
      errorMessage.value = ErrorFormatter.formatError(e);
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isAnalyzing.value = false;
    }
  }
}

