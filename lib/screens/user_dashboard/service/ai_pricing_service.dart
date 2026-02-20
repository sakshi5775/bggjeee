import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/ai_pricing_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiPricingService {
  final ApiRepository _apiRepository = Get.find();

  Future<AiPricingResponse?> getAiPricing() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.aiPricing);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return AiPricingResponse.fromJson(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching AI pricing: $e');
    }
    return null;
  }
}
