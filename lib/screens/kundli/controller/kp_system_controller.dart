import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class KpSystemController extends BaseController {
  // KP System table data for main page
  final kpSystemTableData = [
    {'left': 'KP Chart', 'right': 'Rasi Chart', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Planets', 'right': 'Cusps', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Planet Signification', 'right': 'House Significators', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Planet Signification(View2)', 'right': 'Nakshatra Nadi', 'hasApi': true, 'hasApiRight': false},
    {'left': 'CIL (Sub Sub)', 'right': '4-Step', 'hasApi': false, 'hasApiRight': false},
    {'left': 'CIL (Sub)', 'right': 'Ruling Planets', 'hasApi': false, 'hasApiRight': false},
    {'left': 'Current Ruling Planets', 'right': 'Misc', 'hasApi': false, 'hasApiRight': false},
    {'left': 'KP Cusp', 'right': '', 'hasApi': false, 'hasApiRight': false},
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // Current tab index: -1 = TABLE VIEW, 0-15 = specific tabs
  final selectedTabIndex = (-1).obs;
  
  // PageController for swipeable tabs
  late PageController pageController;
  
  // API data
  final kpChartData = Rxn<Map<String, dynamic>>();
  final kpRasiChartData = Rxn<Map<String, dynamic>>();
  final kpPlanetDetailsData = Rxn<Map<String, dynamic>>();
  final kpPlanetSignificationsData = Rxn<Map<String, dynamic>>();
  final kpHouseSignificatorsData = Rxn<Map<String, dynamic>>();
  final kpPlanetSignificatorsLevelWiseData = Rxn<Map<String, dynamic>>();
  final kpCuspsDetailsData = Rxn<Map<String, dynamic>>();
  
  // Loading states
  final isLoadingKpChart = false.obs;
  final isLoadingKpRasiChart = false.obs;
  final isLoadingKpPlanetDetails = false.obs;
  final isLoadingKpPlanetSignifications = false.obs;
  final isLoadingKpHouseSignificators = false.obs;
  final isLoadingKpPlanetSignificatorsLevelWise = false.obs;
  final isLoadingKpCuspsDetails = false.obs;
  
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
      case 'KP Chart':
        selectedTabIndex.value = 0;
        if (kpChartData.value == null) {
          fetchKpChart();
        }
        break;
      case 'Rasi Chart':
        selectedTabIndex.value = 1;
        if (kpRasiChartData.value == null) {
          fetchKpRasiChart();
        }
        break;
      case 'Planets':
        selectedTabIndex.value = 2;
        if (kpPlanetDetailsData.value == null) {
          fetchKpPlanetDetails();
        }
        break;
      case 'Cusps':
        selectedTabIndex.value = 3;
        if (kpCuspsDetailsData.value == null) {
          fetchKpCuspsDetails();
        }
        break;
      case 'Planet Signification':
        selectedTabIndex.value = 4;
        if (kpPlanetSignificationsData.value == null) {
          fetchKpPlanetSignifications();
        }
        break;
      case 'House Significators':
        selectedTabIndex.value = 5;
        if (kpHouseSignificatorsData.value == null) {
          fetchKpHouseSignificators();
        }
        break;
      case 'Planet Signification(View2)':
        selectedTabIndex.value = 6;
        if (kpPlanetSignificatorsLevelWiseData.value == null) {
          fetchKpPlanetSignificatorsLevelWise();
        }
        break;
      case 'Nakshatra Nadi':
        selectedTabIndex.value = 7;
        break;
      case 'CIL (Sub Sub)':
      case '4-Step':
      case 'CIL (Sub)':
      case 'Ruling Planets':
      case 'Current Ruling Planets':
      case 'Misc':
      case 'KP Cusp':
        // Coming soon tabs
        selectedTabIndex.value = 8 + _getComingSoonTabIndex(tabName);
        break;
    }
  }

  int _getComingSoonTabIndex(String tabName) {
    final comingSoonTabs = [
      'CIL (Sub Sub)',
      '4-Step',
      'CIL (Sub)',
      'Ruling Planets',
      'Current Ruling Planets',
      'Misc',
      'KP Cusp',
    ];
    return comingSoonTabs.indexOf(tabName);
  }
  
  // Tab names for display
  final List<String> tabNames = [
    'KP Chart',
    'Rasi Chart',
    'Planets',
    'Cusps',
    'Planet Signification',
    'House Significators',
    'Planet Signification(View2)',
    'Nakshatra Nadi',
  ];

  // Fetch KP Chart
  Future<void> fetchKpChart() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP Chart');
      return;
    }

    try {
      isLoadingKpChart.value = true;
      
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
        debugPrint('Missing required form data for KP Chart');
        isLoadingKpChart.value = false;
        return;
      }

      final data = await _kundliService.getKpChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: '#ed6f30', // Double URL encoded
      );

      isLoadingKpChart.value = false;

      if (data != null) {
        kpChartData.value = data;
        debugPrint('KP Chart data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP Chart data');
      }
    } catch (e) {
      isLoadingKpChart.value = false;
      debugPrint('Error fetching KP Chart data: $e');
    }
  }

  // Fetch KP Rasi Chart
  Future<void> fetchKpRasiChart() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP Rasi Chart');
      return;
    }

    try {
      isLoadingKpRasiChart.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for KP Rasi Chart');
        isLoadingKpRasiChart.value = false;
        return;
      }

      final data = await _kundliService.getKpRasiChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: false,
        color: '#ed6f30', // Double URL encoded
      );

      isLoadingKpRasiChart.value = false;

      if (data != null) {
        kpRasiChartData.value = data;
        debugPrint('KP Rasi Chart data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP Rasi Chart data');
      }
    } catch (e) {
      isLoadingKpRasiChart.value = false;
      debugPrint('Error fetching KP Rasi Chart data: $e');
    }
  }

  // Fetch KP Planet Details
  Future<void> fetchKpPlanetDetails() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP Planet Details');
      return;
    }

    try {
      isLoadingKpPlanetDetails.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for KP Planet Details');
        isLoadingKpPlanetDetails.value = false;
        return;
      }

      final data = await _kundliService.getKpPlanetDetails(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingKpPlanetDetails.value = false;

      if (data != null) {
        kpPlanetDetailsData.value = data;
        debugPrint('KP Planet Details data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP Planet Details data');
      }
    } catch (e) {
      isLoadingKpPlanetDetails.value = false;
      debugPrint('Error fetching KP Planet Details data: $e');
    }
  }

  // Fetch KP Planet Significations
  Future<void> fetchKpPlanetSignifications() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP Planet Significations');
      return;
    }

    try {
      isLoadingKpPlanetSignifications.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for KP Planet Significations');
        isLoadingKpPlanetSignifications.value = false;
        return;
      }

      final data = await _kundliService.getKpPlanetSignifications(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingKpPlanetSignifications.value = false;

      if (data != null) {
        kpPlanetSignificationsData.value = data;
        debugPrint('KP Planet Significations data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP Planet Significations data');
      }
    } catch (e) {
      isLoadingKpPlanetSignifications.value = false;
      debugPrint('Error fetching KP Planet Significations data: $e');
    }
  }

  // Fetch KP House Significators
  Future<void> fetchKpHouseSignificators() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP House Significators');
      return;
    }

    try {
      isLoadingKpHouseSignificators.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for KP House Significators');
        isLoadingKpHouseSignificators.value = false;
        return;
      }

      final data = await _kundliService.getKpHouseSignificators(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingKpHouseSignificators.value = false;

      if (data != null) {
        kpHouseSignificatorsData.value = data;
        debugPrint('KP House Significators data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP House Significators data');
      }
    } catch (e) {
      isLoadingKpHouseSignificators.value = false;
      debugPrint('Error fetching KP House Significators data: $e');
    }
  }

  // Fetch KP Planet Significators Level Wise
  Future<void> fetchKpPlanetSignificatorsLevelWise() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP Planet Significators Level Wise');
      return;
    }

    try {
      isLoadingKpPlanetSignificatorsLevelWise.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for KP Planet Significators Level Wise');
        isLoadingKpPlanetSignificatorsLevelWise.value = false;
        return;
      }

      final data = await _kundliService.getKpPlanetSignificatorsLevelWise(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingKpPlanetSignificatorsLevelWise.value = false;

      if (data != null) {
        kpPlanetSignificatorsLevelWiseData.value = data;
        debugPrint('KP Planet Significators Level Wise data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP Planet Significators Level Wise data');
      }
    } catch (e) {
      isLoadingKpPlanetSignificatorsLevelWise.value = false;
      debugPrint('Error fetching KP Planet Significators Level Wise data: $e');
    }
  }

  // Fetch KP Cusps Details
  Future<void> fetchKpCuspsDetails() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch KP Cusps Details');
      return;
    }

    try {
      isLoadingKpCuspsDetails.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for KP Cusps Details');
        isLoadingKpCuspsDetails.value = false;
        return;
      }

      final data = await _kundliService.getKpCuspsDetails(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingKpCuspsDetails.value = false;

      if (data != null) {
        kpCuspsDetailsData.value = data;
        debugPrint('KP Cusps Details data loaded successfully');
      } else {
        debugPrint('Failed to fetch KP Cusps Details data');
      }
    } catch (e) {
      isLoadingKpCuspsDetails.value = false;
      debugPrint('Error fetching KP Cusps Details data: $e');
    }
  }
}

