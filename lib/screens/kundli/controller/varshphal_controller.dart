import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class VarshphalController extends BaseController {
  final formData = Rxn<Map<String, dynamic>>();
  final varshphalDetailsData = Rxn<Map<String, dynamic>>();
  final varshphalYearlyChartData = Rxn<Map<String, dynamic>>();
  final isLoadingVarshphalDetails = false.obs;
  final isLoadingVarshphalYearlyChart = false.obs;
  final selectedVarshphalTab = 0.obs; // 0 = Details, 1 = Yearly Chart

  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    _loadData();
    fetchVarshphalDetails();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  Future<void> fetchVarshphalDetails() async {
    if (varshphalDetailsData.value != null) return;
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
        if (data['data'] != null && data['data']['response'] != null) {
          varshphalDetailsData.value =
              data['data']['response'] as Map<String, dynamic>;
        } else if (data['response'] != null) {
          varshphalDetailsData.value = data['response'] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      isLoadingVarshphalDetails.value = false;
      debugPrint('Error fetching Varshphal Details: $e');
    }
  }

  Future<void> fetchVarshphalYearlyChart() async {
    if (varshphalYearlyChartData.value != null) return;
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
        if (data['data'] != null && data['data']['response'] != null) {
          varshphalYearlyChartData.value =
              data['data']['response'] as Map<String, dynamic>;
        } else if (data['response'] != null) {
          varshphalYearlyChartData.value =
              data['response'] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      isLoadingVarshphalYearlyChart.value = false;
      debugPrint('Error fetching Varshphal Yearly Chart: $e');
    }
  }
}
