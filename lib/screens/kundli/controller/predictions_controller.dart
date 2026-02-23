import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/zodiac_sign_selection_grid.dart';

class PredictionsController extends BaseController {
  // Predictions table data (removed Cloud)
  // Coming Soon features hidden in UI: Lal Kitab Teva Type, Mahadasha Phala, Baby Names, Yantra, Jadi, Ask a question
  final predictionsTableData = [
    {
      'left': 'Mangal Dosh',
      'right': 'Daily Predictions',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Kaal Sarp Dosha',
      'right': 'Sade Sati Life Report',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Lal Kitab Teva Type',
      'right': 'Lal Kitab Debt',
      'hasApi': false,
      'hasApiRight': true,
    },
    {
      'left': 'Ascendant Prediction',
      'right': 'Lal Kitab Remedies',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Gemstones Report',
      'right': 'Planet Consideration',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Mahadasha Phala',
      'right': 'Transit Today',
      'hasApi': false,
      'hasApiRight': true,
    },
    {
      'left': 'Prediction',
      'right': 'Nakshatra Report',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Moon Sign',
      'right': 'Baby Names',
      'hasApi': true,
      'hasApiRight': false,
    },
    {
      'left': 'Rudraksha',
      'right': 'Moon Sign (Classical)',
      'hasApi': true,
      'hasApiRight': false,
    }, // Moon Sign (Classical) commented out
    {'left': 'Yantra', 'right': 'Jadi', 'hasApi': false, 'hasApiRight': false},
    {
      'left': 'Numerology',
      'right': 'Panchang',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Weekly Predictions',
      'right': 'Monthly Predictions',
      'hasApi': true,
      'hasApiRight': true,
    },
    {
      'left': 'Yearly Predictions',
      'right': 'Ask a question',
      'hasApi': true,
      'hasApiRight': false,
    },
  ];

  // Form data
  final formData = Rxn<Map<String, dynamic>>();

  // Current tab index: 0 = TABLE VIEW, 1+ = specific tabs
  final selectedTabIndex = 0.obs;

  // PageController for swipeable tabs
  late PageController pageController;

  // ScrollController for tab bar (matches kundli_result_view)
  final ScrollController tabsScrollController = ScrollController();
  final Map<int, GlobalKey> tabKeys = {};

  // Selected zodiac (1-12)
  final selectedZodiac = 1.obs;
  // Moon sign fetched from API when formData exists (no user selection needed)
  final moonSignFetchedFromApi = false.obs;
  Future<void>? _moonSignFetchFuture;

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
  final rudrakshaPredictionData = Rxn<Map<String, dynamic>>();
  final lalKitabDebtsData = Rxn<Map<String, dynamic>>();
  final lalKitabRemediesData = Rxn<Map<String, dynamic>>();
  final prokeralaDailyData = Rxn<Map<String, dynamic>>();
  final prokeralaDailyAdvancedData = Rxn<Map<String, dynamic>>();
  final loveCompatibilityData = Rxn<Map<String, dynamic>>();

