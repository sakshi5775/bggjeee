import 'dart:convert';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RahukaalController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // Form controllers
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final timezoneController = TextEditingController();

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

  // State
  final isLoading = false.obs;
  final isFetchingLocation = false.obs;
  final selectedDate = DateTime.now().obs;
  final selectedLocation = 'Fetching Location...'.obs;

  // Data
  final dailyPanchang = Rxn<Map<String, dynamic>>();
  final monthlyRahukaal = <Map<String, dynamic>>[].obs;

  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  void _initializeForm() {
    final now = DateTime.now();
    selectedDate.value = now;
    dateController.text = DateFormat('dd/MM/yyyy').format(now);
    timeController.text = TimePickerHelper.formatTime24To12Display(
      now.hour,
      now.minute,
    );
    timezoneController.text = '5.5';

    _tryGetCurrentLocation().then((_) {
      if (latitudeController.text.isNotEmpty &&
          longitudeController.text.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          fetchRahukaalData();
        });
      }
    });
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

  Future<void> selectDate() async {
    final picked = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = picked;
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      fetchRahukaalData();
    }
  }

  /// Fetch daily panchang (for today's rahukaal) and monthly panchang (all days)
  Future<void> fetchRahukaalData() async {
    if (dateController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select a date');
      return;
    }
    if (timeController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select a time');
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

      final time24 =
          TimePickerHelper.parseTime12To24(timeController.text) ??
          timeController.text;
      final results = await Future.wait([
        _panchangService.getDailyPanchang(
          date: dateController.text,
          time: time24,
          latitude: latitude,
          longitude: longitude,
          tz: tz,
          lang: selectedLanguage.value,
        ),
        _panchangService.getMonthlyPanchang(
          date: dateController.text,
          time: time24,
          latitude: latitude,
          longitude: longitude,
          tz: tz,
          lang: selectedLanguage.value,
        ),
      ]);

      // Daily
      if (results[0] != null) {
        dailyPanchang.value = results[0]!['response'] as Map<String, dynamic>?;
      } else {
        dailyPanchang.value = null;
      }

      // Monthly list
      if (results[1] != null) {
        final list = results[1]!['response'] as List<dynamic>? ?? [];
        monthlyRahukaal.assignAll(list.cast<Map<String, dynamic>>());
      } else {
        monthlyRahukaal.clear();
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Location helpers (same pattern as other panchang controllers)
  Future<void> _tryGetCurrentLocation() async {
    try {
      if (_isDisposed) return;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!_isDisposed) selectedLocation.value = 'Select Location';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!_isDisposed) selectedLocation.value = 'Select Location';
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (!_isDisposed) selectedLocation.value = 'Select Location';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (_isDisposed) return;

      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);

      await _updateLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final offset = await _getTimezoneOffsetFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (!_isDisposed) timezoneController.text = offset.toString();
    } catch (e) {
      if (!_isDisposed) selectedLocation.value = 'Select Location';
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isFetchingLocation.value = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showErrorMessage(
            title: 'Permission Denied',
            message: 'Location permissions are denied.',
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        showErrorMessage(
          title: 'Permission Denied',
          message: 'Location permissions are permanently denied.',
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (_isDisposed) return;

      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);

      await _updateLocationFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final timezone = await AddressHelper.getTimezoneFromCoordinates(
        position.latitude,
        position.longitude,
      );
      double offset;
      if (timezone != null && timezone.isNotEmpty) {
        offset = await _getTimezoneOffset(timezone);
      } else {
        offset = await _getTimezoneOffsetFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }
      timezoneController.text = offset.toString();

      showSuccessMessage(
        title: 'Success',
        message: 'Location fetched successfully',
      );
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Failed to get location: ${e.toString()}',
      );
    } finally {
      isFetchingLocation.value = false;
    }
  }

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
    return 5.5;
  }

  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      final lat = double.tryParse(latitudeController.text);
      final lon = double.tryParse(longitudeController.text);
      if (lat != null && lon != null) {
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
          debugPrint('Error fetching timezone offset from API: $e');
        }
      }
      return 5.5;
    } catch (e) {
      debugPrint('Error calculating timezone offset: $e');
      return 5.5;
    }
  }

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

  Future<void> _updateLocationFromCoordinates(double lat, double lon) async {
    try {
      if (_isDisposed) return;
      final reverseGeocode = await _reverseGeocode(lat, lon);
      if (_isDisposed) return;
      if (reverseGeocode != null && reverseGeocode['city'] != null) {
        selectedLocation.value = reverseGeocode['city'] as String;
      } else {
        selectedLocation.value = 'Current Location';
      }
    } catch (e) {
      if (!_isDisposed) selectedLocation.value = 'Current Location';
    }
  }

  Future<Map<String, dynamic>?> _reverseGeocode(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json&addressdetails=1&accept-language=en',
        ),
        headers: {'User-Agent': 'AstrologyApp/1.0', 'Accept-Language': 'en'},
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>?;
        final address = result?['address'] as Map<String, dynamic>?;
        if (address != null) {
          final city =
              address['city']?.toString() ??
              address['town']?.toString() ??
              address['village']?.toString() ??
              address['municipality']?.toString() ??
              address['city_district']?.toString();
          return {
            'city': city,
            'state':
                address['state']?.toString() ??
                address['region']?.toString() ??
                address['province']?.toString(),
            'country': address['country']?.toString(),
          };
        }
      }
    } catch (e) {
      debugPrint('Error in reverse geocoding: $e');
    }
    return null;
  }
}

