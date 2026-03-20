import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/service/match_making_service.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/widgets/astrologers_section_widget.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/widgets/compatibility_report_widget.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/widgets/match_making_lagna_chart_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

import 'package:astrobharataiuser/screens/navtara/controller/navtara_controller.dart';
import 'package:astrobharataiuser/screens/navtara/widgets/navtara_compatibility_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/widgets/common_tab_slider.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MatchMakingResultView extends StatefulWidget {
  const MatchMakingResultView({super.key});

  @override
  State<MatchMakingResultView> createState() => _MatchMakingResultViewState();
}

class _MatchMakingResultViewState extends State<MatchMakingResultView> {
  bool _showMatchingImage = true;
  final MatchMakingService _service = MatchMakingService();
  Map<String, dynamic>? _currentResponse;
  final Map<String, Map<String, dynamic>> _tabResponses = {};
  Map<String, dynamic>? _formData;
  bool _isFetching = false;
  String _activeTab = 'North Match';
  late PageController _pageController;
  bool _hasRunExtractors = false;
  final List<String> _tabs = [
    'North Match',
    'South Match',
    'East Match',
    'Aggregate Match',
    'Rajju Vedha Details',
    'Papasamaya Match',
    'Nakshatra Match',
    'Western Match',
    'Navtara',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // Register NavtaraController if not already registered
    if (!Get.isRegistered<NavtaraController>()) {
      Get.put(NavtaraController());
    }
    // Register AiPricingController for pricing checks
    if (!Get.isRegistered<AiPricingController>()) {
      Get.put(AiPricingController());
    }
    // After first build, seed North tab response and extract nakshatra/zodiac from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_currentResponse != null && !_tabResponses.containsKey('North Match')) {
        _tabResponses['North Match'] = _currentResponse!;
      }
      if (!_hasRunExtractors) {
        _hasRunExtractors = true;
        _extractNakshatraNumbers();
        _extractZodiacSigns();
      }
      if (mounted) setState(() {});
    });
    // Show matching animation for 3 seconds, then show report
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showMatchingImage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;

    // Only require args when we don't already have data (Get.arguments can become null after route/nav updates, e.g. when Navtara dialog closes)
    if (_currentResponse == null) {
      if (args == null || args is! Map<String, dynamic>) {
        return _buildErrorView('No data available');
      }

      _formData ??= args['formData'] as Map<String, dynamic>?;

      // Handle response - it can be a String (error) or Map (success)
      final responseValue = args['response'];
      if (responseValue is Map<String, dynamic>) {
        // Check if it's nested under 'response' key (API structure: {status: 200, response: {...}})
        if (responseValue.containsKey('response') && responseValue['response'] is Map<String, dynamic>) {
          _currentResponse = responseValue['response'] as Map<String, dynamic>;
        } else {
          _currentResponse = responseValue;
        }
      } else if (responseValue is String) {
        return _buildErrorView(responseValue);
      } else {
        final status = args['status'];
        final responseMsg = args['response'];
        if (status != null && status != 200 && responseMsg is String) {
          return _buildErrorView(responseMsg);
        }
        // Check if args itself has nested response
        if (args.containsKey('response') && args['response'] is Map<String, dynamic>) {
          _currentResponse = args['response'] as Map<String, dynamic>;
        } else {
          _currentResponse = args;
        }
      }

      if (_currentResponse == null) {
        return _buildErrorView('No data available');
      }
    }

    // Check if response has status at top level (might be nested structure)
    final status = _currentResponse!['status'];
    if (status != null && status != 200) {
      final errorMsg = _currentResponse!['response'];
      if (errorMsg is String) {
        return _buildErrorView(errorMsg);
      }
    }

    if (_showMatchingImage) {
      return Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Lottie.network(
              AppConstant.matchMakingKundliJson,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              repeat: true,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(
              title: 'Match Making Result',
              showBackButton: true,
            ),
            _buildMatchTabs(),
            if (_isFetching)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  if (index < _tabs.length && _activeTab != _tabs[index]) {
                    // Call _onTabSelected first so it runs (it updates _activeTab inside)
                    _onTabSelected(_tabs[index], fromSwipe: true);
                  }
                },
                children: _tabs.map((tab) {
                  final responseForTab = _tabResponses[tab] ?? _currentResponse;
                  final showLoading = _isFetching && tab == _activeTab;
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          child: showLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : responseForTab == null
                                  ? Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(24.w),
                                        child: AutoTranslateText(
                                          'Tap the tab to load',
                                          style: MyTextTheme.mediumBCN,
                                        ),
                                      ),
                                    )
                                  : CompatibilityReportWidget(
                                      data: responseForTab,
                                      formData: _formData,
                                      showProfile:
                                          tab == 'North Match' ||
                                          tab == 'South Match' ||
                                          tab == 'East Match',
                                      showGunMilan: tab == 'North Match' || tab == 'East Match',
                                      showDashakootGunMilan: tab == 'South Match',
                                      matchScoreTotalOverride: _resolveTotal(responseForTab, tab),
                                      showTotalSeparately: tab == 'Western Match',
                                      rawTotal: tab == 'Western Match' ? null : responseForTab['total'] as num?,
                                      showScoreAsPercentage: tab == 'Western Match',
                                      kundliSection:
                                          (tab == 'North Match' ||
                                              tab == 'South Match' ||
                                              tab == 'East Match') &&
                                              _formData != null
                                          ? MatchMakingLagnaChartWidget(
                                              formData: _formData!,
                                              chartStyle: tab == 'North Match'
                                                  ? 'north'
                                                  : tab == 'South Match'
                                                      ? 'south'
                                                      : 'east',
                                            )
                                          : null,
                                      showNavtaraOnly: tab == 'Navtara',
                                      showNavtaraSection: tab == 'Navtara',
                                      matchLabel: tab == 'Papasamaya Match'
                                          ? 'Papa Match'
                                          : tab == 'Nakshatra Match'
                                          ? 'Star Match'
                                          : tab == 'Western Match'
                                          ? 'Zodiac Match'
                                          : 'Gun Milan',
                                      chartStyleForFullKundli: tab == 'North Match'
                                          ? 'north'
                                          : tab == 'South Match'
                                              ? 'south'
                                              : tab == 'East Match'
                                                  ? 'east'
                                                  : 'north',
                                      navtaraWidget: tab == 'Navtara'
                                          ? (Get.isRegistered<NavtaraController>()
                                              ? Obx(() {
                                                  final ctl = Get.find<NavtaraController>();
                                                  return ctl.compatibility.value != null
                                                      ? NavtaraCompatibilityWidget(controller: ctl)
                                                      : const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                })
                                              : const SizedBox.shrink())
                                          : null,
                                    ),
                        ),
                        Spacing.h(20),
                        const AstrologersSectionWidget(),
                        Spacing.h(20),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final List<String?> _tabPricingKeys = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    'navtara', // Navtara tab shows price badge
  ];

  Widget _buildMatchTabs() {
    final selectedIndex = _tabs.indexWhere((t) => t == _activeTab);
    final effectiveIndex = selectedIndex >= 0 ? selectedIndex : 0;

    return CommonTabSlider(
      tabs: _tabs,
      selectedIndex: effectiveIndex,
      onTabSelected: (index) {
        if (index < _tabs.length) {
          _onTabSelected(_tabs[index], fromSwipe: false);
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      tabPricingKeys: _tabPricingKeys,
    );
  }

  Future<void> _onTabSelected(String tab, {bool fromSwipe = false}) async {
    if (_isFetching || _activeTab == tab) return;
    final form = _formData;
    if (form == null) {
      return;
    }

    // All matchmaking APIs: use cached data when available so we don't hit APIs again on tab switch
    // North Match, South Match, East Match, Aggregate, Rajju Vedha, Papasamaya, Nakshatra, Western → _tabResponses[tab]
    // Navtara → NavtaraController.compatibility
    if (tab == 'Navtara') {
      if (Get.isRegistered<NavtaraController>()) {
        final navtaraCtl = Get.find<NavtaraController>();
        if (navtaraCtl.compatibility.value != null) {
          setState(() => _activeTab = tab);
          return;
        }
      }
    } else {
      final cached = _tabResponses[tab];
      if (cached != null) {
        setState(() {
          _activeTab = tab;
          _currentResponse = cached;
        });
        return;
      }
    }

    // Check balance for Navtara tab
    if (tab == 'Navtara') {
      if (Get.isRegistered<AiPricingController>()) {
        final pricingCtrl = Get.find<AiPricingController>();
        final canProceed = await pricingCtrl.ensureHasSufficientBalance(
          'navtara',
          showPopup: true,
        );
        if (!canProceed) {
          // Reset to previous tab if swiping
          if (fromSwipe && _pageController.hasClients) {
            final prevIndex = _tabs.indexWhere((t) => t == _activeTab);
            if (prevIndex >= 0) {
              _pageController.jumpToPage(prevIndex);
            }
          }
          return;
        }
      }
    }

    // Extract nakshatra numbers and zodiac signs from API response if available
    if (tab == 'Nakshatra Match') {
      final extracted = _extractNakshatraNumbers();
      if (!extracted) {
        // Fallback to popup if extraction fails
        final ok = await _ensureNakshatraFields();
        if (!ok) {
          // Reset to previous tab if swiping
          if (fromSwipe && _pageController.hasClients) {
            final prevIndex = _tabs.indexWhere((t) => t == _activeTab);
            if (prevIndex >= 0) {
              _pageController.jumpToPage(prevIndex);
            }
          }
          return;
        }
      }
    }
    if (tab == 'Western Match') {
      final extracted = _extractZodiacSigns();
      if (!extracted) {
        // Fallback to popup if extraction fails
        final ok = await _ensureWesternFields();
        if (!ok) {
          // Reset to previous tab if swiping
          if (fromSwipe && _pageController.hasClients) {
            final prevIndex = _tabs.indexWhere((t) => t == _activeTab);
            if (prevIndex >= 0) {
              _pageController.jumpToPage(prevIndex);
            }
          }
          return;
        }
      }
    }

    setState(() {
      _activeTab = tab;
      _isFetching = true;
    });

    try {
      Map<String, dynamic>? res;
      switch (tab) {
        case 'North Match':
        case 'East Match':
          res = await _service.getAshtakootMatching(
            boyDob: form['boyDob'],
            boyTob: form['boyTob'],
            boyTz: form['boyTz'],
            boyLat: form['boyLat'],
            boyLon: form['boyLon'],
            girlDob: form['girlDob'],
            girlTob: form['girlTob'],
            girlTz: form['girlTz'],
            girlLat: form['girlLat'],
            girlLon: form['girlLon'],
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'South Match':
          res = await _service.getDashakootMatching(
            boyDob: form['boyDob'],
            boyTob: form['boyTob'],
            boyTz: form['boyTz'],
            boyLat: form['boyLat'],
            boyLon: form['boyLon'],
            girlDob: form['girlDob'],
            girlTob: form['girlTob'],
            girlTz: form['girlTz'],
            girlLat: form['girlLat'],
            girlLon: form['girlLon'],
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'Aggregate Match':
          res = await _service.getAggregateMatch(
            boyDob: form['boyDob'],
            boyTob: form['boyTob'],
            boyTz: form['boyTz'],
            boyLat: form['boyLat'],
            boyLon: form['boyLon'],
            girlDob: form['girlDob'],
            girlTob: form['girlTob'],
            girlTz: form['girlTz'],
            girlLat: form['girlLat'],
            girlLon: form['girlLon'],
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'Rajju Vedha Details':
          res = await _service.getRajjuVedhaDetails(
            boyDob: form['boyDob'],
            boyTob: form['boyTob'],
            boyTz: form['boyTz'],
            boyLat: form['boyLat'],
            boyLon: form['boyLon'],
            girlDob: form['girlDob'],
            girlTob: form['girlTob'],
            girlTz: form['girlTz'],
            girlLat: form['girlLat'],
            girlLon: form['girlLon'],
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'Papasamaya Match':
          res = await _service.getPapasamayaMatch(
            boyDob: form['boyDob'],
            boyTob: form['boyTob'],
            boyTz: form['boyTz'],
            boyLat: form['boyLat'],
            boyLon: form['boyLon'],
            girlDob: form['girlDob'],
            girlTob: form['girlTob'],
            girlTz: form['girlTz'],
            girlLat: form['girlLat'],
            girlLon: form['girlLon'],
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'Nakshatra Match':
          res = await _service.getNakshatraMatch(
            boyStar: form['boyStar']?.toString() ?? '',
            girlStar: form['girlStar']?.toString() ?? '',
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'Western Match':
          res = await _service.getWesternMatch(
            boySign: form['boySign']?.toString() ?? '',
            girlSign: form['girlSign']?.toString() ?? '',
            lang: form['lang'] ?? 'en',
          );
          break;
        case 'Navtara':
          // Check balance before proceeding
          if (Get.isRegistered<AiPricingController>()) {
            final pricingCtrl = Get.find<AiPricingController>();
            final canProceed = await pricingCtrl.ensureHasSufficientBalance(
              'navtara',
              showPopup: true,
            );
            if (!canProceed) {
              res = null;
              break;
            }
          }

          // Use a response that has astro details (North or South tab)
          Map<String, dynamic>? responseData = _tabResponses['North Match']
              ?? _tabResponses['South Match']
              ?? _currentResponse;

          // If we don't have astro details yet, fetch North Match so Navtara can get nakshatra
          if (responseData == null ||
              ((responseData['boy_astro_details'] == null &&
                  responseData['boy_planetary_details'] == null))) {
            final northRes = await _fetchAndStoreNorthMatch();
            if (northRes != null) responseData = northRes;
          }

          final boyAstro =
              responseData?['boy_astro_details'] as Map<String, dynamic>?;
          final girlAstro =
              responseData?['girl_astro_details'] as Map<String, dynamic>?;
          final boyPlanetary = responseData?['boy_planetary_details'] as Map<String, dynamic>?;
          final girlPlanetary = responseData?['girl_planetary_details'] as Map<String, dynamic>?;

          // Prefer nakshatra from astrological details (boy/girl full kundli), then Moon
          String? boyNakshatra = boyAstro?['nakshatra'] as String?;
          String? girlNakshatra = girlAstro?['nakshatra'] as String?;
          if (boyNakshatra == null && boyPlanetary != null && boyPlanetary['2'] is Map<String, dynamic>) {
            final moon = boyPlanetary['2'] as Map<String, dynamic>;
            boyNakshatra = moon['nakshatra'] as String?;
          }
          if (girlNakshatra == null && girlPlanetary != null && girlPlanetary['2'] is Map<String, dynamic>) {
            final moon = girlPlanetary['2'] as Map<String, dynamic>;
            girlNakshatra = moon['nakshatra'] as String?;
          }

          if (boyNakshatra != null && girlNakshatra != null && Get.isRegistered<NavtaraController>()) {
            try {
              final navtaraCtl = Get.find<NavtaraController>();
              // Get language from form (convert code to name if needed)
              String? language;
              if (form['lang'] != null) {
                final langCode = form['lang'].toString().toLowerCase();
                language = _getLanguageName(langCode);
              }
              
              navtaraCtl.initFromMatching(
                boyName: form['boyName']?.toString() ?? 'Boy',
                boyNakshatra: boyNakshatra,
                girlName: form['girlName']?.toString() ?? 'Girl',
                girlNakshatra: girlNakshatra,
                language: language,
              );
              // Call compatibility API when Navtara tab is selected
              navtaraCtl.checkCompatibility();
            } catch (e) {
              debugPrint('Error initializing Navtara: $e');
              Get.snackbar(
                'Error',
                'Failed to initialize Navtara analysis',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          } else {
            debugPrint('Missing nakshatra data: Boy=$boyNakshatra, Girl=$girlNakshatra');
            Get.snackbar(
              'Error',
              'Nakshatra data not available',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
          res = _currentResponse;
          break;
      }

      if (res != null && mounted) {
        final responseData = res;
        setState(() {
          // Check if response is an error (status != 200 or response is a String)
          final status = responseData['status'];
          final responseValue = responseData['response'];

          if (status != null && status != 200 && responseValue is String) {
            // Error case - response is a string message
            Get.snackbar(
              'Error',
              responseValue,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else if (responseValue is Map<String, dynamic>) {
            // Success case - response is a map nested under 'response' key
            // Normalize keys (e.g., total_score -> score)
            if (responseValue.containsKey('total_score')) {
              responseValue['score'] = responseValue['total_score'];
            }
            // Store per-tab so PageView and tabs stay in sync
            _tabResponses[tab] = responseValue;
            _currentResponse = responseValue;
          } else if (responseValue is String) {
            // Error case - response is a string
            Get.snackbar(
              'Error',
              responseValue,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else {
            // Fallback - use the whole response (might already be the nested data)
            final fallback = res is Map<String, dynamic> ? res : null;
            if (fallback != null) {
              _tabResponses[tab] = fallback;
              _currentResponse = fallback;
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Match switch error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  num? _resolveTotal(Map<String, dynamic> response, String tab) {
    switch (tab) {
      case 'North Match':
      case 'East Match':
        return 36;
      case 'South Match':
        return 10;
      case 'Aggregate Match':
        return 100;
      case 'Papasamaya Match':
        return 100;
      case 'Nakshatra Match':
        return 10;
      case 'Western Match':
        return 100; // API score is compatibility % (e.g. 58)
      case 'Rajju Vedha Details':
        return null;
      default:
        final totalFromApi = response['total'];
        if (totalFromApi is num && totalFromApi > 0) return totalFromApi;
        return null;
    }
  }

  /// Map nakshatra name (from astro_details) to star number 1-27 for API
  int? _nakshatraNameToNumber(String name) {
    const names = [
      'ashwini', 'bharani', 'krittika', 'rohini', 'mrigashira', 'ardra', 'punarvasu',
      'pushya', 'ashlesha', 'magha', 'purvaphalguni', 'uttaraphalguni', 'hasta', 'chitra',
      'swati', 'vishakha', 'anuradha', 'jyeshtha', 'mula', 'purvashadha', 'uttarashadha',
      'shravana', 'dhanishta', 'shatabhisha', 'purvabhadrapada', 'uttarabhadrapada', 'revati',
    ];
    final key = name.toLowerCase().replaceAll(' ', '').replaceAll(RegExp(r'[^a-z]'), '');
    for (int i = 0; i < names.length; i++) {
      if (key.contains(names[i]) || names[i].contains(key)) return i + 1;
    }
    return null;
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

  /// Fetch North Match (ashtakoot-with-astro-details) and store in _tabResponses so Navtara can get nakshatra.
  /// Returns the inner response map if successful, null otherwise.
  Future<Map<String, dynamic>?> _fetchAndStoreNorthMatch() async {
    final form = _formData;
    if (form == null) return null;
    final boyDob = form['boyDob']?.toString();
    final girlDob = form['girlDob']?.toString();
    if (boyDob == null || girlDob == null) return null;
    try {
      final result = await _service.getAshtakootMatching(
        boyDob: boyDob,
        boyTob: form['boyTob']?.toString() ?? '',
        boyTz: (form['boyTz'] is num) ? (form['boyTz'] as num).toDouble() : double.tryParse(form['boyTz']?.toString() ?? '') ?? 5.5,
        boyLat: (form['boyLat'] is num) ? (form['boyLat'] as num).toDouble() : double.tryParse(form['boyLat']?.toString() ?? '') ?? 0.0,
        boyLon: (form['boyLon'] is num) ? (form['boyLon'] as num).toDouble() : double.tryParse(form['boyLon']?.toString() ?? '') ?? 0.0,
        girlDob: girlDob,
        girlTob: form['girlTob']?.toString() ?? '',
        girlTz: (form['girlTz'] is num) ? (form['girlTz'] as num).toDouble() : double.tryParse(form['girlTz']?.toString() ?? '') ?? 5.5,
        girlLat: (form['girlLat'] is num) ? (form['girlLat'] as num).toDouble() : double.tryParse(form['girlLat']?.toString() ?? '') ?? 0.0,
        girlLon: (form['girlLon'] is num) ? (form['girlLon'] as num).toDouble() : double.tryParse(form['girlLon']?.toString() ?? '') ?? 0.0,
        lang: form['lang']?.toString() ?? 'en',
      );
      if (result == null || !mounted) return null;
      final responseValue = result['response'];
      final Map<String, dynamic>? inner = responseValue is Map<String, dynamic> ? responseValue : null;
      if (inner != null) {
        _tabResponses['North Match'] = inner;
        _currentResponse = inner;
        if (mounted) setState(() {});
        return inner;
      }
    } catch (e) {
      debugPrint('_fetchAndStoreNorthMatch error: $e');
    }
    return null;
  }

  /// Extract nakshatra numbers from API response (boy_planetary_details and girl_planetary_details)
  bool _extractNakshatraNumbers() {
    // Get the actual response data (could be nested under 'response' key)
    Map<String, dynamic>? response = _currentResponse;
    if (response == null) {
      debugPrint('_extractNakshatraNumbers: _currentResponse is null');
      return false;
    }

    // Check if data is nested under 'response' key
    if (response.containsKey('response') && response['response'] is Map<String, dynamic>) {
      response = response['response'] as Map<String, dynamic>;
      debugPrint('_extractNakshatraNumbers: Using nested response');
    }

    // Try to get from boy_planetary_details[2] (Moon) and girl_planetary_details[2] (Moon)
    final boyPlanetary = response['boy_planetary_details'] as Map<String, dynamic>?;
    final girlPlanetary = response['girl_planetary_details'] as Map<String, dynamic>?;

    debugPrint('_extractNakshatraNumbers: boyPlanetary=${boyPlanetary != null}, girlPlanetary=${girlPlanetary != null}');

    int? boyStar;
    int? girlStar;

    // Prefer astrological details (full kundli) nakshatra, then Moon's nakshatra_no
    final boyAstro = response['boy_astro_details'] as Map<String, dynamic>?;
    final girlAstro = response['girl_astro_details'] as Map<String, dynamic>?;
    if (boyAstro != null) {
      final name = (boyAstro['nakshatra'] as String?).toString().trim();
      if (name.isNotEmpty) boyStar = _nakshatraNameToNumber(name);
    }
    if (girlAstro != null) {
      final name = (girlAstro['nakshatra'] as String?).toString().trim();
      if (name.isNotEmpty) girlStar = _nakshatraNameToNumber(name);
    }
    // From Moon (index 2) in planetary details
    if (boyStar == null && boyPlanetary != null && boyPlanetary['2'] is Map<String, dynamic>) {
      final moon = boyPlanetary['2'] as Map<String, dynamic>;
      boyStar = moon['nakshatra_no'] as int?;
      debugPrint('Boy Moon nakshatra_no: $boyStar');
    }
    if (girlStar == null && girlPlanetary != null && girlPlanetary['2'] is Map<String, dynamic>) {
      final moon = girlPlanetary['2'] as Map<String, dynamic>;
      girlStar = moon['nakshatra_no'] as int?;
      debugPrint('Girl Moon nakshatra_no: $girlStar');
    }

    if (boyStar != null && girlStar != null && boyStar >= 1 && boyStar <= 27 && girlStar >= 1 && girlStar <= 27) {
      _formData ??= {};
      _formData!['boyStar'] = boyStar;
      _formData!['girlStar'] = girlStar;
      debugPrint('✓ Extracted nakshatra numbers: Boy=$boyStar, Girl=$girlStar');
      return true;
    }

    debugPrint('✗ Failed to extract nakshatra numbers: Boy=$boyStar, Girl=$girlStar');
    return false;
  }

  Future<bool> _ensureNakshatraFields() async {
    final form = _formData ?? {};
    if ((form['boyStar'] ?? '').toString().isNotEmpty &&
        (form['girlStar'] ?? '').toString().isNotEmpty) {
      return true;
    }
    final boyCtl = TextEditingController(
      text: form['boyStar']?.toString() ?? '',
    );
    final girlCtl = TextEditingController(
      text: form['girlStar']?.toString() ?? '',
    );
    final result = await Get.defaultDialog<bool>(
      title: 'Nakshatra Numbers',
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _numberField('Boy Star (1-27)', boyCtl),
            Spacing.h(10),
            _numberField('Girl Star (1-27)', girlCtl),
          ],
        ),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        final b = int.tryParse(boyCtl.text) ?? 0;
        final g = int.tryParse(girlCtl.text) ?? 0;
        if (b < 1 || b > 27 || g < 1 || g > 27) {
          Get.snackbar('Invalid', 'Stars must be between 1 and 27');
          return;
        }
        _formData ??= {};
        _formData!['boyStar'] = b;
        _formData!['girlStar'] = g;
        Get.back(result: true);
      },
      onCancel: () => Get.back(result: false),
    );
    return result ?? false;
  }

  /// Extract zodiac sign numbers from API response (ascendant_sign from astro_details)
  bool _extractZodiacSigns() {
    // Get the actual response data (could be nested under 'response' key)
    Map<String, dynamic>? response = _currentResponse;
    if (response == null) {
      debugPrint('_extractZodiacSigns: _currentResponse is null');
      return false;
    }

    // Check if data is nested under 'response' key
    if (response.containsKey('response') && response['response'] is Map<String, dynamic>) {
      response = response['response'] as Map<String, dynamic>;
      debugPrint('_extractZodiacSigns: Using nested response');
    }

    final boyAstro = response['boy_astro_details'] as Map<String, dynamic>?;
    final girlAstro = response['girl_astro_details'] as Map<String, dynamic>?;

    debugPrint('_extractZodiacSigns: boyAstro=${boyAstro != null}, girlAstro=${girlAstro != null}');

    int? boySign;
    int? girlSign;

    if (boyAstro != null) {
      final ascendantSign = boyAstro['ascendant_sign'] as String?;
      if (ascendantSign != null) {
        boySign = _getZodiacNumber(ascendantSign);
        debugPrint('Boy ascendant_sign: $ascendantSign -> $boySign');
      }
    }

    if (girlAstro != null) {
      final ascendantSign = girlAstro['ascendant_sign'] as String?;
      if (ascendantSign != null) {
        girlSign = _getZodiacNumber(ascendantSign);
        debugPrint('Girl ascendant_sign: $ascendantSign -> $girlSign');
      }
    }

    if (boySign != null && girlSign != null && boySign >= 1 && boySign <= 12 && girlSign >= 1 && girlSign <= 12) {
      _formData ??= {};
      _formData!['boySign'] = boySign;
      _formData!['girlSign'] = girlSign;
      debugPrint('✓ Extracted zodiac signs: Boy=$boySign, Girl=$girlSign');
      return true;
    }

    debugPrint('✗ Failed to extract zodiac signs: Boy=$boySign, Girl=$girlSign');
    return false;
  }

  int _getZodiacNumber(String sign) {
    final zodiacMap = {
      'Aries': 1,
      'Taurus': 2,
      'Gemini': 3,
      'Cancer': 4,
      'Leo': 5,
      'Virgo': 6,
      'Libra': 7,
      'Scorpio': 8,
      'Sagittarius': 9,
      'Capricorn': 10,
      'Aquarius': 11,
      'Pisces': 12,
    };
    return zodiacMap[sign] ?? 1;
  }

  Future<bool> _ensureWesternFields() async {
    final form = _formData ?? {};
    if ((form['boySign'] ?? '').toString().isNotEmpty &&
        (form['girlSign'] ?? '').toString().isNotEmpty) {
      return true;
    }
    final boyCtl = TextEditingController(
      text: form['boySign']?.toString() ?? '',
    );
    final girlCtl = TextEditingController(
      text: form['girlSign']?.toString() ?? '',
    );
    final result = await Get.defaultDialog<bool>(
      title: 'Western Zodiac Signs',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _numberField('Boy Sign (1-12)', boyCtl),
          Spacing.h(10),
          _numberField('Girl Sign (1-12)', girlCtl),
        ],
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        final b = int.tryParse(boyCtl.text) ?? 0;
        final g = int.tryParse(girlCtl.text) ?? 0;
        if (b < 1 || b > 12 || g < 1 || g > 12) {
          Get.snackbar('Invalid', 'Signs must be between 1 and 12');
          return;
        }
        _formData ??= {};
        _formData!['boySign'] = b;
        _formData!['girlSign'] = g;
        Get.back(result: true);
      },
      onCancel: () => Get.back(result: false),
    );
    return result ?? false;
  }

  Widget _numberField(String label, TextEditingController ctl) {
    return SizedBox(
      width: 200.w,
      child: TextField(
        controller: ctl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            CommonHeader(
              title: 'Match Making Result',
              showBackButton: true,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.w,
                        color: "#6F221E".toColor(),
                      ),
                      Spacing.h(24),
                      AutoTranslateText(
                        'Error',
                        style: MyTextTheme.largeBCB
                            .copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h1),
                      ),
                      Spacing.h(16),
                      AutoTranslateText(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: MyTextTheme.mediumBCN
                            .copyWith(color: Colors.black87)
                            .merge(AppTypography.h3),
                      ),
                      Spacing.h(32),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: "#6F221E".toColor(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: AutoTranslateText(
                          'Go Back',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: const Color(0xFFDFB343),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
