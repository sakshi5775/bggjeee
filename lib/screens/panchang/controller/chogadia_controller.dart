import 'dart:convert';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChogadiaController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // State
  final isLoading = false.obs;
  final selectedDate = DateTime.now().obs;
  final selectedLocation = 'Fetching Location...'.obs;
  final dayChogadias = <Map<String, dynamic>>[].obs;
  final nightChogadias = <Map<String, dynamic>>[].obs;
  final allChogadias = <Map<String, dynamic>>[].obs;
  final currentChogadia = Rxn<Map<String, dynamic>>();
  
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
    fetchChogadiaData();
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
          final city = reverseGeocode['city'] ?? reverseGeocode['town'] ?? reverseGeocode['village'] ?? '';
          final state = reverseGeocode['state'] ?? '';
          if (city.isNotEmpty) {
            selectedLocation.value = state.isNotEmpty ? '$city, $state' : city;
          } else {
            selectedLocation.value = 'Select Location';
          }
        } else {
          selectedLocation.value = 'Select Location';
        }

        currentLatitude = position.latitude;
        currentLongitude = position.longitude;

        // Get timezone
        try {
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
        } catch (e) {
          currentTimezone = 5.5;
        }
      } catch (e) {
        if (_isDisposed) return;
        selectedLocation.value = 'Select Location';
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
        currentTimezone = 5.5;
      }
    } catch (e) {
      if (_isDisposed) return;
      selectedLocation.value = 'Select Location';
      debugPrint('Error getting initial location: $e');
    }
  }

  /// Reverse geocode coordinates to get address
  Future<Map<String, dynamic>?> _reverseGeocode(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['address'] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }
    return null;
  }

  /// Fetch chogadia data
  Future<void> fetchChogadiaData() async {
    if (currentLatitude == null || currentLongitude == null || currentTimezone == null) {
      // Use default values if location not available
      currentLatitude = 28.6139; // Delhi default
      currentLongitude = 77.2090;
      currentTimezone = 5.5;
    }

    try {
      isLoading.value = true;

      final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate.value);
      // Use current time for determining active chogadia
      final time = DateFormat('HH:mm').format(DateTime.now());

      final data = await _panchangService.getChoghadiyaMuhurta(
        date: dateStr,
        time: time,
        latitude: currentLatitude!,
        longitude: currentLongitude!,
        tz: currentTimezone!,
        lang: 'en',
      );

      if (data != null) {
        // The API returns: { "success": true, "data": { "status": 200, "response": { "day": [...], "night": [...] } } }
        // Service returns: data['data'] which is { "status": 200, "response": { "day": [...], "night": [...] } }
        final response = data['response'] as Map<String, dynamic>?;
        
        if (response != null) {
          final dayList = response['day'] as List<dynamic>?;
          final nightList = response['night'] as List<dynamic>?;
          
          if (dayList != null) {
            dayChogadias.value = dayList.map((c) => c as Map<String, dynamic>).toList();
          }
          
          if (nightList != null) {
            nightChogadias.value = nightList.map((c) => c as Map<String, dynamic>).toList();
          }
          
          // Combine day and night chogadias
          allChogadias.value = [...dayChogadias, ...nightChogadias];
          
          // Find current chogadia based on current time (only if selected date is today)
          final isToday = selectedDate.value.year == DateTime.now().year &&
                         selectedDate.value.month == DateTime.now().month &&
                         selectedDate.value.day == DateTime.now().day;
          
          if (isToday) {
            _findCurrentChogadia();
          } else {
            // For other dates, show the first chogadia
            if (allChogadias.isNotEmpty) {
              currentChogadia.value = allChogadias.first;
            }
          }
          
          if (kDebugMode) {
            debugPrint('Chogadia data fetched successfully: ${allChogadias.length} chogadias (${dayChogadias.length} day, ${nightChogadias.length} night)');
          }
        } else {
          if (kDebugMode) {
            debugPrint('Response field not found in data: ${data.keys}');
          }
          showErrorMessage(title: 'Error', message: 'Invalid response format');
        }
      } else {
        if (kDebugMode) {
          debugPrint('Data is null from service');
        }
        showErrorMessage(title: 'Error', message: 'Failed to fetch chogadia data');
      }
    } catch (e) {
      debugPrint('Error fetching chogadia data: $e');
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Find current chogadia based on current time
  void _findCurrentChogadia() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    for (var chogadia in allChogadias) {
      final startStr = chogadia['start']?.toString() ?? '';
      final endStr = chogadia['end']?.toString() ?? '';
      
      try {
        final startTime = _parseDateTime(startStr);
        final endTime = _parseDateTime(endStr);
        
        if (startTime != null && endTime != null) {
          // Normalize times to today for comparison
          final startToday = DateTime(
            today.year,
            today.month,
            today.day,
            startTime.hour,
            startTime.minute,
          );
          final endToday = DateTime(
            today.year,
            today.month,
            today.day,
            endTime.hour,
            endTime.minute,
          );
          
          // Handle case where end time is next day (e.g., 11:44 PM - 0:44 AM)
          final endTimeAdjusted = endToday.isBefore(startToday) 
              ? endToday.add(const Duration(days: 1))
              : endToday;
          
          // Check if current time is within this chogadia
          if (now.isAfter(startToday) && now.isBefore(endTimeAdjusted)) {
            currentChogadia.value = chogadia;
            return;
          }
        }
      } catch (e) {
        debugPrint('Error parsing chogadia time: $e');
      }
    }
    
    // If no current chogadia found, use the first one
    if (allChogadias.isNotEmpty) {
      currentChogadia.value = allChogadias.first;
    }
  }

  /// Parse date time string from API format
  DateTime? _parseDateTime(String dateTimeStr) {
    try {
      // Format: "15/12/2025, 6:24:06 AM"
      final parts = dateTimeStr.split(', ');
      if (parts.length == 2) {
        final datePart = parts[0].trim(); // "15/12/2025"
        final timePart = parts[1].trim(); // "6:24:06 AM"
        
        final dateParts = datePart.split('/');
        if (dateParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          
          // Parse time
          final isPM = timePart.toLowerCase().contains('pm');
          final timeOnly = timePart.replaceAll(RegExp(r'[ap]m', caseSensitive: false), '').trim();
          final timeParts = timeOnly.split(':');
          
          if (timeParts.length >= 2) {
            var hour = int.parse(timeParts[0]);
            final minute = int.parse(timeParts[1]);
            
            if (isPM && hour != 12) {
              hour += 12;
            } else if (!isPM && hour == 12) {
              hour = 0;
            }
            
            return DateTime(year, month, day, hour, minute);
          }
        }
      }
    } catch (e) {
      debugPrint('Error parsing date time: $e');
    }
    return null;
  }

  /// Format time from API response
  String formatTime(String dateTimeStr) {
    final dateTime = _parseDateTime(dateTimeStr);
    if (dateTime != null) {
      return DateFormat('hh:mm a').format(dateTime);
    }
    return '';
  }

  /// Format time range
  String formatTimeRange(String startStr, String endStr) {
    final start = formatTime(startStr);
    final end = formatTime(endStr);
    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }
    return '';
  }

  /// Navigate to previous day
  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    fetchChogadiaData();
  }

  /// Navigate to next day
  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    fetchChogadiaData();
  }

  /// Go to today
  void goToToday() {
    selectedDate.value = DateTime.now();
    fetchChogadiaData();
  }

  /// Get timezone offset from timezone string
  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      final response = await http.get(
        Uri.parse('https://timeapi.io/api/TimeZone/coordinate?latitude=${currentLatitude ?? 28.6139}&longitude=${currentLongitude ?? 77.2090}'),
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
    
    return await _getTimezoneOffsetFromCoordinates(
      currentLatitude ?? 28.6139,
      currentLongitude ?? 77.2090,
    );
  }

  /// Get timezone offset from coordinates
  Future<double> _getTimezoneOffsetFromCoordinates(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('https://timeapi.io/api/TimeZone/coordinate?latitude=$lat&longitude=$lon'),
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
}



