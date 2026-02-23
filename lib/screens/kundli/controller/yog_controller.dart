import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class YogController extends BaseController {
  // Form data
  final formData = Rxn<Map<String, dynamic>>();

  // Yog API data
  final yogData = Rxn<Map<String, dynamic>>();

  // Loading states
  final isLoadingYog = false.obs;

  // Service
  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
    // Fetch yog data automatically when view loads
    fetchYog();
  }

  // Fetch Yog
  Future<void> fetchYog() async {
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Yog');
      return;
    }

    try {
      isLoadingYog.value = true;

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
        debugPrint('Missing required form data for Yog');
        isLoadingYog.value = false;
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

      isLoadingYog.value = false;

      if (data != null) {
        yogData.value = data;
        debugPrint('Yog data loaded successfully');
      } else {
        debugPrint('Failed to fetch Yog data');
      }
    } catch (e) {
      isLoadingYog.value = false;
      debugPrint('Error fetching Yog data: $e');
    }
  }
}
