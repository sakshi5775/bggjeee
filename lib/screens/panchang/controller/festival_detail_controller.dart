import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/panchang/service/panchang_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FestivalDetailController extends BaseController {
  final PanchangService _panchangService = PanchangService();

  // State
  final isLoading = false.obs;
  final festival = Rxn<Map<String, dynamic>>();
  final panchangData = Rxn<Map<String, dynamic>>();
  final date = ''.obs;
  final dayNumber = 0.obs;
  final dayName = ''.obs;
  final location = ''.obs;
  final pujaVidhi = <String>[].obs;

  double? latitude;
  double? longitude;
  double? timezone;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      festival.value = arguments['festival'] as Map<String, dynamic>?;
      date.value = arguments['date']?.toString() ?? '';
      dayNumber.value = arguments['dayNumber'] as int? ?? 0;
      dayName.value = arguments['dayName']?.toString() ?? '';
      location.value = arguments['location']?.toString() ?? 'New Delhi, India';
      latitude = arguments['latitude'] as double?;
      longitude = arguments['longitude'] as double?;
      timezone = arguments['timezone'] as double?;

      // Fetch monthly calendar data to get festival details
      _fetchFestivalDetails();

      // Fetch panchang data for the date
      _fetchPanchangData();
    }
  }

  /// Fetch festival details from monthly calendar API
  Future<void> _fetchFestivalDetails() async {
    try {
      // Parse date to get month and year
      DateTime? dateTime;
      try {
        final parts = date.value.split('/');
        if (parts.length == 3) {
          dateTime = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (e) {
        dateTime = DateTime.now();
      }

      if (dateTime == null) return;

      // Fetch monthly calendar data
      final calendarData = await _panchangService.getMonthlyCalendar(
        month: dateTime.month,
        year: dateTime.year,
      );

      if (calendarData != null) {
        final response = calendarData['response'] as List<dynamic>?;
        if (response != null) {
          // Find the festival for this date
          final dateStr = date.value; // Format: yyyy/MM/dd
          for (var item in response) {
            final itemDate = item['date']?.toString() ?? '';
            if (itemDate == dateStr) {
              final festivals = item['festivals'] as List<dynamic>?;
              if (festivals != null) {
                // Find matching festival by name
                final festivalName = festival.value?['name']?.toString() ?? '';
                for (var fest in festivals) {
                  final festMap = fest as Map<String, dynamic>;
                  if (festMap['name']?.toString() == festivalName) {
                    // Update festival data with API data
                    festival.value = festMap;
                    
                    // Extract puja vidhi if available in the API response
                    // Note: Current API doesn't provide puja_vidhi, so we'll keep it empty
                    // If API provides puja_vidhi in future, extract it here
                    if (festMap['puja_vidhi'] != null) {
                      final pujaVidhiList = festMap['puja_vidhi'];
                      if (pujaVidhiList is List) {
                        pujaVidhi.value = pujaVidhiList
                            .map((item) => item.toString())
                            .toList();
                      } else if (pujaVidhiList is String) {
                        // If it's a string, split by newlines or other delimiters
                        pujaVidhi.value = pujaVidhiList
                            .split('\n')
                            .where((line) => line.trim().isNotEmpty)
                            .toList();
                      }
                    }
                    break;
                  }
                }
              }
              break;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching festival details: $e');
    }
  }

  Future<void> _fetchPanchangData() async {
    if (latitude == null || longitude == null || timezone == null) {
      latitude = 28.6139; // Delhi default
      longitude = 77.2090;
      timezone = 5.5;
    }

    try {
      isLoading.value = true;

      // Parse date string (format: yyyy/MM/dd)
      DateTime? dateTime;
      try {
        final parts = date.value.split('/');
        if (parts.length == 3) {
          dateTime = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
      } catch (e) {
        dateTime = DateTime.now();
      }

      final dateStr = DateFormat('dd/MM/yyyy').format(dateTime ?? DateTime.now());
      final time = DateFormat('HH:mm').format(DateTime.now());

      final data = await _panchangService.getDailyPanchang(
        date: dateStr,
        time: time,
        latitude: latitude!,
        longitude: longitude!,
        tz: timezone!,
        lang: 'en',
      );

      if (data != null && data['response'] != null) {
        panchangData.value = data['response'] as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('Error fetching panchang data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

