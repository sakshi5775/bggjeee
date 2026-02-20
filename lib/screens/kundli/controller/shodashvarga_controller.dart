import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShodashvargaController extends BaseController {
  // Selected tab
  final selectedTabIndex = 0.obs;

  // ScrollController for horizontal tab bar
  final ScrollController tabsScrollController = ScrollController();

  // PageController for swipeable tabs
  late PageController pageController;

  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // Tabs - All divisions (D2 removed)
  final tabs = [
    'SHODASHVARGA',
    'D1',
    'D3',
    'D4',
    'D6',
    'D7',
    'D8',
    'D9',
    'D10',
    'D12',
    'D16',
    'D20',
    'D24',
    'D27',
    'D30',
    'D40',
    'D45',
    'D60',
  ];
  
  // Division data for table (D2 removed)
  final divisions = [
    {'name': 'Lagna', 'code': 'D1', 'description': 'Rashi Chart'},
    {'name': 'Drekkana', 'code': 'D3', 'description': 'Siblings Division'},
    {'name': 'Chaturthamsha', 'code': 'D4', 'description': 'Property Division'},
    {'name': 'Shashthamsha', 'code': 'D6', 'description': 'Health Division'},
    {'name': 'Saptamamsha', 'code': 'D7', 'description': 'Children Division'},
    {'name': 'Ashtamamsha', 'code': 'D8', 'description': 'Longevity Division'},
    {'name': 'Navamsha', 'code': 'D9', 'description': 'Spouse Division'},
    {'name': 'Dashamamsha', 'code': 'D10', 'description': 'Career Division'},
    {'name': 'Dwadashamamsha', 'code': 'D12', 'description': 'Parents Division'},
    {'name': 'Shodashamsha', 'code': 'D16', 'description': 'Vehicles Division'},
    {'name': 'Vimshamsha', 'code': 'D20', 'description': 'Spiritual Division'},
    {'name': 'Chaturvimshamsha', 'code': 'D24', 'description': 'Education Division'},
    {'name': 'Saptavimshamsha', 'code': 'D27', 'description': 'Strength Division'},
    {'name': 'Trimshamsha', 'code': 'D30', 'description': 'Evil Division'},
    {'name': 'Khavedamsha', 'code': 'D40', 'description': 'Maternal Division'},
    {'name': 'Akshvedamsha', 'code': 'D45', 'description': 'Paternal Division'},
    {'name': 'Shashtiamsha', 'code': 'D60', 'description': 'Precision Division'},
  ];

  // SVG data for each division
  final svgDataMap = <String, String?>{}.obs;
  
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
  
  // Handle page change from swipe
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    // Fetch chart for the selected division (skip index 0 which is SHODASHVARGA)
    if (index > 0 && index < tabs.length) {
      final division = tabs[index];
      _fetchChartForDivision(division);
      // Preload adjacent divisions so next/previous swipe is instant
      if (index > 1) _fetchChartForDivision(tabs[index - 1]);
      if (index + 1 < tabs.length) _fetchChartForDivision(tabs[index + 1]);
    }
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
      // Also try to get from kundliData if formData is not directly available
      if (formData.value == null) {
        final kundliData = arguments['kundliData'] as Map<String, dynamic>?;
        if (kundliData != null) {
          // Extract form data from kundliData if available
        }
      }
    }
  }

  void onTabSelected(int index) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onVargaTap(String varga) {
    // Handle varga tap - can navigate to specific varga chart or show details
    debugPrint('Varga tapped: $varga');
    // TODO: Implement navigation or action for each varga
  }

  void onDivisionTap(String code) {
    final tabIndex = tabs.indexWhere((tab) => tab == code);
    if (tabIndex != -1) {
      selectedTabIndex.value = tabIndex;
      if (pageController.hasClients) {
        pageController.animateToPage(
          tabIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      _fetchChartForDivision(code);
    } else {
      debugPrint('Division code not found: $code');
    }
  }

  Future<void> _fetchChartForDivision(String division) async {
    // Skip if already loaded
    if (svgDataMap[division] != null && svgDataMap[division]!.isNotEmpty) {
      return;
    }

    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch $division chart');
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

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for $division chart');
        return;
      }

      // Handle D1 and D9 separately as they use different methods
      Map<String, dynamic>? data;
      if (division == 'D1') {
        data = await _kundliService.generateKundli(
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
      } else if (division == 'D9') {
        data = await _kundliService.generateNavamsha(
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
      } else {
        // Use generic method for other divisions
        data = await _kundliService.generateDivisionChart(
          division: division,
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
      }

      if (data != null) {
        final svgString = data['data'] as String?;
        if (svgString != null && svgString.isNotEmpty) {
          svgDataMap[division] = svgString;
          debugPrint('$division SVG Data loaded');
        } else {
          debugPrint('$division SVG Data is null or empty');
        }
      } else {
        debugPrint('Failed to fetch $division chart');
      }
    } catch (e) {
      debugPrint('Error fetching $division chart: $e');
    }
  }

  String? getSvgDataForDivision(String division) {
    return svgDataMap[division];
  }
}

