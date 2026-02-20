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

class FestivalYearlyController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // State
  final isLoading = false.obs;
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs; // Dynamic year - defaults to current year
  final selectedLocation = 'Fetching Location...'.obs;
  final yearlyFestivalData = <Map<String, dynamic>>[].obs;
  
  // Month names
  final List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  
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
    fetchYearlyFestivals();
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

  /// Fetch yearly festival data for selected month only
  Future<void> fetchYearlyFestivals() async {
    try {
      isLoading.value = true;
      final festivalData = <Map<String, dynamic>>[];

      // Fetch data for selected month only
      try {
        final data = await _panchangService.getMonthlyCalendar(
          month: selectedMonth.value,
          year: selectedYear.value,
        );

        if (data != null) {
          final response = data['response'] as List<dynamic>?;
          if (response != null) {
            for (var item in response) {
              final dateStr = item['date']?.toString() ?? '';
              final festivals = item['festivals'] as List<dynamic>?;
              if (festivals != null) {
                for (var festival in festivals) {
                  final festMap = festival as Map<String, dynamic>;
                  festivalData.add({
                    'date': dateStr,
                    'festival': festMap,
                    'month': selectedMonth.value,
                  });
                }
              }
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching month ${selectedMonth.value}: $e');
      }

      // Sort by date
      festivalData.sort((a, b) {
        final dateA = _parseDate(a['date'] as String);
        final dateB = _parseDate(b['date'] as String);
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });

      yearlyFestivalData.value = festivalData;
    } catch (e) {
      debugPrint('Error fetching yearly festivals: $e');
      showErrorMessage(title: 'Error', message: 'Failed to fetch festival data');
    } finally {
      isLoading.value = false;
    }
  }

  /// Parse date string to DateTime
  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return null;
  }

  /// Select month
  void selectMonth(int month) {
    selectedMonth.value = month;
    fetchYearlyFestivals();
  }

  /// Select year
  void selectYear(int year) {
    selectedYear.value = year;
    fetchYearlyFestivals();
  }

  /// Get month name
  String getMonthName(int month) {
    return monthNames[month - 1];
  }

  /// Select city
  Future<void> selectCity(String cityName, String? state, String? country) async {
    try {
      final coords = await AddressHelper.fetchCoordinatesFromCity(
        city: cityName,
        state: state,
        country: country ?? 'India',
      );
      if (coords != null) {
        currentLatitude = coords['latitude'] as double?;
        currentLongitude = coords['longitude'] as double?;
        
        if (currentLatitude != null && currentLongitude != null) {
          try {
            final timezone = await AddressHelper.getTimezoneFromCoordinates(
              currentLatitude!,
              currentLongitude!,
            );
            if (timezone != null) {
              currentTimezone = await _getTimezoneOffset(timezone);
            } else {
              currentTimezone = await _getTimezoneOffsetFromCoordinates(
                currentLatitude!,
                currentLongitude!,
              );
            }
          } catch (e) {
            currentTimezone = 5.5;
          }
        }

        selectedLocation.value = state != null ? '$cityName, $state' : cityName;
      }
    } catch (e) {
      debugPrint('Error selecting city: $e');
    }
  }

  /// Get current location
  Future<void> getCurrentLocation() async {
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

      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

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
      debugPrint('Error getting current location: $e');
    }
  }

  /// Get location string with coordinates
  String getLocationString() {
    if (currentLatitude != null && currentLongitude != null) {
      final latDir = currentLatitude! >= 0 ? 'N' : 'S';
      final lonDir = currentLongitude! >= 0 ? 'E' : 'W';
      final lat = currentLatitude!.abs();
      final lon = currentLongitude!.abs();
      final tz = currentTimezone ?? 5.5;
      return '(${lat.toStringAsFixed(0)}$latDir${((lat % 1) * 60).toStringAsFixed(0)}, ${lon.toStringAsFixed(0)}$lonDir${((lon % 1) * 60).toStringAsFixed(0)} +$tz)';
    }
    return '';
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


