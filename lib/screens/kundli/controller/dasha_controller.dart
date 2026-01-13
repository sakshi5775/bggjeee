import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashaController extends BaseController {
  // Dasha table data for main page
  final dashaTableData = [
    {'left': 'Vimshottari Dasha', 'right': 'Mahadasha'},
    {'left': 'Current Mahadasha', 'right': ''},
    {'left': 'Yogini Dasha', 'right': ''},
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // Dasha API data
  final dashaData = Rxn<Map<String, dynamic>>();
  final currentMahadashaData = Rxn<Map<String, dynamic>>();
  final mahadashaData = Rxn<Map<String, dynamic>>();
  final yoginiMainData = Rxn<Map<String, dynamic>>();
  final yoginiSubData = Rxn<Map<String, dynamic>>();
  
  // Loading states
  final isLoadingCurrentMahadasha = false.obs;
  final isLoadingMahadasha = false.obs;
  final isLoadingYoginiMain = false.obs;
  final isLoadingYoginiSub = false.obs;
  
  // Current tab index: 0 = DASHA, 1 = VIMSHOTTARI DASHA, 2 = MAHADASHA, 3 = CURRENT MAHADASHA, 4 = YOGINI DASHA
  final selectedTabIndex = 0.obs;
  
  // PageController for swipeable tabs
  late PageController pageController;
  
  // Current navigation level: 'mahadasha', 'antardasha', 'paryantardasha', 'shookshamadasha', 'pranadasha'
  final currentLevel = 'mahadasha'.obs;
  
  // Yogini Dasha navigation level: 'main', 'sub'
  final yoginiCurrentLevel = 'main'.obs;
  
  // Selected item for navigation
  final selectedItemIndex = Rxn<int>();
  
  // Track selected path through hierarchy (e.g., ['Me', 'Me', 'Me', 'Me', 'Me'])
  final selectedPath = <String>[].obs;
  
  // Selected Yogini Main Dasha index
  final selectedYoginiMainIndex = Rxn<int>();
  
  // Track selected path through Yogini hierarchy (e.g., ['Mangala', 'Mangala'])
  final yoginiSelectedPath = <String>[].obs;
  
  // Service
  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController with 5 tabs
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
    switch (index) {
      case 0:
        navigateToDashaTab();
        break;
      case 1:
        navigateToVimshottariDasha();
        break;
      case 2:
        navigateToMahadashaTab();
        break;
      case 3:
        navigateToCurrentMahadashaTab();
        break;
      case 4:
        navigateToYoginiDasha();
        break;
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
    // Don't fetch data automatically - wait for user to tap "Vimshottari Dasha"
  }

  Future<void> fetchDashaData() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Dasha data');
      return;
    }

    try {
      isLoading.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Dasha');
        isLoading.value = false;
        return;
      }

      final data = await _kundliService.getCurrentMahadashaFull(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoading.value = false;

      if (data != null && data['response'] != null) {
        dashaData.value = data['response'] as Map<String, dynamic>;
        debugPrint('Dasha data loaded successfully');
      } else {
        debugPrint('Failed to fetch Dasha data');
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error fetching Dasha data: $e');
    }
  }

  // Get current list based on level
  List<Map<String, dynamic>> getCurrentList() {
    if (dashaData.value == null) return [];
    
    final response = dashaData.value!;
    
    switch (currentLevel.value) {
      case 'mahadasha':
        final list = response['mahadasha'] as List<dynamic>?;
        return list?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      case 'antardasha':
        final list = response['antardasha'] as List<dynamic>?;
        return list?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      case 'paryantardasha':
        final list = response['paryantardasha'] as List<dynamic>?;
        return list?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      case 'shookshamadasha':
        final list = response['Shookshamadasha'] as List<dynamic>?;
        return list?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      case 'pranadasha':
        final list = response['Pranadasha'] as List<dynamic>?;
        return list?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      default:
        return [];
    }
  }

  // Get level title
  String getLevelTitle() {
    switch (currentLevel.value) {
      case 'mahadasha':
        return 'Vimshottari Maha Dasha';
      case 'antardasha':
        return 'Vimshottari Antar Dasha';
      case 'paryantardasha':
        return 'Vimshottari Paryantar Dasha';
      case 'shookshamadasha':
        return 'Vimshottari Shooksham Dasha';
      case 'pranadasha':
        return 'Vimshottari Prana Dasha';
      default:
        return 'Dasha';
    }
  }

  // Get next level
  String? getNextLevel() {
    switch (currentLevel.value) {
      case 'mahadasha':
        return 'antardasha';
      case 'antardasha':
        return 'paryantardasha';
      case 'paryantardasha':
        return 'shookshamadasha';
      case 'shookshamadasha':
        return 'pranadasha';
      case 'pranadasha':
        return null; // Last level
      default:
        return null;
    }
  }

  // Navigate to next level
  void onDashaItemTap(int index) {
    final nextLevel = getNextLevel();
    if (nextLevel != null) {
      final currentList = getCurrentList();
      if (index < currentList.length) {
        final item = currentList[index];
        final planetName = item['name'] as String? ?? '';
        final planetShort = getPlanetShortName(planetName);
        
        // Add to path
        selectedPath.add(planetShort);
        selectedItemIndex.value = index;
        currentLevel.value = nextLevel;
      }
    } else {
      debugPrint('Already at the last level');
    }
  }

  // Navigate back
  void navigateBack() {
    switch (currentLevel.value) {
      case 'antardasha':
        currentLevel.value = 'mahadasha';
        selectedItemIndex.value = null;
        selectedPath.clear();
        break;
      case 'paryantardasha':
        currentLevel.value = 'antardasha';
        selectedItemIndex.value = null;
        if (selectedPath.isNotEmpty) {
          selectedPath.removeLast();
        }
        break;
      case 'shookshamadasha':
        currentLevel.value = 'paryantardasha';
        selectedItemIndex.value = null;
        if (selectedPath.isNotEmpty) {
          selectedPath.removeLast();
        }
        break;
      case 'pranadasha':
        currentLevel.value = 'shookshamadasha';
        selectedItemIndex.value = null;
        if (selectedPath.isNotEmpty) {
          selectedPath.removeLast();
        }
        break;
      default:
        Get.back();
    }
  }
  
  // Get full path string (e.g., "Me/Me/Me/Me/Me")
  String getFullPath(String currentPlanetShort) {
    if (selectedPath.isEmpty) {
      return currentPlanetShort;
    }
    return '${selectedPath.join('/')}/$currentPlanetShort';
  }
  
  // Check if we can go back
  bool canGoBack() {
    return currentLevel.value != 'mahadasha';
  }

  // Format date from API (e.g., "Wed Dec 14 2016" to "14/12/2016")
  String formatDate(String dateStr) {
    try {
      // Try parsing date like "Wed Dec 14 2016"
      DateTime? date;
      
      // Try different date formats
      final formats = [
        'EEE MMM dd yyyy',  // "Wed Dec 14 2016"
        'EEE, MMM dd yyyy', // "Wed, Dec 14 2016"
        'MMM dd yyyy',      // "Dec 14 2016"
        'dd/MM/yyyy',       // Already in correct format
      ];
      
      for (final format in formats) {
        try {
          date = DateFormat(format).parse(dateStr);
          break;
        } catch (e) {
          continue;
        }
      }
      
      if (date != null) {
        return DateFormat('dd/MM/yyyy').format(date);
      }
      
      return dateStr;
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return dateStr;
    }
  }

  // Get planet short name
  String getPlanetShortName(String name) {
    final planetMap = {
      'Sun': 'Su',
      'Moon': 'Mo',
      'Mars': 'Ma',
      'Mercury': 'Me',
      'Jupiter': 'Ju',
      'Venus': 'Ve',
      'Saturn': 'Sa',
      'Rahu': 'Ra',
      'Ketu': 'Ke',
    };
    return planetMap[name] ?? name;
  }

  // Navigate to Vimshottari Dasha
  void navigateToVimshottariDasha() {
    selectedTabIndex.value = 1; // Switch to VIMSHOTTARI DASHA tab
    currentLevel.value = 'mahadasha';
    selectedItemIndex.value = null;
    selectedPath.clear();
    // Fetch data if not already loaded
    if (dashaData.value == null) {
      if (formData.value != null) {
        fetchDashaData();
      } else {
        debugPrint('Form data is null, cannot fetch Vimshottari Dasha data');
      }
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 1) {
      pageController.jumpToPage(1);
    }
  }
  
  // Navigate to DASHA tab
  void navigateToDashaTab() {
    selectedTabIndex.value = 0;
    dashaData.value = null;
    currentLevel.value = 'mahadasha';
    selectedItemIndex.value = null;
    selectedPath.clear();
    // Reset Yogini state
    yoginiCurrentLevel.value = 'main';
    selectedYoginiMainIndex.value = null;
    yoginiSelectedPath.clear();
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 0) {
      pageController.jumpToPage(0);
    }
  }
  
  // Navigate to Mahadasha tab
  void navigateToMahadashaTab() {
    selectedTabIndex.value = 2;
    if (mahadashaData.value == null) {
      fetchMahadasha();
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 2) {
      pageController.jumpToPage(2);
    }
  }
  
  // Navigate to Current Mahadasha tab
  void navigateToCurrentMahadashaTab() {
    selectedTabIndex.value = 3;
    if (currentMahadashaData.value == null) {
      fetchCurrentMahadasha();
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 3) {
      pageController.jumpToPage(3);
    }
  }
  
  // Navigate to Yogini Dasha
  void navigateToYoginiDasha() {
    selectedTabIndex.value = 4; // Switch to YOGINI DASHA tab
    yoginiCurrentLevel.value = 'main';
    selectedYoginiMainIndex.value = null;
    yoginiSelectedPath.clear();
    // Fetch main data if not already loaded
    if (yoginiMainData.value == null) {
      if (formData.value != null) {
        fetchYoginiMain();
      } else {
        debugPrint('Form data is null, cannot fetch Yogini Dasha data');
      }
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 4) {
      pageController.jumpToPage(4);
    }
  }
  
  // Get Yogini Main list
  List<Map<String, dynamic>> getYoginiMainList() {
    if (yoginiMainData.value == null) return [];
    
    final response = yoginiMainData.value!['response'] as Map<String, dynamic>?;
    if (response == null) return [];
    
    final dashaList = response['dasha_list'] as List<dynamic>? ?? [];
    final dashaEndDates = response['dasha_end_dates'] as List<dynamic>? ?? [];
    final dashaLordList = response['dasha_lord_list'] as List<dynamic>? ?? [];
    
    final List<Map<String, dynamic>> result = [];
    for (int i = 0; i < dashaList.length; i++) {
      result.add({
        'dasha': dashaList[i].toString(),
        'lord': i < dashaLordList.length ? dashaLordList[i].toString() : '',
        'end_date': i < dashaEndDates.length ? dashaEndDates[i].toString() : '',
      });
    }
    return result;
  }
  
  // Get Yogini Sub list for selected main dasha
  List<Map<String, dynamic>> getYoginiSubList() {
    if (yoginiSubData.value == null || selectedYoginiMainIndex.value == null) return [];
    
    final response = yoginiSubData.value!['response'] as List<dynamic>?;
    if (response == null || response.isEmpty) return [];
    
    final mainIndex = selectedYoginiMainIndex.value!;
    if (mainIndex >= response.length) return [];
    
    final mainDashaItem = response[mainIndex] as Map<String, dynamic>;
    final subDashaList = mainDashaItem['sub_dasha_list'] as List<dynamic>? ?? [];
    final subDashaEndDates = mainDashaItem['sub_dasha_end_dates'] as List<dynamic>? ?? [];
    
    final List<Map<String, dynamic>> result = [];
    for (int i = 0; i < subDashaList.length; i++) {
      result.add({
        'dasha': subDashaList[i].toString(),
        'end_date': i < subDashaEndDates.length ? subDashaEndDates[i].toString() : '',
      });
    }
    return result;
  }
  
  // Get selected Yogini Main Dasha info
  Map<String, dynamic>? getSelectedYoginiMainInfo() {
    if (yoginiSubData.value == null || selectedYoginiMainIndex.value == null) return null;
    
    final response = yoginiSubData.value!['response'] as List<dynamic>?;
    if (response == null || response.isEmpty) return null;
    
    final mainIndex = selectedYoginiMainIndex.value!;
    if (mainIndex >= response.length) return null;
    
    return response[mainIndex] as Map<String, dynamic>;
  }
  
  // Navigate to Yogini Sub level
  void onYoginiMainItemTap(int index) {
    final mainList = getYoginiMainList();
    if (index < mainList.length) {
      final mainDasha = mainList[index];
      final dashaName = mainDasha['dasha'] as String? ?? '';
      // Add main dasha to path
      yoginiSelectedPath.add(dashaName);
      selectedYoginiMainIndex.value = index;
      yoginiCurrentLevel.value = 'sub';
      // Fetch sub data if not already loaded
      if (yoginiSubData.value == null) {
        if (formData.value != null) {
          fetchYoginiSub();
        } else {
          debugPrint('Form data is null, cannot fetch Yogini Sub data');
        }
      }
    }
  }
  
  // Navigate back from Yogini Sub to Main
  void navigateYoginiBack() {
    if (yoginiCurrentLevel.value == 'sub') {
      yoginiCurrentLevel.value = 'main';
      selectedYoginiMainIndex.value = null;
      // Remove from path
      if (yoginiSelectedPath.isNotEmpty) {
        yoginiSelectedPath.removeLast();
      }
    }
  }
  
  // Get full Yogini path string (e.g., "Mangala/Mangala")
  String getYoginiFullPath(String currentDasha) {
    if (yoginiSelectedPath.isEmpty) {
      return currentDasha;
    }
    return '${yoginiSelectedPath.join('/')}/$currentDasha';
  }
  
  // Check if can go back in Yogini
  bool canGoBackYogini() {
    return yoginiCurrentLevel.value == 'sub';
  }
  
  // Get Yogini level title
  String getYoginiLevelTitle() {
    if (yoginiCurrentLevel.value == 'main') {
      return 'Yogini Dasha Main';
    } else {
      final mainInfo = getSelectedYoginiMainInfo();
      final mainDasha = mainInfo?['main_dasha']?.toString() ?? '';
      return 'Yogini Dasha Sub - $mainDasha';
    }
  }

  // Fetch Current Mahadasha
  Future<void> fetchCurrentMahadasha() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Current Mahadasha');
      return;
    }

    try {
      isLoadingCurrentMahadasha.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Current Mahadasha');
        isLoadingCurrentMahadasha.value = false;
        return;
      }

      final data = await _kundliService.getCurrentMahadasha(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingCurrentMahadasha.value = false;

      if (data != null) {
        currentMahadashaData.value = data;
        debugPrint('Current Mahadasha data loaded successfully');
      } else {
        debugPrint('Failed to fetch Current Mahadasha data');
      }
    } catch (e) {
      isLoadingCurrentMahadasha.value = false;
      debugPrint('Error fetching Current Mahadasha data: $e');
    }
  }

  // Fetch Mahadasha
  Future<void> fetchMahadasha() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Mahadasha');
      return;
    }

    try {
      isLoadingMahadasha.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Mahadasha');
        isLoadingMahadasha.value = false;
        return;
      }

      final data = await _kundliService.getMahadasha(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingMahadasha.value = false;

      if (data != null) {
        mahadashaData.value = data;
        debugPrint('Mahadasha data loaded successfully');
      } else {
        debugPrint('Failed to fetch Mahadasha data');
      }
    } catch (e) {
      isLoadingMahadasha.value = false;
      debugPrint('Error fetching Mahadasha data: $e');
    }
  }

  // Fetch Yogini Main
  Future<void> fetchYoginiMain() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Yogini Main');
      return;
    }

    try {
      isLoadingYoginiMain.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Yogini Main');
        isLoadingYoginiMain.value = false;
        return;
      }

      final data = await _kundliService.getYoginiDashaMain(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingYoginiMain.value = false;

      if (data != null) {
        yoginiMainData.value = data;
        debugPrint('Yogini Main data loaded successfully');
      } else {
        debugPrint('Failed to fetch Yogini Main data');
      }
    } catch (e) {
      isLoadingYoginiMain.value = false;
      debugPrint('Error fetching Yogini Main data: $e');
    }
  }

  // Fetch Yogini Sub
  Future<void> fetchYoginiSub() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Yogini Sub');
      return;
    }

    try {
      isLoadingYoginiSub.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Yogini Sub');
        isLoadingYoginiSub.value = false;
        return;
      }

      final data = await _kundliService.getYoginiDashaSub(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingYoginiSub.value = false;

      if (data != null) {
        yoginiSubData.value = data;
        debugPrint('Yogini Sub data loaded successfully');
      } else {
        debugPrint('Failed to fetch Yogini Sub data');
      }
    } catch (e) {
      isLoadingYoginiSub.value = false;
      debugPrint('Error fetching Yogini Sub data: $e');
    }
  }
}
