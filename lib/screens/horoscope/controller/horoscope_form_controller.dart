import 'dart:convert';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HoroscopeFormController extends BaseController {
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
  final selectedTime = TimeOfDay.now().obs;
  final selectedLocation = 'Fetching Location...'.obs;
  
  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
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
    // Set default values
    final now = DateTime.now();
    selectedDate.value = now;
    dateController.text = DateFormat('dd/MM/yyyy').format(now);
    final currentTime = TimeOfDay.now();
    selectedTime.value = currentTime;
    timeController.text = DateFormat('HH:mm').format(
      DateTime(now.year, now.month, now.day, currentTime.hour, currentTime.minute),
    );
    timezoneController.text = '5.5'; // Default IST
    
    // Try to get current location on init
    _tryGetCurrentLocation();
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
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Check again if controller is disposed before using it
      if (_isDisposed) return;

      // Set coordinates
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);

      // Update location name
      await _updateLocationFromCoordinates(position.latitude, position.longitude);

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
        final city = reverseGeocode['city'] ?? reverseGeocode['town'] ?? reverseGeocode['village'] ?? '';
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
      
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'AstrologyApp',
        },
      ).timeout(const Duration(seconds: 10));

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
  Future<double> _getTimezoneOffsetFromCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse('https://timeapi.io/api/TimeZone/coordinate?latitude=$lat&longitude=$lon');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final offsetString = data['currentUtcOffset']?.toString() ?? '5.5';
        // Parse offset like "+05:30" to 5.5
        final offset = double.tryParse(offsetString.replaceAll(':', '.').replaceAll('+', '')) ?? 5.5;
        return offset;
      }
    } catch (e) {
      debugPrint('Error getting timezone: $e');
    }
    return 5.5; // Default IST
  }

  /// Fetch location from city name
  Future<void> fetchLocationFromCity(String city, {String? state, String? country = 'India'}) async {
    try {
      isFetchingLocation.value = true;
      
      final result = await AddressHelper.fetchCoordinatesFromCity(
        city: city,
        state: state ?? '',
        country: country ?? 'India',
      );

      if (_isDisposed) return;

      if (result != null) {
        final lat = result['latitude'] as double?;
        final lon = result['longitude'] as double?;
        final tz = result['timezone'] as String?;

        if (lat != null && lon != null) {
          latitudeController.text = lat.toStringAsFixed(6);
          longitudeController.text = lon.toStringAsFixed(6);
          
          selectedLocation.value = state != null && state.isNotEmpty 
              ? '$city, $state' 
              : city;

          // Update timezone
          if (tz != null) {
            final offset = double.tryParse(tz) ?? 5.5;
            timezoneController.text = offset.toString();
          } else {
            final offset = await _getTimezoneOffsetFromCoordinates(lat, lon);
            timezoneController.text = offset.toString();
          }
        } else {
          showErrorMessage(title: 'Error', message: 'Could not fetch coordinates for $city');
        }
      } else {
        showErrorMessage(title: 'Error', message: 'Location not found. Please try again.');
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
      showErrorMessage(title: 'Error', message: 'Failed to fetch location. Please try again.');
    } finally {
      if (!_isDisposed) {
        isFetchingLocation.value = false;
      }
    }
  }

  /// Use current location
  Future<void> useCurrentLocation() async {
    try {
      isFetchingLocation.value = true;
      
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showErrorMessage(title: 'Error', message: 'Location services are disabled. Please enable them in settings.');
        isFetchingLocation.value = false;
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showErrorMessage(title: 'Error', message: 'Location permission is required. Please grant permission in settings.');
          isFetchingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showErrorMessage(title: 'Error', message: 'Location permission is permanently denied. Please enable it in app settings.');
        isFetchingLocation.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_isDisposed) return;

      // Set coordinates
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);

      // Update location name
      await _updateLocationFromCoordinates(position.latitude, position.longitude);

      // Get timezone
      final offset = await _getTimezoneOffsetFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (!_isDisposed) {
        timezoneController.text = offset.toString();
      }
    } catch (e) {
      debugPrint('Error using current location: $e');
      showErrorMessage(title: 'Error', message: 'Failed to get current location. Please try again.');
    } finally {
      if (!_isDisposed) {
        isFetchingLocation.value = false;
      }
    }
  }

  /// Set selected date
  void _setSelectedDate(DateTime picked) {
    if (!_isDisposed && picked != selectedDate.value) {
      selectedDate.value = picked;
      dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  /// Show date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: "#6F221E".toColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: "#6F221E".toColor(),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _setSelectedDate(picked);
    }
  }

  /// Set selected time
  void _setSelectedTime(TimeOfDay picked) {
    if (!_isDisposed && picked != selectedTime.value) {
      selectedTime.value = picked;
      final now = DateTime.now();
      timeController.text = DateFormat('HH:mm').format(
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
      );
    }
  }

  /// Show time picker
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: "#6F221E".toColor(),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: "#6F221E".toColor(),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _setSelectedTime(picked);
    }
  }

  /// Validate form
  bool _validateForm() {
    if (dateController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select date of birth');
      return false;
    }

    if (timeController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select time of birth');
      return false;
    }

    if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select location');
      return false;
    }

    if (timezoneController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Timezone is missing. Please select location again.');
      return false;
    }

    return true;
  }

  /// Submit form and navigate to sign selection
  void submitForm() {
    if (!_validateForm()) {
      return;
    }

    // Prepare form data
    final formData = {
      'date': dateController.text,
      'time': timeController.text,
      'latitude': double.parse(latitudeController.text),
      'longitude': double.parse(longitudeController.text),
      'timezone': double.parse(timezoneController.text),
      'place': selectedLocation.value,
      'language': selectedLanguage.value,
    };

    // Navigate to sign selection with form data
    Get.toNamed(
      AppRoutes.horoscopeSignSelection,
      arguments: {
        'formData': formData,
      },
    );
  }
}

