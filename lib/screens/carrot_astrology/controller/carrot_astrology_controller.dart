import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/carrot_astrology_model.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/service/carrot_astrology_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/utils/error_formatter.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/utils/location_prompt_helper.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CarrotAstrologyController extends GetxController {
  final CarrotAstrologyService _carrotAstrologyService =
      CarrotAstrologyService();
  final UserProfileService _userProfileService = UserProfileService();

  // Form controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController timezoneController = TextEditingController();

  // State variables
  final RxString selectedZodiacSign = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxString errorMessage = RxString('');
  final Rx<CarrotAstrologyData?> analysisResult = Rx<CarrotAstrologyData?>(
    null,
  );

  // Form fields
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  final RxString selectedLocation = 'Fetching Location...'.obs;
  final RxString selectedLanguage = 'en'.obs;
  final RxBool isFetchingLocation = false.obs;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  // Location data
  double? latitude;
  double? longitude;
  String? timezone;

  // Language options
  final Map<String, String> languages = {'en': 'English', 'hi': 'Hindi'};

  final List<String> zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
    _loadUserProfileData();
  }

  @override
  void onClose() {
    _isDisposed = true;
    dateController.dispose();
    timeController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    timezoneController.dispose();
    super.onClose();
  }

  void _initializeForm() {
    // Set default values (may be overwritten by profile in _loadUserProfileData)
    final now = DateTime.now();
    selectedDate.value = now;
    dateController.text = DateFormat('dd/MM/yyyy').format(now);
    final currentTime = TimeOfDay.now();
    selectedTime.value = currentTime;
    timeController.text = TimePickerHelper.formatTime24To12Display(
      currentTime.hour,
      currentTime.minute,
    );
    timezoneController.text = '5.5'; // Default IST

    // Try to get current location on init
    _tryGetCurrentLocation();
  }

  /// Prefill DOB, time of birth, and location from user profile when available.
  Future<void> _loadUserProfileData() async {
    try {
      final userId = UserData().getLoginData.user?.userId;
      if (userId == null) return;
      final profile = await _userProfileService.getProfile(userId);
      if (profile == null || _isDisposed) return;

      // DOB from personalInfo.dateOfBirth or birthChart.generatedAt
      String? dateStr = profile.personalInfo?.dateOfBirth;
      if (dateStr == null && profile.birthChart?.generatedAt != null) {
        dateStr = profile.birthChart!.generatedAt!;
      }
      if (dateStr != null && dateStr.isNotEmpty) {
        try {
          DateTime? dob = DateTime.tryParse(dateStr);
          if (dob == null) {
            final parts = dateStr.split(RegExp(r'[/\-]'));
            if (parts.length >= 3) {
              if (parts[0].length == 4 && int.tryParse(parts[0]) != null) {
                final y = int.tryParse(parts[0]);
                final m = int.tryParse(parts[1]);
                final d = int.tryParse(parts[2]);
                if (y != null && m != null && d != null)
                  dob = DateTime(y, m, d);
              } else {
                final d = int.tryParse(parts[0]);
                final m = int.tryParse(parts[1]);
                final y = int.tryParse(parts[2]);
                if (d != null && m != null && y != null)
                  dob = DateTime(y, m, d);
              }
            }
          }
          if (dob != null && !_isDisposed) {
            selectedDate.value = dob;
            dateController.text = DateFormat('dd/MM/yyyy').format(dob);
          }
        } catch (e) {
          debugPrint('Error parsing profile DOB for carrot astrology: $e');
        }
      }

      // Time of birth from birthChart.birthTime
      if (profile.birthChart?.birthTime != null && !_isDisposed) {
        final bt = profile.birthChart!.birthTime!;
        final h = (bt.hour ?? 0).clamp(0, 23);
        final m = (bt.minute ?? 0).clamp(0, 59);
        selectedTime.value = TimeOfDay(hour: h, minute: m);
        timeController.text = TimePickerHelper.formatTime24To12Display(h, m);
      }

      // Location from birthChart.birthPlace
      if (profile.birthChart?.birthPlace != null && !_isDisposed) {
        final place = profile.birthChart!.birthPlace!;
        if (place.latitude != null && place.longitude != null) {
          latitudeController.text = place.latitude!.toStringAsFixed(6);
          longitudeController.text = place.longitude!.toStringAsFixed(6);
          latitude = place.latitude;
          longitude = place.longitude;
        }
        if (place.timezone != null && place.timezone!.isNotEmpty) {
          timezoneController.text = place.timezone!;
          timezone = place.timezone;
        }
        final city = place.city ?? '';
        final state = place.state ?? '';
        if (city.isNotEmpty) {
          selectedLocation.value = state.isNotEmpty ? '$city, $state' : city;
        }
      }
    } catch (e) {
      debugPrint('Error loading profile for carrot astrology form: $e');
    }
  }

  /// Try to get current location silently on initialization
  Future<void> _tryGetCurrentLocation() async {
    try {
      if (_isDisposed) return;

      final position = await LocationPromptHelper.checkAndGetLocation();
      if (_isDisposed || position == null) {
        if (!_isDisposed) selectedLocation.value = 'Select Location';
        return;
      }

      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);
      latitude = position.latitude;
      longitude = position.longitude;

      await _updateLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final offset = await _getTimezoneOffsetFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!_isDisposed) {
        timezoneController.text = offset.toString();
        timezone = offset.toString();
      }
    } catch (e) {
      debugPrint('Error getting initial location: $e');
      if (!_isDisposed) selectedLocation.value = 'Select Location';
    }
  }

  /// Update location name from coordinates
  Future<void> _updateLocationFromCoordinates(double lat, double lon) async {
    try {
      final reverseGeocode = await _reverseGeocode(lat, lon);
      if (_isDisposed) return;

      if (reverseGeocode != null) {
        final city =
            reverseGeocode['city'] ??
            reverseGeocode['town'] ??
            reverseGeocode['village'] ??
            '';
        final state = reverseGeocode['state'] ?? '';
        if (city.isNotEmpty) {
          selectedLocation.value = state.isNotEmpty ? '$city, $state' : city;
        } else {
          selectedLocation.value = 'Current Location';
        }
      } else {
        selectedLocation.value = 'Current Location';
      }
    } catch (e) {
      debugPrint('Error updating location name: $e');
      if (!_isDisposed) selectedLocation.value = 'Current Location';
    }
  }

  /// Reverse geocode coordinates to get address
  Future<Map<String, dynamic>?> _reverseGeocode(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
      );

      final response = await http
          .get(url, headers: {'User-Agent': 'AstrologyApp'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['address'] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
      return null;
    }
  }

  /// Get timezone offset from coordinates
  Future<double> _getTimezoneOffsetFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final url = Uri.parse(
        'https://timeapi.io/api/TimeZone/coordinate?latitude=$lat&longitude=$lon',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final offsetString = data['currentUtcOffset']?.toString() ?? '5.5';
        final offset =
            double.tryParse(
              offsetString.replaceAll(':', '.').replaceAll('+', ''),
            ) ??
            5.5;
        return offset;
      }
    } catch (e) {
      debugPrint('Error getting timezone: $e');
    }
    return 5.5; // Default IST
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

  void setSelectedZodiacSign(String sign) {
    selectedZodiacSign.value = sign;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
      timeController.text = '${picked.hour}:${picked.minute}';
    }
  }

  void fetchLocationFromCity(
    String city, {
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    double? timezone,
  }) {
    String locationText = city;
    if (state != null && state.isNotEmpty) {
      locationText += ', $state';
    }
    if (country != null && country.isNotEmpty) {
      locationText += ', $country';
    }

    selectedLocation.value = locationText;
    if (latitude != null) latitudeController.text = latitude.toString();
    if (longitude != null) longitudeController.text = longitude.toString();
    if (timezone != null) timezoneController.text = timezone.toString();

    this.latitude = latitude;
    this.longitude = longitude;
    this.timezone = timezone?.toString();
  }

  Future<void> useCurrentLocation() async {
    try {
      isFetchingLocation.value = true;
      final position = await LocationPromptHelper.checkAndGetLocation();
      if (_isDisposed || position == null) {
        return;
      }

      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);
      latitude = position.latitude;
      longitude = position.longitude;

      await _updateLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final offset = await _getTimezoneOffsetFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!_isDisposed) {
        timezoneController.text = offset.toString();
        timezone = offset.toString();
      }

      Get.snackbar(
        'Success',
        'Location updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint('Error using current location: $e');
    } finally {
      isFetchingLocation.value = false;
    }
  }

  String _calculateZodiacSign(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'Aries';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'Taurus';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'Gemini';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'Cancer';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'Leo';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'Virgo';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'Libra';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    } else {
      return 'Pisces'; // Feb 19 - Mar 20
    }
  }

  Future<void> submitForm() async {
    // Validate inputs
    if (dateController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select your date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedLocation.value.isEmpty ||
        selectedLocation.value == 'Fetching Location...' ||
        selectedLocation.value == 'Select Location') {
      Get.snackbar(
        'Validation Error',
        'Please select your birth place',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    // Calculate zodiac sign from birth date
    final calculatedSign = _calculateZodiacSign(selectedDate.value);
    selectedZodiacSign.value = calculatedSign;

    // Proceed with analysis
    await analyzeCarrotAstrology();
  }

  Future<void> analyzeCarrotAstrology() async {
    // Check balance
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('carrot_astrology')) {
        pricingCtrl.showInsufficientBalancePopup('carrot_astrology');
        return;
      }
    }

    try {
      isAnalyzing.value = true;
      errorMessage.value = '';
      analysisResult.value = null;

      final result = await _carrotAstrologyService.analyzeCarrotAstrology(
        zodiacSign: selectedZodiacSign.value,
        timeout: const Duration(minutes: 5),
      );

      analysisResult.value = result;

      // Navigate to results page
      UserMainController.pushInCurrentTab(
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
