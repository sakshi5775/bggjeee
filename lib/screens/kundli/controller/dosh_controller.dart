import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class DoshController extends BaseController {
  // Dosh table data for main page
  final doshTableData = [
    {'title': 'Mangal/Manglik Dosh', 'icon': Icons.warning_amber_rounded},
    {'title': 'Kaalsarp Dosh', 'icon': Icons.ac_unit},
    {'title': 'Pitra Dosh', 'icon': Icons.family_restroom},
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // Current tab index: -1 = TABLE VIEW, 0 = MANGAL/MANGLIK DOSH, 1 = KAALSARP DOSH, 2 = PITRA DOSH
  final selectedTabIndex = (-1).obs;
  
  // PageController for swipeable tabs
  late PageController pageController;
  
  // Mangal/Manglik Dosh sub-tab: 0 = Classical Vedic Astrology, 1 = Extended/Modern Manglik Analysis
  final selectedMangalSubTab = 0.obs;
  
  // API data
  final mangalDoshData = Rxn<Map<String, dynamic>>();
  final manglikDoshData = Rxn<Map<String, dynamic>>();
  final kaalsarpDoshData = Rxn<Map<String, dynamic>>();
  final pitraDoshData = Rxn<Map<String, dynamic>>();
  
  // Loading states
  final isLoadingMangalDosh = false.obs;
  final isLoadingManglikDosh = false.obs;
  final isLoadingKaalsarpDosh = false.obs;
  final isLoadingPitraDosh = false.obs;
  
  // Service
  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController with 3 tabs (excluding table view)
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
    // Map PageView index to tab index (0, 1, 2)
    selectedTabIndex.value = index;
    // Trigger navigation based on index
    if (index == 0) {
      navigateToMangalDoshTab();
    } else if (index == 1) {
      navigateToKaalsarpDoshTab();
    } else if (index == 2) {
      navigateToPitraDoshTab();
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

  // Navigate to Mangal/Manglik Dosh tab
  void navigateToMangalDoshTab() {
    selectedTabIndex.value = 0;
    selectedMangalSubTab.value = 0;
    if (mangalDoshData.value == null) {
      fetchMangalDosh();
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 0) {
      pageController.jumpToPage(0);
    }
  }

  // Navigate to Kaalsarp Dosh tab
  void navigateToKaalsarpDoshTab() {
    selectedTabIndex.value = 1;
    if (kaalsarpDoshData.value == null) {
      fetchKaalsarpDosh();
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 1) {
      pageController.jumpToPage(1);
    }
  }

  // Navigate to Pitra Dosh tab
  void navigateToPitraDoshTab() {
    selectedTabIndex.value = 2;
    if (pitraDoshData.value == null) {
      fetchPitraDosh();
    }
    // Sync PageController if needed
    if (pageController.hasClients && pageController.page?.round() != 2) {
      pageController.jumpToPage(2);
    }
  }

  // Switch Mangal sub-tab
  void switchMangalSubTab(int index) {
    selectedMangalSubTab.value = index;
    if (index == 0 && mangalDoshData.value == null) {
      fetchMangalDosh();
    } else if (index == 1 && manglikDoshData.value == null) {
      fetchManglikDosh();
    }
  }

  // Fetch Mangal Dosh (Classical Vedic Astrology)
  Future<void> fetchMangalDosh() async {
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

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
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
        debugPrint('Mangal Dosh data loaded successfully');
      } else {
        debugPrint('Failed to fetch Mangal Dosh data');
      }
    } catch (e) {
      isLoadingMangalDosh.value = false;
      debugPrint('Error fetching Mangal Dosh data: $e');
    }
  }

  // Fetch Manglik Dosh (Extended/Modern Manglik Analysis)
  Future<void> fetchManglikDosh() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Manglik Dosh');
      return;
    }

    try {
      isLoadingManglikDosh.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Manglik Dosh');
        isLoadingManglikDosh.value = false;
        return;
      }

      final data = await _kundliService.getManglikDosh(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingManglikDosh.value = false;

      if (data != null) {
        manglikDoshData.value = data;
        debugPrint('Manglik Dosh data loaded successfully');
      } else {
        debugPrint('Failed to fetch Manglik Dosh data');
      }
    } catch (e) {
      isLoadingManglikDosh.value = false;
      debugPrint('Error fetching Manglik Dosh data: $e');
    }
  }

  // Fetch Kaalsarp Dosh
  Future<void> fetchKaalsarpDosh() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Kaalsarp Dosh');
      return;
    }

    try {
      isLoadingKaalsarpDosh.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Kaalsarp Dosh');
        isLoadingKaalsarpDosh.value = false;
        return;
      }

      final data = await _kundliService.getKaalsarpDosh(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingKaalsarpDosh.value = false;

      if (data != null) {
        kaalsarpDoshData.value = data;
        debugPrint('Kaalsarp Dosh data loaded successfully');
      } else {
        debugPrint('Failed to fetch Kaalsarp Dosh data');
      }
    } catch (e) {
      isLoadingKaalsarpDosh.value = false;
      debugPrint('Error fetching Kaalsarp Dosh data: $e');
    }
  }

  // Fetch Pitra Dosh
  Future<void> fetchPitraDosh() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Pitra Dosh');
      return;
    }

    try {
      isLoadingPitraDosh.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Pitra Dosh');
        isLoadingPitraDosh.value = false;
        return;
      }

      final data = await _kundliService.getPitraDosh(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingPitraDosh.value = false;

      if (data != null) {
        pitraDoshData.value = data;
        debugPrint('Pitra Dosh data loaded successfully');
      } else {
        debugPrint('Failed to fetch Pitra Dosh data');
      }
    } catch (e) {
      isLoadingPitraDosh.value = false;
      debugPrint('Error fetching Pitra Dosh data: $e');
    }
  }
}

