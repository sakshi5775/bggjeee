import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/numerology/service/numerology_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoShuGridResultController extends BaseController {
  final NumerologyService _numerologyService = NumerologyService();
  // Grid data - Fixed Lo Shu Grid layout
  // 4 | 9 | 2
  // 3 | 5 | 7
  // 8 | 1 | 6
  final RxMap<int, String?> gridData = <int, String?>{
    4: null,
    9: null,
    2: null,
    3: null,
    5: null,
    7: null,
    8: null,
    1: null,
    6: null,
  }.obs;

  // API response data
  final radicalNumber = 0.obs;
  final destinyNumber = 0.obs;
  final kuaNumber = 0.obs;
  final psychicNumber = 0.obs;
  final lifePathNumber = 0.obs;
  final luckFactor = 0.obs;
  final missingNumbers = ''.obs;
  final availableNumbers = ''.obs;
  final planePercentages = <String, int>{}.obs;
  final planeNumbers = <String, String>{}.obs;
  final realDigits = <int>[].obs;

  // Form data for API calls
  String _date = '';
  String _gender = '';
  String _lang = 'en';

  // Plane expansion state
  final expandedPlanes = <String, bool>{}.obs;
  final planeDetails = <String, Map<String, dynamic>>{}.obs;
  final loadingPlanes = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    final arguments = Get.arguments;
    if (arguments == null) return;

    // Safely convert to Map
    Map<String, dynamic> data;
    if (arguments is Map) {
      data = Map<String, dynamic>.from(arguments);
    } else {
      return;
    }

    // Load form data
    final formData = data['_formData'];
    if (formData != null && formData is Map) {
      final formDataMap = Map<String, dynamic>.from(formData);
      _date = formDataMap['date']?.toString() ?? '';
      _gender = formDataMap['gender']?.toString() ?? '';
      _lang = formDataMap['lang']?.toString() ?? 'en';
    }

    // Load grid data
    final loShuGrid = data['loShuGrid'];
    Map<String, dynamic>? loShuGridMap;
    if (loShuGrid != null && loShuGrid is Map) {
      loShuGridMap = Map<String, dynamic>.from(loShuGrid);
    }
    if (loShuGridMap != null) {
      // Map API response to fixed grid layout
      // API returns: "1", "2", "3", "4", "5", "6", "7", "8", "9"
      // Fixed layout: 4|9|2, 3|5|7, 8|1|6
      gridData[4] = loShuGridMap['4']?.toString();
      gridData[9] = loShuGridMap['9']?.toString();
      gridData[2] = loShuGridMap['2']?.toString();
      gridData[3] = loShuGridMap['3']?.toString();
      gridData[5] = loShuGridMap['5']?.toString();
      gridData[7] = loShuGridMap['7']?.toString();
      gridData[8] = loShuGridMap['8']?.toString();
      gridData[1] = loShuGridMap['1']?.toString();
      gridData[6] = loShuGridMap['6']?.toString();
      
      // Convert "null" strings to actual null
      gridData.forEach((key, value) {
        if (value == 'null' || value == null || value.isEmpty) {
          gridData[key] = null;
        }
      });
    }

    // Load numerology numbers
    radicalNumber.value = _safeInt(data['radicalNumber']) ?? 0;
    destinyNumber.value = _safeInt(data['destinyNumber']) ?? 0;
    kuaNumber.value = _safeInt(data['kuaNumber']) ?? 0;
    psychicNumber.value = _safeInt(data['psychicNumber']) ?? 0;
    lifePathNumber.value = _safeInt(data['lifePathNumber']) ?? 0;
    luckFactor.value = _safeInt(data['luckFactor']) ?? 0;

    // Load missing and available numbers
    missingNumbers.value = data['missingNumbers']?.toString() ?? '';
    availableNumbers.value = data['availableNumbers']?.toString() ?? '';

    // Load plane percentages
    final planePercentagesData = data['planePercentages'];
    if (planePercentagesData != null && planePercentagesData is Map) {
      final planePercentagesMap = Map<String, dynamic>.from(planePercentagesData);
      planePercentages.clear();
      planePercentagesMap.forEach((key, value) {
        planePercentages[key] = _safeInt(value) ?? 0;
      });
    }

    // Load plane numbers
    final planeNumbersData = data['planeNumbers'];
    if (planeNumbersData != null && planeNumbersData is Map) {
      final planeNumbersMap = Map<String, dynamic>.from(planeNumbersData);
      planeNumbers.clear();
      planeNumbersMap.forEach((key, value) {
        planeNumbers[key] = value?.toString() ?? '';
      });
    }

    // Load real digits
    final realDigitsData = data['realDigits'];
    if (realDigitsData != null && realDigitsData is List) {
      realDigits.clear();
      realDigits.addAll(realDigitsData.map((e) => _safeInt(e) ?? 0).where((e) => e != 0));
    }
  }

  // Get repeated numbers (numbers appearing more than once, e.g., "22")
  List<String> getRepeatedNumbers() {
    final List<String> repeated = [];
    final Map<String, int> countMap = {};

    gridData.values.forEach((value) {
      if (value != null && value.isNotEmpty) {
        // Check if it's a master number (22, 33, etc.)
        if (value.length > 1) {
          repeated.add(value);
        } else {
          countMap[value] = (countMap[value] ?? 0) + 1;
        }
      }
    });

    // Add numbers that appear more than once
    countMap.forEach((number, count) {
      if (count > 1) {
        repeated.add(number);
      }
    });

    return repeated;
  }

  // Get plane strength category
  String getPlaneStrength(int percentage) {
    if (percentage >= 71) return 'Strong';
    if (percentage >= 41) return 'Moderate';
    return 'Weak';
  }

  // Get plane strength color
  Color getPlaneStrengthColor(int percentage) {
    if (percentage >= 71) return Colors.green;
    if (percentage >= 41) return Colors.orange;
    return Colors.red;
  }

  // Toggle plane expansion
  Future<void> togglePlane(String planeKey) async {
    final isExpanded = expandedPlanes[planeKey] ?? false;
    expandedPlanes[planeKey] = !isExpanded;

    // If expanding and details not loaded, fetch them
    if (!isExpanded && !planeDetails.containsKey(planeKey)) {
      await fetchPlaneDetails(planeKey);
    }
  }

  // Fetch plane details from API
  Future<void> fetchPlaneDetails(String planeKey) async {
    if (_date.isEmpty || _gender.isEmpty) {
      return;
    }

    loadingPlanes[planeKey] = true;

    try {
      final response = await _numerologyService.getPlaneDetails(
        date: _date,
        gender: _gender,
        lang: _lang,
      );

      if (response != null && response['response'] != null) {
        final responseData = response['response'] as Map<String, dynamic>?;
        
        // Map plane key (handle outlook/action - they are the same)
        String apiKey = planeKey;
        if (planeKey == 'outlook') {
          // API uses 'action' but we store it as 'outlook' for consistency
          apiKey = 'action';
        }

        if (responseData?.containsKey(apiKey) == true) {
          final planeData = responseData![apiKey] as Map<String, dynamic>?;
          if (planeData != null) {
            planeDetails[planeKey] = planeData;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching plane details for $planeKey: $e');
    } finally {
      loadingPlanes[planeKey] = false;
    }
  }

  // Get plane details for a specific plane
  Map<String, dynamic>? getPlaneDetail(String planeKey) {
    return planeDetails[planeKey];
  }

  // Check if plane is loading
  bool isPlaneLoading(String planeKey) {
    return loadingPlanes[planeKey] ?? false;
  }

  // Check if plane is expanded
  bool isPlaneExpanded(String planeKey) {
    return expandedPlanes[planeKey] ?? false;
  }

  // Helper method to safely convert to int
  int? _safeInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

