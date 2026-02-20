import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:intl/intl.dart';

class KundliResultController extends BaseController {
  // Kundli data
  final kundliData = Rxn<Map<String, dynamic>>();
  final formData = Rxn<Map<String, dynamic>>();

  // Selected tab
  final selectedTabIndex = 0.obs;

  // PageController for swipeable tabs
  late PageController pageController;

  // ScrollController for tabs
  final ScrollController tabsScrollController = ScrollController();

  // Map to store GlobalKeys for each tab
  final Map<int, GlobalKey> tabKeys = {};

  // Tabs
  final tabs = [
    'Basic',
    'Lagna',
    'Navamsha',
    'Sun',
    'Moon',
    'Bhav-Chalit',
    'Birth Details',
    'Ashtakvarga',
    'Divisional Chart',
    'Shad Bala',
    'Planets',
    'Summary(lagna) Report',
    'Panchang',
    'Binnashtakvarga',
    'Transit',
    'Ashtakvarga Chart',
    'Bhav Madhya',
    'Person Details',
    'Ghatak and Favourable',
    'Reports',
    'Friendship',
    'Avkahada Chakra',
    'Download PDF',
  ];

  /// Tab names that show "Coming Soon". These tabs are hidden from the UI.
  static const _comingSoonTabNames = [
    'bhav madhya',
    'person details',
    'ghatak and favourable',
    'reports',
    'friendship',
    'avkahada chakra',
    'download pdf',
  ];

  /// Indices into [tabs] for non-coming-soon tabs (visible in tab bar & PageView).
  List<int> get visibleTabIndices => tabs
      .asMap()
      .entries
      .where((e) => !_comingSoonTabNames.contains(e.value.toLowerCase()))
      .map((e) => e.key)
      .toList();

  /// Tab names for visible tabs only.
  List<String> get visibleTabs =>
      visibleTabIndices.map((i) => tabs[i]).toList();

  bool _isComingSoonTab(String tabName) =>
      _comingSoonTabNames.contains(tabName.toLowerCase());

  // Feature grid items (imageUrl uses 3D logos from S3 when set)
  final featureGridItems = [
    {'title': 'Dasha', 'icon': Icons.timeline, 'imageUrl': AppConstant.dasha},
    {'title': 'Yog', 'icon': Icons.auto_awesome, 'imageUrl': AppConstant.yog3d},
    {'title': 'Dosh', 'icon': Icons.ac_unit, 'imageUrl': AppConstant.dosh},
    {
      'title': 'Predictions',
      'icon': Icons.auto_awesome,
      'imageUrl': AppConstant.horoscope,
    },
    {
      'title': 'KP System',
      'icon': Icons.grid_view,
      'imageUrl': AppConstant.kpN,
    },
    {
      'title': 'Shodash\nvarga',
      'icon': Icons.view_module,
      'imageUrl': AppConstant.shodashVarga3d,
    },
    {
      'title': 'Lal Kitab',
      'icon': Icons.menu_book,
      'imageUrl': AppConstant.lalKitab,
    },
    {
      'title': 'Varshphal',
      'icon': Icons.calendar_today,
      'imageUrl': AppConstant.varshpal3d,
    },
    {
      'title': 'Navtara\nAnalysis',
      'icon': Icons.star_half,
      'imageUrl': null,
      'pricingKey': 'navtara',
    },
  ];

  // Feature list items (left column)
  final leftColumnFeatures = [
    'Lagna',
    'Sun',
    'Bhav-Chalit',

    'Birth Details',
    'Ashtakvarga',
    'Divisional Chart',
    'Shad Bala',
    'Summary(lagna) Report',
  ];

  // Feature list items (right column)
  final rightColumnFeatures = [
    'Navamsha',
    'Moon',
    'Planets',

    'Panchang',
    'Binnashtakvarga',
    'Transit',
    'Ashtakvarga Chart',
  ];

  // Additional features (grid)
  final additionalFeatures = [
    {'title': 'Bhav Madhya', 'icon': Icons.center_focus_strong},
    {'title': 'Person Details', 'icon': Icons.person},
    {'title': 'Ghatak and Favourable', 'icon': Icons.favorite},
    {'title': 'Reports', 'icon': Icons.description},

    {'title': 'Friendship', 'icon': Icons.people},
    {'title': 'Avkahada Chakra', 'icon': Icons.radio_button_checked},
    {'title': 'Download PDF', 'icon': Icons.download},
  ];

  // Reactive variable to control showing all features
  final showAllFeatures = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController with number of tabs
    pageController = PageController(initialPage: selectedTabIndex.value);
    _loadData();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Handle page change from swipe. [index] is visible (page) index.
  void onPageChanged(int index) {
    if (index < 0 || index >= visibleTabIndices.length) return;
    final fullIndex = visibleTabIndices[index];
    selectedTabIndex.value = fullIndex;
    onTabSelected(fullIndex);
  }

  // SVG data
  final svgData = Rxn<String>();
  final navamshaSvgData = Rxn<String>();
  final sunSvgData = Rxn<String>();
  final moonSvgData = Rxn<String>();
  final chalitSvgData = Rxn<String>();
  final transitSvgData = Rxn<String>();

  // Planet details data
  final planetDetailsData = Rxn<Map<String, dynamic>>();
  final isLoadingPlanetDetails = false.obs;
  final detectedNakshatra = Rxn<String>();

  // Birth details data
  final mangalDoshData = Rxn<Map<String, dynamic>>();
  final isLoadingMangalDosh = false.obs;

  // Panchang data
  final panchangData = Rxn<Map<String, dynamic>>();
  final isLoadingPanchang = false.obs;

  // Ashtakvarga data
  final ashtakvargaData = Rxn<Map<String, dynamic>>();
  final isLoadingAshtakvarga = false.obs;

  // Binnashtakvarga data
  final binnashtakvargaData = Rxn<Map<String, dynamic>>();
  final isLoadingBinnashtakvarga = false.obs;
  final selectedPlanetForBinnashtakvarga = Rxn<String>();

  // Ashtakvarga Chart data (SVG)
  final ashtakvargaChartSvg = Rxn<String>();
  final isLoadingAshtakvargaChart = false.obs;

  // Divisional Chart data
  final divisionalChartData = Rxn<Map<String, dynamic>>();
  final isLoadingDivisionalChart = false.obs;
  final selectedDivisionForChart = Rxn<String>();

  /// Selected Lagna action: 'planet' = show Planets below slider; null = default (Planetary Positions)
  final selectedLagnaAction = Rxn<String>();

  // Ascendant Report data
  final ascendantReportData = Rxn<Map<String, dynamic>>();
  final isLoadingAscendantReport = false.obs;

  // Varshphal data
  final varshphalDetailsData = Rxn<Map<String, dynamic>>();
  final varshphalYearlyChartData = Rxn<Map<String, dynamic>>();
  final isLoadingVarshphalDetails = false.obs;
  final isLoadingVarshphalYearlyChart = false.obs;
  final selectedVarshphalTab = 0.obs; // 0 = Details, 1 = Yearly Chart

  // Shad Bala data
  final shadBalaData = Rxn<Map<String, dynamic>>();
  final isLoadingShadBala = false.obs;

