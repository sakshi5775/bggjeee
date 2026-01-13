import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LalKitabController extends BaseController {
  // Lal Kitab table data for main page (removed Cloud)
  final lalKitabTableData = [
    {'left': 'Lal Kitab Kundli', 'right': 'Prediction and Remedies', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Debts', 'right': 'Varsha Kundli', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Lal Kitab Dasha', 'right': 'Teva Type', 'hasApi': false, 'hasApiRight': false},
    {'left': 'House', 'right': 'Planet', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Chart', 'right': 'Ask a question', 'hasApi': true, 'hasApiRight': false},
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // Current tab index: -1 = TABLE VIEW, 0-8 = specific tabs
  final selectedTabIndex = (-1).obs;
  
  // PageController for swipeable tabs
  late PageController pageController;
  
  // Varshphal year selector (default to current year)
  final selectedVarshphalYear = DateTime.now().year.obs;
  
  // API data
  final lalKitabHoroscopeData = Rxn<Map<String, dynamic>>();
  final lalKitabDebtsData = Rxn<Map<String, dynamic>>();
  final lalKitabRemediesData = Rxn<Map<String, dynamic>>();
  final lalKitabHousesData = Rxn<Map<String, dynamic>>();
  final lalKitabPlanetsData = Rxn<Map<String, dynamic>>();
  final lalKitabChartData = Rxn<Map<String, dynamic>>();
  final lalKitabVarshphalChartData = Rxn<Map<String, dynamic>>();
  
  // Loading states
  final isLoadingLalKitabHoroscope = false.obs;
  final isLoadingLalKitabDebts = false.obs;
  final isLoadingLalKitabRemedies = false.obs;
  final isLoadingLalKitabHouses = false.obs;
  final isLoadingLalKitabPlanets = false.obs;
  final isLoadingLalKitabChart = false.obs;
  final isLoadingLalKitabVarshphalChart = false.obs;
  
  // Service
  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController with number of tabs
    pageController = PageController(initialPage: 0);
    _loadData();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  // Handle page change from swipe
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    // Trigger navigation based on index
    if (index < tabNames.length) {
      navigateToTab(tabNames[index]);
    }
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

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  // Navigate to table view
  void navigateToTableView() {
    selectedTabIndex.value = -1;
  }

  // Navigate to specific tab
  void navigateToTab(String tabName) {
    switch (tabName) {
      case 'Lal Kitab Kundli':
        selectedTabIndex.value = 0;
        if (lalKitabHoroscopeData.value == null) {
          fetchLalKitabHoroscope();
        }
        break;
      case 'Prediction and Remedies':
        selectedTabIndex.value = 1;
        if (lalKitabRemediesData.value == null) {
          fetchLalKitabRemedies();
        }
        break;
      case 'Debts':
        selectedTabIndex.value = 2;
        if (lalKitabDebtsData.value == null) {
          fetchLalKitabDebts();
        }
        break;
      case 'Varsha Kundli':
        selectedTabIndex.value = 3;
        if (lalKitabVarshphalChartData.value == null) {
          fetchLalKitabVarshphalChart();
        }
        break;
      case 'House':
        selectedTabIndex.value = 4;
        if (lalKitabHousesData.value == null) {
          fetchLalKitabHouses();
        }
        break;
      case 'Planet':
        selectedTabIndex.value = 5;
        if (lalKitabPlanetsData.value == null) {
          fetchLalKitabPlanets();
        }
        break;
      case 'Chart':
        selectedTabIndex.value = 6;
        if (lalKitabChartData.value == null) {
          fetchLalKitabChart();
        }
        break;
      case 'Lal Kitab Dasha':
      case 'Teva Type':
      case 'Ask a question':
        // Coming soon tabs
        selectedTabIndex.value = 7 + _getComingSoonTabIndex(tabName);
        break;
    }
  }

  int _getComingSoonTabIndex(String tabName) {
    final comingSoonTabs = [
      'Lal Kitab Dasha',
      'Teva Type',
      'Ask a question',
    ];
    return comingSoonTabs.indexOf(tabName);
  }
  
  // Tab names for display
  final List<String> tabNames = [
    'Lal Kitab Kundli',
    'Prediction and Remedies',
    'Debts',
    'Varsha Kundli',
    'House',
    'Planet',
    'Chart',
  ];

  // Fetch Lal Kitab Horoscope
  Future<void> fetchLalKitabHoroscope() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Horoscope');
      return;
    }

    try {
      isLoadingLalKitabHoroscope.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Horoscope');
        isLoadingLalKitabHoroscope.value = false;
        return;
      }

      final data = await _kundliService.getLalKitabHoroscope(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingLalKitabHoroscope.value = false;

      if (data != null) {
        lalKitabHoroscopeData.value = data;
        debugPrint('Lal Kitab Horoscope data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Horoscope data');
      }
    } catch (e) {
      isLoadingLalKitabHoroscope.value = false;
      debugPrint('Error fetching Lal Kitab Horoscope data: $e');
    }
  }

  // Fetch Lal Kitab Debts
  Future<void> fetchLalKitabDebts() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Debts');
      return;
    }

    try {
      isLoadingLalKitabDebts.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Debts');
        isLoadingLalKitabDebts.value = false;
        return;
      }

      final data = await _kundliService.getLalKitabDebts(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingLalKitabDebts.value = false;

      if (data != null) {
        lalKitabDebtsData.value = data;
        debugPrint('Lal Kitab Debts data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Debts data');
      }
    } catch (e) {
      isLoadingLalKitabDebts.value = false;
      debugPrint('Error fetching Lal Kitab Debts data: $e');
    }
  }

  // Fetch Lal Kitab Remedies
  Future<void> fetchLalKitabRemedies() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Remedies');
      return;
    }

    try {
      isLoadingLalKitabRemedies.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Remedies');
        isLoadingLalKitabRemedies.value = false;
        return;
      }

      final data = await _kundliService.getLalKitabRemedies(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingLalKitabRemedies.value = false;

      if (data != null) {
        lalKitabRemediesData.value = data;
        debugPrint('Lal Kitab Remedies data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Remedies data');
      }
    } catch (e) {
      isLoadingLalKitabRemedies.value = false;
      debugPrint('Error fetching Lal Kitab Remedies data: $e');
    }
  }

  // Fetch Lal Kitab Houses
  Future<void> fetchLalKitabHouses() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Houses');
      return;
    }

    try {
      isLoadingLalKitabHouses.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Houses');
        isLoadingLalKitabHouses.value = false;
        return;
      }

      final data = await _kundliService.getLalKitabHouses(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingLalKitabHouses.value = false;

      if (data != null) {
        lalKitabHousesData.value = data;
        debugPrint('Lal Kitab Houses data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Houses data');
      }
    } catch (e) {
      isLoadingLalKitabHouses.value = false;
      debugPrint('Error fetching Lal Kitab Houses data: $e');
    }
  }

  // Fetch Lal Kitab Planets
  Future<void> fetchLalKitabPlanets() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Planets');
      return;
    }

    try {
      isLoadingLalKitabPlanets.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Planets');
        isLoadingLalKitabPlanets.value = false;
        return;
      }

      final data = await _kundliService.getLalKitabPlanets(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingLalKitabPlanets.value = false;

      if (data != null) {
        lalKitabPlanetsData.value = data;
        debugPrint('Lal Kitab Planets data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Planets data');
      }
    } catch (e) {
      isLoadingLalKitabPlanets.value = false;
      debugPrint('Error fetching Lal Kitab Planets data: $e');
    }
  }

  // Fetch Lal Kitab Chart
  Future<void> fetchLalKitabChart() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Chart');
      return;
    }

    try {
      isLoadingLalKitabChart.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['colored_planets'] as bool? ?? true;

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Chart');
        isLoadingLalKitabChart.value = false;
        return;
      }

      final data = await _kundliService.getLalKitabChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: '#ed6f30',
      );

      isLoadingLalKitabChart.value = false;

      if (data != null) {
        lalKitabChartData.value = data;
        debugPrint('Lal Kitab Chart data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Chart data');
      }
    } catch (e) {
      isLoadingLalKitabChart.value = false;
      debugPrint('Error fetching Lal Kitab Chart data: $e');
    }
  }

  // Fetch Lal Kitab Varshphal Chart
  Future<void> fetchLalKitabVarshphalChart() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Lal Kitab Varshphal Chart');
      return;
    }

    try {
      isLoadingLalKitabVarshphalChart.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['colored_planets'] as bool? ?? true;

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Lal Kitab Varshphal Chart');
        isLoadingLalKitabVarshphalChart.value = false;
        return;
      }

      // Auto-generate varshphal_date from DOB (DD/MM) + selected year
      // Varshphal is calculated from birthday to birthday, not by calendar year
      // IMPORTANT: varshphal_date must be different from birth date
      final varshphalDate = _validateAndAdjustVarshphalDate(date, selectedVarshphalYear.value);

      final data = await _kundliService.getLalKitabVarshphalChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        varshphalDate: varshphalDate,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: '#ed6f30',
      );

      isLoadingLalKitabVarshphalChart.value = false;

      if (data != null) {
        lalKitabVarshphalChartData.value = data;
        debugPrint('Lal Kitab Varshphal Chart data loaded successfully');
      } else {
        debugPrint('Failed to fetch Lal Kitab Varshphal Chart data');
        // Show error message to user
        Get.snackbar(
          'Error',
          'Failed to fetch Varshphal Chart. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingLalKitabVarshphalChart.value = false;
      debugPrint('Error fetching Lal Kitab Varshphal Chart data: $e');
      
      // Check if error is related to same date issue
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('running year') || 
          errorString.contains('house mapping') ||
          errorString.contains('400')) {
        // Auto-adjust year and retry
        debugPrint('Detected same date error. Auto-adjusting year and retrying...');
        final adjustedYear = selectedVarshphalYear.value + 1;
        selectedVarshphalYear.value = adjustedYear;
        
        // Retry after a short delay
        Future.delayed(Duration(milliseconds: 500), () {
          fetchLalKitabVarshphalChart();
        });
        
        Get.snackbar(
          'Info',
          'Varshphal date adjusted to next year (birthday to birthday calculation).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      } else {
        // Show generic error
        Get.snackbar(
          'Error',
          'Failed to fetch Varshphal Chart. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  /// Generate varshphal_date from DOB (DD/MM) + selected year
  /// Varshphal is calculated from birthday to birthday, not by calendar year
  String _generateVarshphalDate(String? dob, int year) {
    if (dob == null || dob.isEmpty) {
      // Fallback to current date if DOB is not available
      final now = DateTime.now();
      return '${now.day}/${now.month}/$year';
    }

    try {
      // Parse DOB format: DD/MM/YYYY
      final parts = dob.split('/');
      if (parts.length >= 2) {
        final day = parts[0].padLeft(2, '0');
        final month = parts[1].padLeft(2, '0');
        // Construct varshphal_date as DD/MM/YYYY using DOB day/month + selected year
        return '$day/$month/$year';
      }
    } catch (e) {
      debugPrint('Error parsing DOB for varshphal_date: $e');
    }

    // Fallback to current date if parsing fails
    final now = DateTime.now();
    return '${now.day}/${now.month}/$year';
  }

  /// Update selected Varshphal year and refresh chart if already loaded
  void updateVarshphalYear(int year) {
    selectedVarshphalYear.value = year;
    // Clear existing chart data to force refresh
    lalKitabVarshphalChartData.value = null;
    // If chart data was already loaded, refresh it with new year
    if (selectedTabIndex.value == 3) { // Varshphal tab is selected
      fetchLalKitabVarshphalChart();
    }
  }
  
  /// Validate and adjust varshphal date if it matches birth date
  String _validateAndAdjustVarshphalDate(String birthDate, int year) {
    String varshphalDate = _generateVarshphalDate(birthDate, year);
    
    // If varshphal_date matches birth date, increment year by 1
    if (varshphalDate == birthDate) {
      debugPrint('Warning: varshphal_date ($varshphalDate) matches birth date ($birthDate). Auto-incrementing year.');
      final adjustedYear = year + 1;
      varshphalDate = _generateVarshphalDate(birthDate, adjustedYear);
      // Update the selected year to reflect the adjustment
      if (selectedVarshphalYear.value == year) {
        selectedVarshphalYear.value = adjustedYear;
      }
    }
    
    return varshphalDate;
  }
}

