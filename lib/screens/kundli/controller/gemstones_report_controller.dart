import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class GemstonesReportController extends BaseController {
  final formData = Rxn<Map<String, dynamic>>();
  final gemSuggestionData = Rxn<Map<String, dynamic>>();
  final gemDetailsData = Rxn<Map<String, dynamic>>();
  final isLoadingSuggestion = false.obs;

  final _kundliService = KundliService();

  @override
  void onInit() {
    super.onInit();
    _loadData();
    if (formData.value != null) fetchGemSuggestion();
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
    }
  }

  Future<void> fetchGemSuggestion() async {
    final form = formData.value;
    if (form == null) {
      debugPrint('Form data null, cannot fetch gem suggestion');
      return;
    }
    final date = form['date']?.toString();
    final time = form['time']?.toString();
    final lat = form['latitude'] as double?;
    final lng = form['longitude'] as double?;
    final tz = form['timezone'] as double?;
    if (date == null || time == null || lat == null || lng == null || tz == null) return;
    try {
      isLoadingSuggestion.value = true;
      gemDetailsData.value = null;
      final data = await _kundliService.getGemSuggestion(date: date, time: time, latitude: lat, longitude: lng, tz: tz);
      gemSuggestionData.value = data;
      final response = data?['data']?['response'] as Map<String, dynamic>?;
      if (response != null) {
        final gemKey = response['key']?.toString() ?? response['gem']?.toString();
        if (gemKey != null && gemKey.isNotEmpty) {
          final details = await _kundliService.getGemDetails(gem: gemKey);
          if (details != null) {
            gemDetailsData.value = details;
          }
        }
      }
    } finally {
      isLoadingSuggestion.value = false;
    }
  }
}