  // Love compatibility sign selection (1-12 for zodiacNames)
  final selectedLoveSignOne = 1.obs;
  final selectedLoveSignTwo = 4.obs; // Default Aries-Cancer

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
  final isLoadingRudraksha = false.obs;
  final isLoadingLalKitabDebts = false.obs;
  final isLoadingLalKitabRemedies = false.obs;
  final isLoadingLoveCompatibility = false.obs;

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
    // Index 0 = Table, no fetch needed. For 1-9, ensure data is loaded when swiping.
    if (index == 0) return;
    // Daily (2), Weekly (3), Monthly (4), Yearly (5) - use Moon sign from API when formData exists
    if (index == 1 && numerologyData.value == null && _canFetchNumerology()) {
      fetchNumerologyPrediction(getNameFromFormData()!.trim());
    } else if (index == 2 &&
        dailyPredictionData.value == null &&
        formData.value != null) {
      ensureMoonSignFromApi().then((_) => fetchDailyPrediction());
    } else if (index == 3 &&
        weeklyPredictionData.value == null &&
        formData.value != null) {
      ensureMoonSignFromApi().then((_) => fetchWeeklyPrediction());
    } else if (index == 4 &&
        monthlyPredictionData.value == null &&
        formData.value != null) {
      ensureMoonSignFromApi().then((_) => fetchMonthlyPrediction());
    } else if (index == 5 &&
        yearlyPredictionData.value == null &&
        formData.value != null) {
      ensureMoonSignFromApi().then((_) => fetchYearlyPrediction());
    } else if (index == 6 && ascendantPredictionData.value == null)
      fetchAscendantPrediction();
    else if (index == 7 && moonSignPredictionData.value == null)
      fetchMoonSignPrediction();
    else if (index == 8 && nakshatraPredictionData.value == null)
      fetchNakshatraPrediction();
    else if (index == 9 && panchangPredictionData.value == null)
      fetchPanchangPrediction();
    else if (index == 10 && rudrakshaPredictionData.value == null)
      fetchRudrakshaPrediction();
    else if (index == 11 && formData.value != null) {
      if (lalKitabDebtsData.value == null) fetchLalKitabDebts();
      if (lalKitabRemediesData.value == null) fetchLalKitabRemedies();
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
      // Auto-fetch Moon sign when we have birth details (no user selection needed)
      if (formData.value != null) {
        ensureMoonSignFromApi();
      }
    }
  }

  /// Fetch Moon sign from API when formData exists. Uses same APIs that return Moon sign.
  Future<void> ensureMoonSignFromApi() async {
    if (formData.value == null || moonSignFetchedFromApi.value) return;
    if (_moonSignFetchFuture != null) {
      await _moonSignFetchFuture;
      return;
    }

    _moonSignFetchFuture = _fetchMoonSignFromApiImpl();
    await _moonSignFetchFuture;
    _moonSignFetchFuture = null;
  }

  Future<void> _fetchMoonSignFromApiImpl() async {
    try {
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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

      if (data != null) {
        final response = data['response'] as Map<String, dynamic>?;
        final zodiacName = response?['zodiac']?.toString();
        if (zodiacName != null && zodiacName.isNotEmpty) {
          final zodiacNum = _zodiacNameToNumber(zodiacName);
          if (zodiacNum >= 1 && zodiacNum <= 12) {
            selectedZodiac.value = zodiacNum;
            selectedLoveSignOne.value =
                zodiacNum; // Default love compatibility to Moon sign
            moonSignFetchedFromApi.value = true;
            debugPrint('Moon sign from API: $zodiacName (zodiac #$zodiacNum)');
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching Moon sign from API: $e');
    }
  }

  int _zodiacNameToNumber(String name) {
    const map = {
      'aries': 1,
      'taurus': 2,
      'gemini': 3,
      'cancer': 4,
      'leo': 5,
      'virgo': 6,
      'libra': 7,
      'scorpio': 8,
      'sagittarius': 9,
      'capricorn': 10,
      'aquarius': 11,
      'pisces': 12,
    };
    return map[name.toLowerCase().trim()] ?? 1;
  }

  // Get name from form data
  String? getNameFromFormData() {
    if (formData.value == null) return null;
    final name = formData.value!['name']?.toString().trim();
    return (name != null && name.isNotEmpty) ? name : null;
  }

  bool _canFetchNumerology() {
    if (formData.value == null) return false;
    final name = getNameFromFormData();
    final date = formData.value!['date']?.toString().trim();
    return name != null && date != null && date.isNotEmpty;
  }

  // Navigate to table view (index 0)
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

  // Navigate to specific tab (indices 1-9 for prediction types)
  void navigateToTab(String tabName) {
    switch (tabName) {
      case 'Numerology':
        selectedTabIndex.value = 1;
        if (pageController.hasClients) {
          pageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (_canFetchNumerology()) {
          fetchNumerologyPrediction(getNameFromFormData()!.trim());
        } else {
          _showNumerologyFormDialog();
        }
        break;
      case 'Daily Predictions':
        selectedTabIndex.value = 2;
        if (pageController.hasClients) {
          pageController.animateToPage(
            2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (formData.value != null) {
          ensureMoonSignFromApi().then((_) => fetchDailyPrediction());
        } else {
          _showZodiacSelectionDialog('daily');
        }
        break;
      case 'Weekly Predictions':
        selectedTabIndex.value = 3;
        if (pageController.hasClients) {
          pageController.animateToPage(
            3,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (formData.value != null) {
          ensureMoonSignFromApi().then((_) => fetchWeeklyPrediction());
        } else {
          _showZodiacSelectionDialog('weekly');
        }
        break;
      case 'Monthly Predictions':
        selectedTabIndex.value = 4;
        if (pageController.hasClients) {
          pageController.animateToPage(
            4,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (formData.value != null) {
          ensureMoonSignFromApi().then((_) => fetchMonthlyPrediction());
        } else {
          _showZodiacSelectionDialog('monthly');
        }
        break;
      case 'Yearly Predictions':
        selectedTabIndex.value = 5;
        if (pageController.hasClients) {
          pageController.animateToPage(
            5,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (formData.value != null) {
          ensureMoonSignFromApi().then((_) => fetchYearlyPrediction());
        } else {
          _showYearlyPredictionDialog();
        }
        break;
      case 'Ascendant Prediction':
        selectedTabIndex.value = 6;
        if (pageController.hasClients) {
          pageController.animateToPage(
            6,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (ascendantPredictionData.value == null) fetchAscendantPrediction();
        break;
      case 'Moon Sign':
        selectedTabIndex.value = 7;
        if (pageController.hasClients) {
          pageController.animateToPage(
            7,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (moonSignPredictionData.value == null) fetchMoonSignPrediction();
        break;
      case 'Nakshatra Report':
        selectedTabIndex.value = 8;
        if (pageController.hasClients) {
          pageController.animateToPage(
            8,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (nakshatraPredictionData.value == null) fetchNakshatraPrediction();
        break;
      case 'Panchang':
        selectedTabIndex.value = 9;
        if (pageController.hasClients) {
          pageController.animateToPage(
            9,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (panchangPredictionData.value == null) fetchPanchangPrediction();
        break;
      case 'Rudraksha':
        if (formData.value == null) {
          showInfoMessage(
            message:
                'Please generate Kundli first to view Rudraksha suggestion.',
          );
          Get.toNamed(
            AppRoutes.kundliForm,
            arguments: {'targetRoute': AppRoutes.predictions},
          );
          return;
        }
        selectedTabIndex.value = 10;
        if (pageController.hasClients) {
          pageController.animateToPage(
            10,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (rudrakshaPredictionData.value == null) fetchRudrakshaPrediction();
        break;
      case 'Mangal Dosh':
      case 'Kaal Sarp Dosha':
        _navigateToDosh();
        break;
      case 'Sade Sati Life Report':
        _navigateToSadeSati();
        break;
      case 'Lal Kitab Debt':
      case 'Lal Kitab Remedies':
        if (formData.value == null) {
          showInfoMessage(
            message: 'Please generate Kundli first to view Lal Kitab report.',
          );
          Get.toNamed(
            AppRoutes.kundliForm,
            arguments: {'targetRoute': AppRoutes.predictions},
          );
          return;
        }
        selectedTabIndex.value = 11;
        if (pageController.hasClients) {
          pageController.animateToPage(
            11,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (lalKitabDebtsData.value == null) fetchLalKitabDebts();
        if (lalKitabRemediesData.value == null) fetchLalKitabRemedies();
        break;
      case 'Gemstones Report':
        _navigateToGemstonesReport();
        break;
      case 'Planet Consideration':
        _navigateToPlanetConsideration();
        break;
      case 'Transit Today':
        _navigateToTransitToday();
        break;
      case 'Prediction':
        selectedTabIndex.value = 2;
        if (pageController.hasClients) {
          pageController.animateToPage(
            2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (formData.value != null) {
          ensureMoonSignFromApi().then((_) => fetchDailyPrediction());
        } else {
          _showZodiacSelectionDialog('daily');
        }
        break;
      case 'Moon Sign (Classical)':
        selectedTabIndex.value = 7;
        if (pageController.hasClients) {
          pageController.animateToPage(
            7,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        if (moonSignPredictionData.value == null) fetchMoonSignPrediction();
        break;
      default:
        selectedTabIndex.value = 0;
        break;
    }
  }

  void _navigateToDosh() {
    if (formData.value == null) {
      showInfoMessage(
        message: 'Please generate Kundli first to view Dosh report.',
      );
      Get.toNamed(
        AppRoutes.kundliForm,
        arguments: {'targetRoute': AppRoutes.dosh},
      );
      return;
    }
    Get.toNamed(AppRoutes.dosh, arguments: {'formData': formData.value});
  }

  void _navigateToSadeSati() {
    if (formData.value == null) {
      showInfoMessage(
        message: 'Please generate Kundli first to view Sade Sati report.',
      );
      Get.toNamed(
        AppRoutes.kundliForm,
        arguments: {'targetRoute': AppRoutes.sadeSati},
      );
      return;
    }
    Get.toNamed(AppRoutes.sadeSati, arguments: {'formData': formData.value});
  }

  void _navigateToGemstonesReport() {
    if (formData.value == null) {
      showInfoMessage(
        message: 'Please generate Kundli first to view Gemstones report.',
      );
      Get.toNamed(
        AppRoutes.kundliForm,
        arguments: {'targetRoute': AppRoutes.gemstonesReport},
      );
      return;
    }
    Get.toNamed(
      AppRoutes.gemstonesReport,
      arguments: {'formData': formData.value},
    );
  }

  void _navigateToPlanetConsideration() {
    if (formData.value == null) {
      showInfoMessage(
        message: 'Please generate Kundli first to view Planet Consideration.',
      );
      Get.toNamed(
        AppRoutes.kundliForm,
        arguments: {'targetRoute': AppRoutes.planets},
      );
      return;
    }
    Get.toNamed(AppRoutes.planets, arguments: {'formData': formData.value});
  }

  void _navigateToTransitToday() {
    if (formData.value == null) {
      showInfoMessage(
        message: 'Please generate Kundli first to view Transit Today.',
      );
      Get.toNamed(
        AppRoutes.kundliForm,
        arguments: {'targetRoute': AppRoutes.transitToday},
      );
      return;
    }
    Get.toNamed(
      AppRoutes.transitToday,
      arguments: {'formData': formData.value},
    );
  }

  // Tab names for display (index 0 = Table, 1-11 = prediction types)
  final List<String> tabNames = [
    'Table',
    'Numerology',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'Ascendant',
    'Moon Sign',
    'Nakshatra',
    'Panchang',
    'Rudraksha',
    'Lal Kitab',
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
                          backgroundColor: Colors.red.withValues(alpha: 0.8),
                          colorText: Colors.white,
                        );
                        return;
                      }
                      Get.back();
                      if (pageController.hasClients) {
                        pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
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
          constraints: BoxConstraints(maxWidth: 400.w, maxHeight: 500.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Select Zodiac Sign',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: "#6F221E".toColor(),
                        )
                        .merge(AppTypography.h2),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Spacing.h(16),
              Expanded(
                child: SingleChildScrollView(
                  child: ZodiacSignSelectionGrid(
                    onSignSelected: (name) {
                      final index = zodiacNames.indexOf(name);
                      if (index != -1) {
                        selectedZodiac.value = index + 1;
                        Get.back();
                        final pageIndex = type == 'daily'
                            ? 2
                            : type == 'weekly'
                            ? 3
                            : 4;
                        if (pageController.hasClients) {
                          pageController.animateToPage(
                            pageIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
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
                      }
                    },
                  ),
                ),
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
          constraints: BoxConstraints(maxWidth: 400.w, maxHeight: 550.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoTranslateText(
                    'Yearly Prediction',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: "#6F221E".toColor(),
                        )
                        .merge(AppTypography.h2),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Spacing.h(16),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: "#ed6f30".toColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: "#ed6f30".toColor().withValues(alpha: 0.3),
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
                    Obx(
                      () => AutoTranslateText(
                        'Year: ${selectedYear.value}',
                        style: MyTextTheme.mediumBCB
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: "#6F221E".toColor(),
                            )
                            .merge(AppTypography.h3),
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.h(16),
              Expanded(
                child: SingleChildScrollView(
                  child: ZodiacSignSelectionGrid(
                    onSignSelected: (name) {
                      final index = zodiacNames.indexOf(name);
                      if (index != -1) {
                        selectedZodiac.value = index + 1;
                        Get.back();
                        if (pageController.hasClients) {
                          pageController.animateToPage(
                            5,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                        fetchYearlyPrediction();
                      }
                    },
                  ),
                ),
              ),
              Spacing.h(8),
              AutoTranslateText(
                'Note: Year is set to current year automatically.',
                style: MyTextTheme.smallBCN
                    .copyWith(color: Colors.grey)
                    .merge(AppTypography.body2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoveCompatibilityDialog() {
    selectedLoveSignOne.value = 1;
    selectedLoveSignTwo.value = 4;
    loveCompatibilityData.value = null;
    _showLoveCompatibilityDialog();
  }

  void _showLoveCompatibilityDialog() {
    Get.dialog(
      barrierDismissible: true,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: GetX<PredictionsController>(
          builder: (c) => Container(
            padding: EdgeInsets.all(24.w),
            constraints: BoxConstraints(maxWidth: 400.w, maxHeight: 500.h),
            child: Obx(() {
              if (c.isLoadingLoveCompatibility.value) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 32.w,
                        height: 32.w,
                        child: CircularProgressIndicator(
                          color: "#ed6f30".toColor(),
                          strokeWidth: 2,
                        ),
                      ),
                      Spacing.h(16),
                      AutoTranslateText(
                        'Loading...',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: "#6F221E".toColor(),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final data = c.loveCompatibilityData.value;
              if (data != null) {
                final predictions =
                    data['data']?['daily_love_predictions'] as List<dynamic>? ??
                    [];
                final first = predictions.isNotEmpty
                    ? predictions[0] as Map<String, dynamic>?
                    : null;
                final prediction = first?['prediction']?.toString() ?? '';
                final combo = first?['sign_combination']?.toString() ?? '';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoTranslateText(
                          'Love Compatibility',
                          style: MyTextTheme.largeBCB
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: "#6F221E".toColor(),
                              )
                              .merge(AppTypography.h2),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    if (combo.isNotEmpty) ...[
                      Spacing.h(8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: ['#FF8A3D'.toColor(), '#ed6f30'.toColor()],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: AutoTranslateText(
                          combo,
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    Spacing.h(12),
                    Flexible(
                      child: SingleChildScrollView(
                        child: AutoTranslateText(
                          prediction.isNotEmpty
                              ? prediction
                              : 'No compatibility data.',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: "#6F221E".toColor(),
                            height: 1.6,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    Spacing.h(16),
                    TextButton.icon(
                      onPressed: () {
                        c.loveCompatibilityData.value = null;
                        _showLoveCompatibilityDialog();
                      },
                      icon: Icon(
                        Icons.refresh,
                        size: 18.w,
                        color: "#ed6f30".toColor(),
                      ),
                      label: AutoTranslateText(
                        'Check Another Pair',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: "#ed6f30".toColor(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoTranslateText(
                        'Love Compatibility',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: "#6F221E".toColor(),
                            )
                            .merge(AppTypography.h2),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  AutoTranslateText(
                    'Select two zodiac signs to check daily love compatibility.',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: "#6F221E".toColor().withValues(alpha: 0.8),
                    ),
                  ),
                  Spacing.h(16),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: c.selectedLoveSignOne.value,
                      decoration: InputDecoration(
                        labelText: 'Sign 1',
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
                      items: List.generate(
                        12,
                        (i) => DropdownMenuItem<int>(
                          value: i + 1,
                          child: AutoTranslateText(zodiacNames[i]),
                        ),
                      ),
                      onChanged: (v) {
                        if (v != null) c.selectedLoveSignOne.value = v;
                      },
                    ),
                  ),
                  Spacing.h(12),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value: c.selectedLoveSignTwo.value,
                      decoration: InputDecoration(
                        labelText: 'Sign 2',
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
                      items: List.generate(
                        12,
                        (i) => DropdownMenuItem<int>(
                          value: i + 1,
                          child: AutoTranslateText(zodiacNames[i]),
                        ),
                      ),
                      onChanged: (v) {
                        if (v != null) c.selectedLoveSignTwo.value = v;
                      },
                    ),
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
                        onPressed: () => c.fetchLoveCompatibility(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: "#ed6f30".toColor(),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: AutoTranslateText('Check Compatibility'),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> fetchLoveCompatibility() async {
    try {
      isLoadingLoveCompatibility.value = true;
      final datetime = _getDatetimeForDay('today');
      final signOne = _zodiacToSign(selectedLoveSignOne.value);
      final signTwo = _zodiacToSign(selectedLoveSignTwo.value);
      final lang = formData.value?['language'] as String? ?? 'en';
      final data = await _kundliService.getProkeralaLoveCompatibility(
        datetime: datetime,
        signOne: signOne,
        signTwo: signTwo,
        lang: lang,
      );
      isLoadingLoveCompatibility.value = false;
      if (data != null) {
        loveCompatibilityData.value = data;
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch Love Compatibility. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingLoveCompatibility.value = false;
      debugPrint('Error fetching Love Compatibility: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Love Compatibility. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  // Zodiac index (1-12) to Prokerala sign name
  String _zodiacToSign(int zodiac) {
    if (zodiac < 1 || zodiac > 12) return 'aries';
    const signs = [
      'aries',
      'taurus',
      'gemini',
      'cancer',
      'leo',
      'virgo',
      'libra',
      'scorpio',
      'sagittarius',
      'capricorn',
      'aquarius',
      'pisces',
    ];
    return signs[zodiac - 1];
  }

  String _getDatetimeForDay(String day) {
    final now = DateTime.now();
    late DateTime target;
    switch (day) {
      case 'tomorrow':
        target = now.add(const Duration(days: 1));
        break;
      case 'yesterday':
        target = now.subtract(const Duration(days: 1));
        break;
      default:
        target = now;
    }
    return '${target.year}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}T23:59:59+05:30';
  }

  // Fetch Daily Prediction
  Future<void> fetchDailyPrediction() async {
    try {
      isLoadingDaily.value = true;

      final lang = formData.value?['language'] as String? ?? 'en';
      final datetime = _getDatetimeForDay(selectedDay.value);
      final sign = _zodiacToSign(selectedZodiac.value);

      final data = await _kundliService.getDailyPrediction(
        zodiac: selectedZodiac.value,
        day: selectedDay.value,
        lang: lang,
      );

      final prokeralaBasic = await _kundliService.getProkeralaDaily(
        datetime: datetime,
        sign: sign,
        lang: lang,
      );
      prokeralaDailyData.value = prokeralaBasic;

      final prokeralaData = await _kundliService.getProkeralaDailyAdvanced(
        datetime: datetime,
        sign: sign,
        type: 'all',
        lang: lang,
      );
      prokeralaDailyAdvancedData.value = prokeralaData;

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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Yearly Prediction
  Future<void> fetchYearlyPrediction() async {
    try {
      isLoadingYearly.value = true;

      final lang = formData.value?['language'] as String? ?? 'en';

      final data = await _kundliService.getYearlyPrediction(
        zodiac: selectedZodiac.value,
        year: selectedYear.value,
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Ascendant Prediction');
        isLoadingAscendant.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Moon Sign Prediction');
        isLoadingMoonSign.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Nakshatra Prediction');
        isLoadingNakshatra.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
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
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        debugPrint('Missing required form data for Panchang Prediction');
        isLoadingPanchang.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
          backgroundColor: Colors.red.withValues(alpha: 0.8),
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
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Rudraksha Prediction
  Future<void> fetchRudrakshaPrediction() async {
    if (formData.value == null) return;

    try {
      isLoadingRudraksha.value = true;

      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
        isLoadingRudraksha.value = false;
        Get.snackbar(
          'Error',
          'Missing required birth details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
        return;
      }

      final data = await _kundliService.getRudrakshSuggestion(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingRudraksha.value = false;

      if (data != null) {
        rudrakshaPredictionData.value = data;
        debugPrint('Rudraksha Prediction data loaded successfully');
      } else {
        debugPrint('Failed to fetch Rudraksha Prediction data');
        Get.snackbar(
          'Error',
          'Failed to fetch Rudraksha suggestion. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingRudraksha.value = false;
      debugPrint('Error fetching Rudraksha Prediction data: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch Rudraksha suggestion. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  // Fetch Lal Kitab Debts
  Future<void> fetchLalKitabDebts() async {
    if (formData.value == null) return;

    try {
      isLoadingLalKitabDebts.value = true;
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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
      }
    } catch (e) {
      isLoadingLalKitabDebts.value = false;
      debugPrint('Error fetching Lal Kitab Debts: $e');
    }
  }

  // Fetch Lal Kitab Remedies
  Future<void> fetchLalKitabRemedies() async {
    if (formData.value == null) return;

    try {
      isLoadingLalKitabRemedies.value = true;
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latRaw = form['latitude'];
      final lonRaw = form['longitude'];
      final tzRaw = form['timezone'];
      final latitude = latRaw is num
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final longitude = lonRaw is num
          ? lonRaw.toDouble()
          : double.tryParse(lonRaw?.toString() ?? '');
      final tz = tzRaw is num
          ? tzRaw.toDouble()
          : double.tryParse(tzRaw?.toString() ?? '');
      final lang = form['language'] as String? ?? 'en';

      if (date == null ||
          time == null ||
          latitude == null ||
          longitude == null ||
          tz == null) {
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
      }
    } catch (e) {
      isLoadingLalKitabRemedies.value = false;
      debugPrint('Error fetching Lal Kitab Remedies: $e');
    }
  }
}
