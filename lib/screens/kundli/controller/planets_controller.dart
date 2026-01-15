import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetsController extends BaseController {
  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // API data
  final planetDetailsData = Rxn<Map<String, dynamic>>();
  
  // Loading state
  final isLoadingPlanetDetails = false.obs;
  
  // Service
  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    _loadData();
    // Fetch data automatically when controller is initialized
    fetchPlanetDetails();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  // Check if required fields are present
  bool _hasRequiredFields() {
    if (formData.value == null) return false;
    
    final form = formData.value!;
    final date = form['date'] as String?;
    final time = form['time'] as String?;
    final latitude = form['latitude'] as double?;
    final longitude = form['longitude'] as double?;
    final tz = form['timezone'] as double?;
    
    return date != null && time != null && latitude != null && longitude != null && tz != null;
  }

  // Get missing required fields
  List<String> _getMissingRequiredFields() {
    if (formData.value == null) {
      return ['date', 'time', 'latitude', 'longitude', 'timezone'];
    }
    
    final form = formData.value!;
    final missing = <String>[];
    
    if (form['date'] == null) missing.add('date');
    if (form['time'] == null) missing.add('time');
    if (form['latitude'] == null) missing.add('latitude');
    if (form['longitude'] == null) missing.add('longitude');
    if (form['timezone'] == null) missing.add('timezone');
    
    return missing;
  }

  // Show form popup for missing fields
  Future<void> _showFormPopup(List<String> missingFields) async {
    final formControllers = <String, TextEditingController>{};
    final formValues = <String, dynamic>{};
    
    // Initialize controllers with existing values if available
    if (formData.value != null) {
      final existingForm = formData.value!;
      for (final field in missingFields) {
        formControllers[field] = TextEditingController(
          text: existingForm[field]?.toString() ?? '',
        );
      }
    } else {
      for (final field in missingFields) {
        formControllers[field] = TextEditingController();
      }
    }
    
    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: Get.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Additional Information Required',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F221E),
                ).merge(AppTypography.h2),
              ),
              Spacing.h(16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: missingFields.map((field) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: TextField(
                          controller: formControllers[field],
                          decoration: InputDecoration(
                            labelText: _getFieldLabel(field),
                            hintText: _getFieldHint(field),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          keyboardType: _getKeyboardType(field),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Spacing.h(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText('Cancel'),
                  ),
                  Spacing.w(8),
                  ElevatedButton(
                    onPressed: () {
                      // Collect form values
                      for (final field in missingFields) {
                        final value = formControllers[field]?.text.trim();
                        if (value != null && value.isNotEmpty) {
                          if (field == 'latitude' || field == 'longitude' || field == 'timezone') {
                            formValues[field] = double.tryParse(value);
                          } else {
                            formValues[field] = value;
                          }
                        }
                      }
                      
                      // Update formData
                      if (formData.value != null) {
                        formData.value!.addAll(formValues);
                      } else {
                        formData.value = formValues;
                      }
                      
                      Get.back();
                      // Retry fetching data
                      fetchPlanetDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: "#ed6f30".toColor(),
                      foregroundColor: Colors.white,
                    ),
                    child: AutoTranslateText('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
    // Dispose controllers
    for (final controller in formControllers.values) {
      controller.dispose();
    }
  }

  String _getFieldLabel(String field) {
    switch (field) {
      case 'date':
        return 'Date (dd/mm/yyyy)';
      case 'time':
        return 'Time (HH:mm)';
      case 'latitude':
        return 'Latitude';
      case 'longitude':
        return 'Longitude';
      case 'timezone':
        return 'Timezone';
      default:
        return field;
    }
  }

  String _getFieldHint(String field) {
    switch (field) {
      case 'date':
        return 'e.g., 16/01/2024';
      case 'time':
        return 'e.g., 14:30';
      case 'latitude':
        return 'e.g., 24.5854';
      case 'longitude':
        return 'e.g., 73.7125';
      case 'timezone':
        return 'e.g., 5.5';
      default:
        return '';
    }
  }

  TextInputType _getKeyboardType(String field) {
    switch (field) {
      case 'latitude':
      case 'longitude':
      case 'timezone':
        return TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  // Fetch Planet Details
  Future<void> fetchPlanetDetails() async {
    // Check if required fields are present
    if (!_hasRequiredFields()) {
      final missingFields = _getMissingRequiredFields();
      if (missingFields.isNotEmpty) {
        await _showFormPopup(missingFields);
        // After popup, check again
        if (!_hasRequiredFields()) {
          Get.snackbar(
            'Error',
            'Please provide all required fields',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
          return;
        }
      }
    }

    try {
      isLoadingPlanetDetails.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Planet Details');
        isLoadingPlanetDetails.value = false;
        Get.snackbar(
          'Error',
          'Missing required fields. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getPlanetDetails(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingPlanetDetails.value = false;

      if (data != null && data['response'] != null) {
        planetDetailsData.value = data['response'] as Map<String, dynamic>;
        debugPrint('Planet Details data loaded successfully');
      } else {
        debugPrint('Failed to fetch Planet Details data');
        Get.snackbar(
          'Error',
          'Failed to fetch planet details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingPlanetDetails.value = false;
      debugPrint('Error fetching Planet Details data: $e');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

