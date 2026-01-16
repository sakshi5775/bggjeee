import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class PredictionsController extends BaseController {
  // Predictions table data (removed Cloud)
  final predictionsTableData = [
    {'left': 'Mangal Dosh', 'right': 'Daily Predictions', 'hasApi': false, 'hasApiRight': true},
    {'left': 'Kaal Sarp Dosha', 'right': 'Sade Sati Life Report', 'hasApi': false, 'hasApiRight': false},
    {'left': 'Lal Kitab Teva Type', 'right': 'Lal Kitab Debt', 'hasApi': false, 'hasApiRight': false},
    {'left': 'Ascendant Prediction', 'right': 'Lal Kitab Remedies', 'hasApi': true, 'hasApiRight': false},
    {'left': 'Gemstones Report', 'right': 'Planet Consideration', 'hasApi': false, 'hasApiRight': false},
    {'left': 'Mahadasha Phala', 'right': 'Transit Today', 'hasApi': false, 'hasApiRight': false},
    {'left': 'Prediction', 'right': 'Nakshatra Report', 'hasApi': false, 'hasApiRight': true},
    {'left': 'Moon Sign', 'right': 'Baby Names', 'hasApi': true, 'hasApiRight': false},
    {'left': 'Rudraksha', 'right': 'Moon Sign (Classical)', 'hasApi': false, 'hasApiRight': true},
    {'left': 'Yantra', 'right': 'Jadi', 'hasApi': false, 'hasApiRight': false},
    {'left': 'Numerology', 'right': 'Panchang', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Weekly Predictions', 'right': 'Monthly Predictions', 'hasApi': true, 'hasApiRight': true},
    {'left': 'Yearly Predictions', 'right': 'Ask a question', 'hasApi': true, 'hasApiRight': false},
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // Current tab index: -1 = TABLE VIEW, 0+ = specific tabs
  final selectedTabIndex = (-1).obs;
  
  // PageController for swipeable tabs
  late PageController pageController;
  
  // Selected zodiac (1-12)
  final selectedZodiac = 1.obs;
  
  // Daily prediction day selection (today, tomorrow, yesterday)
  final selectedDay = 'today'.obs;
  final List<String> dayOptions = ['yesterday', 'today', 'tomorrow'];
  
  // Selected year for yearly prediction (always use current year)
  final selectedYear = DateTime.now().year.obs;
  
  // API data
  final numerologyData = Rxn<Map<String, dynamic>>();
  final dailyPredictionData = Rxn<Map<String, dynamic>>();
  final weeklyPredictionData = Rxn<Map<String, dynamic>>();
  final monthlyPredictionData = Rxn<Map<String, dynamic>>();
  final yearlyPredictionData = Rxn<Map<String, dynamic>>();
  final ascendantPredictionData = Rxn<Map<String, dynamic>>();
  final moonSignPredictionData = Rxn<Map<String, dynamic>>();
  final nakshatraPredictionData = Rxn<Map<String, dynamic>>();
  final panchangPredictionData = Rxn<Map<String, dynamic>>();
  
  // Loading states
  final isLoadingNumerology = false.obs;
  final isLoadingDaily = false.obs;
  final isLoadingWeekly = false.obs;
  final isLoadingMonthly = false.obs;
  final isLoadingYearly = false.obs;
  final isLoadingAscendant = false.obs;
  final isLoadingMoonSign = false.obs;
  final isLoadingNakshatra = false.obs;
  final isLoadingPanchang = false.obs;
  
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
  
  // Get name from form data
  String? getNameFromFormData() {
    if (formData.value == null) return null;
    return formData.value!['name']?.toString();
  }

  // Navigate to table view
  void navigateToTableView() {
    selectedTabIndex.value = -1;
  }

  // Navigate to specific tab
  void navigateToTab(String tabName) {
    switch (tabName) {
      case 'Numerology':
        selectedTabIndex.value = 0;
        _showNumerologyFormDialog();
        break;
      case 'Daily Predictions':
        selectedTabIndex.value = 1;
        _showZodiacSelectionDialog('daily');
        break;
      case 'Weekly Predictions':
        selectedTabIndex.value = 2;
        _showZodiacSelectionDialog('weekly');
        break;
      case 'Monthly Predictions':
        selectedTabIndex.value = 3;
        _showZodiacSelectionDialog('monthly');
        break;
      case 'Yearly Predictions':
        selectedTabIndex.value = 4;
        _showYearlyPredictionDialog();
        break;
      case 'Ascendant Prediction':
        selectedTabIndex.value = 5;
        if (ascendantPredictionData.value == null) {
          fetchAscendantPrediction();
        }
        break;
      case 'Moon Sign':
        selectedTabIndex.value = 6;
        if (moonSignPredictionData.value == null) {
          fetchMoonSignPrediction();
        }
        break;
      case 'Nakshatra Report':
        selectedTabIndex.value = 7;
        if (nakshatraPredictionData.value == null) {
          fetchNakshatraPrediction();
        }
        break;
      case 'Panchang':
        selectedTabIndex.value = 8;
        if (panchangPredictionData.value == null) {
          fetchPanchangPrediction();
        }
        break;
      default:
        // Coming soon tabs
        selectedTabIndex.value = 9 + _getComingSoonTabIndex(tabName);
        break;
    }
  }

  int _getComingSoonTabIndex(String tabName) {
    final comingSoonTabs = [
      'Mangal Dosh',
      'Kaal Sarp Dosha',
      'Lal Kitab Teva Type',
      'Lal Kitab Debt',
      'Lal Kitab Remedies',
      'Gemstones Report',
      'Planet Consideration',
      'Mahadasha Phala',
      'Transit Today',
      'Prediction',
      'Baby Names',
      'Moon Sign (Classical)',
      'Rudraksha',
      'Jadi',
      'Ask a question',
    ];
    return comingSoonTabs.indexOf(tabName);
  }
  
  // Tab names for display
  final List<String> tabNames = [
    'Numerology',
    'Daily Predictions',
    'Weekly Predictions',
    'Monthly Predictions',
    'Yearly Predictions',
    'Ascendant Prediction',
    'Moon Sign',
    'Nakshatra Report',
    'Panchang',
  ];

  // Zodiac names
  final List<String> zodiacNames = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  // Show Numerology form dialog
  void _showNumerologyFormDialog() {
    // Prefill name from formData if available
    final nameFromForm = getNameFromFormData();
    final nameController = TextEditingController(text: nameFromForm ?? '');
    
    Get.dialog(
      barrierDismissible: true,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          constraints: BoxConstraints(maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Numerology Prediction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: "#6F221E".toColor(),
                ).merge(AppTypography.h2),
              ),
              Spacing.h(16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              Spacing.h(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText('Cancel'),
                  ),
                  Spacing.w(12),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter your name',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                        return;
                      }
                      Get.back();
                      fetchNumerologyPrediction(nameController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: "#ed6f30".toColor(),
                      foregroundColor: Colors.white,
                    ),
                    child: AutoTranslateText('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show Zodiac selection dialog
  void _showZodiacSelectionDialog(String type) {
    Get.dialog(
      barrierDismissible: true,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          constraints: BoxConstraints(maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Select Zodiac Sign',
                    style: MyTextTheme.largeBCB.copyWith(
                      fontWeight: FontWeight.bold,
                      color: "#6F221E".toColor(),
                    ).merge(AppTypography.h2),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Spacing.h(16),
              Obx(() => DropdownButtonFormField<int>(
                value: selectedZodiac.value,
                decoration: InputDecoration(
                  labelText: 'Zodiac Sign (1-12)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: "#ed6f30".toColor(),
                      width: 2,
                    ),
                  ),
                ),
                items: List.generate(12, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: AutoTranslateText('${index + 1}. ${zodiacNames[index]}'),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    selectedZodiac.value = value;
                  }
                },
              )),
              Spacing.h(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText(
                      'Cancel',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                  ),
                  Spacing.w(12),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      switch (type) {
                        case 'daily':
                          fetchDailyPrediction();
                          break;
                        case 'weekly':
                          fetchWeeklyPrediction();
                          break;
                        case 'monthly':
                          fetchMonthlyPrediction();
                          break;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: "#ed6f30".toColor(),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                    child: AutoTranslateText(
                      'Submit',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show Yearly prediction dialog
  void _showYearlyPredictionDialog() {
    Get.dialog(
      barrierDismissible: true,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          constraints: BoxConstraints(maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Yearly Prediction',
                    style: MyTextTheme.largeBCB.copyWith(
                      fontWeight: FontWeight.bold,
                      color: "#6F221E".toColor(),
                    ).merge(AppTypography.h2),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Spacing.h(16),
              Obx(() => DropdownButtonFormField<int>(
                value: selectedZodiac.value,
                decoration: InputDecoration(
                  labelText: 'Zodiac Sign (1-12)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: "#ed6f30".toColor(),
                      width: 2,
                    ),
                  ),
                ),
                items: List.generate(12, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: AutoTranslateText('${index + 1}. ${zodiacNames[index]}'),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    selectedZodiac.value = value;
                  }
                },
              )),
              Spacing.h(16),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: "#ed6f30".toColor().withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: "#ed6f30".toColor(),
                      size: 18.w,
                    ),
                    Spacing.w(8),
                    Obx(() => AutoTranslateText(
                      'Year: ${selectedYear.value}',
                      style: MyTextTheme.mediumBCB.copyWith(
                        fontWeight: FontWeight.w600,
                        color: "#6F221E".toColor(),
                      ).merge(AppTypography.h3),
                    )),
                  ],
                ),
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Note: Year is set to current year automatically.',
                style: MyTextTheme.smallBCN.copyWith(
                  color: Colors.grey,
                ).merge(AppTypography.body2),
              ),
              Spacing.h(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText(
                      'Cancel',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: "#6F221E".toColor(),
                      ),
                    ),
                  ),
                  Spacing.w(12),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      fetchYearlyPrediction();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: "#ed6f30".toColor(),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    ),
                    child: AutoTranslateText(
                      'Submit',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch Numerology Prediction
  Future<void> fetchNumerologyPrediction(String name) async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Numerology Prediction');
      return;
    }

    try {
      isLoadingNumerology.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null) {
        debugPrint('Missing required form data for Numerology Prediction');
        isLoadingNumerology.value = false;
        Get.snackbar(
          'Error',
          'Missing birth date. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getNumerologyPrediction(
        date: date,
        name: name,
        lang: lang,
      );

      isLoadingNumerology.value = false;

      if (data != null) {
        numerologyData.value = data;
        debugPrint('Numerology Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Numerology Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Numerology Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingNumerology.value = false;
      debugPrint('Error fetching Numerology Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Numerology Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Daily Prediction
  Future<void> fetchDailyPrediction() async {
    try {
      isLoadingDaily.value = true;
      
      final lang = formData.value?['language'] as String? ?? 'en';

      final data = await _kundliService.getDailyPrediction(
        zodiac: selectedZodiac.value,
        day: selectedDay.value, // Use selected day (today, tomorrow, yesterday)
        lang: lang,
      );

      isLoadingDaily.value = false;

      if (data != null) {
        dailyPredictionData.value = data;
        debugPrint('Daily Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Daily Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Daily Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingDaily.value = false;
      debugPrint('Error fetching Daily Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Daily Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Weekly Prediction
  Future<void> fetchWeeklyPrediction() async {
    try {
      isLoadingWeekly.value = true;
      
      final lang = formData.value?['language'] as String? ?? 'en';

      final data = await _kundliService.getWeeklyPrediction(
        zodiac: selectedZodiac.value,
        lang: lang,
      );

      isLoadingWeekly.value = false;

      if (data != null) {
        weeklyPredictionData.value = data;
        debugPrint('Weekly Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Weekly Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Weekly Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingWeekly.value = false;
      debugPrint('Error fetching Weekly Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Weekly Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Monthly Prediction
  Future<void> fetchMonthlyPrediction() async {
    try {
      isLoadingMonthly.value = true;
      
      final lang = formData.value?['language'] as String? ?? 'en';

      final data = await _kundliService.getMonthlyPrediction(
        zodiac: selectedZodiac.value,
        lang: lang,
      );

      isLoadingMonthly.value = false;

      if (data != null) {
        monthlyPredictionData.value = data;
        debugPrint('Monthly Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Monthly Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Monthly Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingMonthly.value = false;
      debugPrint('Error fetching Monthly Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Monthly Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Yearly Prediction
  Future<void> fetchYearlyPrediction() async {
    try {
      isLoadingYearly.value = true;
      
      final lang = formData.value?['language'] as String? ?? 'en';
      final currentYear = DateTime.now().year; // Always use current year

      final data = await _kundliService.getYearlyPrediction(
        zodiac: selectedZodiac.value,
        year: currentYear, // Always use current year, not selectedYear
        lang: lang,
      );

      isLoadingYearly.value = false;

      if (data != null) {
        yearlyPredictionData.value = data;
        debugPrint('Yearly Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Yearly Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Yearly Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingYearly.value = false;
      debugPrint('Error fetching Yearly Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Yearly Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Ascendant Prediction
  Future<void> fetchAscendantPrediction() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Ascendant Prediction');
      return;
    }

    try {
      isLoadingAscendant.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Ascendant Prediction');
        isLoadingAscendant.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getAscendantPrediction(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingAscendant.value = false;

      if (data != null) {
        ascendantPredictionData.value = data;
        debugPrint('Ascendant Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Ascendant Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Ascendant Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingAscendant.value = false;
      debugPrint('Error fetching Ascendant Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Ascendant Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Moon Sign Prediction
  Future<void> fetchMoonSignPrediction() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Moon Sign Prediction');
      return;
    }

    try {
      isLoadingMoonSign.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Moon Sign Prediction');
        isLoadingMoonSign.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getMoonSignPrediction(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingMoonSign.value = false;

      if (data != null) {
        moonSignPredictionData.value = data;
        debugPrint('Moon Sign Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Moon Sign Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Moon Sign Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingMoonSign.value = false;
      debugPrint('Error fetching Moon Sign Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Moon Sign Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Nakshatra Prediction
  Future<void> fetchNakshatraPrediction() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Nakshatra Prediction');
      return;
    }

    try {
      isLoadingNakshatra.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Nakshatra Prediction');
        isLoadingNakshatra.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getNakshatraPrediction(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingNakshatra.value = false;

      if (data != null) {
        nakshatraPredictionData.value = data;
        debugPrint('Nakshatra Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Nakshatra Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Nakshatra Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingNakshatra.value = false;
      debugPrint('Error fetching Nakshatra Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Nakshatra Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Panchang Prediction
  Future<void> fetchPanchangPrediction() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Panchang Prediction');
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

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Panchang Prediction');
        isLoadingPanchang.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getPanchangPrediction(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingPanchang.value = false;

      if (data != null) {
        panchangPredictionData.value = data;
        debugPrint('Panchang Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Panchang Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Panchang Prediction. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingPanchang.value = false;
      debugPrint('Error fetching Panchang Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Panchang Prediction. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}

