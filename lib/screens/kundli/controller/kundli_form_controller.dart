import 'dart:convert';

import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';

import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/report_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/location_prompt_helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:astrobharataiuser/widgets/report_insufficient_balance_dialog.dart';
import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';

class KundliFormController extends BaseController {
  final KundliService _kundliService = KundliService();

  final ReportService _reportService = ReportService();

  // PDF Generation Mode
  bool isGeneratePdfMode = false;
  String? reportKey;
  String? reportType;
  String? reportVariant;

  // Target route to navigate to after form submission (if provided)
  String? targetRoute;

  // Form controllers
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final timezoneController = TextEditingController();

  // Gender selection
  final selectedGender = Rxn<String>();
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  // Language selection
  final selectedLanguage = 'en'.obs;
  final Map<String, String> languages = {
    'en': 'English',
    'hi': 'Hindi',
    'te': 'Telugu',
    'ka': 'Kannada',
    'ml': 'Malayalam',
    'be': 'Bengali',
    'gr': 'Gujarati',
    'mr': 'Marathi',
  };

  // Style selection
  final selectedStyle = 'north'.obs;
  final List<String> styles = ['north', 'south', 'east'];

  // Colored planets
  final coloredPlanets = true.obs;

  // State
  final isLoading = false.obs;
  final isFetchingLocation = false.obs;
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;
  final selectedLocation = 'Fetching Location...'.obs;

  // ===== NEW: Tab & Saved Kundli State =====
  final selectedTabIndex =
      1.obs; // 0 = Saved Kundli, 1 = New Kundli (default New)
  final savedKundliList = <Map<String, dynamic>>[].obs;
  final isLoadingSavedKundli = false.obs;
  final saveKundliChecked = false.obs;
  final searchQuery = ''.obs;
  final editingKundliId =
      Rxn<String>(); // non-null when editing an existing profile
  final isOpeningSavedKundli =
      false.obs; // loading state for opening saved kundli

