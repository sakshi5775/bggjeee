import 'dart:convert';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MoonCalendarController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // State
  final isLoading = false.obs;
  final selectedDate = DateTime.now().obs;
  final moonCalendarData = <Map<String, dynamic>>[].obs;
  final selectedLocation = 'Fetching Location...'.obs;

  // Location coordinates
  double? currentLatitude;
  double? currentLongitude;
  double? currentTimezone;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // Set default values immediately and fetch data
    currentLatitude = 28.6139;
    currentLongitude = 77.2090;
    currentTimezone = 5.5;
    selectedLocation.value = 'Loading...';

    // Fetch data immediately with default values
    fetchMoonCalendar();

    // Then try to get actual location in background
    _tryGetCurrentLocation();
  }

  @override
  void onClose() {
    _isDisposed = true;
    super.onClose();
  }

  /// Try to get current location on initialization
  Future<void> _tryGetCurrentLocation() async {
    try {
      bool serviceEnabled = false;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } on MissingPluginException {
        if (_isDisposed) return;
        selectedLocation.value = 'Select Location';
        return;
      }

      if (!serviceEnabled) {
        if (_isDisposed) return;
        selectedLocation.value = 'Select Location';
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (_isDisposed) return;
          selectedLocation.value = 'Select Location';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (_isDisposed) return;
        selectedLocation.value = 'Select Location';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_isDisposed) return;

      try {
        final reverseGeocode = await _reverseGeocode(
          position.latitude,
          position.longitude,
        );

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
            selectedLocation.value = 'Select Location';
          }
        } else {
          selectedLocation.value = 'Select Location';
        }
      } catch (e) {
        debugPrint('Error reverse geocoding: $e');
        if (_isDisposed) return;
        selectedLocation.value = 'Select Location';
      }

      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

      // Get timezone
      final timezone = await AddressHelper.getTimezoneFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (timezone != null && timezone.isNotEmpty) {
        currentTimezone = await _getTimezoneOffset(timezone);
      } else {
        currentTimezone = await _getTimezoneOffsetFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      // Update location and re-fetch with actual coordinates
      if (currentLatitude != null &&
          currentLongitude != null &&
          currentTimezone != null) {
        // Only re-fetch if location changed significantly (optional optimization)
        final oldLat = currentLatitude!;
        final oldLon = currentLongitude!;
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;

        // Re-fetch with actual location (only if location changed significantly)
        if ((oldLat - position.latitude).abs() > 0.1 ||
            (oldLon - position.longitude).abs() > 0.1) {
          fetchMoonCalendar();
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (_isDisposed) return;
      selectedLocation.value = 'Select Location';
      // Use default values (already set in onInit, but ensure they're set)
      if (currentLatitude == null ||
          currentLongitude == null ||
          currentTimezone == null) {
        currentLatitude = 28.6139;
        currentLongitude = 77.2090;
        currentTimezone = 5.5;
        fetchMoonCalendar();
      }
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

        // Refresh moon calendar data for selected date
        fetchMoonCalendar();
      }
    } catch (e) {
      debugPrint('Error selecting city: $e');
    }
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

      // Reverse geocode to get address
      final reverseGeocode = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      if (reverseGeocode != null && reverseGeocode['city'] != null) {
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

      // Refresh moon calendar data
      fetchMoonCalendar();
    } catch (e) {
      debugPrint('Error getting current location: $e');
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

  /// Fetch moon calendar data for selected date
  Future<void> fetchMoonCalendar() async {
    if (currentLatitude == null ||
        currentLongitude == null ||
        currentTimezone == null) {
      currentLatitude = 28.6139;
      currentLongitude = 77.2090;
      currentTimezone = 5.5;
    }

    try {
      isLoading.value = true;
      moonCalendarData.clear();

      final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate.value);
      final time = DateFormat('HH:mm').format(DateTime.now());

      debugPrint(
        'Moon Calendar API - Date: $dateStr, Time: $time, Lat: $currentLatitude, Lon: $currentLongitude, TZ: $currentTimezone',
      );

      final data = await _panchangService.getMoonCalendar(
        date: dateStr,
        time: time,
        latitude: currentLatitude!,
        longitude: currentLongitude!,
        tz: currentTimezone!,
        lang: 'en',
      );

      if (data != null && data['response'] != null) {
        final response = data['response'] as List<dynamic>?;
        if (response != null && response.isNotEmpty) {
          moonCalendarData.value = response
              .map((item) => item as Map<String, dynamic>)
              .toList();
          debugPrint('Moon Calendar - Loaded ${moonCalendarData.length} items');
        } else {
          moonCalendarData.clear();
          debugPrint('Moon Calendar - Empty response');
        }
      } else {
        moonCalendarData.clear();
        debugPrint('Moon Calendar - No data in response');
        showErrorMessage(
          title: 'Error',
          message: 'Failed to fetch moon calendar data',
        );
      }
    } catch (e) {
      debugPrint('Error fetching moon calendar: $e');
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
      moonCalendarData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Select date
  void selectDate(DateTime date) {
    selectedDate.value = date;
    fetchMoonCalendar();
  }
}
