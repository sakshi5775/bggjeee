import 'dart:convert';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PanchangController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // Selected navigation tab
  final RxString selectedNavTab = 'Panchang'.obs;

  // Navigation tabs
  final List<String> navTabs = [
    'ult',
    'Reports',
    'Video',
    'Panchang',
    'Horoscope',
  ];

  // Sun/Moon times
  final sunriseTime = ''.obs;
  final sunsetTime = ''.obs;
  final moonriseTime = ''.obs;
  final moonsetTime = ''.obs;
  final solarNoonTime = ''.obs;
  final moonPhaseData = Rxn<Map<String, dynamic>>();
  final isLoadingTimes = false.obs;

  // Location coordinates
  double? currentLatitude;
  double? currentLongitude;
  double? currentTimezone;

  // Flag to track if controller is disposed
  bool _isDisposed = false;

  // Panchang features data - using getter for dynamic year
  List<Map<String, dynamic>> get panchangFeatures => [
    {
      'title': 'Daily Panchang',
      'icon': Icons.auto_awesome,
      'route': null, // TODO: Add route when feature is implemented
    },
    {
      'title': 'Monthly Calendar',
      'icon': Icons.calendar_month,
      'route': AppRoutes.monthlyCalendar,
    },
    {
      'title': 'Hindu Calendar',
      'icon': Icons.calendar_today,
      'route': AppRoutes.hinduCalendar,
    },
    {
      'title': 'Yearly Vrat',
      'icon': Icons.wb_sunny,
      'route': AppRoutes.yearlyVrat,
    },
    {
      'title': 'Festival ${DateTime.now().year}',
      'icon': Icons.event,
      'route': AppRoutes.festivalYearly,
    },
    {'title': 'Hora', 'icon': Icons.access_time, 'route': AppRoutes.hora},
    {'title': 'Chogadia', 'icon': Icons.schedule, 'route': AppRoutes.chogadia},
    // {
    //   'title': 'Do Ghati',
    //   'icon': Icons.timer,
    //   'route': null,
    // },
    {
      'title': 'Rahu Kaal',
      'icon': Icons.watch_later,
      'route': AppRoutes.rahukaal,
    },
    {
      'title': 'Other Calendars',
      'icon': Icons.calendar_view_month,
      'route': AppRoutes.otherCalendars,
    },
    // {
    //   'title': 'Panchak',
    //   'icon': Icons.all_inclusive,
    //   'route': null,
    // },
    {'title': 'Bhadra', 'icon': Icons.timer_outlined, 'route': null},
    {'title': 'Muhurat', 'icon': Icons.celebration, 'route': null},
    // {
    //   'title': 'Lagna Table',
    //   'icon': Icons.table_chart,
    //   'route': null,
    // },
  ];

  @override
  void onInit() {
    super.onInit();
    _tryGetCurrentLocation();
    fetchSunMoonTimes();
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
        return;
      }

      if (!serviceEnabled) {
        if (_isDisposed) return;
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (_isDisposed) return;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (_isDisposed) return;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_isDisposed) return;

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
      debugPrint('Error getting location: $e');
      // Use default values
      currentLatitude = 28.6139;
      currentLongitude = 77.2090;
      currentTimezone = 5.5;
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

  /// Fetch sun and moon times
  Future<void> fetchSunMoonTimes() async {
    if (currentLatitude == null ||
        currentLongitude == null ||
        currentTimezone == null) {
      // Use default values if location not available
      currentLatitude = 28.6139; // Delhi default
      currentLongitude = 77.2090;
      currentTimezone = 5.5;
    }

    try {
      isLoadingTimes.value = true;

      final now = DateTime.now();
      final dateStr = DateFormat('dd/MM/yyyy').format(now);
      final time = DateFormat('HH:mm').format(now);

      // Fetch all times in parallel
      final results = await Future.wait([
        _panchangService.getSunrise(
          date: dateStr,
          time: time,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          tz: currentTimezone!,
          lang: 'en',
        ),
        _panchangService.getSunset(
          date: dateStr,
          time: time,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          tz: currentTimezone!,
          lang: 'en',
        ),
        _panchangService.getMoonrise(
          date: dateStr,
          time: time,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          tz: currentTimezone!,
          lang: 'en',
        ),
        _panchangService.getMoonset(
          date: dateStr,
          time: time,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          tz: currentTimezone!,
          lang: 'en',
        ),
        _panchangService.getSolarNoon(
          date: dateStr,
          time: time,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          tz: currentTimezone!,
          lang: 'en',
        ),
        _panchangService.getMoonPhase(
          date: dateStr,
          time: time,
          latitude: currentLatitude!,
          longitude: currentLongitude!,
          tz: currentTimezone!,
          lang: 'en',
        ),
      ]);

      // Update times
      if (results[0] != null && results[0]!['response'] != null) {
        final response = results[0]!['response'] as Map<String, dynamic>;
        sunriseTime.value = response['sunrise']?.toString() ?? '';
      }

      if (results[1] != null && results[1]!['response'] != null) {
        final response = results[1]!['response'] as Map<String, dynamic>;
        sunsetTime.value = response['sunset']?.toString() ?? '';
      }

      if (results[2] != null && results[2]!['response'] != null) {
        final response = results[2]!['response'] as Map<String, dynamic>;
        moonriseTime.value = response['moonrise']?.toString() ?? '';
      }

      if (results[3] != null && results[3]!['response'] != null) {
        final response = results[3]!['response'] as Map<String, dynamic>;
        moonsetTime.value = response['moonset']?.toString() ?? '';
      }

      if (results[4] != null) {
        if (kDebugMode) {
          debugPrint('Solar Noon API Response: ${results[4]}');
        }
        if (results[4]!['response'] != null) {
          final response = results[4]!['response'] as Map<String, dynamic>;
          if (kDebugMode) {
            debugPrint('Solar Noon Response Data: $response');
            debugPrint('Solar Noon Value: ${response['solarNoon']}');
          }
          solarNoonTime.value = response['solarNoon']?.toString() ?? '';
          if (kDebugMode) {
            debugPrint('Solar Noon Time Set To: ${solarNoonTime.value}');
          }
        } else {
          if (kDebugMode) {
            debugPrint('Solar Noon: response key is null in data');
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint('Solar Noon: results[4] is null');
        }
      }

      if (results[5] != null && results[5]!['response'] != null) {
        final response = results[5]!['response'] as Map<String, dynamic>;
        moonPhaseData.value = response;
      }
    } catch (e) {
      debugPrint('Error fetching sun/moon times: $e');
    } finally {
      isLoadingTimes.value = false;
    }
  }

  void setSelectedNavTab(String tab) {
    selectedNavTab.value = tab;
    // TODO: Handle navigation to different tabs
    if (tab == 'Horoscope') {
      Get.toNamed('/horoscope');
    } else if (tab == 'Reports') {
      Get.toNamed('/stream-reports');
    }
  }

  void onFeatureTap(Map<String, dynamic> feature) {
    final title = feature['title'] as String;
    if (title == 'Daily Panchang') {
      Get.toNamed(AppRoutes.dailyPanchang);
    } else if (title == 'Monthly Calendar') {
      Get.toNamed(AppRoutes.monthlyCalendar);
    } else if (title == 'Hindu Calendar') {
      Get.toNamed(AppRoutes.hinduCalendar);
    } else if (title == 'Yearly Vrat') {
      Get.toNamed(AppRoutes.yearlyVrat);
    } else if (title.startsWith('Festival ')) {
      // Handle dynamic festival year title (e.g., "Festival 2025", "Festival 2026")
      Get.toNamed(AppRoutes.festivalYearly);
    } else if (title == 'Hora') {
      Get.toNamed(AppRoutes.hora);
    } else if (title == 'Chogadia') {
      Get.toNamed(AppRoutes.chogadia);
    } else if (title == 'Muhurat') {
      Get.toNamed(AppRoutes.muhurat);
    } else if (title == 'Rahu Kaal') {
      Get.toNamed(AppRoutes.rahukaal);
    } else if (title == 'Bhadra') {
      Get.toNamed(AppRoutes.bhadra);
    } else if (title == 'Other Calendars') {
      Get.toNamed(AppRoutes.otherCalendars);
    } else {
      Get.snackbar(
        'Coming Soon',
        '$title feature will be available soon',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
