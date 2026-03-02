import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/navtara/model/navtara_models.dart';
import 'package:astrobharataiuser/screens/navtara/service/navtara_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/navtara/widgets/navtara_loading_widget.dart';

import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';

class NavtaraController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final NavtaraService _service = NavtaraService();

  final isLoading = false.obs;
  final analysis = Rxn<NavtaraAnalysis>();
  final compatibility = Rxn<NavtaraCompatibility>();
  final timing = Rxn<NavtaraTiming>();
  final history = <dynamic>[].obs;
  final stats = Rxn<NavtaraStats>();
  final nakshatras = <Nakshatra>[].obs;

  // Input states
  final primaryNakshatra = Rxn<String>();
  final secondaryNakshatra = Rxn<String>();
  final selectedAnalysisType = 'TRANSIT'.obs;
  final selectedActivity = 'MARRIAGE'.obs;
  final selectedLanguage = 'en'.obs;
  final fullName = "".obs;
  final dateOfBirth = "".obs;
  final startDate = Rx<DateTime>(DateTime.now());
  final endDate = Rx<DateTime>(DateTime.now().add(const Duration(days: 30)));
  final questionController = TextEditingController();
  final isMatchmaking = false.obs;
  final selectedHistoryType = Rxn<String>(); // Null means 'All'
  final selectedHistoryStatus = Rxn<String>(); // Null means 'All'

  late TabController tabController;
  late PageController pageController;
  final selectedTabIndex = 0.obs;
  final ScrollController tabsScrollController = ScrollController();
  final Map<int, GlobalKey> tabKeys = {};

  final List<String> tabNames = ['Analyze', 'Timing', 'History', 'Stats'];

  @override
  void onInit() {
    super.onInit();
    // 4 tabs: Analyze, Timing, History, Stats
    tabController = TabController(length: 4, vsync: this);
    pageController = PageController(initialPage: 0);

    // Initialize from arguments if provided
    _initFromArgs();

    // Only fetch stats if balance is sufficient
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (pricingCtrl.hasSufficientBalance('navtara')) {
        fetchStats();
      }
    } else {
      fetchStats();
    }
  }

  void _initFromArgs() {
    // Check balance first - if insufficient, don't initialize anything
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('navtara')) {
        // Don't set nakshatra, name, or any data if balance is insufficient
        pricingCtrl.showInsufficientBalancePopup('navtara');
        return;
      }
    }

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      final nakshatra = args['nakshatra'] as String?;
      final name = args['name'] as String?;
      final dob = args['dob'] as String?;
      final isMatch = args['isMatchmaking'] as bool? ?? false;
      final secondaryNak = args['secondaryNakshatra'] as String?;
      final initialTab = args['initialTab'] as int? ?? 0;

      isMatchmaking.value = isMatch;
      if (nakshatra != null && nakshatra.isNotEmpty) {
        primaryNakshatra.value = nakshatra;
        fullName.value = name ?? "";
        dateOfBirth.value = dob ?? "";
        if (secondaryNak != null) secondaryNakshatra.value = secondaryNak;

        // Ensure UI stays in sync
        Future.delayed(Duration.zero, () {
          onTabSelected(initialTab);
        });
      }
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    tabsScrollController.dispose();
    questionController.dispose();
    super.onClose();
  }

  // Handle page change from swipe
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    _handleDataFetch(index);
  }

  void _handleDataFetch(int index) {
    // Check balance before any data fetch
    if (Get.isRegistered<AiPricingController>()) {
      final pricingCtrl = Get.find<AiPricingController>();
      if (!pricingCtrl.hasSufficientBalance('navtara')) {
        pricingCtrl.showInsufficientBalancePopup('navtara');
        // Clear any existing data to prevent showing nakshatra name or data
        if (index == 0) analysis.value = null;
        if (index == 1) timing.value = null;
        if (index == 2) history.clear();
        if (index == 3) stats.value = null;
        primaryNakshatra.value = null;
        fullName.value = "";
        dateOfBirth.value = "";
        return;
      }
    }

    if (index == 0 && analysis.value == null) {
      analyzeGeneral();
    } else if (index == 1 && timing.value == null) {
      findAuspiciousTiming();
    } else if (index == 2) {
      fetchHistory();
    } else if (index == 3) {
      fetchStats();
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
    tabController.animateTo(index);
    selectedTabIndex.value = index;
    _handleDataFetch(index);
  }

  void initFromMatching({
    required String boyName,
    required String boyNakshatra,
    required String girlName,
    required String girlNakshatra,
  }) {
    isMatchmaking.value = true;
    fullName.value = boyName;
    primaryNakshatra.value = boyNakshatra;
    secondaryNakshatra.value = girlNakshatra;
    checkCompatibility();
  }

  /// Initialize from Kundli Result
  void initFromKundli(String? nakshatraName) {
    if (nakshatraName != null && nakshatraName.isNotEmpty) {
      primaryNakshatra.value = nakshatraName;
      analyzeGeneral();
    }
  }

  /// Initialize from Kundli Result with full data
  void initFromFullKundli({
    required String nakshatraName,
    required String name,
    required String dob,
  }) {
    primaryNakshatra.value = nakshatraName;
    fullName.value = name;
    dateOfBirth.value = dob;
    analyzeGeneral();
  }

  Future<void> fetchNakshatras() async {
    try {
      final list = await _service.getNakshatras();
      nakshatras.value = list;
    } catch (e) {
      debugPrint('Error fetching nakshatras: $e');
    }
  }

  Future<void> analyzeGeneral({String analysisType = 'TRANSIT'}) async {
    debugPrint('analyzeGeneral called with type: $analysisType');
    debugPrint('Primary Nakshatra: ${primaryNakshatra.value}');

    if (primaryNakshatra.value == null || primaryNakshatra.value!.isEmpty) {
      debugPrint('Error: Primary Nakshatra is missing!');
      Get.snackbar(
        'Error',
        'Primary Nakshatra is missing. Please re-open from Kundli.',
      );
      return;
    }
    try {
      // Check balance
      if (Get.isRegistered<AiPricingController>()) {
        final pricingCtrl = Get.find<AiPricingController>();
        if (!pricingCtrl.hasSufficientBalance('navtara')) {
          pricingCtrl.showInsufficientBalancePopup('navtara');
          return;
        }
      }
      _showLoader('Analyzing Navtara...');
      debugPrint('Calling analyzeNavtara API...');
      analysis.value = await _service.analyzeNavtara(
        janmaNakshatra: primaryNakshatra.value!,
        analysisType: analysisType,
        question: questionController.text.isNotEmpty
            ? questionController.text
            : null,
        name: fullName.value.isNotEmpty ? fullName.value : 'User',
        dateOfBirth: dateOfBirth.value.isNotEmpty
            ? _formatDobToIso(dateOfBirth.value)
            : null,
        currentDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        language: _getLanguageName(selectedLanguage.value),
        timeout: const Duration(minutes: 5),
      );
      debugPrint(
        'analyzeNavtara API response received. Success: ${analysis.value != null}',
      );

      _hideLoader(); // Close loader before processing result UI

      if (analysis.value != null) {
        questionController.clear();
      } else {
        _showErrorDialog('Failed to generate analysis. Server might be busy.');
      }
    } catch (e) {
      debugPrint('Error in analyzeGeneral: $e');
      _hideLoader(); // Ensure loader is closed
      _showErrorDialog('An unexpected error occurred. Please try again.');
    }
  }

  Future<void> analyzeSpecific(String type) async {
    debugPrint('analyzeSpecific called with type: $type');
    // The user requested that the TIMING button in Analyze tab hits the ANALYZE API with type TIMING
    // It should NOT redirect to the Timing Tab (which uses a different API)
    await analyzeGeneral(analysisType: type);
  }

  Future<void> checkCompatibility() async {
    debugPrint(
      'checkCompatibility called with: ${primaryNakshatra.value} & ${secondaryNakshatra.value}',
    );
    if (primaryNakshatra.value == null || secondaryNakshatra.value == null) {
      debugPrint(
        'Error: One or both Nakshatras are missing for compatibility.',
      );
      return;
    }
    try {
      // Check balance
      if (Get.isRegistered<AiPricingController>()) {
        final pricingCtrl = Get.find<AiPricingController>();
        if (!pricingCtrl.hasSufficientBalance('navtara')) {
          pricingCtrl.showInsufficientBalancePopup('navtara');
          return;
        }
      }
      _showLoader('Checking Compatibility...');
      debugPrint('Calling checkCompatibility API...');
      compatibility.value = await _service.checkCompatibility(
        nakshatra1: primaryNakshatra.value!,
        nakshatra2: secondaryNakshatra.value!,
        relationshipType: 'ROMANTIC',
        language: _getLanguageName(selectedLanguage.value),
        timeout: const Duration(minutes: 5),
      );
      debugPrint(
        'checkCompatibility API response received. Success: ${compatibility.value != null}',
      );

      _hideLoader();

      if (compatibility.value == null) {
        _showErrorDialog('Failed to check compatibility.');
      }
    } catch (e) {
      debugPrint('Error in checkCompatibility: $e');
      _hideLoader();
      _showErrorDialog('An unexpected error occurred.');
    }
  }

  Future<void> findAuspiciousTiming() async {
    debugPrint('findAuspiciousTiming called (Timing Tab Logic)');
    debugPrint('Primary Nakshatra: ${primaryNakshatra.value}');
    debugPrint('Activity: ${selectedActivity.value}');

    if (primaryNakshatra.value == null || primaryNakshatra.value!.isEmpty) {
      debugPrint('Error: Primary Nakshatra is missing for Timing.');
      Get.snackbar(
        'Error',
        'Primary Nakshatra is missing for Timing analysis.',
      );
      return;
    }
    try {
      // Check balance
      if (Get.isRegistered<AiPricingController>()) {
        final pricingCtrl = Get.find<AiPricingController>();
        if (!pricingCtrl.hasSufficientBalance('navtara')) {
          pricingCtrl.showInsufficientBalancePopup('navtara');
          return;
        }
      }
      _showLoader('Finding Auspicious Timing...');
      debugPrint('Calling findTiming API...');

      // Ensure startDate is not in the past as the API prevents this
      DateTime sDate = startDate.value;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (sDate.isBefore(today)) {
        sDate = today;
        startDate.value = today; // Sync UI
      }

      timing.value = await _service.findTiming(
        janmaNakshatra: primaryNakshatra.value!,
        activityType: selectedActivity.value,
        startDate: DateFormat('yyyy-MM-dd').format(sDate),
        endDate: DateFormat('yyyy-MM-dd').format(endDate.value),
        language: _getLanguageName(selectedLanguage.value),
        timeout: const Duration(minutes: 5),
      );
      debugPrint(
        'findTiming API response received. Success: ${timing.value != null}',
      );

      _hideLoader();

      if (timing.value == null) {
        _showErrorDialog('Failed to find timing dates. Server might be busy.');
      }
    } catch (e) {
      debugPrint('Error in findAuspiciousTiming: $e');
      _hideLoader();
      _showErrorDialog('An unexpected error occurred.');
    }
  }

  Future<void> fetchHistory({String? analysisType, String? status}) async {
    try {
      isLoading.value = true;
      // Update observables if args provided
      if (analysisType != null) selectedHistoryType.value = analysisType;
      if (status != null) selectedHistoryStatus.value = status;

      final type = analysisType ?? selectedHistoryType.value;
      final stat = status ?? selectedHistoryStatus.value;

      final data = await _service.getHistory(analysisType: type, status: stat);
      history.assignAll(data);
    } catch (e) {
      debugPrint('Error in fetchHistory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchStats() async {
    try {
      stats.value = await _service.getStats();
    } catch (e) {
      debugPrint('Error fetching stats: $e');
    }
  }

  Future<void> fetchReadingDetail(String id) async {
    try {
      isLoading.value = true;
      final data = await _service.getReadingById(id);
      if (data != null) {
        final String type = data['userInput']?['analysisType'] ?? '';
        if (type == 'TRANSIT') {
          analysis.value = NavtaraAnalysis.fromJson(data);
          onTabSelected(0);
        } else if (type == 'COMPATIBILITY') {
          compatibility.value = NavtaraCompatibility.fromJson(data);
          onTabSelected(2);
        } else if (type == 'TIMING') {
          timing.value = NavtaraTiming.fromJson(data);
          onTabSelected(1);
        }
      }
    } catch (e) {
      debugPrint('Error fetching reading detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteReading(String id) async {
    try {
      final success = await _service.deleteReading(id);
      if (success) {
        fetchHistory(); // Refresh
      }
    } catch (e) {
      debugPrint('Error deleting reading: $e');
    }
  }

  void updatePrimaryNakshatra(String val) {
    primaryNakshatra.value = val;
    analyzeGeneral();
    fetchStats();
  }

  Future<void> fetchReadingDetails(String id) async {
    try {
      isLoading.value = true;
      final details = await _service.getReadingById(id);
      if (details != null) {
        if (details['analysisType'] == 'GENERAL' ||
            details['analysisType'] == 'TRANSIT') {
          analysis.value = NavtaraAnalysis.fromJson(details['data']);
          onTabSelected(0);
        } else if (details['analysisType'] == 'TIMING') {
          timing.value = NavtaraTiming.fromJson(details['data']);
          onTabSelected(1);
        } else if (details['analysisType'] == 'COMPATIBILITY') {
          compatibility.value = NavtaraCompatibility.fromJson(details['data']);
          onTabSelected(2);
        }
      }
    } catch (e) {
      debugPrint('Error in fetchReadingDetails: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSecondaryNakshatra(String val) {
    secondaryNakshatra.value = val;
    if (primaryNakshatra.value != null) {
      checkCompatibility();
    }
  }

  Future<void> selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: startDate.value,
        end: endDate.value,
      ),
    );

    if (picked != null) {
      startDate.value = picked.start;
      endDate.value = picked.end;
      findAuspiciousTiming();
    }
  }

  String _formatDobToIso(String dob) {
    if (dob.isEmpty) return dob;
    try {
      // Logic to handle dd/MM/yyyy to yyyy-MM-dd
      if (dob.contains('/')) {
        final parts = dob.split('/');
        if (parts.length == 3) {
          // Assume dd/MM/yyyy
          return "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
        }
      }
      return dob;
    } catch (e) {
      return dob;
    }
  }

  String _getLanguageName(String code) {
    switch (code.toLowerCase()) {
      case 'hi':
        return 'hindi';
      case 'kn':
        return 'kannada';
      case 'te':
        return 'telugu';
      case 'ta':
        return 'tamil';
      case 'ml':
        return 'malayalam';
      case 'mr':
        return 'marathi';
      case 'bn':
        return 'bengali';
      case 'gu':
        return 'gujarati';
      case 'en':
      default:
        return 'english';
    }
  }

  final List<String> analysisTypes = [
    'GENERAL',
    'TRANSIT',
    'TIMING',
    'COMPATIBILITY',
  ];

  final List<String> activityTypes = [
    'MARRIAGE',
    'BUSINESS_START',
    'TRAVEL',
    'PROPERTY_PURCHASE',
  ];
  /* Helper Methods */

  void _showLoader(String message) {
    if (Get.isDialogOpen == false) {
      Get.dialog(
        NavtaraLoadingWidget(message: message),
        barrierDismissible: false,
      );
    }
  }

  void _hideLoader() {
    // Only close if dialog is open (and it might be ours)
    // To be safe, we check isDialogOpen.
    // Ideally we would track if WE opened it, but for now this is standard GetX pattern.
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _showErrorDialog(String message) {
    if (Get.isDialogOpen == true) {
      Get.back(); // Close loader if open
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48.w),
              Spacing.h(16),
              AutoTranslateText(
                message,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                ),
                textAlign: TextAlign.center,
              ),
              Spacing.h(24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: "#F38B3B".toColor(),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const AutoTranslateText('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