  /// Filtered saved kundli list based on search query
  List<Map<String, dynamic>> get filteredKundliList {
    if (searchQuery.value.isEmpty) return savedKundliList;
    final q = searchQuery.value.toLowerCase();
    return savedKundliList.where((k) {
      final name = (k['name'] ?? '').toString().toLowerCase();
      final place = (k['birthPlace'] ?? '').toString().toLowerCase();
      return name.contains(q) || place.contains(q);
    }).toList();
  }

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // Load target route from arguments if provided
    final dynamic args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['targetRoute'] != null) {
        targetRoute = args['targetRoute'] as String;
      }
      if (args['generatePdf'] == true) {
        isGeneratePdfMode = true;
        reportKey = args['reportKey'];
        reportType = args['reportType'];
        reportVariant = args['variant'];
      }
      // If editing a saved kundli profile, prefill form
      if (args['editKundliProfile'] != null) {
        final profile = args['editKundliProfile'] as Map<String, dynamic>;
        selectedTabIndex.value = 1; // Switch to New Kundli tab
        _prefillFromProfile(profile);
      }
    }
    _initializeForm();
    fetchSavedKundliProfiles();
  }

  /// Prefill form fields from a saved kundli profile (for edit mode)
  void _prefillFromProfile(Map<String, dynamic> profile) {
    editingKundliId.value = profile['_id']?.toString();
    nameController.text = profile['name'] ?? '';

    final gender = profile['gender']?.toString();
    if (gender != null && gender.isNotEmpty) {
      if (genderOptions.contains(gender)) {
        selectedGender.value = gender;
      }
    }

    // Parse dateOfBirth (API format: MM/dd/yyyy) to display format dd/MM/yyyy
    final dob = profile['dateOfBirth']?.toString();
    if (dob != null && dob.isNotEmpty) {
      try {
        // API returns MM/dd/yyyy
        final parts = dob.split('/');
        if (parts.length == 3) {
          final month = int.parse(parts[0]);
          final day = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          final date = DateTime(year, month, day);
          selectedDate.value = date;
          dateController.text = DateFormat('dd/MM/yyyy').format(date);
        }
      } catch (e) {
        debugPrint('Error parsing profile DOB: $e');
      }
    }

    // Parse birthTime
    final birthTime = profile['birthTime']?.toString();
    if (birthTime != null && birthTime.isNotEmpty) {
      try {
        // Parse "12:00 PM" format
        final format = DateFormat('hh:mm a');
        final dt = format.parse(birthTime);
        selectedTime.value = TimeOfDay(hour: dt.hour, minute: dt.minute);
        timeController.text = DateFormat('HH:mm').format(dt);
      } catch (e) {
        debugPrint('Error parsing birth time: $e');
      }
    }

    // Set location
    final place = profile['birthPlace']?.toString();
    if (place != null && place.isNotEmpty) {
      selectedLocation.value = place;
    }

    // Set coordinates
    if (profile['latitude'] != null) {
      latitudeController.text = profile['latitude'].toString();
    }
    if (profile['longitude'] != null) {
      longitudeController.text = profile['longitude'].toString();
    }

    // Parse timezone
    final tz = profile['timezone']?.toString();
    if (tz != null && tz.isNotEmpty) {
      // Parse "IST +5:30" format to numeric 5.5
      try {
        final match = RegExp(r'([+-]?\d+):(\d+)').firstMatch(tz);
        if (match != null) {
          final hours = int.parse(match.group(1)!);
          final minutes = int.parse(match.group(2)!);
          final offset = hours + (minutes / 60.0);
          timezoneController.text = offset.toString();
        } else {
          timezoneController.text = '5.5';
        }
      } catch (e) {
        timezoneController.text = '5.5';
      }
    }
  }

  // ===== Saved Kundli API Methods =====

  /// Fetch all saved kundli profiles
  Future<void> fetchSavedKundliProfiles() async {
    try {
      isLoadingSavedKundli.value = true;
      final profiles = await _kundliService.getSavedKundliProfiles();
      savedKundliList.assignAll(profiles);
    } catch (e) {
      debugPrint('Error fetching saved kundli profiles: $e');
    } finally {
      isLoadingSavedKundli.value = false;
    }
  }

  /// Delete a saved kundli profile
  Future<void> deleteSavedKundliProfile(String id) async {
    try {
      final success = await _kundliService.deleteKundliProfile(id);
      if (success) {
        savedKundliList.removeWhere((k) => k['_id'] == id);
        showSuccessMessage(
          title: 'Success',
          message: 'Kundli profile deleted successfully',
        );
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to delete kundli profile',
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Error deleting kundli profile',
      );
    }
  }

  /// Open a saved kundli: generate kundli from saved profile data and navigate to result
  Future<void> openSavedKundli(Map<String, dynamic> profile) async {
    try {
      isOpeningSavedKundli.value = true;

      // Parse profile data to form parameters
      final name = profile['name'] ?? '';
      final gender = profile['gender'] ?? '';
      final place = profile['birthPlace'] ?? '';
      final lat = (profile['latitude'] is num)
          ? (profile['latitude'] as num).toDouble()
          : double.tryParse(profile['latitude']?.toString() ?? '') ?? 0.0;
      final lon = (profile['longitude'] is num)
          ? (profile['longitude'] as num).toDouble()
          : double.tryParse(profile['longitude']?.toString() ?? '') ?? 0.0;

      // Parse DOB from API format MM/dd/yyyy to dd/MM/yyyy for kundli API
      String date = '';
      final dob = profile['dateOfBirth']?.toString();
      if (dob != null && dob.isNotEmpty) {
        try {
          final parts = dob.split('/');
          if (parts.length == 3) {
            date = '${parts[1]}/${parts[0]}/${parts[2]}'; // dd/MM/yyyy
          }
        } catch (e) {
          debugPrint('Error parsing DOB: $e');
        }
      }

      // Parse birth time from "12:00 PM" to "HH:mm"
      String time = '';
      final bt = profile['birthTime']?.toString();
      if (bt != null && bt.isNotEmpty) {
        try {
          final format = DateFormat('hh:mm a');
          final dt = format.parse(bt);
          time = DateFormat('HH:mm').format(dt);
        } catch (e) {
          debugPrint('Error parsing birth time: $e');
        }
      }

      // Parse timezone
      double tz = 5.5;
      final tzStr = profile['timezone']?.toString();
      if (tzStr != null && tzStr.isNotEmpty) {
        try {
          final match = RegExp(r'([+-]?\d+):(\d+)').firstMatch(tzStr);
          if (match != null) {
            final hours = int.parse(match.group(1)!);
            final minutes = int.parse(match.group(2)!);
            tz = hours + (minutes / 60.0);
          }
        } catch (e) {
          debugPrint('Error parsing timezone: $e');
        }
      }

      if (date.isEmpty || time.isEmpty) {
        showErrorMessage(title: 'Error', message: 'Invalid profile data');
        return;
      }

      const colorHex = '#ed6f30';

      final data = await _kundliService.generateKundli(
        date: date,
        time: time,
        latitude: lat,
        longitude: lon,
        tz: tz,
        lang: 'en',
        style: 'north',
        coloredPlanets: true,
        color: colorHex,
      );

      if (data != null) {
        final formDataMap = {
          'name': name,
          'gender': gender,
          'date': date,
          'time': time,
          'latitude': lat,
          'longitude': lon,
          'timezone': tz,
          'language': 'en',
          'style': 'north',
          'coloredPlanets': true,
          'color': colorHex,
          'selectedLocation': place,
          'place': place,
          'city': place,
        };

        UserMainController.pushInCurrentTab(
          AppRoutes.kundliResult,
          arguments: {'kundliData': data, 'formData': formDataMap},
        );
      } else {
        showErrorMessage(title: 'Error', message: 'Failed to generate kundli');
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isOpeningSavedKundli.value = false;
    }
  }

  /// Edit a saved kundli: prefill form and switch to New Kundli tab
  void editSavedKundli(Map<String, dynamic> profile) {
    _prefillFromProfile(profile);
    selectedTabIndex.value = 1; // Switch to New Kundli tab
  }

  @override
  void onClose() {
    _isDisposed = true;
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    timezoneController.dispose();
    super.onClose();
  }

  void _initializeForm() {
    // Set default values
    final now = DateTime.now();
    selectedDate.value = now;
    dateController.text = DateFormat('dd/MM/yyyy').format(now);
    final currentTime = TimeOfDay.now();
    selectedTime.value = currentTime;
    timeController.text = DateFormat('HH:mm').format(
      DateTime(
        now.year,
        now.month,
        now.day,
        currentTime.hour,
        currentTime.minute,
      ),
    );
    timezoneController.text = '5.5'; // Default IST

    // Try to get current location on init
    _tryGetCurrentLocation();
  }

  /// Try to get current location silently on initialization
  Future<void> _tryGetCurrentLocation() async {
    try {
      if (_isDisposed) return;

      final position = await LocationPromptHelper.checkAndGetLocation();
      if (_isDisposed || position == null) {
        selectedLocation.value = 'Select Location';
        return;
      }

      // Set coordinates
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);

      // Update location name
      await _updateLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Get timezone
      final offset = await _getTimezoneOffsetFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!_isDisposed) {
        timezoneController.text = offset.toString();
      }
    } catch (e) {
      debugPrint('Error getting initial location: $e');
      if (!_isDisposed) {
        selectedLocation.value = 'Select Location';
      }
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
      if (!_isDisposed) {
        selectedLocation.value = 'Current Location';
      }
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
        final data = json.decode(response.body) as Map<String, dynamic>?;
        if (data?['currentUtcOffset'] != null) {
          final offsetStr = data!['currentUtcOffset'].toString();
          final offset = _parseTimezoneOffset(offsetStr);
          if (offset != null) return offset;
        }
      }
    } catch (e) {
      debugPrint('Error getting timezone from coordinates: $e');
    }
    return 5.5;
  }

  /// Parse timezone offset string
  double? _parseTimezoneOffset(String offsetStr) {
    try {
      offsetStr = offsetStr.trim();
      if (offsetStr.startsWith('+') || offsetStr.startsWith('-')) {
        final sign = offsetStr.startsWith('+') ? 1 : -1;
        final parts = offsetStr.substring(1).split(':');
        if (parts.length >= 2) {
          final hours = int.tryParse(parts[0]) ?? 0;
          final minutes = int.tryParse(parts[1]) ?? 0;
          return sign * (hours + (minutes / 60.0));
        }
      }
      return double.tryParse(offsetStr);
    } catch (e) {
      debugPrint('Error parsing timezone offset: $e');
    }
    return null;
  }

  /// Select date
  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;
    dateController.text = DateFormat('dd/MM/yyyy').format(date);
  }

  /// Select time
  Future<void> selectTime(TimeOfDay time) async {
    selectedTime.value = time;
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    timeController.text = DateFormat('HH:mm').format(dateTime);
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
    try {
      isFetchingLocation.value = true;

      final position = await LocationPromptHelper.checkAndGetLocation();
      if (_isDisposed || position == null) {
        return;
      }

      // Set latitude and longitude
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);

      // Get city name from coordinates using reverse geocoding
      await _updateLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Get timezone from coordinates
      final timezone = await AddressHelper.getTimezoneFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Always calculate and set timezone offset
      double offset;
      if (timezone != null && timezone.isNotEmpty) {
        // Convert timezone to offset
        offset = await _getTimezoneOffset(timezone);
      } else {
        // Fallback: Calculate offset directly from coordinates
        offset = await _getTimezoneOffsetFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      // Set the timezone offset
      timezoneController.text = offset.toString();
      debugPrint(
        'Timezone offset set: $offset for coordinates (${position.latitude}, ${position.longitude})',
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
      showErrorMessage(
        title: 'Error',
        message: 'Failed to get current location: ${e.toString()}',
      );
    } finally {
      isFetchingLocation.value = false;
    }
  }

  /// Get timezone offset from timezone string
  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      final url = Uri.parse(
        'https://timeapi.io/api/TimeZone/zone?timeZone=$timezone',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        if (data?['currentUtcOffset'] != null) {
          final offsetStr = data!['currentUtcOffset'].toString();
          final offset = _parseTimezoneOffset(offsetStr);
          if (offset != null) return offset;
        }
      }
    } catch (e) {
      debugPrint('Error getting timezone offset: $e');
    }
    return 5.5;
  }

  /// Select city and auto-fill coordinates
  Future<void> selectCity(
    String cityName,
    String? state,
    String? country,
  ) async {
    try {
      selectedLocation.value = cityName;

      // Fetch coordinates for the city
      final coords = await AddressHelper.fetchCoordinatesFromCity(
        city: cityName,
        state: state,
        country: country ?? 'India',
      );

      if (coords != null) {
        latitudeController.text = (coords['latitude'] as double)
            .toStringAsFixed(6);
        longitudeController.text = (coords['longitude'] as double)
            .toStringAsFixed(6);

        // Get timezone
        final timezone = await AddressHelper.getTimezoneFromCoordinates(
          coords['latitude'] as double,
          coords['longitude'] as double,
        );

        // Calculate timezone offset
        double offset;
        if (timezone != null) {
          offset = await _getTimezoneOffset(timezone);
        } else {
          offset = await _getTimezoneOffsetFromCoordinates(
            coords['latitude'] as double,
            coords['longitude'] as double,
          );
        }

        timezoneController.text = offset.toString();
      }
    } catch (e) {
      debugPrint('Error selecting city: $e');
      showErrorMessage(
        title: 'Error',
        message: 'Failed to get coordinates for selected city',
      );
    }
  }

  /// Generate Kundli
  Future<void> generateKundli() async {
    // Validate form
    if (nameController.text.trim().isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please enter full name');
      return;
    }
    if (selectedGender.value == null || selectedGender.value!.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select gender');
      return;
    }
    if (dateController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select date of birth');
      return;
    }
    if (timeController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select birth time');
      return;
    }
    if (selectedLocation.value == 'Select Location' ||
        selectedLocation.value == 'Fetching Location...') {
      showErrorMessage(title: 'Error', message: 'Please select birth location');
      return;
    }
    if (latitudeController.text.isEmpty) {
      showErrorMessage(
        title: 'Error',
        message: 'Please enter latitude or get current location',
      );
      return;
    }
    if (longitudeController.text.isEmpty) {
      showErrorMessage(
        title: 'Error',
        message: 'Please enter longitude or get current location',
      );
      return;
    }
    if (timezoneController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please enter timezone');
      return;
    }

    try {
      isLoading.value = true;

      final latitude = double.tryParse(latitudeController.text);
      final longitude = double.tryParse(longitudeController.text);
      final tz = double.tryParse(timezoneController.text);

      if (latitude == null || longitude == null || tz == null) {
        showErrorMessage(
          title: 'Error',
          message: 'Invalid latitude, longitude, or timezone',
        );
        return;
      }

      // Save kundli profile if checkbox is checked and it's new data (not editing)
      if (saveKundliChecked.value && editingKundliId.value == null) {
        _saveKundliProfile(latitude, longitude, tz);
      }

      if (isGeneratePdfMode) {
        await _generatePdfReport(latitude, longitude, tz);
        return;
      }

      // Use orange color for SVG (#ed6f30)
      const colorHex = '#ed6f30';

      final data = await _kundliService.generateKundli(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: selectedLanguage.value,
        style: selectedStyle.value,
        coloredPlanets: coloredPlanets.value,
        color: colorHex,
      );

      if (data != null) {
        // Prepare formData to pass to next screen
        final formDataMap = {
          'name': nameController.text.trim().isNotEmpty
              ? nameController.text.trim()
              : null,
          'gender': selectedGender.value,
          'date': dateController.text,
          'time': timeController.text,
          'latitude': latitude,
          'longitude': longitude,
          'timezone': tz,
          'language': selectedLanguage.value,
          'style': selectedStyle.value,
          'coloredPlanets': coloredPlanets.value,
          'color': colorHex,
          'selectedLocation': selectedLocation.value,
          'place': selectedLocation.value,
          'city': selectedLocation.value,
        };

        // If targetRoute is provided, navigate to that route instead of kundliResult
        if (targetRoute != null && targetRoute!.isNotEmpty) {
          UserMainController.pushInCurrentTab(
            targetRoute!,
            arguments: {'formData': formDataMap},
          );
        } else {
          // Navigate to result page with data (default behavior)
          // Note: name and gender are included in formData but NOT sent to API
          UserMainController.pushInCurrentTab(
            AppRoutes.kundliResult,
            arguments: {'kundliData': data, 'formData': formDataMap},
          );
        }
      } else {
        showErrorMessage(title: 'Error', message: 'Failed to generate kundli');
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Save kundli profile via POST API (fire-and-forget, non-blocking)
  void _saveKundliProfile(double latitude, double longitude, double tz) {
    // Convert dd/MM/yyyy to MM/dd/yyyy for API
    String apiDateOfBirth = '';
    try {
      final parts = dateController.text.split('/');
      if (parts.length == 3) {
        apiDateOfBirth = '${parts[1]}/${parts[0]}/${parts[2]}';
      }
    } catch (e) {
      debugPrint('Error converting date format: $e');
    }

    // Convert 24h time to 12h format for API
    String apiBirthTime = '';
    try {
      final t = selectedTime.value;
      final dt = DateTime(0, 1, 1, t.hour, t.minute);
      apiBirthTime = DateFormat('hh:mm a').format(dt);
    } catch (e) {
      debugPrint('Error formatting birth time: $e');
    }

    // Build timezone string like "IST +5:30"
    String apiTimezone = 'IST +5:30';
    try {
      final hours = tz.truncate();
      final minutes = ((tz - hours) * 60).round();
      apiTimezone = 'IST +$hours:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint('Error formatting timezone: $e');
    }

    // Fire and forget - don't block the main flow
    _kundliService
        .createKundliProfile(
          name: nameController.text.trim().isNotEmpty
              ? nameController.text.trim()
              : 'Unknown',
          gender: selectedGender.value ?? 'Male',
          dateOfBirth: apiDateOfBirth,
          birthTime: apiBirthTime,
          timezone: apiTimezone,
          birthPlace: selectedLocation.value,
          latitude: latitude,
          longitude: longitude,
        )
        .then((_) {
          debugPrint('Kundli profile saved successfully');
          fetchSavedKundliProfiles(); // Refresh list
        })
        .catchError((e) {
          debugPrint('Error saving kundli profile: $e');
        });
  }

  /// Internal method to handle PDF report generation
  Future<void> _generatePdfReport(
    double latitude,
    double longitude,
    double tz,
  ) async {
    try {
      final params = {
        'name': nameController.text.trim().isNotEmpty
            ? nameController.text.trim()
            : 'User',
        'date': dateController.text, // dd/MM/yyyy
        'time': timeController.text, // HH:mm
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'tz': tz.toString(),
        'gender': (selectedGender.value ?? 'Male').toLowerCase(),
        'lang': selectedLanguage.value,
        'style': selectedStyle.value,
        'place': selectedLocation.value,
        'pdf_type': reportVariant ?? 'small',
      };

      final downloadUrl = await _reportService.generateReport(
        params: params,
        reportPath: reportKey,
      );

      print('KundliFormController: Received downloadUrl: $downloadUrl');

      if (downloadUrl != null && downloadUrl.isNotEmpty) {
        // Navigate to the new in-app PDF viewer
        UserMainController.pushInCurrentTab(
          AppRoutes.reportPdfView,
          arguments: {
            'pdfUrl': downloadUrl,
            'title': nameController.text.trim().isNotEmpty
                ? '${nameController.text.trim()} Kundli'
                : 'Kundli Report',
          },
        );
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to generate PDF report. Please try again.',
        );
      }
    } on BadRequestException catch (e) {
      if (e.message.toLowerCase().contains('insufficient balance')) {
        // Parse balance info if available in e.fullBody
        double available = 0;
        double required = 0;

        try {
          if (e.fullBody is Map) {
            final data = (e.fullBody as Map)['data'] ?? e.fullBody;
            available = (data['available_balance'] ?? data['available'] ?? 0)
                .toDouble();
            required = (data['required_balance'] ?? data['required'] ?? 0)
                .toDouble();
          }
        } catch (err) {
          debugPrint('Error parsing balance from body: $err');
        }

        Get.dialog(
          ReportInsufficientBalanceDialog(
            currentBalance: available,
            requiredBalance: required,
            reportName: reportKey ?? 'Kundli Report',
          ),
        );
      } else {
        showErrorMessage(title: 'Error', message: e.message);
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
