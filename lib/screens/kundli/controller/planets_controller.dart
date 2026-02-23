import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlanetsController extends BaseController {
  // Form data
  final formData = Rxn<Map<String, dynamic>>();

  // Tab: 0=Overview, 1=Transit, 2=Detailed
  final selectedTabIndex = 0.obs;
  late PageController pageController;
  final ScrollController tabsScrollController = ScrollController();
  final Map<int, GlobalKey> tabKeys = {};

  // Planet/year for Transit & Detailed
  final selectedPlanet = 'sun'.obs;
  final selectedYear = DateTime.now().year.obs;
  static const planetNames = [
    'sun',
    'moon',
    'mercury',
    'venus',
    'mars',
    'jupiter',
    'saturn',
    'uranus',
    'neptune',
    'pluto',
  ];

  // API data
  final planetDetailsData = Rxn<Map<String, dynamic>>();
  final westernPlanetDetailsData = Rxn<Map<String, dynamic>>();
  final aspectsData = Rxn<Map<String, dynamic>>();
  final transitDatesData = Rxn<Map<String, dynamic>>();
  final detailedReportData = Rxn<Map<String, dynamic>>();

  // Loading state
  final isLoadingPlanetDetails = false.obs;
  final isLoadingWesternPlanetDetails = false.obs;
  final isLoadingAspects = false.obs;
  final isLoadingTransit = false.obs;
  final isLoadingDetailedReport = false.obs;

  // Service
  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    _loadData();
    fetchPlanetDetails();
  }

  @override
  void onClose() {
    pageController.dispose();
    tabsScrollController.dispose();
    super.onClose();
  }

  void onTabSelected(int index) {
    selectedTabIndex.value = index;
    if (pageController.hasClients) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    if (index == 1 && transitDatesData.value == null)
      fetchPlanetTransitDates(selectedPlanet.value, selectedYear.value);
    if (index == 2 && detailedReportData.value == null)
      fetchDetailedPlanetReport(selectedPlanet.value);
  }

  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    if (index == 1 && transitDatesData.value == null)
      fetchPlanetTransitDates(selectedPlanet.value, selectedYear.value);
    if (index == 2 && detailedReportData.value == null)
      fetchDetailedPlanetReport(selectedPlanet.value);
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  // Check if required fields are present
  bool _hasRequiredFields() {
    if (formData.value == null) return false;

    final form = formData.value!;
    final date = form['date'] as String?;
    final time = form['time'] as String?;
    final latitude = form['latitude'] as double?;
    final longitude = form['longitude'] as double?;
    final tz = form['timezone'] as double?;

    return date != null &&
        time != null &&
        latitude != null &&
        longitude != null &&
        tz != null;
  }

  // Get missing required fields
  List<String> _getMissingRequiredFields() {
    if (formData.value == null) {
      return ['date', 'time', 'latitude', 'longitude', 'timezone'];
    }

    final form = formData.value!;
    final missing = <String>[];

    if (form['date'] == null) missing.add('date');
    if (form['time'] == null) missing.add('time');
    if (form['latitude'] == null) missing.add('latitude');
    if (form['longitude'] == null) missing.add('longitude');
    if (form['timezone'] == null) missing.add('timezone');

    return missing;
  }

  // Show form popup for missing fields
  Future<void> _showFormPopup(List<String> missingFields) async {
    final formControllers = <String, TextEditingController>{};
    final formValues = <String, dynamic>{};

    // Initialize controllers with existing values if available
    if (formData.value != null) {
      final existingForm = formData.value!;
      for (final field in missingFields) {
        formControllers[field] = TextEditingController(
          text: existingForm[field]?.toString() ?? '',
        );
      }
    } else {
      for (final field in missingFields) {
        formControllers[field] = TextEditingController();
      }
    }

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          constraints: BoxConstraints(maxHeight: Get.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoTranslateText(
                'Additional Information Required',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F221E),
                ).merge(AppTypography.h2),
              ),
              Spacing.h(16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: missingFields.map((field) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: TextField(
                          controller: formControllers[field],
                          decoration: InputDecoration(
                            labelText: _getFieldLabel(field),
                            hintText: _getFieldHint(field),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          keyboardType: _getKeyboardType(field),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Spacing.h(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: AutoTranslateText('Cancel'),
                  ),
                  Spacing.w(8),
                  ElevatedButton(
                    onPressed: () {
                      // Collect form values
                      for (final field in missingFields) {
                        final value = formControllers[field]?.text.trim();
                        if (value != null && value.isNotEmpty) {
                          if (field == 'latitude' ||
                              field == 'longitude' ||
                              field == 'timezone') {
                            formValues[field] = double.tryParse(value);
                          } else {
                            formValues[field] = value;
                          }
                        }
                      }

                      // Update formData
                      if (formData.value != null) {
                        formData.value!.addAll(formValues);
                      } else {
                        formData.value = formValues;
                      }

                      Get.back();
                      // Retry fetching data
                      fetchPlanetDetails();
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

    // Dispose controllers
    for (final controller in formControllers.values) {
      controller.dispose();
    }
  }

  String _getFieldLabel(String field) {
    switch (field) {
      case 'date':
        return 'Date (dd/mm/yyyy)';
      case 'time':
        return 'Time (HH:mm)';
      case 'latitude':
        return 'Latitude';
      case 'longitude':
        return 'Longitude';
      case 'timezone':
        return 'Timezone';
      default:
        return field;
    }
  }

  String _getFieldHint(String field) {
    switch (field) {
      case 'date':
        return 'e.g., 16/01/2024';
      case 'time':
        return 'e.g., 14:30';
      case 'latitude':
        return 'e.g., 24.5854';
      case 'longitude':
        return 'e.g., 73.7125';
      case 'timezone':
        return 'e.g., 5.5';
      default:
        return '';
    }
  }

  TextInputType _getKeyboardType(String field) {
    switch (field) {
      case 'latitude':
      case 'longitude':
      case 'timezone':
        return TextInputType.numberWithOptions(decimal: true);
      default:
        return TextInputType.text;
    }
  }

  // Fetch Planet Details
  Future<void> fetchPlanetDetails() async {
    // Check if required fields are present
    if (!_hasRequiredFields()) {
      final missingFields = _getMissingRequiredFields();
      if (missingFields.isNotEmpty) {
        await _showFormPopup(missingFields);
        // After popup, check again
        if (!_hasRequiredFields()) {
          Get.snackbar(
            'Error',
            'Please provide all required fields',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
          );
          return;
        }
      }
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
        Get.snackbar(
          'Error',
          'Missing required fields. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
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
        debugPrint('Planet Details data loaded successfully');
        fetchAspects();
        fetchWesternPlanetDetails();
      } else {
        debugPrint('Failed to fetch Planet Details data');
        Get.snackbar(
          'Error',
          'Failed to fetch planet details. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoadingPlanetDetails.value = false;
      debugPrint('Error fetching Planet Details data: $e');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchWesternPlanetDetails() async {
    final form = formData.value;
    if (form == null) return;
    final date = form['date']?.toString();
    final time = form['time']?.toString();
    final latRaw = form['latitude'];
    final lonRaw = form['longitude'];
    final tzRaw = form['timezone'];
    final lat = latRaw is num
        ? latRaw.toDouble()
        : double.tryParse(latRaw?.toString() ?? '');
    final lon = lonRaw is num
        ? lonRaw.toDouble()
        : double.tryParse(lonRaw?.toString() ?? '');
    final tz = tzRaw is num
        ? tzRaw.toDouble()
        : double.tryParse(tzRaw?.toString() ?? '');
    if (date == null ||
        time == null ||
        lat == null ||
        lon == null ||
        tz == null)
      return;
    try {
      isLoadingWesternPlanetDetails.value = true;
      final data = await _kundliService.getWesternPlanetDetails(
        dob: date,
        tob: time,
        lat: lat,
        lon: lon,
        tz: tz,
      );
      if (data != null && data['response'] != null) {
        westernPlanetDetailsData.value =
            data['response'] as Map<String, dynamic>;
      }
    } finally {
      isLoadingWesternPlanetDetails.value = false;
    }
  }

  Future<void> fetchAspects() async {
    final form = formData.value;
    if (form == null) return;
    final date = form['date']?.toString();
    final time = form['time']?.toString();
    final lat = form['latitude'] as double?;
    final lon = form['longitude'] as double?;
    final tz = form['timezone'] as double?;
    if (date == null ||
        time == null ||
        lat == null ||
        lon == null ||
        tz == null)
      return;
    try {
      isLoadingAspects.value = true;
      final data = await _kundliService.getAspects(
        dob: date,
        tob: time,
        lat: lat,
        lon: lon,
        tz: tz,
      );
      if (data != null && data['response'] != null) {
        aspectsData.value = data['response'] as Map<String, dynamic>;
      }
    } finally {
      isLoadingAspects.value = false;
    }
  }

  Future<void> fetchPlanetTransitDates(String planet, int year) async {
    try {
      isLoadingTransit.value = true;
      final data = await _kundliService.getPlanetTransitDates(
        planet: planet,
        year: year,
      );
      transitDatesData.value = data;
    } finally {
      isLoadingTransit.value = false;
    }
  }

  Future<void> fetchDetailedPlanetReport(String planet) async {
    final form = formData.value;
    if (form == null) return;
    final date = form['date']?.toString();
    final time = form['time']?.toString();
    final lat = form['latitude'] as double?;
    final lon = form['longitude'] as double?;
    final tz = form['timezone'] as double?;
    if (date == null ||
        time == null ||
        lat == null ||
        lon == null ||
        tz == null)
      return;
    try {
      isLoadingDetailedReport.value = true;
      final data = await _kundliService.getDetailedPlanetReport(
        dob: date,
        tob: time,
        lat: lat,
        lon: lon,
        tz: tz,
        planet: planet,
      );
      if (data != null && data['response'] != null) {
        detailedReportData.value = data['response'] as Map<String, dynamic>;
      }
    } finally {
      isLoadingDetailedReport.value = false;
    }
  }
}
