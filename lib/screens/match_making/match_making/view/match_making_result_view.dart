import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/service/match_making_service.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/widgets/astrologers_section_widget.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/widgets/compatibility_report_widget.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/widgets/kundli_chart_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
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
  Map<String, dynamic>? _formData;
  bool _isFetching = false;
  String _activeTab = 'North Match';

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AutoTranslateText(
            'No data available',
            style: MyTextTheme.mediumBCB.copyWith(color: "#6F221E".toColor()),
          ),
        ),
      );
    }

    _formData ??= args['formData'] as Map<String, dynamic>?;

    // Handle response - it can be a String (error) or Map (success)
    if (_currentResponse == null) {
      final responseValue = args['response'];
      if (responseValue is Map<String, dynamic>) {
        _currentResponse = responseValue;
      } else if (responseValue is String) {
        // Error response - show error UI
        return _buildErrorView(responseValue);
      } else {
        // Check if args itself has status indicating error
        final status = args['status'];
        final responseMsg = args['response'];
        if (status != null && status != 200 && responseMsg is String) {
          return _buildErrorView(responseMsg);
        }
        _currentResponse = args;
      }
    }

    // If still null or if response indicates an error, show error
    if (_currentResponse == null) {
      return _buildErrorView('No data available');
    }

    // Check for error status in the response
    final status = _currentResponse!['status'];
    if (status != null && status != 200) {
      final errorMsg = _currentResponse!['response'];
      if (errorMsg is String) {
        return _buildErrorView(errorMsg);
      }
    }

    final response = _currentResponse!;

    // Show matching animation first
    if (_showMatchingImage) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Lottie.network(
            AppConstant.matchMakingKundliJson,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            repeat: true,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8), // Pale pinkish-beige background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Content
            Expanded(
              child: SingleChildScrollView(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMatchTabs(),
                          if (_isFetching) ...[
                            Spacing.h(12),
                            const LinearProgressIndicator(minHeight: 2),
                          ],
                          Spacing.h(16),
                          // Compatibility Report with injected Kundli charts
                          CompatibilityReportWidget(
                            data: response,
                            formData: _formData,
                            showProfile:
                                _activeTab == 'North Match' ||
                                _activeTab == 'South Match',
                            showGunMilan:
                                _activeTab ==
                                'North Match', // 36 Gun only for North
                            matchScoreTotalOverride: _resolveTotal(response),
                            showTotalSeparately: _activeTab == 'Western Match',
                            rawTotal: response['total'] as num?,
                            kundliSection:
                                (_activeTab == 'North Match' &&
                                    response['boy_planetary_details'] != null &&
                                    response['girl_planetary_details'] != null)
                                ? KundliChartWidget(
                                    boyPlanetaryDetails:
                                        response['boy_planetary_details']
                                            as Map<String, dynamic>,
                                    girlPlanetaryDetails:
                                        response['girl_planetary_details']
                                            as Map<String, dynamic>,
                                    boyAstroDetails:
                                        response['boy_astro_details']
                                            as Map<String, dynamic>?,
                                    girlAstroDetails:
                                        response['girl_astro_details']
                                            as Map<String, dynamic>?,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),

                    Spacing.h(20),

                    // Top Astrologers For Matchmaking
                    const AstrologersSectionWidget(),

                    Spacing.h(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(color: "#6F221E".toColor()),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
            ),
            Spacing.w(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    'Compatibility Report',
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: const Color(0xFFDFB343),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h2),
                  ),
                  Spacing.h(2),
                  AutoTranslateText(
                    'Based on Vedic Astrology',
                    style: MyTextTheme.smallBCN
                        .copyWith(
                          color: const Color(0xFFDFB343).withOpacity(0.8),
                        )
                        .merge(AppTypography.body2),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Share functionality
              },
              child: Icon(
                Icons.share,
                color: const Color(0xFFDFB343),
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTabs() {
    final tabs = [
      'North Match',
      'South Match',
      'Aggregate Match',
      'Rajju Vedha Details',
      'Papasamaya Match',
      'Nakshatra Match',
      'Western Match',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((t) {
          final isActive = _activeTab == t;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              label: AutoTranslateText(
                t,
                style: MyTextTheme.smallBCB
                    .copyWith(
                      color: isActive ? Colors.white : "#6F221E".toColor(),
                    )
                    .merge(AppTypography.body2),
              ),
              selected: isActive,
              onSelected: (_) => _onTabSelected(t),
              selectedColor: "#6F221E".toColor(),
              backgroundColor: const Color(0xFFFDF3E6),
              shape: StadiumBorder(
                side: BorderSide(
                  color: "#6F221E".toColor().withOpacity(0.3),
                  width: 0.8,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _onTabSelected(String tab) async {
    if (_isFetching || _activeTab == tab) return;
    final form = _formData;
    if (form == null) {
      return;
    }

    // Prompt for missing extra fields
    if (tab == 'Nakshatra Match') {
      final ok = await _ensureNakshatraFields();
      if (!ok) return;
    }
    if (tab == 'Western Match') {
      final ok = await _ensureWesternFields();
      if (!ok) return;
    }

    setState(() {
      _activeTab = tab;
      _isFetching = true;
    });

    try {
      Map<String, dynamic>? res;
      switch (tab) {
        case 'North Match':
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
      }

      if (res != null && mounted) {
        final responseData = res;
        setState(() {
          // Check if response is an error (status != 200 or response is a String)
          final status = responseData['status'];
          final responseValue = responseData['response'];

          if (status != null && status != 200 && responseValue is String) {
            // Error case - response is a string message
            // Don't update _currentResponse, keep showing current data or show error
            // You could also show a snackbar here
            Get.snackbar(
              'Error',
              responseValue,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          } else if (responseValue is Map<String, dynamic>) {
            // Success case - response is a map
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
            // Fallback - use the whole response
            _currentResponse = res;
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

  num? _resolveTotal(Map<String, dynamic> response) {
    // Prefer explicit total if provided
    final totalFromApi = response['total'];
    if (totalFromApi is num && totalFromApi > 0) return totalFromApi;

    switch (_activeTab) {
      case 'North Match':
        return 36;
      case 'South Match':
        return 10;
      case 'Aggregate Match':
        return 100;
      case 'Papasamaya Match':
        return 10;
      case 'Nakshatra Match':
        return 10;
      case 'Western Match':
        if (response['total'] is num) return response['total'] as num;
        return 100;
      case 'Rajju Vedha Details':
        return null; // no score shown
      default:
        return null;
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
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
