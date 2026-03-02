import 'dart:convert';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/location_prompt_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MonthlyCalendarController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // State
  final isLoading = false.obs;
  final selectedDate = DateTime.now().obs;
  final calendarData = <Map<String, dynamic>>[].obs;
  final festivalsMap = <String, List<Map<String, dynamic>>>{}.obs;
  final selectedLocation = 'Fetching Location...'.obs;
  final panchangDataForSelectedDate = Rxn<Map<String, dynamic>>();
  final isFetchingPanchang = false.obs;

  // Location coordinates
  double? currentLatitude;
  double? currentLongitude;
  double? currentTimezone;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _tryGetCurrentLocation();
    fetchMonthlyCalendar();
    fetchPanchangForSelectedDate();
  }

  @override
  void onClose() {
    _isDisposed = true;
    super.onClose();
  }

  /// Try to get current location on initialization
  Future<void> _tryGetCurrentLocation() async {
    try {
      if (_isDisposed) return;

      final position = await LocationPromptHelper.checkAndGetLocation();
      if (_isDisposed || position == null) {
        selectedLocation.value = 'Select Location';
        return;
      }

      // Reverse geocode to get address
      try {
        final reverseGeocode = await _reverseGeocode(
          position.latitude,
          position.longitude,
        );

        if (_isDisposed) return;

        if (reverseGeocode != null && reverseGeocode['city'] != null) {
          selectedLocation.value = reverseGeocode['city'] as String;
          debugPrint('Location updated to: ${selectedLocation.value}');
        } else {
          selectedLocation.value = 'Current Location';
        }
      } catch (e) {
        if (_isDisposed) return;
        debugPrint('Error reverse geocoding: $e');
        selectedLocation.value = 'Current Location';
      }
    } catch (e) {
      if (_isDisposed) return;
      debugPrint('Error getting initial location: $e');
      selectedLocation.value = 'Select Location';
    }
  }

  /// Fetch monthly calendar data
  Future<void> fetchMonthlyCalendar() async {
    try {
      isLoading.value = true;

      final month = selectedDate.value.month;
      final year = selectedDate.value.year;

      final data = await _panchangService.getMonthlyCalendar(
        month: month,
        year: year,
      );

      if (data != null) {
        final response = data['response'] as List<dynamic>?;
        if (response != null) {
          calendarData.value = response
              .map((item) => item as Map<String, dynamic>)
              .toList();

          // Build festivals map by date
          festivalsMap.clear();
          for (var item in calendarData) {
            final dateStr = item['date']?.toString() ?? '';
            final festivals = item['festivals'] as List<dynamic>?;
            if (festivals != null && dateStr.isNotEmpty) {
              festivalsMap[dateStr] = festivals
                  .map((f) => f as Map<String, dynamic>)
                  .toList();
            }
          }
        }
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to fetch monthly calendar data',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
      debugPrint('Error fetching monthly calendar: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to previous month
  void previousMonth() {
    final current = selectedDate.value;
    if (current.month == 1) {
      selectedDate.value = DateTime(current.year - 1, 12, 1);
    } else {
      selectedDate.value = DateTime(current.year, current.month - 1, 1);
    }
    fetchMonthlyCalendar();
    fetchPanchangForSelectedDate();
  }

  /// Navigate to next month
  void nextMonth() {
    final current = selectedDate.value;
    if (current.month == 12) {
      selectedDate.value = DateTime(current.year + 1, 1, 1);
    } else {
      selectedDate.value = DateTime(current.year, current.month + 1, 1);
    }
    fetchMonthlyCalendar();
    fetchPanchangForSelectedDate();
  }

  /// Go to current month
  void goToCurrentMonth() {
    selectedDate.value = DateTime.now();
    fetchMonthlyCalendar();
    fetchPanchangForSelectedDate();
  }

  /// Get festivals for a specific date
  List<Map<String, dynamic>> getFestivalsForDate(DateTime date) {
    final dateStr = DateFormat('yyyy/MM/dd').format(date);
    return festivalsMap[dateStr] ?? [];
  }

  /// Get formatted month year string
  String getMonthYearString() {
    return DateFormat('MMMM yyyy').format(selectedDate.value);
  }

  /// Fetch panchang data for selected date
  Future<void> fetchPanchangForSelectedDate() async {
    if (currentLatitude == null ||
        currentLongitude == null ||
        currentTimezone == null) {
      // Use default values if location not available
      currentLatitude = 28.6139; // Delhi default
      currentLongitude = 77.2090;
      currentTimezone = 5.5;
    }

    try {
      isFetchingPanchang.value = true;

      final date = DateFormat('dd/MM/yyyy').format(selectedDate.value);
      final time = DateFormat('HH:mm').format(DateTime.now());

      final data = await _panchangService.getDailyPanchang(
        date: date,
        time: time,
        latitude: currentLatitude!,
        longitude: currentLongitude!,
        tz: currentTimezone!,
        lang: 'en',
      );

      if (data != null && data['response'] != null) {
        panchangDataForSelectedDate.value =
            data['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching panchang for selected date: $e');
    } finally {
      isFetchingPanchang.value = false;
    }
  }

  /// Select date using calendar picker
  Future<void> selectDate() async {
    final picked = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      fetchMonthlyCalendar();
      fetchPanchangForSelectedDate();
    }
  }

  /// Select city from location bottom sheet
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
        currentLatitude = coords['latitude'] as double?;
        currentLongitude = coords['longitude'] as double?;

        // Get timezone
        if (currentLatitude != null && currentLongitude != null) {
          final timezone = await AddressHelper.getTimezoneFromCoordinates(
            currentLatitude!,
            currentLongitude!,
          );

          // Calculate timezone offset
          if (timezone != null) {
            currentTimezone = await _getTimezoneOffset(timezone);
          } else {
            // Fallback: calculate from coordinates
            currentTimezone = await _getTimezoneOffsetFromCoordinates(
              currentLatitude!,
              currentLongitude!,
            );
          }
        }

        // Refresh panchang data for selected date
        fetchPanchangForSelectedDate();
      }
    } catch (e) {
      debugPrint('Error selecting city: $e');
    }
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
    try {
      final position = await LocationPromptHelper.checkAndGetLocation();
      if (position == null) {
        return;
      }

      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

      // Reverse geocode to get address
      final reverseGeocode = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      if (reverseGeocode != null && reverseGeocode['city'] != null) {
        selectedLocation.value = reverseGeocode['city'] as String;
      } else {
        selectedLocation.value = 'Current Location';
      }

      // Get timezone
      final timezone = await AddressHelper.getTimezoneFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (timezone != null) {
        currentTimezone = await _getTimezoneOffset(timezone);
      } else {
        currentTimezone = await _getTimezoneOffsetFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      // Refresh panchang data
      fetchPanchangForSelectedDate();
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  /// Get timezone offset from timezone string
  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://timeapi.io/api/TimeZone/coordinate?latitude=${currentLatitude ?? 28.6139}&longitude=${currentLongitude ?? 77.2090}',
        ),
        headers: {'Accept': 'application/json'},
      );

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

    // Fallback: calculate from coordinates
    return await _getTimezoneOffsetFromCoordinates(
      currentLatitude ?? 28.6139,
      currentLongitude ?? 77.2090,
    );
  }

  /// Get timezone offset from coordinates
  Future<double> _getTimezoneOffsetFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://timeapi.io/api/TimeZone/coordinate?latitude=$lat&longitude=$lon',
        ),
        headers: {'Accept': 'application/json'},
      );

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

    // Default to IST (5.5)
    return 5.5;
  }

  /// Parse timezone offset string to double
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

  /// Get current Hindu details from panchang data
  String getCurrentHinduDetails() {
    final data = panchangDataForSelectedDate.value;
    if (data == null) return 'Loading...';

    final masa = data['advanced_details']?['masa'] as Map<String, dynamic>?;
    if (masa != null) {
      final amanta = masa['amanta_name']?.toString() ?? '';
      final purnimanta = masa['purnimanta_name']?.toString() ?? '';
      if (amanta.isNotEmpty && purnimanta.isNotEmpty) {
        return '$amanta (Amanta) | $purnimanta (Purnimant)';
      }
    }
    return 'Loading...';
  }

  /// Get paksha and tithi from panchang data
  String getPakshaTithi() {
    final data = panchangDataForSelectedDate.value;
    if (data == null) return 'Loading...';

    final masa = data['advanced_details']?['masa'] as Map<String, dynamic>?;
    final tithi = data['tithi'] as Map<String, dynamic>?;

    String paksha = masa?['paksha']?.toString() ?? '';
    String tithiName = tithi?['name']?.toString() ?? '';

    if (paksha.isNotEmpty && tithiName.isNotEmpty) {
      return '$paksha | $tithiName';
    }
    return 'Loading...';
  }

  /// Reverse geocode coordinates to get address
  Future<Map<String, dynamic>?> _reverseGeocode(double lat, double lon) async {
    try {
      // Rate limiting: wait 1.1 seconds between requests
      await Future.delayed(const Duration(milliseconds: 1100));

      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': 'AstrologyApp/1.0', 'Accept-Language': 'en'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        final address = data?['address'] as Map<String, dynamic>?;

        if (address != null) {
          return {
            'city':
                address['city'] ??
                address['town'] ??
                address['village'] ??
                address['municipality'] ??
                address['county'] ??
                'Unknown',
            'state': address['state'] ?? address['region'] ?? '',
            'country': address['country'] ?? '',
          };
        }
      }
    } catch (e) {
      debugPrint('Error in reverse geocoding: $e');
    }
    return null;
  }
}
