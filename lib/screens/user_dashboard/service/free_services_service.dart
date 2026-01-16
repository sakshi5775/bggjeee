import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FreeServicesService {
  final ApiRepository _apiRepository = Get.find();

  Future<Map<String, dynamic>?> getFreeServicesStatus() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.freeServicesStatus);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Map<String, dynamic>.from(response.body['data'] ?? {});
      }
    } catch (e) {
      debugPrint('Error fetching free services status: $e');
    }
    return null;
  }

  /// Check if user has any free services available (first time login)
  bool hasFreeServicesAvailable(Map<String, dynamic>? data) {
    if (data == null) return false;
    
    final freeServices = data['freeServices'] as Map<String, dynamic>?;
    if (freeServices == null) return false;
    
    final chat = freeServices['chat'] as Map<String, dynamic>?;
    final voiceCall = freeServices['voiceCall'] as Map<String, dynamic>?;
    
    final chatAvailable = chat?['isAvailable'] as bool? ?? false;
    final voiceCallAvailable = voiceCall?['isAvailable'] as bool? ?? false;
    
    return chatAvailable || voiceCallAvailable;
  }
}

