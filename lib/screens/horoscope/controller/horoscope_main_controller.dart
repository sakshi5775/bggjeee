import 'dart:convert';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/horoscope/service/horoscope_service.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/location_prompt_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HoroscopeMainController extends BaseController {
  final HoroscopeService _horoscopeService = HoroscopeService();
  final KundliService _kundliService = KundliService();

  // Selected sign from previous page
  final selectedSign = Rxn<String>();

  // Tab widget selections (for embedded tab)
  final selectedCategory =
      Rxn<String>(); // Daily, Weekly, Weekly Love, Monthly, Yearly
  final selectedZodiac = Rxn<String>(); // Aries, Taurus, etc.

  // Form visibility state for tab widget
  final showEmbeddedForm = false.obs;
  // Track if sign was manually selected to determine back navigation
  final isManualSignSelection = false.obs;

  // Form data (date, time, location)
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final placeController = TextEditingController();

  // Location data
  double? latitude;
  double? longitude;
  double? timezone;

  // Selected tab index
  final selectedTabIndex = 0.obs;

  // PageController for swipeable tabs
  late final PageController pageController;

  // ScrollController for tab slider
  final ScrollController tabScrollController = ScrollController();

  // Keys for each tab to support auto-scrolling parity
  final Map<int, GlobalKey> tabKeys = {};

  // Daily prediction day selection (today, tomorrow, yesterday)
  final selectedDay = 'today'.obs;
  final List<String> dayOptions = ['yesterday', 'today', 'tomorrow'];

  // Tab names
  final tabs = [
    'Key Points',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'Moon Sign',
    'Sun Sign',
    'Ascendant Sign',
    'Current Sade Sati',
    'Gem Suggestion',
    'Rudraksh Suggestion',
    'Friendship Table',
    'Planet KP',
  ];

  // Data observables
  final extendedKundaliData = Rxn<Map<String, dynamic>>();
  final dailyPredictionData = Rxn<Map<String, dynamic>>();
  final weeklyPredictionData = Rxn<Map<String, dynamic>>();
  final monthlyPredictionData = Rxn<Map<String, dynamic>>();
  final yearlyPredictionData = Rxn<Map<String, dynamic>>();
  final moonSignData = Rxn<Map<String, dynamic>>();
  final sunSignData = Rxn<Map<String, dynamic>>();
  final ascendantSignData = Rxn<Map<String, dynamic>>();
  final sadeSatiData = Rxn<Map<String, dynamic>>();
  final gemSuggestionData = Rxn<Map<String, dynamic>>();
  final rudrakshSuggestionData = Rxn<Map<String, dynamic>>();
  final friendshipTableData = Rxn<Map<String, dynamic>>();
  final planetKpData = Rxn<Map<String, dynamic>>();

  // Loading states
  final isLoadingExtendedKundali = false.obs;
  final isLoadingDaily = false.obs;
  final isLoadingWeekly = false.obs;
  final isLoadingMonthly = false.obs;
  final isLoadingYearly = false.obs;
  final isLoadingMoonSign = false.obs;
  final isLoadingSunSign = false.obs;
  final isLoadingAscendantSign = false.obs;
  final isLoadingSadeSati = false.obs;
  final isLoadingGemSuggestion = false.obs;
  final isLoadingRudrakshSuggestion = false.obs;
  final isLoadingFriendshipTable = false.obs;
  final isLoadingPlanetKp = false.obs;
  final detectedNakshatra = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      selectedSign.value = arguments['selectedSign'] as String?;
      // If form data is passed, use it
      if (arguments['formData'] != null) {
        final formData = arguments['formData'] as Map<String, dynamic>;
        dateController.text = formData['date']?.toString() ?? '';
        timeController.text = formData['time']?.toString() ?? '';
        placeController.text = formData['place']?.toString() ?? '';
        latitude = formData['latitude'] as double?;
        longitude = formData['longitude'] as double?;
        timezone = formData['timezone'] as double?;
      }
    }

    // Set default date/time if not provided
    if (dateController.text.isEmpty) {
      dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
    if (timeController.text.isEmpty) {
      timeController.text = DateFormat('HH:mm').format(DateTime.now());
    }

    // Initialize location and then load data
    _initializeLocationAndLoadData();
  }

  Future<void> _initializeLocationAndLoadData() async {
    // If no form data, try to get current location
    if (latitude == null || longitude == null) {
      await _getCurrentLocation();
    }

    // Wait for next frame to ensure widget is fully built before showing errors or loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load first tab data after location is ready
      if (latitude != null && longitude != null && timezone != null) {
        _loadTabData(0);
      } else {
        // Show error after build is complete
        Future.delayed(const Duration(milliseconds: 100), () {
          showErrorMessage(
            title: 'Error',
            message: 'Location data is missing. Please try again.',
          );
        });
      }
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    tabScrollController.dispose();
    dateController.dispose();
    timeController.dispose();
    placeController.dispose();
    super.onClose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationPromptHelper.checkAndGetLocation();
      if (position == null) {
        // Set defaults if location failed/denied
        latitude = 28.6139;
        longitude = 77.2090;
        timezone = 5.5;
        placeController.text = 'New Delhi, India';
        return;
      }
      latitude = position.latitude;
      longitude = position.longitude;

      // Get timezone from address helper (static method)
      final tzString = await AddressHelper.getTimezoneFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (tzString != null) {
        timezone = double.tryParse(tzString) ?? 5.5;
      } else {
        timezone = 5.5;
      }

      // Get place name using reverse geocoding
      final reverseGeocode = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );
      if (reverseGeocode != null) {
        final city =
            reverseGeocode['city'] ??
            reverseGeocode['town'] ??
            reverseGeocode['village'] ??
            '';
        final state = reverseGeocode['state'] ?? '';
        final country = reverseGeocode['country'] ?? '';
        final addressParts = [
          city,
          state,
          country,
        ].where((e) => e.isNotEmpty).toList();
        placeController.text = addressParts.isNotEmpty
            ? addressParts.join(', ')
            : 'Unknown Location';
      } else {
        placeController.text = 'Unknown Location';
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      // Set defaults
      latitude = 28.6139;
      longitude = 77.2090;
      timezone = 5.5;
      placeController.text = 'New Delhi, India';
    }
  }

  Future<Map<String, dynamic>?> _reverseGeocode(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
      );

      final response = await http
          .get(url, headers: {'User-Agent': 'AstrologyApp/1.0'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final address = data['address'] as Map<String, dynamic>? ?? {};
        return address;
      }
    } catch (e) {
      debugPrint('Error in reverse geocoding: $e');
    }
    return null;
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollToTab(index);
    _loadTabData(index);
  }

  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    _scrollToTab(index);
    _loadTabData(index);
  }

  void _scrollToTab(int index) {
    if (!tabScrollController.hasClients) return;

    // Use GlobalKey to scroll the tab into view if available
    final key = tabKeys[index];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5, // Center the tab
      );
    } else {
      // Fallback: Calculate approximate position
      final double tabWidth = 120.0;
      final double screenWidth = tabScrollController.position.viewportDimension;
      final double targetOffset =
          (index * tabWidth) - (screenWidth / 2) + (tabWidth / 2);

      tabScrollController.animateTo(
        targetOffset.clamp(0.0, tabScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _loadTabData(int index) {
    if (latitude == null || longitude == null || timezone == null) {
      // Defer error message to avoid calling during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          showErrorMessage(
            title: 'Error',
            message: 'Location data is missing. Please try again.',
          );
        });
      });
      return;
    }

    switch (index) {
      case 0: // Key Points
        fetchExtendedKundali();
        break;
      case 1: // Daily
        fetchDailyPrediction();
        break;
      case 2: // Weekly
        fetchWeeklyPrediction();
        break;
      case 3: // Monthly
        fetchMonthlyPrediction();
        break;
      case 4: // Yearly
        fetchYearlyPrediction();
        break;
      case 5: // Moon Sign
        fetchMoonSign();
        break;
      case 6: // Sun Sign
        fetchSunSign();
        break;
      case 7: // Ascendant Sign
        fetchAscendantSign();
        break;
      case 8: // Current Sade Sati
        fetchSadeSati();
        break;
      case 9: // Gem Suggestion
        fetchGemSuggestion();
        break;
      case 10: // Rudraksh Suggestion
        fetchRudrakshSuggestion();
        break;
      case 11: // Friendship Table
        fetchFriendshipTable();
        break;
      case 12: // Planet KP
        fetchPlanetKp();
        break;
    }
  }

  Future<void> fetchExtendedKundali() async {
    if (extendedKundaliData.value != null) return;

    try {
      isLoadingExtendedKundali.value = true;
      final data = await _horoscopeService.getExtendedKundali(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        extendedKundaliData.value =
            data['data']['response'] as Map<String, dynamic>;
        _extractFromResponse(extendedKundaliData.value);
      }
    } catch (e) {
      debugPrint('Error fetching Extended Kundali: $e');
    } finally {
      isLoadingExtendedKundali.value = false;
    }
  }

  Future<void> fetchDailyPrediction() async {
    try {
      isLoadingDaily.value = true;
      // Get zodiac number from selected sign
      final zodiacNo = _getZodiacNumber(selectedSign.value ?? 'Aries');
      final data = await _kundliService.getDailyPrediction(
        zodiac: zodiacNo,
        day: selectedDay.value,
      );

      if (data != null) {
        dailyPredictionData.value = data;
      }
    } catch (e) {
      debugPrint('Error fetching Daily Prediction: $e');
    } finally {
      isLoadingDaily.value = false;
    }
  }

  void onDayChanged(String day) {
    selectedDay.value = day;
    dailyPredictionData.value = null; // Clear cached data
    fetchDailyPrediction(); // Fetch new data
  }

  Future<void> fetchWeeklyPrediction() async {
    if (weeklyPredictionData.value != null) return;

    try {
      isLoadingWeekly.value = true;
      final zodiacNo = _getZodiacNumber(selectedSign.value ?? 'Aries');
      final data = await _kundliService.getWeeklyPrediction(zodiac: zodiacNo);

      if (data != null) {
        weeklyPredictionData.value = data;
      }
    } catch (e) {
      debugPrint('Error fetching Weekly Prediction: $e');
    } finally {
      isLoadingWeekly.value = false;
    }
  }

  Future<void> fetchMonthlyPrediction() async {
    if (monthlyPredictionData.value != null) return;

    try {
      isLoadingMonthly.value = true;
      final zodiacNo = _getZodiacNumber(selectedSign.value ?? 'Aries');
      final data = await _kundliService.getMonthlyPrediction(zodiac: zodiacNo);

      if (data != null) {
        monthlyPredictionData.value = data;
      }
    } catch (e) {
      debugPrint('Error fetching Monthly Prediction: $e');
    } finally {
      isLoadingMonthly.value = false;
    }
  }

  Future<void> fetchYearlyPrediction() async {
    if (yearlyPredictionData.value != null) return;

    try {
      isLoadingYearly.value = true;
      final zodiacNo = _getZodiacNumber(selectedSign.value ?? 'Aries');
      final currentYear = DateTime.now().year;
      final data = await _kundliService.getYearlyPrediction(
        zodiac: zodiacNo,
        year: currentYear,
      );

      if (data != null) {
        yearlyPredictionData.value = data;
      }
    } catch (e) {
      debugPrint('Error fetching Yearly Prediction: $e');
    } finally {
      isLoadingYearly.value = false;
    }
  }

  Future<void> fetchMoonSign() async {
    if (moonSignData.value != null) return;

    try {
      isLoadingMoonSign.value = true;
      final data = await _horoscopeService.getMoonSign(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        moonSignData.value = data['data']['response'] as Map<String, dynamic>;
        _extractFromResponse(moonSignData.value);
      }
    } catch (e) {
      debugPrint('Error fetching Moon Sign: $e');
    } finally {
      isLoadingMoonSign.value = false;
    }
  }

  Future<void> fetchSunSign() async {
    if (sunSignData.value != null) return;

    try {
      isLoadingSunSign.value = true;
      final data = await _horoscopeService.getSunSign(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        sunSignData.value = data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Sun Sign: $e');
    } finally {
      isLoadingSunSign.value = false;
    }
  }

  Future<void> fetchAscendantSign() async {
    if (ascendantSignData.value != null) return;

    try {
      isLoadingAscendantSign.value = true;
      final data = await _horoscopeService.getAscendantSign(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        ascendantSignData.value =
            data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Ascendant Sign: $e');
    } finally {
      isLoadingAscendantSign.value = false;
    }
  }

  Future<void> fetchSadeSati() async {
    if (sadeSatiData.value != null) return;

    try {
      isLoadingSadeSati.value = true;
      final data = await _horoscopeService.getCurrentSadeSati(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        sadeSatiData.value = data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Sade Sati: $e');
    } finally {
      isLoadingSadeSati.value = false;
    }
  }

  Future<void> fetchGemSuggestion() async {
    if (gemSuggestionData.value != null) return;

    try {
      isLoadingGemSuggestion.value = true;
      final data = await _horoscopeService.getGemSuggestion(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        gemSuggestionData.value =
            data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Gem Suggestion: $e');
    } finally {
      isLoadingGemSuggestion.value = false;
    }
  }

  Future<void> fetchRudrakshSuggestion() async {
    if (rudrakshSuggestionData.value != null) return;

    try {
      isLoadingRudrakshSuggestion.value = true;
      final data = await _horoscopeService.getRudrakshSuggestion(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        rudrakshSuggestionData.value =
            data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Rudraksh Suggestion: $e');
    } finally {
      isLoadingRudrakshSuggestion.value = false;
    }
  }

  Future<void> fetchFriendshipTable() async {
    if (friendshipTableData.value != null) return;

    try {
      isLoadingFriendshipTable.value = true;
      final data = await _horoscopeService.getFriendshipTable(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        friendshipTableData.value =
            data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Friendship Table: $e');
    } finally {
      isLoadingFriendshipTable.value = false;
    }
  }

  Future<void> fetchPlanetKp() async {
    if (planetKpData.value != null) return;

    try {
      isLoadingPlanetKp.value = true;
      final data = await _horoscopeService.getPlanetKp(
        date: dateController.text,
        time: timeController.text,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
      );

      if (data != null &&
          data['data'] != null &&
          data['data']['response'] != null) {
        planetKpData.value = data['data']['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching Planet KP: $e');
    } finally {
      isLoadingPlanetKp.value = false;
    }
  }

  int _getZodiacNumber(String sign) {
    final zodiacMap = {
      'Aries': 1,
      'Taurus': 2,
      'Gemini': 3,
      'Cancer': 4,
      'Leo': 5,
      'Virgo': 6,
      'Libra': 7,
      'Scorpio': 8,
      'Sagittarius': 9,
      'Capricorn': 10,
      'Aquarius': 11,
      'Pisces': 12,
    };
    return zodiacMap[sign] ?? 1;
  }

  /// Deep scan a response (Map or List) to find and extract Nakshatra names.
  void _extractFromResponse(dynamic data) {
    if (data == null) return;

    void scan(dynamic obj) {
      if (obj is Map) {
        final potentialKeys = [
          'nakshatra',
          'nakshatra_name',
          'nakshtra',
          'nakshtra_name',
          'birth_nakshatra',
        ];

        for (final key in potentialKeys) {
          if (obj.containsKey(key)) {
            final val = obj[key];
            if (val is String && val.isNotEmpty && val != '-') {
              detectedNakshatra.value = val;
              debugPrint('Auto-detected Nakshatra: $val');
              return;
            } else if (val is Map && val.containsKey('name')) {
              final name = val['name'].toString();
              if (name.isNotEmpty && name != '-') {
                detectedNakshatra.value = name;
                debugPrint('Auto-detected Nakshatra from map: $name');
                return;
              }
            }
          }
        }

        for (final value in obj.values) {
          scan(value);
          if (detectedNakshatra.value != null &&
              detectedNakshatra.value != '-') {
            return;
          }
        }
      } else if (obj is List) {
        for (final item in obj) {
          scan(item);
          if (detectedNakshatra.value != null &&
              detectedNakshatra.value != '-') {
            return;
          }
        }
      }
    }

    scan(data);
  }
}
