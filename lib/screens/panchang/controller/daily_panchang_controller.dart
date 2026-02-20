import 'dart:convert';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DailyPanchangController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // Form controllers
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final timezoneController = TextEditingController();

  // Language selection
  final selectedLanguage = 'en'.obs; // Default to English
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
  final panchangData = Rxn<Map<String, dynamic>>();
  final selectedDate = DateTime.now().obs;
  final selectedLocation = 'Loading...'.obs;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
  }

  void _initializeForm() {
    // Check if arguments are passed (from monthly calendar navigation)
    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null && arguments['date'] != null) {
      // Use date from arguments
      final date = arguments['date'] as DateTime;
      selectedDate.value = date;
      dateController.text = DateFormat('dd/MM/yyyy').format(date);

      // Use location data from arguments if available
      if (arguments['latitude'] != null) {
        latitudeController.text = (arguments['latitude'] as double)
            .toStringAsFixed(6);
      }
      if (arguments['longitude'] != null) {
        longitudeController.text = (arguments['longitude'] as double)
            .toStringAsFixed(6);
      }
      if (arguments['timezone'] != null) {
        timezoneController.text = (arguments['timezone'] as double).toString();
      }
      if (arguments['location'] != null) {
        selectedLocation.value = arguments['location'] as String;
      }

      // Set current time (12h display)
      final now = DateTime.now();
      timeController.text = TimePickerHelper.formatTime24To12Display(
        now.hour,
        now.minute,
      );

      // Auto-fetch panchang data
      Future.delayed(const Duration(milliseconds: 500), () {
        fetchPanchang();
      });
    } else {
      // Default initialization
      final now = DateTime.now();
      selectedDate.value = now;
      dateController.text = DateFormat('dd/MM/yyyy').format(now);
      timeController.text = TimePickerHelper.formatTime24To12Display(
        now.hour,
        now.minute,
      );
      timezoneController.text = '5.5'; // Default IST

      // Try to get current location on init
      _tryGetCurrentLocation();
    }
  }

  /// Try to get current location silently on initialization
  Future<void> _tryGetCurrentLocation() async {
    try {
      // Check if controller is disposed
      if (_isDisposed) return;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!_isDisposed) {
          selectedLocation.value = 'Select Location';
        }
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!_isDisposed) {
            selectedLocation.value = 'Select Location';
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!_isDisposed) {
          selectedLocation.value = 'Select Location';
        }
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Use high for better accuracy
        timeLimit: const Duration(seconds: 5),
      );

      // Check again if controller is disposed before using it
      if (_isDisposed) return;

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

      // Final check before setting timezone
      if (!_isDisposed) {
        timezoneController.text = offset.toString();
      }
    } catch (e) {
      debugPrint('Error getting initial location: $e');
      // Only update if controller is not disposed
      if (!_isDisposed) {
        selectedLocation.value = 'Select Location';
      }
    }
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

  /// Get current location and auto-fill fields
  Future<void> getCurrentLocation() async {
    try {
      isFetchingLocation.value = true;

      // Check if geolocator plugin is available
      try {
        // Test if plugin is available by checking a simple method
        await Geolocator.isLocationServiceEnabled();
      } on MissingPluginException catch (e) {
        showErrorMessage(
          title: 'Location Service Unavailable',
          message:
              'Location service plugin is not available. Please:\n\n1. Stop the app completely\n2. Run: flutter clean\n3. Run: flutter pub get\n4. Rebuild the app (not hot reload)\n\nYou can manually enter coordinates in the meantime.',
        );
        debugPrint('Geolocator plugin not found: $e');
        return;
      }

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Open location settings to enable location services
        final opened = await Geolocator.openLocationSettings();
        if (!opened) {
          showErrorMessage(
            title: 'Location Service',
            message:
                'Location services are disabled. Please enable them in your device settings.',
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showErrorMessage(
            title: 'Permission Denied',
            message:
                'Location permissions are denied. Please enable them in settings.',
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showErrorMessage(
          title: 'Permission Denied',
          message:
              'Location permissions are permanently denied. Please enable them in app settings.',
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Check if controller is disposed before using it
      if (_isDisposed) return;

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

      // Always calculate and set timezone offset (even if timezone string is null, use coordinates)
      double offset;
      if (timezone != null && timezone.isNotEmpty) {
        // Convert timezone to offset (e.g., "Asia/Kolkata" -> 5.5)
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

      showSuccessMessage(
        title: 'Success',
        message: 'Location fetched successfully',
      );
    } on MissingPluginException catch (e) {
      // Handle missing plugin exception
      showErrorMessage(
        title: 'Location Service Unavailable',
        message:
            'Location service is not available. Please rebuild the app after running "flutter pub get".\n\nYou can manually enter your coordinates instead.',
      );
      debugPrint('Geolocator plugin not found: $e');
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message:
            'Failed to get location: ${e.toString()}\n\nYou can manually enter your coordinates instead.',
      );
      debugPrint('Location error: $e');
    } finally {
      isFetchingLocation.value = false;
    }
  }

  /// Get timezone offset directly from coordinates (fallback method)
  Future<double> _getTimezoneOffsetFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // Try to get offset from timezone API
      try {
        final response = await http.get(
          Uri.parse(
            'https://timeapi.io/api/TimeZone/coordinate?latitude=$latitude&longitude=$longitude',
          ),
          headers: {'Accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>?;
          // Check for currentUtcOffset field
          if (data?['currentUtcOffset'] != null) {
            final offsetStr = data!['currentUtcOffset'].toString();
            final offset = _parseTimezoneOffset(offsetStr);
            if (offset != null) {
              debugPrint('Timezone offset from API (coordinates): $offset');
              return offset;
            }
          }
          // Alternative: Check for offset field
          if (data?['offset'] != null) {
            final offset = double.tryParse(data!['offset'].toString());
            if (offset != null) {
              debugPrint('Timezone offset from API (offset field): $offset');
              return offset;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching timezone offset from API: $e');
      }

      // Fallback: Use coordinate-based estimation
      if (latitude >= 6 &&
          latitude <= 37 &&
          longitude >= 68 &&
          longitude <= 97) {
        return 5.5; // Indian subcontinent
      }

      // Default to UTC
      return 0.0;
    } catch (e) {
      debugPrint('Error calculating timezone offset from coordinates: $e');
      return 5.5; // Default to IST
    }
  }

  /// Get timezone offset from timezone string dynamically
  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      // Try to get offset from timezone API if available
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
            // Check for currentUtcOffset field
            if (data?['currentUtcOffset'] != null) {
              final offsetStr = data!['currentUtcOffset'].toString();
              // Parse offset like "+05:30" or "+05:30:00" to 5.5
              final offset = _parseTimezoneOffset(offsetStr);
              if (offset != null) {
                debugPrint('Timezone offset from API: $offset');
                return offset;
              }
            }
            // Alternative: Check for offset field
            if (data?['offset'] != null) {
              final offset = double.tryParse(data!['offset'].toString());
              if (offset != null) {
                debugPrint('Timezone offset from API (offset field): $offset');
                return offset;
              }
            }
          }
        } catch (e) {
          debugPrint('Error fetching timezone offset from API: $e');
        }
      }

      // Fallback: Use known timezone offsets
      final offsetMap = {
        'Asia/Kolkata': 5.5,
        'Asia/Calcutta': 5.5,
        'Asia/Delhi': 5.5,
        'Asia/Mumbai': 5.5,
        'Asia/Chennai': 5.5,
        'Asia/Bangalore': 5.5,
        'Asia/Hyderabad': 5.5,
        'America/New_York': -5.0,
        'America/Los_Angeles': -8.0,
        'America/Chicago': -6.0,
        'Europe/London': 0.0,
        'Europe/Paris': 1.0,
        'Europe/Berlin': 1.0,
        'Asia/Dubai': 4.0,
        'Asia/Singapore': 8.0,
        'Asia/Tokyo': 9.0,
        'Australia/Sydney': 10.0,
        'Australia/Melbourne': 10.0,
      };

      // Check if timezone matches any key (case-insensitive)
      for (final entry in offsetMap.entries) {
        if (timezone.toLowerCase().contains(
          entry.key.toLowerCase().split('/').last,
        )) {
          return entry.value;
        }
      }

      // If timezone contains common patterns
      if (timezone.toLowerCase().contains('kolkata') ||
          timezone.toLowerCase().contains('calcutta') ||
          timezone.toLowerCase().contains('delhi') ||
          timezone.toLowerCase().contains('mumbai') ||
          timezone.toLowerCase().contains('chennai') ||
          timezone.toLowerCase().contains('bangalore') ||
          timezone.toLowerCase().contains('hyderabad') ||
          timezone.toLowerCase().contains('india')) {
        return 5.5; // IST
      }

      // Default to IST if in Indian coordinates range
      if (lat != null && lon != null) {
        if (lat >= 6 && lat <= 37 && lon >= 68 && lon <= 97) {
          return 5.5; // Indian subcontinent
        }
      }

      // Default to UTC (0.0)
      return 0.0;
    } catch (e) {
      debugPrint('Error calculating timezone offset: $e');
      // Default to IST for safety
      return 5.5;
    }
  }

  /// Parse timezone offset string like "+05:30" or "+05:30:00" to double like 5.5
  double? _parseTimezoneOffset(String offsetStr) {
    try {
      // Remove any whitespace
      offsetStr = offsetStr.trim();

      // Handle formats like "+05:30", "-05:30", "+05:30:00"
      if (offsetStr.startsWith('+') || offsetStr.startsWith('-')) {
        final sign = offsetStr.startsWith('+') ? 1 : -1;
        final parts = offsetStr.substring(1).split(':');

        if (parts.length >= 2) {
          final hours = int.tryParse(parts[0]) ?? 0;
          final minutes = int.tryParse(parts[1]) ?? 0;

          // Convert to decimal (e.g., 5 hours 30 minutes = 5.5)
          final offset = hours + (minutes / 60.0);
          return sign * offset;
        }
      }

      // Try to parse as direct number
      final directOffset = double.tryParse(offsetStr);
      if (directOffset != null) {
        return directOffset;
      }
    } catch (e) {
      debugPrint('Error parsing timezone offset: $e');
    }
    return null;
  }

  /// Select date
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
    }
  }

  /// Select time (12h AM/PM picker and display)
  Future<void> selectTime() async {
    final now = DateTime.now();
    final picked = await TimePickerHelper.showTimePicker12h(
      Get.context!,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (picked != null) {
      timeController.text = TimePickerHelper.formatTime24To12Display(
        picked.hour,
        picked.minute,
      );
    }
  }

  /// Navigate to previous date
  void previousDate() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate.value);
    if (panchangData.value != null) {
      fetchPanchang();
    }
  }

  /// Navigate to next date
  void nextDate() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate.value);
    if (panchangData.value != null) {
      fetchPanchang();
    }
  }

  /// Go to today's date
  void goToToday() {
    selectedDate.value = DateTime.now();
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate.value);
    final now = DateTime.now();
    timeController.text = TimePickerHelper.formatTime24To12Display(
      now.hour,
      now.minute,
    );
    if (panchangData.value != null) {
      fetchPanchang();
    }
  }

  /// Fetch panchang data
  Future<void> fetchPanchang() async {
    // Validate form
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
      final data = await _panchangService.getDailyPanchang(
        date: dateController.text,
        time: time24,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: selectedLanguage.value,
      );

      if (data != null) {
        panchangData.value = data['response'] as Map<String, dynamic>?;
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to fetch panchang data',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Select city and auto-fill coordinates
  Future<void> selectCity(
    String cityName,
    String? state,
    String? country,
  ) async {
    try {
      isFetchingLocation.value = true;
      selectedLocation.value = cityName;

      final result = await AddressHelper.fetchCoordinatesFromCity(
        city: cityName,
        state: state,
        country: country ?? 'India',
      );

      if (result != null) {
        latitudeController.text = result['latitude']?.toStringAsFixed(6) ?? '';
        longitudeController.text =
            result['longitude']?.toStringAsFixed(6) ?? '';

        // Get timezone offset
        final lat = result['latitude'] as double?;
        final lon = result['longitude'] as double?;
        if (lat != null && lon != null) {
          final offset = await _getTimezoneOffsetFromCoordinates(lat, lon);
          timezoneController.text = offset.toString();
        }

        // Update location name
        selectedLocation.value = cityName;

        showSuccessMessage(
          title: 'Success',
          message: 'Location updated to $cityName',
        );
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Could not find coordinates for $cityName',
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Failed to get location: ${e.toString()}',
      );
      debugPrint('Error selecting city: $e');
    } finally {
      isFetchingLocation.value = false;
    }
  }

  /// Update location name from coordinates using reverse geocoding
  Future<void> _updateLocationFromCoordinates(double lat, double lon) async {
    try {
      // Check if controller is disposed
      if (_isDisposed) return;

      // Use reverse geocoding directly
      final reverseGeocode = await _reverseGeocode(lat, lon);

      // Check again before updating
      if (_isDisposed) return;

      if (reverseGeocode != null && reverseGeocode['city'] != null) {
        selectedLocation.value = reverseGeocode['city'] as String;
        debugPrint('Location updated to: ${selectedLocation.value}');
      } else {
        // Fallback: Try to get from coordinates using a simple lookup
        if (!_isDisposed) {
          selectedLocation.value = 'Current Location';
        }
      }
    } catch (e) {
      debugPrint('Error updating location name: $e');
      // Only update if controller is not disposed
      if (!_isDisposed) {
        selectedLocation.value = 'Current Location';
      }
    }
  }

  /// Reverse geocoding to get city name from coordinates
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

