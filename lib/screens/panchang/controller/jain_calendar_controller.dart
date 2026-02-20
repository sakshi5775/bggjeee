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

class JainCalendarController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // Selected tab: 'navkarshi' or 'kalyanak'
  final selectedTab = 'navkarshi'.obs;
  
  // PageController for swipeable tabs
  late PageController pageController;
  
  // Selected year and month
  final selectedYear = DateTime.now().year.obs;
  final selectedMonth = DateTime.now().month.obs;
  
  // Selected section for Kalyanak: 'digambar' or 'shvetambar'
  final selectedSection = 'digambar'.obs;

  // Tab options
  final List<Map<String, dynamic>> tabs = [
    {
      'id': 'navkarshi',
      'title': 'Jain Navkarshi',
    },
    {
      'id': 'kalyanak',
      'title': 'Jain Kalyanak',
    },
  ];

  // State for Navkarshi
  final isLoadingNavkarshi = false.obs;
  final navkarshiData = Rxn<Map<String, dynamic>>();
  final selectedDate = DateTime.now().obs;
  final selectedLocation = 'Fetching Location...'.obs;
  
  // State for Kalyanak
  final isLoadingKalyanak = false.obs;
  final kalyanakData = <Map<String, dynamic>>[].obs;
  
  // Location coordinates
  double? currentLatitude;
  double? currentLongitude;
  double? currentTimezone;
  
  // Flag to track if controller is disposed
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController with 2 tabs
    pageController = PageController(initialPage: 0);
    _tryGetCurrentLocation();
    // Fetch data based on selected tab
    ever(selectedTab, (_) {
      if (selectedTab.value == 'navkarshi') {
        fetchNavkarshiData();
      } else {
        fetchKalyanakData();
      }
    });
    // Initial fetch
    if (selectedTab.value == 'navkarshi') {
      fetchNavkarshiData();
    } else {
      fetchKalyanakData();
    }
  }
  
  @override
  void onClose() {
    pageController.dispose();
    _isDisposed = true;
    super.onClose();
  }
  
  // Handle page change from swipe
  void onPageChanged(int index) {
    final tabId = tabs[index]['id'] as String;
    selectedTab.value = tabId;
  }
  
  // Navigate to specific tab (called from tab tap)
  void onTabSelected(int index) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectTab(String tabId) {
    selectedTab.value = tabId;
    // Find index and sync PageController
    final index = tabs.indexWhere((tab) => tab['id'] == tabId);
    if (index != -1 && pageController.hasClients && pageController.page?.round() != index) {
      pageController.jumpToPage(index);
    }
  }

  void selectYear(int year) {
    selectedYear.value = year;
    if (selectedTab.value == 'kalyanak') {
      fetchKalyanakData();
    }
  }

  void selectMonth(int month) {
    selectedMonth.value = month;
    if (selectedTab.value == 'kalyanak') {
      fetchKalyanakData();
    }
  }

  void selectSection(String section) {
    selectedSection.value = section;
    if (selectedTab.value == 'kalyanak') {
      fetchKalyanakData();
    }
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

      // Fetch navkarshi data if tab is selected
      if (selectedTab.value == 'navkarshi') {
        fetchNavkarshiData();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (_isDisposed) return;
      selectedLocation.value = 'Select Location';
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

  /// Get timezone offset from timezone string
  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      final url = Uri.parse('https://timeapi.io/api/TimeZone/zone?timeZone=$timezone');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final offsetString = data['currentUtcOffset'] as String?;
        if (offsetString != null) {
          return _parseTimezoneOffset(offsetString);
        }
      }
    } catch (e) {
      debugPrint('Error getting timezone offset: $e');
    }
    
    // Fallback: return IST
    return 5.5;
  }

  /// Get timezone offset from coordinates
  Future<double> _getTimezoneOffsetFromCoordinates(double lat, double lon) async {
    try {
      final url = Uri.parse('https://timeapi.io/api/TimeZone/coordinate?latitude=$lat&longitude=$lon');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final offsetString = data['currentUtcOffset'] as String?;
        if (offsetString != null) {
          return _parseTimezoneOffset(offsetString);
        }
      }
    } catch (e) {
      debugPrint('Error getting timezone from coordinates: $e');
    }
    
    // Fallback: return IST
    return 5.5;
  }

  /// Parse timezone offset string (e.g., "+05:30" -> 5.5)
  double _parseTimezoneOffset(String offset) {
    try {
      final cleanOffset = offset.replaceAll('+', '').replaceAll('-', '');
      final parts = cleanOffset.split(':');
      if (parts.length == 2) {
        final hours = double.tryParse(parts[0]) ?? 0;
        final minutes = double.tryParse(parts[1]) ?? 0;
        final isNegative = offset.startsWith('-');
        final total = hours + (minutes / 60);
        return isNegative ? -total : total;
      }
    } catch (e) {
      debugPrint('Error parsing timezone offset: $e');
    }
    return 5.5;
  }

  /// Fetch Jain Navkarshi data
  Future<void> fetchNavkarshiData() async {
    if (currentLatitude == null || currentLongitude == null || currentTimezone == null) {
      // Use default values if location not available
      currentLatitude = 28.6139; // Delhi
      currentLongitude = 77.2090;
      currentTimezone = 5.5;
    }

    try {
      isLoadingNavkarshi.value = true;

      final dateStr = DateFormat('dd/MM/yyyy').format(selectedDate.value);
      final time = DateFormat('HH:mm').format(DateTime.now());

      final data = await _panchangService.getJainNavkarshi(
        date: dateStr,
        time: time,
        latitude: currentLatitude!,
        longitude: currentLongitude!,
        tz: currentTimezone!,
        lang: 'en',
      );

      if (data != null && data['response'] != null) {
        navkarshiData.value = data['response'] as Map<String, dynamic>;
      } else {
        showErrorMessage(title: 'Error', message: 'Failed to fetch Navkarshi data');
      }
    } catch (e) {
      debugPrint('Error fetching navkarshi data: $e');
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isLoadingNavkarshi.value = false;
    }
  }

  /// Fetch Jain Kalyanak data
  Future<void> fetchKalyanakData() async {
    try {
      isLoadingKalyanak.value = true;

      final data = await _panchangService.getJainKalyanak(
        year: selectedYear.value,
        month: selectedMonth.value,
        section: selectedSection.value,
      );

      if (data != null && data['response'] != null) {
        final response = data['response'] as List<dynamic>;
        kalyanakData.value = response.map((e) => e as Map<String, dynamic>).toList();
      } else {
        kalyanakData.clear();
        showErrorMessage(title: 'Error', message: 'Failed to fetch Kalyanak data');
      }
    } catch (e) {
      debugPrint('Error fetching kalyanak data: $e');
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
      kalyanakData.clear();
    } finally {
      isLoadingKalyanak.value = false;
    }
  }
}

