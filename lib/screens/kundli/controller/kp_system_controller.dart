import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KpSystemController extends BaseController {
  // KP System table data for main page. Nakshatra Nadi commented out.
  final kpSystemTableData = [
    {
      'left': 'KP Chart',
      'right': 'Rasi Chart',
      'hasApi': true,
      'hasApiRight': true,
    },
    {'left': 'Planets', 'right': 'Cusps', 'hasApi': true, 'hasApiRight': true},
    {
      'left': 'Planet And House Significations',
      'right': '',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Planet Signification Level Wise',
      'right': '',
      'hasApi': true,
      'hasApiRight': false,
    }, // 'Nakshatra Nadi' commented out
    {
      'left': 'CIL (Sub Sub)',
      'right': '4-Step',
      'hasApi': false,
      'hasApiRight': false,
    },
    {
      'left': 'CIL (Sub)',
      'right': 'Ruling Planets',
      'hasApi': false,
      'hasApiRight': false,
    },
    {
      'left': 'Current Ruling Planets',
      'right': 'Misc',
      'hasApi': false,
      'hasApiRight': false,
    },
    {'left': 'KP Cusp', 'right': '', 'hasApi': false, 'hasApiRight': false},
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();

  // Current tab index: 0 = Table (first page), 1-7 = KP Chart, Rasi Chart, Planets, etc. (like Predictions)
  final selectedTabIndex = 0.obs;

  // PageController for swipeable tabs
  late PageController pageController;

  // ScrollController for horizontal tab bar
  final ScrollController tabsScrollController = ScrollController();

  // GlobalKeys for each tab (for scroll-into-view)
  final Map<int, GlobalKey> tabKeys = {};

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
    tabsScrollController.dispose();
    super.onClose();
  }

  // Handle page change from swipe – update selection and fetch data for this page
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    _fetchForPageIndex(index);
  }

  // Called when user taps a tab – update selection, fetch data, animate to page
  void onTabSelected(int index) {
    selectedTabIndex.value = index;
    _fetchForPageIndex(index);
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _fetchForPageIndex(int index) {
    if (index <= 0) return; // Page 0 = Table, no fetch
    if (index == 1 && kpChartData.value == null)
      fetchKpChart();
    else if (index == 2 && kpRasiChartData.value == null)
      fetchKpRasiChart();
    else if (index == 3 && kpPlanetDetailsData.value == null)
      fetchKpPlanetDetails();
    else if (index == 4 && kpCuspsDetailsData.value == null)
      fetchKpCuspsDetails();
    else if (index == 5) {
      // Merged tab: fetch both Planet Significations and House Significators
      if (kpPlanetSignificationsData.value == null)
        fetchKpPlanetSignifications();
      if (kpHouseSignificatorsData.value == null)
        fetchKpHouseSignificators();
    } else if (index == 6 && kpPlanetSignificatorsLevelWiseData.value == null)
      fetchKpPlanetSignificatorsLevelWise();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  // Navigate to table view (page 0)
  void navigateToTableView() {
    selectedTabIndex.value = 0;
    if (pageController.hasClients) {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Page index: 0=Table, 1=KP Chart, 2=Rasi Chart, 3=Planets, 4=Cusps, 5=Significations (merged), 6=Planet Signification Level Wise
  int _tabNameToPageIndex(String tabName) {
    switch (tabName) {
      case 'KP Chart':
        return 1;
      case 'Rasi Chart':
        return 2;
      case 'Planets':
        return 3;
      case 'Cusps':
        return 4;
      case 'Planet Signification House wise':
      case 'House Significators':
      case 'Planet And House Significations':
        return 5;
      case 'Planet Signification Level Wise':
        return 6;
// Nakshatra Nadi commented out
      default:
        return 0;
    }
  }

  // Navigate to specific tab (from table card tap)
  void navigateToTab(String tabName) {
    final index = _tabNameToPageIndex(tabName);
    selectedTabIndex.value = index;
    _fetchForPageIndex(index);
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Tab names for display – first is Table (like Predictions), then content tabs. Nakshatra Nadi commented out.
  final List<String> tabNames = [
    'Overview',
    'KP Chart',
    'Rasi Chart',
    'Planets',
    'Cusps',
    'Planet And House Significations',
    'Planet Signification Level Wise',
    // 'Nakshatra Nadi',
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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
      debugPrint(
        'Form data is null, cannot fetch KP Planet Significators Level Wise',
      );
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint(
          'Missing required form data for KP Planet Significators Level Wise',
        );
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
        debugPrint(
          'KP Planet Significators Level Wise data loaded successfully',
        );
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

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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