  // Service
  final _kundliService = KundliService();
  final _panchangService = PanchangService();

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      kundliData.value = arguments['kundliData'] as Map<String, dynamic>?;
      formData.value = arguments['formData'] as Map<String, dynamic>?;

      // Extract SVG string from API response
      if (kundliData.value != null) {
        final data = kundliData.value!['data'] as String?;
        if (data != null && data.isNotEmpty) {
          svgData.value = data;
          debugPrint(
            'SVG Data loaded: ${data.substring(0, data.length > 100 ? 100 : data.length)}...',
          );
        } else {
          debugPrint('SVG Data is null or empty');
        }
      } else {
        debugPrint('Kundli Data is null');
      }
    } else {
      debugPrint('Arguments is null');
    }
  }

  /// Fetch Navamsha chart when needed
  Future<void> fetchNavamshaChart() async {
    if (navamshaSvgData.value != null && navamshaSvgData.value!.isNotEmpty) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Navamsha chart');
      return;
    }

    try {
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['coloredPlanets'] as bool? ?? true;
      const colorHex = '#ed6f30';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Navamsha chart');
        return;
      }

      final data = await _kundliService.generateNavamsha(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: colorHex,
      );

      if (data != null) {
        final svgString = data['data'] as String?;
        if (svgString != null && svgString.isNotEmpty) {
          navamshaSvgData.value = svgString;
          debugPrint('Navamsha SVG Data loaded');
        } else {
          debugPrint('Navamsha SVG Data is null or empty');
        }
      } else {
        debugPrint('Failed to fetch Navamsha chart');
      }
    } catch (e) {
      debugPrint('Error fetching Navamsha chart: $e');
    }
  }

  /// Fetch Sun chart when needed
  Future<void> fetchSunChart() async {
    if (sunSvgData.value != null && sunSvgData.value!.isNotEmpty) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Sun chart');
      return;
    }

    try {
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['coloredPlanets'] as bool? ?? true;
      const colorHex = '#ed6f30';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Sun chart');
        return;
      }

      final data = await _kundliService.generateSun(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: colorHex,
      );

      if (data != null) {
        final svgString = data['data'] as String?;
        if (svgString != null && svgString.isNotEmpty) {
          sunSvgData.value = svgString;
          debugPrint('Sun SVG Data loaded');
        } else {
          debugPrint('Sun SVG Data is null or empty');
        }
      } else {
        debugPrint('Failed to fetch Sun chart');
      }
    } catch (e) {
      debugPrint('Error fetching Sun chart: $e');
    }
  }

  /// Fetch Moon chart when needed
  Future<void> fetchMoonChart() async {
    if (moonSvgData.value != null && moonSvgData.value!.isNotEmpty) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Moon chart');
      return;
    }

    try {
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['coloredPlanets'] as bool? ?? true;
      const colorHex = '#ed6f30';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Moon chart');
        return;
      }

      final data = await _kundliService.generateMoon(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: colorHex,
      );

      if (data != null) {
        final svgString = data['data'] as String?;
        if (svgString != null && svgString.isNotEmpty) {
          moonSvgData.value = svgString;
          debugPrint('Moon SVG Data loaded');
        } else {
          debugPrint('Moon SVG Data is null or empty');
        }
      } else {
        debugPrint('Failed to fetch Moon chart');
      }
    } catch (e) {
      debugPrint('Error fetching Moon chart: $e');
    }
  }

  /// Fetch Transit chart when needed
  Future<void> fetchTransitChart() async {
    if (transitSvgData.value != null && transitSvgData.value!.isNotEmpty) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Transit chart');
      return;
    }

    try {
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['coloredPlanets'] as bool? ?? true;
      const colorHex = '#ed6f30';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Transit chart');
        return;
      }

      // Parse birth date and time
      DateTime? birthDateTime;
      try {
        final birthDateParts = date.split('/');
        if (birthDateParts.length == 3) {
          final birthDay = int.parse(birthDateParts[0]);
          final birthMonth = int.parse(birthDateParts[1]);
          final birthYear = int.parse(birthDateParts[2]);

          final timeParts = time.split(':');
          if (timeParts.length >= 2) {
            final birthHour = int.parse(timeParts[0]);
            final birthMinute = int.parse(timeParts[1]);

            birthDateTime = DateTime(
              birthYear,
              birthMonth,
              birthDay,
              birthHour,
              birthMinute,
            );
          }
        }
      } catch (e) {
        debugPrint('Error parsing birth date/time: $e');
      }

      // Get current date and time
      DateTime transitDateTime = DateTime.now();

      // Ensure transit date/time is always after birth date/time
      if (birthDateTime != null) {
        // Compare transit with birth date/time
        if (transitDateTime.isBefore(birthDateTime) ||
            transitDateTime.isAtSameMomentAs(birthDateTime)) {
          // Transit is before or equal to birth, add 1 day to birth
          transitDateTime = birthDateTime.add(const Duration(days: 1));
          debugPrint(
            'Transit date/time adjusted: Added 1 day to birth date/time',
          );
        } else {
          // Check if same date but same or earlier time
          final sameDate =
              transitDateTime.year == birthDateTime.year &&
              transitDateTime.month == birthDateTime.month &&
              transitDateTime.day == birthDateTime.day;

          if (sameDate) {
            // Same date - check time
            final transitMinutes =
                transitDateTime.hour * 60 + transitDateTime.minute;
            final birthMinutes = birthDateTime.hour * 60 + birthDateTime.minute;

            if (transitMinutes <= birthMinutes) {
              // Transit time is same or earlier, add at least 1 hour
              transitDateTime = birthDateTime.add(const Duration(hours: 1));
              debugPrint(
                'Transit date/time adjusted: Added 1 hour to birth time (same date)',
              );
            }
          }
        }
      }

      final transitDate = DateFormat('dd/MM/yyyy').format(transitDateTime);
      final transitTime = DateFormat('HH:mm').format(transitDateTime);

      debugPrint('Birth Date: $date, Birth Time: $time');
      debugPrint('Transit Date (Auto): $transitDate');
      debugPrint('Transit Time (Auto): $transitTime');

      final data = await _kundliService.generateTransitChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        transitDate: transitDate,
        transitTime: transitTime,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: colorHex,
      );

      if (data != null) {
        final svgString = data['data'] as String?;
        if (svgString != null && svgString.isNotEmpty) {
          transitSvgData.value = svgString;
          debugPrint('Transit SVG Data loaded');
        } else {
          debugPrint('Transit SVG Data is null or empty');
        }
      } else {
        debugPrint('Failed to fetch Transit chart');
      }
    } catch (e) {
      debugPrint('Error fetching Transit chart: $e');
    }
  }

  /// Fetch Chalit chart when needed
  Future<void> fetchChalitChart() async {
    if (chalitSvgData.value != null && chalitSvgData.value!.isNotEmpty) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Chalit chart');
      return;
    }

    try {
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final coloredPlanets = form['coloredPlanets'] as bool? ?? true;
      const colorHex = '#ed6f30';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Chalit chart');
        return;
      }

      final data = await _kundliService.generateChalit(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        coloredPlanets: coloredPlanets,
        color: colorHex,
      );

      if (data != null) {
        final svgString = data['data'] as String?;
        if (svgString != null && svgString.isNotEmpty) {
          chalitSvgData.value = svgString;
          debugPrint('Chalit SVG Data loaded');
        } else {
          debugPrint('Chalit SVG Data is null or empty');
        }
      } else {
        debugPrint('Failed to fetch Chalit chart');
      }
    } catch (e) {
      debugPrint('Error fetching Chalit chart: $e');
    }
  }

  void onTabSelected(int index) {
    // Clear Lagna "Planet" selection when switching away from Lagna tab
    const lagnaIndex = 1;
    if (index != lagnaIndex) {
      selectedLagnaAction.value = null;
    }

    selectedTabIndex.value = index;

    // Animate PageView to selected tab (use visible index)
    final visibleIdx = visibleTabIndices.indexOf(index);
    if (visibleIdx != -1 &&
        pageController.hasClients &&
        pageController.page?.round() != visibleIdx) {
      pageController.animateToPage(
        visibleIdx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Fetch Navamsha chart when NAVAMSHA tab is selected
    if (index == 2) {
      // NAVAMSHA tab index
      fetchNavamshaChart();
    }

    // Fetch Sun chart when SUN tab is selected
    if (index == 3) {
      // SUN tab index
      fetchSunChart();
    }

    // Fetch Moon chart when MOON tab is selected
    if (index == 4) {
      // MOON tab index
      fetchMoonChart();
    }

    // Fetch Chalit chart when CHALIT tab is selected
    if (index == 5) {
      // BHAV-CHALIT tab index
      fetchChalitChart();
    }

    // Fetch Transit chart when TRANSIT tab is selected
    final transitIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'transit',
    );
    if (transitIndex != -1 && index == transitIndex) {
      fetchTransitChart();
    }

    // Fetch Navtara data when Navtara tab is selected
    final navtaraIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'navtara',
    );
    if (navtaraIndex != -1 && index == navtaraIndex) {
      _initNavtaraController();
    }

    // Fetch Planet details when LAGNA or PLANETS tab is selected
    if (index == 1) {
      fetchPlanetDetails();
    }
    final planetsIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'planets',
    );
    if (planetsIndex != -1 && index == planetsIndex) {
      fetchPlanetDetails();
    }

    // Fetch Birth Details data when BIRTH DETAILS tab is selected
    final birthDetailsIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'birth details',
    );
    if (birthDetailsIndex != -1 && index == birthDetailsIndex) {
      fetchBirthDetailsData();
    }

    // Fetch Panchang data when PANCHANG tab is selected
    final panchangIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'panchang',
    );
    if (panchangIndex != -1 && index == panchangIndex) {
      fetchPanchangData();
    }

    // Fetch Ashtakvarga data when ASHTAKVARGA tab is selected
    final ashtakvargaIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'ashtakvarga',
    );
    if (ashtakvargaIndex != -1 && index == ashtakvargaIndex) {
      fetchAshtakvargaData();
    }

    // Reset Binnashtakvarga when BINNASHTAKVARGA tab is selected (user needs to select planet)
    final binnashtakvargaIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'binnashtakvarga',
    );
    if (binnashtakvargaIndex != -1 && index == binnashtakvargaIndex) {
      // Don't fetch automatically, user needs to select a planet first
      selectedPlanetForBinnashtakvarga.value = null;
      binnashtakvargaData.value = null;
    }

    // Fetch Ashtakvarga Chart when ASHTAKVARGA CHART tab is selected
    final ashtakvargaChartIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'ashtakvarga chart',
    );
    if (ashtakvargaChartIndex != -1 && index == ashtakvargaChartIndex) {
      fetchAshtakvargaChart();
    }

    // Reset Divisional Chart when DIVISIONAL CHART tab is selected (user needs to select division)
    final divisionalChartIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'divisional chart',
    );
    if (divisionalChartIndex != -1 && index == divisionalChartIndex) {
      // Don't fetch automatically, user needs to select a division first
      selectedDivisionForChart.value = null;
      divisionalChartData.value = null;
    }

    // Fetch Ascendant Report when ASCENDANT REPORT tab is selected
    final ascendantReportIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'summary(lagna) report',
    );
    if (ascendantReportIndex != -1 && index == ascendantReportIndex) {
      fetchAscendantReport();
    }

    // Fetch Shad Bala when SHAD BALA tab is selected
    final shadBalaIndex = tabs.indexWhere(
      (tab) => tab.toLowerCase() == 'shad bala',
    );
    if (shadBalaIndex != -1 && index == shadBalaIndex) {
      fetchShadBalaDetails();
    }
  }

  Future<void> _initNavtaraController() async {
    final form = formData.value;
    if (form == null) return;

    // 1. Ensure Nakshatra is available
    if (detectedNakshatra.value == null || detectedNakshatra.value!.isEmpty) {
      debugPrint('_initNavtaraController: Nakshatra missing, fetching APIs...');
      await fetchAllNakshatraApis();
    }

    // Get nakshatra from detectedNakshatra
    final nakshatra = detectedNakshatra.value ?? "";
    debugPrint(
      '_initNavtaraController: Initializing with Nakshatra: $nakshatra',
    );

    if (!Get.isRegistered<NavtaraController>()) {
      Get.put(NavtaraController());
    }

    final navtaraController = Get.find<NavtaraController>();
    navtaraController.initFromFullKundli(
      nakshatraName: nakshatra,
      name: form['name'] ?? 'User',
      dob: form['date'] ?? '',
    );
  }

  /// Fetch Ashtakvarga Chart (SVG)
  Future<void> fetchAshtakvargaChart() async {
    if (ashtakvargaChartSvg.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Ashtakvarga Chart');
      return;
    }

    try {
      isLoadingAshtakvargaChart.value = true;

      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';
      final style = form['style'] as String? ?? 'north';
      final color = form['color'] as String? ?? '#ed6f30';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Ashtakvarga Chart');
        isLoadingAshtakvargaChart.value = false;
        return;
      }

      final data = await _kundliService.getAshtakvargaChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
        style: style,
        color: color,
      );

      if (data != null) {
        debugPrint('Ashtakvarga Chart data received, keys: ${data.keys}');

        // The API returns SVG as a string in the response
        // Check if it's directly a string or in a 'data' field
        String? svgString;

        // First check if data itself is a string (from service layer)
        if (data['data'] != null) {
          svgString = data['data'] as String?;
          debugPrint(
            'Found SVG in data["data"], type: ${svgString.runtimeType}, length: ${svgString?.length}',
          );
        } else if (data['response'] != null) {
          final response = data['response'];
          debugPrint('Found response field, type: ${response.runtimeType}');
          if (response is String) {
            svgString = response;
            debugPrint('Response is String, length: ${svgString.length}');
          } else if (response is Map && response['data'] != null) {
            svgString = response['data'] as String?;
            debugPrint(
              'Response is Map with data field, length: ${svgString?.length}',
            );
          } else if (response is Map && response['svg'] != null) {
            svgString = response['svg'] as String?;
            debugPrint(
              'Response is Map with svg field, length: ${svgString?.length}',
            );
          }
        } else if (data['svg'] != null) {
          svgString = data['svg'] as String?;
          debugPrint('Found SVG in data["svg"], length: ${svgString?.length}');
        }

        // Clean up the SVG string - JSON decode already unescapes, but check for edge cases
        if (svgString != null) {
          // Remove surrounding quotes if present (shouldn't happen after JSON decode, but just in case)
          svgString = svgString.trim();
          if (svgString.startsWith('"') &&
              svgString.endsWith('"') &&
              svgString.length > 1) {
            svgString = svgString.substring(1, svgString.length - 1);
            debugPrint('Removed surrounding quotes');
          }
          // JSON decode already handles unescaping, but if we still have literal \n (not actual newlines), fix them
          // This should only happen if the string wasn't properly decoded
          if (svgString.contains('\\n') && !svgString.contains('\n')) {
            svgString = svgString.replaceAll('\\n', '\n');
            debugPrint('Fixed literal newline escapes');
          }
          if (svgString.contains('\\"')) {
            svgString = svgString.replaceAll('\\"', '"');
            debugPrint('Fixed escaped quotes');
          }
          if (svgString.contains('\\/')) {
            svgString = svgString.replaceAll('\\/', '/');
            debugPrint('Fixed escaped slashes');
          }
          debugPrint('Cleaned SVG string, final length: ${svgString.length}');
          debugPrint(
            'SVG starts with: ${svgString.substring(0, svgString.length > 50 ? 50 : svgString.length)}',
          );
          debugPrint('SVG contains <svg>: ${svgString.contains('<svg')}');
        }

        if (svgString != null && svgString.isNotEmpty) {
          ashtakvargaChartSvg.value = svgString;
          isLoadingAshtakvargaChart.value = false;
          debugPrint(
            'Ashtakvarga Chart SVG loaded successfully, length: ${svgString.length}',
          );
        } else {
          isLoadingAshtakvargaChart.value = false;
          debugPrint('Ashtakvarga Chart SVG is empty or null');
          debugPrint('Data keys: ${data.keys}');
        }
      } else {
        isLoadingAshtakvargaChart.value = false;
        debugPrint('Failed to fetch Ashtakvarga Chart - data is null');
      }
    } catch (e) {
      isLoadingAshtakvargaChart.value = false;
      debugPrint('Error fetching Ashtakvarga Chart: $e');
    }
  }

  /// Fetch Ashtakvarga data
  Future<void> fetchAshtakvargaData() async {
    if (ashtakvargaData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Ashtakvarga');
      return;
    }

    try {
      isLoadingAshtakvarga.value = true;

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
        debugPrint('Missing required form data for Ashtakvarga');
        isLoadingAshtakvarga.value = false;
        return;
      }

      final data = await _kundliService.getAshtakvarga(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingAshtakvarga.value = false;

      if (data != null && data['response'] != null) {
        ashtakvargaData.value = data['response'] as Map<String, dynamic>;
        _extractFromResponse(ashtakvargaData.value);
        debugPrint('Ashtakvarga data loaded successfully');
      } else {
        debugPrint('Failed to fetch Ashtakvarga data');
      }
    } catch (e) {
      isLoadingAshtakvarga.value = false;
      debugPrint('Error fetching Ashtakvarga data: $e');
    }
  }

  /// Fetch Divisional Chart data for selected division
  Future<void> fetchDivisionalChartData(String division) async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Divisional Chart');
      return;
    }

    try {
      isLoadingDivisionalChart.value = true;
      selectedDivisionForChart.value = division;

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
        debugPrint('Missing required form data for Divisional Chart');
        isLoadingDivisionalChart.value = false;
        return;
      }

      final data = await _kundliService.getDivisionalChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        division: division,
        lang: lang,
      );

      isLoadingDivisionalChart.value = false;

      if (data != null && data['response'] != null) {
        divisionalChartData.value = data['response'] as Map<String, dynamic>;
        debugPrint('Divisional Chart data loaded successfully for $division');
      } else {
        debugPrint('Failed to fetch Divisional Chart data for $division');
      }
    } catch (e) {
      isLoadingDivisionalChart.value = false;
      debugPrint('Error fetching Divisional Chart data: $e');
    }
  }

  /// Fetch Ascendant Report
  Future<void> fetchAscendantReport() async {
    if (ascendantReportData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Ascendant Report');
      return;
    }

    try {
      isLoadingAscendantReport.value = true;

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
        debugPrint('Missing required form data for Ascendant Report');
        isLoadingAscendantReport.value = false;
        return;
      }

      final data = await _kundliService.getAscendantReport(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingAscendantReport.value = false;

      if (data != null && data['response'] != null) {
        final response = data['response'];
        if (response is List && response.isNotEmpty) {
          ascendantReportData.value = response[0] as Map<String, dynamic>;
          debugPrint('Ascendant Report data loaded successfully');
        } else if (response is Map) {
          ascendantReportData.value = response as Map<String, dynamic>;
          _extractFromResponse(ascendantReportData.value);
          debugPrint('Ascendant Report data loaded successfully');
        } else {
          debugPrint(
            'Failed to fetch Ascendant Report - invalid response format',
          );
        }
      } else {
        debugPrint('Failed to fetch Ascendant Report data');
      }
    } catch (e) {
      isLoadingAscendantReport.value = false;
      debugPrint('Error fetching Ascendant Report: $e');
    }
  }

  /// Fetch Shad Bala (Vedic)
  Future<void> fetchShadBalaDetails() async {
    if (shadBalaData.value != null) return;
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Shad Bala');
      return;
    }
    try {
      isLoadingShadBala.value = true;
      final form = formData.value!;
      final date = _stringFromForm(form, 'date');
      final time = _stringFromForm(form, 'time');
      final latitude = _doubleFromForm(form, 'latitude');
      final longitude = _doubleFromForm(form, 'longitude');
      final tz = _doubleFromForm(form, 'timezone');
      final lang = _stringFromForm(form, 'language') ?? 'en';
      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint(
          'Shad Bala: missing required form fields (date=$date, time=$time, lat=$latitude, lng=$longitude, tz=$tz)',
        );
        isLoadingShadBala.value = false;
        return;
      }
      final data = await _kundliService.getShadBalaVedic(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );
      isLoadingShadBala.value = false;
      if (data != null) {
        Map<String, dynamic>? responseMap;
        if (data['data'] is Map &&
            (data['data'] as Map).containsKey('response')) {
          final inner = (data['data'] as Map)['response'];
          if (inner is Map<String, dynamic>) {
            responseMap = inner;
          } else if (inner is Map) {
            responseMap = Map<String, dynamic>.from(inner);
          }
        } else if (data['response'] is Map<String, dynamic>) {
          responseMap = data['response'] as Map<String, dynamic>;
        } else if (data['response'] is Map) {
          responseMap = Map<String, dynamic>.from(data['response'] as Map);
        }
        if (responseMap != null && responseMap.isNotEmpty) {
          shadBalaData.value = responseMap;
          _extractFromResponse(shadBalaData.value);
          debugPrint('Shad Bala data loaded successfully');
        } else {
          debugPrint('Shad Bala: response map empty or invalid');
        }
      } else {
        debugPrint('Shad Bala API returned null');
      }
    } catch (e) {
      isLoadingShadBala.value = false;
      debugPrint('Error fetching Shad Bala: $e');
    }
  }

  static String? _stringFromForm(Map<String, dynamic> form, String key) {
    final v = form[key];
    if (v == null) return null;
    if (v is String) return v.isEmpty ? null : v;
    return v.toString();
  }

  static double? _doubleFromForm(Map<String, dynamic> form, String key) {
    final v = form[key];
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  /// Fetch Varshphal Details
  Future<void> fetchVarshphalDetails() async {
    if (varshphalDetailsData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Varshphal Details');
      return;
    }

    try {
      isLoadingVarshphalDetails.value = true;

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
        debugPrint('Missing required form data for Varshphal Details');
        isLoadingVarshphalDetails.value = false;
        return;
      }

      // Same logic as Lal Kitab varshphal: always call API with birth date; API returns varshphal data (e.g. next birthday year).
      final data = await _kundliService.getVarshphalDetails(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingVarshphalDetails.value = false;

      if (data != null) {
        // Handle nested response structure
        if (data['data'] != null && data['data']['response'] != null) {
          varshphalDetailsData.value =
              data['data']['response'] as Map<String, dynamic>;
          _extractFromResponse(varshphalDetailsData.value);
          debugPrint('Varshphal Details data loaded successfully');
        } else if (data['response'] != null) {
          varshphalDetailsData.value = data['response'] as Map<String, dynamic>;
          _extractFromResponse(varshphalDetailsData.value);
          debugPrint('Varshphal Details data loaded successfully');
        } else {
          debugPrint(
            'Failed to fetch Varshphal Details - invalid response format',
          );
        }
      } else {
        debugPrint('Failed to fetch Varshphal Details data');
      }
    } catch (e) {
      isLoadingVarshphalDetails.value = false;
      debugPrint('Error fetching Varshphal Details: $e');
    }
  }

  /// Fetch Varshphal Yearly Chart
  Future<void> fetchVarshphalYearlyChart() async {
    if (varshphalYearlyChartData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Varshphal Yearly Chart');
      return;
    }

    try {
      isLoadingVarshphalYearlyChart.value = true;

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
        debugPrint('Missing required form data for Varshphal Yearly Chart');
        isLoadingVarshphalYearlyChart.value = false;
        return;
      }

      // Same logic as Lal Kitab varshphal: always call API with birth date; API returns yearly chart data.
      final data = await _kundliService.getVarshphalYearlyChart(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingVarshphalYearlyChart.value = false;

      if (data != null) {
        // Handle nested response structure
        if (data['data'] != null && data['data']['response'] != null) {
          varshphalYearlyChartData.value =
              data['data']['response'] as Map<String, dynamic>;
          _extractFromResponse(varshphalYearlyChartData.value);
          debugPrint('Varshphal Yearly Chart data loaded successfully');
        } else if (data['response'] != null) {
          varshphalYearlyChartData.value =
              data['response'] as Map<String, dynamic>;
          _extractFromResponse(varshphalYearlyChartData.value);
          debugPrint('Varshphal Yearly Chart data loaded successfully');
        } else {
          debugPrint(
            'Failed to fetch Varshphal Yearly Chart - invalid response format',
          );
        }
      } else {
        debugPrint('Failed to fetch Varshphal Yearly Chart data');
      }
    } catch (e) {
      isLoadingVarshphalYearlyChart.value = false;
      debugPrint('Error fetching Varshphal Yearly Chart: $e');
    }
  }

  /// Fetch Binnashtakvarga data for selected planet
  Future<void> fetchBinnashtakvargaData(String planet) async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Binnashtakvarga');
      return;
    }

    try {
      isLoadingBinnashtakvarga.value = true;
      selectedPlanetForBinnashtakvarga.value = planet;

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
        debugPrint('Missing required form data for Binnashtakvarga');
        isLoadingBinnashtakvarga.value = false;
        return;
      }

      final data = await _kundliService.getBinnashtakvarga(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        planet: planet,
        lang: lang,
      );

      isLoadingBinnashtakvarga.value = false;

      if (data != null && data['response'] != null) {
        binnashtakvargaData.value = data['response'] as Map<String, dynamic>;
        debugPrint(
          'Binnashtakvarga data loaded successfully for planet: $planet',
        );
      } else {
        debugPrint('Failed to fetch Binnashtakvarga data');
      }
    } catch (e) {
      isLoadingBinnashtakvarga.value = false;
      debugPrint('Error fetching Binnashtakvarga data: $e');
    }
  }

  /// Fetch Panchang data
  Future<void> fetchPanchangData() async {
    if (panchangData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Panchang');
      return;
    }

    try {
      isLoadingPanchang.value = true;

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
        debugPrint('Missing required form data for Panchang');
        isLoadingPanchang.value = false;
        return;
      }

      final data = await _panchangService.getDailyPanchang(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingPanchang.value = false;

      if (data != null && data['response'] != null) {
        panchangData.value = data['response'] as Map<String, dynamic>;
        // Extract Nakshatra using deep scan
        _extractFromResponse(panchangData.value);
        debugPrint('Panchang data loaded successfully');
      } else {
        debugPrint('Failed to fetch Panchang data');
      }
    } catch (e) {
      isLoadingPanchang.value = false;
      debugPrint('Error fetching Panchang data: $e');
    }
  }

  /// Fetch Birth Details data (Planet Details and Mangal Dosh)
  Future<void> fetchBirthDetailsData() async {
    // Fetch planet details if not already loaded
    if (planetDetailsData.value == null) {
      await fetchPlanetDetails();
    }

    // Fetch mangal dosh if not already loaded
    if (mangalDoshData.value == null) {
      await fetchMangalDosh();
    }
  }

  /// Fetch Mangal Dosh
  Future<void> fetchMangalDosh() async {
    if (mangalDoshData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Mangal Dosh');
      return;
    }

    try {
      isLoadingMangalDosh.value = true;

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
        debugPrint('Missing required form data for Mangal Dosh');
        isLoadingMangalDosh.value = false;
        return;
      }

      final data = await _kundliService.getMangalDosh(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingMangalDosh.value = false;

      if (data != null) {
        mangalDoshData.value = data;
        _extractFromResponse(data);
        debugPrint('Mangal Dosh data loaded successfully');
      } else {
        debugPrint('Failed to fetch Mangal Dosh data');
      }
    } catch (e) {
      isLoadingMangalDosh.value = false;
      debugPrint('Error fetching Mangal Dosh data: $e');
    }
  }

  // Get Name from form data or user profile
  String getName() {
    // First check form data
    if (formData.value != null) {
      final name = formData.value!['name']?.toString();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
    return '-';
  }

  // Get Date from form data
  String getDate() {
    if (formData.value == null) return '-';
    return formData.value!['date']?.toString() ?? '-';
  }

  // Get Time from form data
  String getTime() {
    if (formData.value == null) return '-';
    final time = formData.value!['time']?.toString() ?? '-';
    // If time doesn't have seconds, add :00
    if (time != '-' && !time.contains(':')) {
      return '$time:00';
    }
    if (time != '-' && time.split(':').length == 2) {
      return '$time:00';
    }
    return time;
  }

  // Get Place from form data
  String getPlace() {
    if (formData.value == null) return '-';
    return formData.value!['place']?.toString() ??
        formData.value!['city']?.toString() ??
        formData.value!['selectedLocation']?.toString() ??
        '-';
  }

  // Get Gender from form data
  String getGender() {
    if (formData.value == null) return '-';
    final gender = formData.value!['gender']?.toString() ?? '-';
    if (gender != '-' && gender.isNotEmpty) {
      return gender;
    }
    return '-';
  }

  // Get Ayanamsa from planet details
  String getAyanamsa() {
    if (planetDetailsData.value == null) return '-';
    final panchang =
        planetDetailsData.value!['panchang'] as Map<String, dynamic>?;
    if (panchang == null) return '-';

    final ayanamsaName = panchang['ayanamsa_name']?.toString() ?? '';
    final ayanamsa = panchang['ayanamsa']?.toString() ?? '';

    if (ayanamsaName.isEmpty && ayanamsa.isEmpty) return '-';

    // Format ayanamsa as degrees
    String formattedAyanamsa = '';
    if (ayanamsa.isNotEmpty) {
      try {
        final ayanamsaValue = double.parse(ayanamsa);
        final degrees = ayanamsaValue.floor();
        final minutes = ((ayanamsaValue - degrees) * 60).floor();
        final seconds = (((ayanamsaValue - degrees) * 60 - minutes) * 60)
            .floor();
        formattedAyanamsa =
            '${degrees.toString().padLeft(3, '0')}Â°${minutes.toString().padLeft(2, '0')}\'${seconds.toString().padLeft(2, '0')}"';
      } catch (e) {
        formattedAyanamsa = ayanamsa;
      }
    }

    if (ayanamsaName.isNotEmpty && formattedAyanamsa.isNotEmpty) {
      return '$ayanamsaName ($formattedAyanamsa)';
    } else if (ayanamsaName.isNotEmpty) {
      return ayanamsaName;
    } else {
      return formattedAyanamsa;
    }
  }

  // Get DST (Daylight Saving Time) - usually 0 for India
  String getDST() {
    if (formData.value == null) return '0';
    return formData.value!['dst']?.toString() ?? '0';
  }

  // Get Mangal Dosh status
  String getMangalDosh() {
    if (mangalDoshData.value != null) {
      final response =
          mangalDoshData.value!['response'] as Map<String, dynamic>?;
      if (response != null) {
        final hasDosh = response['has_dosh'] as bool? ?? false;
        final doshType = response['dosh_type']?.toString() ?? '';
        if (hasDosh) {
          if (doshType.isNotEmpty) {
            return 'Yes ($doshType)';
          }
          return 'Yes';
        }
        return 'No';
      }
    }
    return '-';
  }

  // Get Rashi from planet details
  String getRashi() {
    if (planetDetailsData.value == null) return '-';
    return planetDetailsData.value!['rasi']?.toString() ?? '-';
  }

  // Get Nakshatra from detected value
  String getNakshatra() {
    return detectedNakshatra.value ?? '-';
  }

  // Calculate Age from date
  String getAge() {
    if (formData.value == null) return '-';
    final dateStr = formData.value!['date']?.toString();
    if (dateStr == null || dateStr == '-') return '-';

    try {
      // Parse date in dd/MM/yyyy format
      final dateParts = dateStr.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        final birthDate = DateTime(year, month, day);
        final now = DateTime.now();

        int years = now.year - birthDate.year;
        int months = now.month - birthDate.month;
        int days = now.day - birthDate.day;

        if (days < 0) {
          months--;
          final lastMonth = DateTime(now.year, now.month - 1, 0);
          days += lastMonth.day;
        }

        if (months < 0) {
          years--;
          months += 12;
        }

        return '${years}Y${months}M${days}D';
      }
    } catch (e) {
      debugPrint('Error calculating age: $e');
    }

    return '-';
  }

  // Get Bal Dasa from planet details
  String getBalDasa() {
    if (planetDetailsData.value == null) return '-';
    final birthDasa = planetDetailsData.value!['birth_dasa']?.toString() ?? '';
    final birthDasaTime =
        planetDetailsData.value!['birth_dasa_time']?.toString() ?? '';

    if (birthDasa.isEmpty && birthDasaTime.isEmpty) return '-';

    // Parse birth_dasa_time to extract years, months, days
    if (birthDasaTime.isNotEmpty) {
      try {
        // Try to parse as date first
        final dateParts = birthDasaTime.split('/');
        if (dateParts.length == 3) {
          // It's a date, calculate difference
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          final dasaDate = DateTime(year, month, day);
          final now = DateTime.now();

          int years = now.year - dasaDate.year;
          int months = now.month - dasaDate.month;
          int days = now.day - dasaDate.day;

          if (days < 0) {
            months--;
            final lastMonth = DateTime(now.year, now.month - 1, 0);
            days += lastMonth.day;
          }

          if (months < 0) {
            years--;
            months += 12;
          }

          final dasaPlanet = birthDasa.split('/').isNotEmpty
              ? birthDasa.split('/').last
              : '';
          return '$dasaPlanet $years Y $months M $days D';
        }
      } catch (e) {
        // If parsing fails, return as is
        return birthDasaTime;
      }
    }

    return birthDasa;
  }

  /// Fetch Planet Details for Lagna Chart
  Future<void> fetchPlanetDetails() async {
    if (planetDetailsData.value != null) {
      // Already loaded
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Planet Details');
      return;
    }

    try {
      isLoadingPlanetDetails.value = true;

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
        debugPrint('Missing required form data for Planet Details');
        isLoadingPlanetDetails.value = false;
        return;
      }

      final data = await _kundliService.getPlanetDetails(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingPlanetDetails.value = false;

      if (data != null && data['response'] != null) {
        planetDetailsData.value = data['response'] as Map<String, dynamic>;
        debugPrint(
          'Planet Details RAW Response Keys: ${planetDetailsData.value!.keys}',
        );
        // Extract Nakshatra using deep scan
        _extractFromResponse(planetDetailsData.value);
        debugPrint('Planet Details data loaded successfully');
      } else {
        debugPrint('Failed to fetch Planet Details data. Data: $data');
      }
    } catch (e) {
      isLoadingPlanetDetails.value = false;
      debugPrint('Error fetching Planet Details data: $e');
    }
  }

  Future<void> onFeatureTap(String feature) async {
    // Find matching tab by name (case-insensitive)
    final featureLower = feature.replaceAll('\n', ' ').toLowerCase();

    // Handle Planets: switch to Planets tab (slider + PlanetsWidget below, no navigation)
    if (featureLower == 'planet' || featureLower == 'planets') {
      final planetsIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'planets',
      );
      if (planetsIndex != -1) {
        selectedTabIndex.value = planetsIndex;
        final visibleIdx = visibleTabIndices.indexOf(planetsIndex);
        if (visibleIdx != -1 &&
            pageController.hasClients &&
            pageController.page?.round() != visibleIdx) {
          pageController.animateToPage(
            visibleIdx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        fetchPlanetDetails();
      }
      return;
    }

    // Handle Birth Details - switch to Birth Details tab
    if (featureLower == 'lagna') {
      final lagna = tabs.indexWhere((tab) => tab.toLowerCase() == 'lagna');
      if (lagna != -1) {
        onTabSelected(lagna);
      }
      return;
    }

    // Handle Birth Details - switch to Birth Details tab
    if (featureLower == 'sun') {
      final sun = tabs.indexWhere((tab) => tab.toLowerCase() == 'sun');
      if (sun != -1) {
        onTabSelected(sun);
      }
      return;
    }

    // Handle Birth Details - switch to Birth Details tab
    if (featureLower == 'bhav-chalit') {
      final generateChalit = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'bhav-chalit',
      );
      if (generateChalit != -1) {
        onTabSelected(generateChalit);
      }
      return;
    }

    // Handle Birth Details - switch to Birth Details tab
    if (featureLower == 'birth details') {
      final birthDetailsIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'birth details',
      );
      if (birthDetailsIndex != -1) {
        onTabSelected(birthDetailsIndex);
      }
      return;
    }

    // Handle Ashtakvarga - switch to Ashtakvarga tab
    if (featureLower == 'ashtakvarga') {
      final ashtakvargaIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'ashtakvarga',
      );
      if (ashtakvargaIndex != -1) {
        onTabSelected(ashtakvargaIndex);
      }
      return;
    }

    // Handle Divisional Chart - switch to Divisional Chart tab
    if (featureLower == 'divisional chart') {
      final divisionalChartIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'divisional chart',
      );
      if (divisionalChartIndex != -1) {
        onTabSelected(divisionalChartIndex);
      }
      return;
    }

    // Handle Shad bala - coming soon
    // if (featureLower == 'shad bala') {
    //   final shadBala = tabs.indexWhere(
    //     (tab) => tab.toLowerCase() == 'shad bala',
    //   );
    //   if (shadBala != -1) {
    //     onTabSelected(shadBala);
    //   }
    //   return;
    // }

    // Handle Ascendant Report - switch to Ascendant Report tab
    if (featureLower == 'summary(lagna) report') {
      final ascendantReportIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'summary(lagna) report',
      );
      if (ascendantReportIndex != -1) {
        onTabSelected(ascendantReportIndex);
      }
      return;
    }

    // Handle Mangal Dosh - switch to Mangal Dosh tab
    if (featureLower == 'mangal dosh') {
      final shadBalaIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'shad bala',
      );
      if (shadBalaIndex != -1) {
        onTabSelected(shadBalaIndex);
      }
      return;
    }

    // Handle Shad Bala - switch to Shad Bala tab
    if (featureLower == 'shad bala') {
      final shadBalaIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'shad bala',
      );
      if (shadBalaIndex != -1) {
        onTabSelected(shadBalaIndex);
      }
      return;
    }

    // Handle Birth Details - switch to Birth Details tab
    if (featureLower == 'navamsha') {
      final navamshaIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'navamsha',
      );
      if (navamshaIndex != -1) {
        onTabSelected(navamshaIndex);
      }
      return;
    }

    // Handle Birth Details - switch to Birth Details tab
    if (featureLower == 'moon') {
      final moonIndex = tabs.indexWhere((tab) => tab.toLowerCase() == 'moon');
      if (moonIndex != -1) {
        onTabSelected(moonIndex);
      }
      return;
    }

    /// first define the feature name to be used in the if condition

    // Handle Panchang - switch to Panchang tab
    if (featureLower == 'panchang') {
      final panchangIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'panchang',
      );
      if (panchangIndex != -1) {
        onTabSelected(panchangIndex);
      }
      return;
    }

    // Handle Binnashtakvarga - switch to Binnashtakvarga tab
    if (featureLower == 'binnashtakvarga') {
      final binnashtakvargaIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'binnashtakvarga',
      );
      if (binnashtakvargaIndex != -1) {
        onTabSelected(binnashtakvargaIndex);
      }
      return;
    }

    // Handle Binnashtakvarga - switch to Binnashtakvarga tab
    if (featureLower == 'transit') {
      final transitIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'transit',
      );
      if (transitIndex != -1) {
        onTabSelected(transitIndex);
      }
      return;
    }

    // Handle Ashtakvarga Chart - switch to Ashtakvarga Chart tab
    if (featureLower == 'ashtakvarga chart') {
      final ashtakvargaChartIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == 'ashtakvarga chart',
      );
      if (ashtakvargaChartIndex != -1) {
        onTabSelected(ashtakvargaChartIndex);
      }
      return;
    }

    // Handle Varshphal - open standalone Varshphal page (like Dasha, Dosh)
    if (featureLower == 'varshphal') {
      Get.toNamed(AppRoutes.varshphal, arguments: {'formData': formData.value});
      return;
    }

    // Coming-soon tabs: no navigation (hidden from UI)
    if (_isComingSoonTab(featureLower) ||
        featureLower == 'personal details' ||
        featureLower == 'person details') {
      return;
    }

    // Map feature names to tab names
    final Map<String, String> featureToTabMap = {
      'lagna': 'Lagna',
      'navamsha': 'Navamsha',
      'sun': 'Sun',
      'moon': 'Moon',
      'chalit': 'Bhav-Chalit',
      'planets-sub': 'Planets-Sub',
      'birth details': 'Birth Details',
      'ashtakvarga': 'Ashtakvarga',
      'Divisional Chart': 'Divisional Chart',
      'shad bala': 'Shad Bala',
      'summary(lagna) report': 'Summary(lagna) Report',
      'chalit table': 'Chalit Table',
      'panchang': 'Panchang',
      'Binnashtakvarga': 'Binnashtakvarga',
      'transit': 'Transit',
      'Ashtakvarga Chart': 'Ashtakvarga Chart',
      'bhav madhya': 'Bhav Madhya',
      'person details': 'Person Details',
      'ghatak and favourable': 'Ghatak and Favourable',
      'reports': 'Reports',
      'friendship': 'Friendship',
      'avkahada chakra': 'Avkahada Chakra',
      'download pdf': 'Download PDF',
    };

    // Get the tab name from the map
    final tabName = featureToTabMap[featureLower];

    if (tabName != null) {
      if (_isComingSoonTab(tabName)) return;

      final tabIndex = tabs.indexWhere(
        (tab) => tab.toLowerCase() == tabName.toLowerCase(),
      );

      if (tabIndex != -1) {
        onTabSelected(tabIndex);
        return;
      }
    }

    // Handle Shodashvarga navigation (feature grid title is "Shodash\nvarga")
    final featureNormalized = feature
        .replaceAll(RegExp(r'\s'), '')
        .toLowerCase();
    if (featureNormalized == 'shodashvarga') {
      Get.toNamed(
        AppRoutes.shodashvarga,
        arguments: {'formData': formData.value},
      );
      return;
    }

    // Handle Dasha navigation
    if (feature.toLowerCase() == 'dasha') {
      // Pass form data to Dasha view
      Get.toNamed(AppRoutes.dasha, arguments: {'formData': formData.value});
      return;
    }

    // Handle Yog navigation
    if (feature.toLowerCase() == 'yog') {
      // Pass form data to Yog view
      Get.toNamed(AppRoutes.yog, arguments: {'formData': formData.value});
      return;
    }

    // Handle Dosh navigation
    if (feature.toLowerCase() == 'dosh') {
      // Pass form data to Dosh view
      Get.toNamed(AppRoutes.dosh, arguments: {'formData': formData.value});
      return;
    }

    // Handle KP System navigation
    if (feature.toLowerCase() == 'kp system' ||
        feature.toLowerCase().contains('kp')) {
      // Pass form data to KP System view
      Get.toNamed(AppRoutes.kpSystem, arguments: {'formData': formData.value});
      return;
    }

    // Handle Lal Kitab navigation
    if (feature.toLowerCase().contains('lal kitab') ||
        feature.toLowerCase().contains('lal')) {
      // Pass form data to Lal Kitab view
      Get.toNamed(AppRoutes.lalKitab, arguments: {'formData': formData.value});
      return;
    }

    // Handle Predictions navigation
    if (feature.toLowerCase().contains('prediction') ||
        feature.toLowerCase().contains('predictions')) {
      // Pass form data to Predictions view
      Get.toNamed(
        AppRoutes.predictions,
        arguments: {'formData': formData.value},
      );
      return;
    }

    // Handle Navtara navigation - switch to Navtara tab
    if (featureLower.contains('navtara')) {
      debugPrint('Navtara feature tapped. Initiating transition...');

      // 1. Ensure Nakshatra is available via standard planet details (Moon Sign logic)
      if (detectedNakshatra.value == null ||
          detectedNakshatra.value!.isEmpty ||
          detectedNakshatra.value == '-') {
        debugPrint('Nakshatra not found, fetching planet details...');
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        await fetchPlanetDetails();

        if (Get.isDialogOpen ?? false) Get.back();
      }

      final nakshatra = getNakshatra();
      debugPrint('Detected Nakshatra: $nakshatra');

      if (nakshatra.isNotEmpty) {
        // 2. Show Animation/Dialog for 2 seconds
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Your Janma Nakshatra is',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nakshatra,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        // 3. Wait for 2 seconds then navigate
        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isDialogOpen ?? false) Get.back(); // Close dialog

          debugPrint(
            'Navigating to Navtara Dashboard with Nakshatra: $nakshatra',
          );
          Get.toNamed(
            AppRoutes.navtaraDashboard,
            arguments: {
              'nakshatra': nakshatra,
              'name': formData.value?['name'] ?? '',
              'dob': formData.value?['date'] ?? '',
              'initialTab': featureLower.contains('timing') ? 1 : 0,
            },
          );
        });
      } else {
        debugPrint('Failed to detect Nakshatra even after fetching.');
        Get.snackbar(
          'Error',
          'Could not detect your Nakshatra. Please check your birth details.',
        );
      }
      return;
    }

    // Handle other features - navigate to specific feature page
    // This will be implemented based on API endpoints
    debugPrint('Feature tapped: $feature (no matching tab found)');
  }

  /// Returns the detected Nakshatra or '-' if none found.

  /// Fetch all APIs that might contain Nakshatra information
  Future<void> fetchAllNakshatraApis() async {
    if (detectedNakshatra.value != null &&
        detectedNakshatra.value!.isNotEmpty &&
        detectedNakshatra.value != '-') {
      return;
    }

    if (formData.value == null) return;

    try {
      debugPrint('Fetching Nakshatra via Planet Details (Moon Sign logic)...');
      await fetchPlanetDetails();
      debugPrint(
        'Finished fetching Nakshatra. Result: ${detectedNakshatra.value}',
      );
    } catch (e) {
      debugPrint('Error fetching nakshatra: $e');
    }
  }

  /// Fetch Nakshatra Prediction for detection
  Future<void> fetchNakshatraPrediction() async {
    if (formData.value == null) return;
    try {
      debugPrint('Fetching Nakshatra Prediction for detection...');
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
          tz == null)
        return;

      final data = await _kundliService.getNakshatraPrediction(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      if (data != null) {
        debugPrint('Nakshatra Prediction RAW Data: $data');
        _extractFromResponse(data);
      }
    } catch (e) {
      debugPrint('Error fetching Nakshatra Prediction: $e');
    }
  }

  /// Deep scan a response (Map or List) to find and extract Nakshatra names.
  /// This eliminates the need for manual user input.
  /// Deep scan a response (Map or List) to find and extract Nakshatra names.
  /// This eliminates the need for manual user input.
  void _extractFromResponse(dynamic data) {
    if (data == null) return;
    // Don't overwrite if already found a valid one
    if (detectedNakshatra.value != null &&
        detectedNakshatra.value!.isNotEmpty &&
        detectedNakshatra.value != '-')
      return;

    debugPrint('Scanning response for Nakshatra...');

    void scan(dynamic obj, {int depth = 0}) {
      if (depth > 20) return; // Prevent infinite recursion
      if (detectedNakshatra.value != null &&
          detectedNakshatra.value!.isNotEmpty &&
          detectedNakshatra.value != '-')
        return;

      if (obj is Map) {
        // debugPrint('Scanning Map Keys: ${obj.keys}');
        // 1. Check for specific Nakshatra fields first
        final nakshatraKeys = [
          'nakshatra',
          'nakshatra_name',
          'nakshtra',
          'nakshtra_name',
          'birth_nakshatra',
          'Nakshatra',
          'NakshatraName',
          'janma_nakshatra',
          'star',
          'Nakshatra_Name',
        ];

        for (final key in nakshatraKeys) {
          if (obj.containsKey(key)) {
            final val = obj[key];
            if (val is String &&
                val.isNotEmpty &&
                val != '-' &&
                val.length > 2) {
              detectedNakshatra.value = val;
              debugPrint('âœ… Auto-detected Nakshatra: $val (Key: $key)');
              return;
            } else if (val is Map) {
              // If it's a map e.g. "nakshatra": {"name": "Rohini", ...}
              final innerVal =
                  val['name'] ??
                  val['Name'] ??
                  val['nakshatra'] ??
                  val['value'];
              if (innerVal is String &&
                  innerVal.isNotEmpty &&
                  innerVal != '-') {
                detectedNakshatra.value = innerVal;
                debugPrint(
                  'âœ… Auto-detected Nakshatra from map: $innerVal (Key: $key)',
                );
                return;
              }
            }
          }
        }

        // 2. Scan deeply if not found at this level
        for (final entry in obj.entries) {
          scan(entry.value, depth: depth + 1);
          if (detectedNakshatra.value != null &&
              detectedNakshatra.value!.isNotEmpty &&
              detectedNakshatra.value != '-')
            return;
        }
      } else if (obj is List) {
        for (final item in obj) {
          scan(item, depth: depth + 1);
          if (detectedNakshatra.value != null &&
              detectedNakshatra.value!.isNotEmpty &&
              detectedNakshatra.value != '-')
            return;
        }
      }
    }

    scan(data);
    if (detectedNakshatra.value == null || detectedNakshatra.value == '-') {
      debugPrint('âŒ Nakshatra NOT found in this response branch.');
    }
  }

  /// Fetch Avkahada Chakra data (often contains Nakshatra)
  Future<void> fetchAvkahadaChakra() async {
    if (formData.value == null) return;
    try {
      debugPrint('Fetching Avkahada Chakra for Nakshatra detection...');
      final form = formData.value!;
      // Re-use logic for required fields check as in other methods...
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
        return;
      }

      final data = await _kundliService.getAvkahadaChakra(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      if (data != null) {
        debugPrint('Avkahada Chakra RAW Data: $data');
        _extractFromResponse(data);
        debugPrint('Avkahada Chakra data scan complete.');
      }
    } catch (e) {
      debugPrint('Error fetching Avkahada Chakra: $e');
    }
  }
}

