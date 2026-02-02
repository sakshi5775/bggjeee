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
  
  // Current tab index: 0 = TABLE VIEW, 1-7 = specific tabs (matches kundli_result_view pattern)
  final selectedTabIndex = 0.obs;
  
  // PageController for swipeable tabs
  late PageController pageController;

  // ScrollController for tab bar (match kundli_result_view)
  final ScrollController tabsScrollController = ScrollController();
  final Map<int, GlobalKey> tabKeys = {};
  
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
    // 8 pages: 0=Table, 1=Kundli, 2=Remedies, 3=Debts, 4=Varsha, 5=House, 6=Planet, 7=Chart
    pageController = PageController(initialPage: 0);
    _loadData();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    tabsScrollController.dispose();
    super.onClose();
  }
  
  // Handle page change from swipe
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    if (index == 0) return; // Table view
    if (index == 1 && lalKitabHoroscopeData.value == null) fetchLalKitabHoroscope();
    else if (index == 2 && lalKitabRemediesData.value == null) fetchLalKitabRemedies();
    else if (index == 3 && lalKitabDebtsData.value == null) fetchLalKitabDebts();
    else if (index == 4 && lalKitabVarshphalChartData.value == null) fetchLalKitabVarshphalChart();
    else if (index == 5 && lalKitabHousesData.value == null) fetchLalKitabHouses();
    else if (index == 6 && lalKitabPlanetsData.value == null) fetchLalKitabPlanets();
    else if (index == 7 && lalKitabChartData.value == null) fetchLalKitabChart();
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
    selectedTabIndex.value = index;
    if (index == 1 && lalKitabHoroscopeData.value == null) fetchLalKitabHoroscope();
    else if (index == 2 && lalKitabRemediesData.value == null) fetchLalKitabRemedies();
    else if (index == 3 && lalKitabDebtsData.value == null) fetchLalKitabDebts();
    else if (index == 4 && lalKitabVarshphalChartData.value == null) fetchLalKitabVarshphalChart();
    else if (index == 5 && lalKitabHousesData.value == null) fetchLalKitabHouses();
    else if (index == 6 && lalKitabPlanetsData.value == null) fetchLalKitabPlanets();
    else if (index == 7 && lalKitabChartData.value == null) fetchLalKitabChart();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  // Navigate to table view (index 0)
  void navigateToTableView() {
    selectedTabIndex.value = 0;
    if (pageController.hasClients) {
      pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  // Navigate to specific tab by name (from table card tap)
  void navigateToTab(String tabName) {
    switch (tabName) {
      case 'Table':
        onTabSelected(0);
        break;
      case 'Lal Kitab Kundli':
        onTabSelected(1);
        break;
      case 'Prediction and Remedies':
        onTabSelected(2);
        break;
      case 'Debts':
        onTabSelected(3);
        break;
      case 'Varsha Kundli':
        onTabSelected(4);
        break;
      case 'House':
        onTabSelected(5);
        break;
      case 'Planet':
        onTabSelected(6);
        break;
      case 'Chart':
        onTabSelected(7);
        break;
      case 'Lal Kitab Dasha':
      case 'Teva Type':
      case 'Ask a question':
        // Coming soon - stay on table
        break;
    }
  }

  // Tab names for display (0=Table, 1-7=content)
  final List<String> tabNames = [
    'Table',
    'Lal Kitab Kundli',
    'Remedies',
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

