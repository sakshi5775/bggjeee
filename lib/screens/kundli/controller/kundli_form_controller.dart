import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/report_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:astrobharataiuser/widgets/report_insufficient_balance_dialog.dart';
import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';

class KundliFormController extends BaseController {
  final KundliService _kundliService = KundliService();
  final UserProfileService _userProfileService = UserProfileService();
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
    }
    _initializeForm();
    _loadUserProfileData();
  }

  /// Load user profile (name, gender, DOB, time of birth, location) to prefill Kundli form.
  /// Ensures saved profile DOB and TOB are used instead of current date/time when available.
  Future<void> _loadUserProfileData() async {
    try {
      final userId = UserData().getLoginData.user?.userId;
      if (userId == null) return;
      final profile = await _userProfileService.getProfile(userId);
      if (profile == null) return;
      if (_isDisposed) return;

      // Prefill name and gender
      if (profile.personalInfo != null) {
        final fullName = profile.personalInfo!.fullName;
        if (fullName != null &&
            fullName.isNotEmpty &&
            nameController.text.isEmpty) {
          nameController.text = fullName;
        }
        final gender = profile.personalInfo!.gender;
        if (gender != null &&
            gender.isNotEmpty &&
            selectedGender.value == null) {
          if (gender.toUpperCase() == 'MALE') {
            selectedGender.value = 'Male';
          } else if (gender.toUpperCase() == 'FEMALE') {
            selectedGender.value = 'Female';
          } else {
            selectedGender.value = gender;
          }
        }
      }

      // Prefill DOB from personalInfo.dateOfBirth or birthChart.generatedAt
      String? dateStr = profile.personalInfo?.dateOfBirth;
      if (dateStr == null && profile.birthChart?.generatedAt != null) {
        dateStr = profile.birthChart!.generatedAt!;
      }
      if (dateStr != null && dateStr.isNotEmpty) {
        try {
          DateTime? dob;
          final isoDate = DateTime.tryParse(dateStr);
          if (isoDate != null) {
            dob = isoDate;
          } else {
            final parts = dateStr.split(RegExp(r'[/\-]'));
            if (parts.length >= 3) {
              int? day, month, year;
              // yyyy-MM-dd (e.g. 2002-01-30) vs dd/MM/yyyy (e.g. 30/01/2002)
              if (parts[0].length == 4 && int.tryParse(parts[0]) != null) {
                year = int.tryParse(parts[0]);
                month = int.tryParse(parts[1]);
                day = int.tryParse(parts[2]);
              } else {
                day = int.tryParse(parts[0]);
                month = int.tryParse(parts[1]);
                year = int.tryParse(parts[2]);
              }
              if (day != null && month != null && year != null) {
                dob = DateTime(year, month, day);
              }
            }
          }
          if (dob != null && !_isDisposed) {
            selectedDate.value = dob;
            dateController.text = DateFormat('dd/MM/yyyy').format(dob);
          }
        } catch (e) {
          debugPrint('Error parsing profile DOB: $e');
        }
      }

      // Prefill time of birth from birthChart.birthTime
      if (profile.birthChart?.birthTime != null && !_isDisposed) {
        final bt = profile.birthChart!.birthTime!;
        final h = (bt.hour ?? 0).clamp(0, 23);
        final m = (bt.minute ?? 0).clamp(0, 59);
        selectedTime.value = TimeOfDay(hour: h, minute: m);
        timeController.text = DateFormat(
          'HH:mm',
        ).format(DateTime(0, 1, 1, h, m));
      }

      // Prefill birth place / location from birthChart.birthPlace
      if (profile.birthChart?.birthPlace != null && !_isDisposed) {
        final place = profile.birthChart!.birthPlace!;
        if (place.latitude != null && place.longitude != null) {
          latitudeController.text = place.latitude!.toStringAsFixed(6);
          longitudeController.text = place.longitude!.toStringAsFixed(6);
        }
        if (place.timezone != null && place.timezone!.isNotEmpty) {
          timezoneController.text = place.timezone!;
        }
        final city = place.city ?? '';
        final state = place.state ?? '';
        if (city.isNotEmpty) {
          selectedLocation.value = state.isNotEmpty ? '$city, $state' : city;
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile for Kundli form: $e');
    }
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
    if (dateController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select date of birth');
      return;
    }
    if (timeController.text.isEmpty) {
      showErrorMessage(title: 'Error', message: 'Please select birth time');
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
          Get.toNamed(targetRoute!, arguments: {'formData': formDataMap});
        } else {
          // Navigate to result page with data (default behavior)
          // Note: name and gender are included in formData but NOT sent to API
          Get.toNamed(
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
        Get.toNamed(
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

