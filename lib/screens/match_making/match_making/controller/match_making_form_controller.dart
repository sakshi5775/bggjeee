import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/service/match_making_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/report_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/widgets/report_insufficient_balance_dialog.dart';
import 'package:astrobharataiuser/apihelper/api_provider/networkException/exception.dart';

class MatchMakingFormController extends BaseController {
  final MatchMakingService _matchMakingService = MatchMakingService();
  final ReportService _reportService = ReportService();

  // PDF Generation Mode
  bool isGeneratePdfMode = false;
  String? reportKey;

  // Person 1 (Groom) Controllers
  final person1NameController = TextEditingController();
  final person1DateController = TextEditingController();
  final person1TimeController = TextEditingController();
  final person1PlaceController = TextEditingController();
  final person1LatController = TextEditingController();
  final person1LonController = TextEditingController();
  final person1TzController = TextEditingController();

  // Person 2 (Bride) Controllers
  final person2NameController = TextEditingController();
  final person2DateController = TextEditingController();
  final person2TimeController = TextEditingController();
  final person2PlaceController = TextEditingController();
  final person2LatController = TextEditingController();
  final person2LonController = TextEditingController();
  final person2TzController = TextEditingController();

  // Language selection
  final selectedLanguage = 'en'.obs;
  final Map<String, String> languages = {
    'be': 'Bengali',
    'fr': 'French',
    'hi': 'Hindi',
    'ka': 'Kannada',
    'ml': 'Malayalam',
    'sp': 'Spanish',
    'ta': 'Tamil',
    'te': 'Telugu',
    'mr': 'Marathi',
    'si': 'Sinhalese',
    'ne': 'Nepali',
    'ko': 'Korean',
    'ja': 'Japanese',
    'gu': 'Gujarati',
    'pt': 'Portuguese',
    'de': 'German',
    'tr': 'Turkish',
    'ru': 'Russian',
    'it': 'Italian',
    'nl': 'Dutch',
    'pl': 'Polish',
    'en': 'English',
  };

  // State
  final isLoading = false.obs;
  final person1Date = Rxn<DateTime>();
  final person1Time = Rxn<TimeOfDay>();
  final person2Date = Rxn<DateTime>();
  final person2Time = Rxn<TimeOfDay>();

  // ===== NEW: Tab & Saved Matchmaking State =====
  final selectedTabIndex = 1.obs; // 0 = Saved, 1 = New (default New)
  final savedMatchmakingList = <Map<String, dynamic>>[].obs;
  final isLoadingSavedMatchmaking = false.obs;
  final saveMatchmakingChecked = false.obs;
  final searchQuery = ''.obs;
  final editingMatchmakingId = Rxn<String>();
  final isOpeningSavedMatchmaking = false.obs;

  /// Filtered saved matchmaking list based on search query
  List<Map<String, dynamic>> get filteredMatchmakingList {
    if (searchQuery.value.isEmpty) return savedMatchmakingList;
    final q = searchQuery.value.toLowerCase();
    return savedMatchmakingList.where((m) {
      final boyName = (m['boy']?['name'] ?? '').toString().toLowerCase();
      final girlName = (m['girl']?['name'] ?? '').toString().toLowerCase();
      return boyName.contains(q) || girlName.contains(q);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['generatePdf'] == true) {
        isGeneratePdfMode = true;
        reportKey = args['reportKey'];
      }
      // If editing a saved matchmaking profile, prefill form
      if (args['editMatchmakingProfile'] != null) {
        final profile = args['editMatchmakingProfile'] as Map<String, dynamic>;
        selectedTabIndex.value = 1;
        _prefillFromProfile(profile);
      }
    }
    _initializeForm();
    fetchSavedMatchmakingProfiles();
  }

  /// Prefill form fields from a saved matchmaking profile (for edit mode)
  void _prefillFromProfile(Map<String, dynamic> profile) {
    editingMatchmakingId.value = profile['_id']?.toString();

    final boy = profile['boy'] as Map<String, dynamic>?;
    final girl = profile['girl'] as Map<String, dynamic>?;

    if (boy != null) {
      person1NameController.text = boy['name'] ?? '';
      person1PlaceController.text = boy['birthPlace'] ?? '';
      if (boy['latitude'] != null)
        person1LatController.text = boy['latitude'].toString();
      if (boy['longitude'] != null)
        person1LonController.text = boy['longitude'].toString();

      // Parse DOB (API format: MM/dd/yyyy)
      final dob = boy['dateOfBirth']?.toString();
      if (dob != null && dob.isNotEmpty) {
        try {
          final parts = dob.split('/');
          if (parts.length == 3) {
            final month = int.parse(parts[0]);
            final day = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            final date = DateTime(year, month, day);
            person1Date.value = date;
            person1DateController.text = DateFormat('dd-MM-yyyy').format(date);
          }
        } catch (e) {
          debugPrint('Error parsing boy DOB: $e');
        }
      }

      // Parse birth time (12h format like "10:30 AM")
      final bt = boy['birthTime']?.toString();
      if (bt != null && bt.isNotEmpty) {
        try {
          final format = DateFormat('hh:mm a');
          final dt = format.parse(bt);
          person1Time.value = TimeOfDay(hour: dt.hour, minute: dt.minute);
          person1TimeController.text = bt;
        } catch (e) {
          debugPrint('Error parsing boy birth time: $e');
        }
      }

      // Parse timezone
      final tz = boy['timezone']?.toString();
      if (tz != null && tz.isNotEmpty) {
        try {
          final match = RegExp(r'([+-]?\d+):(\d+)').firstMatch(tz);
          if (match != null) {
            final hours = int.parse(match.group(1)!);
            final minutes = int.parse(match.group(2)!);
            person1TzController.text = (hours + (minutes / 60.0)).toString();
          } else {
            person1TzController.text = '5.5';
          }
        } catch (e) {
          person1TzController.text = '5.5';
        }
      }
    }

    if (girl != null) {
      person2NameController.text = girl['name'] ?? '';
      person2PlaceController.text = girl['birthPlace'] ?? '';
      if (girl['latitude'] != null)
        person2LatController.text = girl['latitude'].toString();
      if (girl['longitude'] != null)
        person2LonController.text = girl['longitude'].toString();

      final dob = girl['dateOfBirth']?.toString();
      if (dob != null && dob.isNotEmpty) {
        try {
          final parts = dob.split('/');
          if (parts.length == 3) {
            final month = int.parse(parts[0]);
            final day = int.parse(parts[1]);
            final year = int.parse(parts[2]);
            final date = DateTime(year, month, day);
            person2Date.value = date;
            person2DateController.text = DateFormat('dd-MM-yyyy').format(date);
          }
        } catch (e) {
          debugPrint('Error parsing girl DOB: $e');
        }
      }

      final bt = girl['birthTime']?.toString();
      if (bt != null && bt.isNotEmpty) {
        try {
          final format = DateFormat('hh:mm a');
          final dt = format.parse(bt);
          person2Time.value = TimeOfDay(hour: dt.hour, minute: dt.minute);
          person2TimeController.text = bt;
        } catch (e) {
          debugPrint('Error parsing girl birth time: $e');
        }
      }

      final tz = girl['timezone']?.toString();
      if (tz != null && tz.isNotEmpty) {
        try {
          final match = RegExp(r'([+-]?\d+):(\d+)').firstMatch(tz);
          if (match != null) {
            final hours = int.parse(match.group(1)!);
            final minutes = int.parse(match.group(2)!);
            person2TzController.text = (hours + (minutes / 60.0)).toString();
          } else {
            person2TzController.text = '5.5';
          }
        } catch (e) {
          person2TzController.text = '5.5';
        }
      }
    }
  }

  // ===== Saved Matchmaking API Methods =====

  Future<void> fetchSavedMatchmakingProfiles() async {
    try {
      isLoadingSavedMatchmaking.value = true;
      final profiles = await _matchMakingService.getSavedMatchmakingProfiles();
      savedMatchmakingList.assignAll(profiles);
    } catch (e) {
      debugPrint('Error fetching saved matchmaking profiles: $e');
    } finally {
      isLoadingSavedMatchmaking.value = false;
    }
  }

  Future<void> deleteSavedMatchmakingProfile(String id) async {
    try {
      final success = await _matchMakingService.deleteMatchmakingProfile(id);
      if (success) {
        savedMatchmakingList.removeWhere((m) => m['_id'] == id);
        showSuccessMessage(
          title: 'Success',
          message: 'Matchmaking profile deleted successfully',
        );
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to delete matchmaking profile',
        );
      }
    } catch (e) {
      showErrorMessage(
        title: 'Error',
        message: 'Error deleting matchmaking profile',
      );
    }
  }

  /// Open a saved matchmaking: generate matching from saved profile data and navigate to result
  Future<void> openSavedMatchmaking(Map<String, dynamic> profile) async {
    try {
      isOpeningSavedMatchmaking.value = true;

      final boy = profile['boy'] as Map<String, dynamic>?;
      final girl = profile['girl'] as Map<String, dynamic>?;

      if (boy == null || girl == null) {
        showErrorMessage(title: 'Error', message: 'Invalid profile data');
        return;
      }

      // Parse boy data
      String boyDob = '';
      final boyDobRaw = boy['dateOfBirth']?.toString() ?? '';
      if (boyDobRaw.isNotEmpty) {
        // API stores MM/dd/yyyy, convert to dd/MM/yyyy for matching API
        try {
          final parts = boyDobRaw.split('/');
          if (parts.length == 3) {
            boyDob = '${parts[1]}/${parts[0]}/${parts[2]}';
          }
        } catch (e) {
          debugPrint('Error parsing boy DOB: $e');
        }
      }

      String boyTob = '';
      final boyTimeRaw = boy['birthTime']?.toString() ?? '';
      if (boyTimeRaw.isNotEmpty) {
        boyTob = _convertTo24Hour(boyTimeRaw);
      }

      double boyTz = 5.5;
      final boyTzStr = boy['timezone']?.toString() ?? '';
      if (boyTzStr.isNotEmpty) {
        final match = RegExp(r'([+-]?\d+):(\d+)').firstMatch(boyTzStr);
        if (match != null) {
          boyTz =
              int.parse(match.group(1)!) + (int.parse(match.group(2)!) / 60.0);
        }
      }

      final boyLat = (boy['latitude'] is num)
          ? (boy['latitude'] as num).toDouble()
          : double.tryParse(boy['latitude']?.toString() ?? '') ?? 0.0;
      final boyLon = (boy['longitude'] is num)
          ? (boy['longitude'] as num).toDouble()
          : double.tryParse(boy['longitude']?.toString() ?? '') ?? 0.0;

      // Parse girl data
      String girlDob = '';
      final girlDobRaw = girl['dateOfBirth']?.toString() ?? '';
      if (girlDobRaw.isNotEmpty) {
        try {
          final parts = girlDobRaw.split('/');
          if (parts.length == 3) {
            girlDob = '${parts[1]}/${parts[0]}/${parts[2]}';
          }
        } catch (e) {
          debugPrint('Error parsing girl DOB: $e');
        }
      }

      String girlTob = '';
      final girlTimeRaw = girl['birthTime']?.toString() ?? '';
      if (girlTimeRaw.isNotEmpty) {
        girlTob = _convertTo24Hour(girlTimeRaw);
      }

      double girlTz = 5.5;
      final girlTzStr = girl['timezone']?.toString() ?? '';
      if (girlTzStr.isNotEmpty) {
        final match = RegExp(r'([+-]?\d+):(\d+)').firstMatch(girlTzStr);
        if (match != null) {
          girlTz =
              int.parse(match.group(1)!) + (int.parse(match.group(2)!) / 60.0);
        }
      }

      final girlLat = (girl['latitude'] is num)
          ? (girl['latitude'] as num).toDouble()
          : double.tryParse(girl['latitude']?.toString() ?? '') ?? 0.0;
      final girlLon = (girl['longitude'] is num)
          ? (girl['longitude'] as num).toDouble()
          : double.tryParse(girl['longitude']?.toString() ?? '') ?? 0.0;

      if (boyDob.isEmpty ||
          boyTob.isEmpty ||
          girlDob.isEmpty ||
          girlTob.isEmpty) {
        showErrorMessage(title: 'Error', message: 'Invalid profile data');
        return;
      }

      final result = await _matchMakingService.getAshtakootMatching(
        boyDob: boyDob,
        boyTob: boyTob,
        boyTz: boyTz,
        boyLat: boyLat,
        boyLon: boyLon,
        girlDob: girlDob,
        girlTob: girlTob,
        girlTz: girlTz,
        girlLat: girlLat,
        girlLon: girlLon,
        lang: 'en',
      );

      if (result != null) {
        final status = result['status'];
        final responseValue = result['response'];

        if (status != null && status != 200 && responseValue is String) {
          showErrorMessage(title: 'Error', message: responseValue);
          return;
        }

        final formData = {
          'boyName': (boy['name'] ?? 'Boy').toString(),
          'girlName': (girl['name'] ?? 'Girl').toString(),
          'boyDob': boyDob,
          'boyTob': boyTob,
          'boyTz': boyTz,
          'boyLat': boyLat,
          'boyLon': boyLon,
          'girlDob': girlDob,
          'girlTob': girlTob,
          'girlTz': girlTz,
          'girlLat': girlLat,
          'girlLon': girlLon,
          'lang': 'en',
          'boyStar': '',
          'girlStar': '',
          'boySign': '',
          'girlSign': '',
        };

        UserMainController.pushInCurrentTab(
          '/match-making-result',
          arguments: {
            'response': responseValue is Map<String, dynamic>
                ? responseValue
                : (result['response'] ?? result),
            'formData': formData,
          },
        );
      } else {
        showErrorMessage(
          title: 'Error',
          message: 'Failed to get matching results',
        );
      }
    } catch (e) {
      showErrorMessage(title: 'Error', message: 'Error: ${e.toString()}');
    } finally {
      isOpeningSavedMatchmaking.value = false;
    }
  }

  /// Edit a saved matchmaking: prefill form and switch to New tab
  void editSavedMatchmaking(Map<String, dynamic> profile) {
    _prefillFromProfile(profile);
    selectedTabIndex.value = 1;
  }

  @override
  void onClose() {
    person1NameController.dispose();
    person1DateController.dispose();
    person1TimeController.dispose();
    person1PlaceController.dispose();
    person1LatController.dispose();
    person1LonController.dispose();
    person1TzController.dispose();
    person2NameController.dispose();
    person2DateController.dispose();
    person2TimeController.dispose();
    person2PlaceController.dispose();
    person2LatController.dispose();
    person2LonController.dispose();
    person2TzController.dispose();
    super.onClose();
  }

  void _initializeForm() {
    person1TzController.text = '5.5';
    person2TzController.text = '5.5';
  }

  /// Set person 1 location from autocomplete details
  Future<void> setPerson1LocationFromAutocomplete(
    Map<String, dynamic> placeDetails,
  ) async {
    final lat = placeDetails['latitude'];
    final lon = placeDetails['longitude'];

    if (lat != null && lon != null) {
      person1LatController.text = lat.toString();
      person1LonController.text = lon.toString();

      try {
        final timezone = await AddressHelper.getTimezoneFromCoordinates(
          lat is double ? lat : double.parse(lat.toString()),
          lon is double ? lon : double.parse(lon.toString()),
        );

        if (timezone != null) {
          final offset = await _getTimezoneOffset(timezone);
          person1TzController.text = offset.toString();
        }
      } catch (e) {
        debugPrint('Error fetching timezone for person 1: $e');
        person1TzController.text = '5.5';
      }
    }
  }

  /// Set person 2 location from autocomplete details
  Future<void> setPerson2LocationFromAutocomplete(
    Map<String, dynamic> placeDetails,
  ) async {
    final lat = placeDetails['latitude'];
    final lon = placeDetails['longitude'];

    if (lat != null && lon != null) {
      person2LatController.text = lat.toString();
      person2LonController.text = lon.toString();

      try {
        final timezone = await AddressHelper.getTimezoneFromCoordinates(
          lat is double ? lat : double.parse(lat.toString()),
          lon is double ? lon : double.parse(lon.toString()),
        );

        if (timezone != null) {
          final offset = await _getTimezoneOffset(timezone);
          person2TzController.text = offset.toString();
        }
      } catch (e) {
        debugPrint('Error fetching timezone for person 2: $e');
        person2TzController.text = '5.5';
      }
    }
  }

  /// Fetch coordinates for person 1 place (fallback if not using autocomplete)
  Future<void> fetchPerson1Coordinates() async {
    final place = person1PlaceController.text.trim();
    if (place.isEmpty) return;

    try {
      final coords = await AddressHelper.fetchCoordinatesFromCity(
        city: place,
        state: '',
        country: 'India',
      );

      if (coords != null) {
        person1LatController.text = (coords['latitude'] as double)
            .toStringAsFixed(6);
        person1LonController.text = (coords['longitude'] as double)
            .toStringAsFixed(6);

        final timezone = await AddressHelper.getTimezoneFromCoordinates(
          coords['latitude'] as double,
          coords['longitude'] as double,
        );

        if (timezone != null) {
          final offset = await _getTimezoneOffset(timezone);
          person1TzController.text = offset.toString();
        }
      }
    } catch (e) {
      debugPrint('Error fetching coordinates for person 1: $e');
    }
  }

  /// Fetch coordinates for person 2 place (fallback if not using autocomplete)
  Future<void> fetchPerson2Coordinates() async {
    final place = person2PlaceController.text.trim();
    if (place.isEmpty) return;

    try {
      final coords = await AddressHelper.fetchCoordinatesFromCity(
        city: place,
        state: '',
        country: 'India',
      );

      if (coords != null) {
        person2LatController.text = (coords['latitude'] as double)
            .toStringAsFixed(6);
        person2LonController.text = (coords['longitude'] as double)
            .toStringAsFixed(6);

        final timezone = await AddressHelper.getTimezoneFromCoordinates(
          coords['latitude'] as double,
          coords['longitude'] as double,
        );

        if (timezone != null) {
          final offset = await _getTimezoneOffset(timezone);
          person2TzController.text = offset.toString();
        }
      }
    } catch (e) {
      debugPrint('Error fetching coordinates for person 2: $e');
    }
  }

  Future<double> _getTimezoneOffset(String timezone) async {
    try {
      if (timezone.contains(':')) {
        final parts = timezone.replaceAll('+', '').split(':');
        if (parts.length == 2) {
          final hours = int.tryParse(parts[0]) ?? 0;
          final minutes = int.tryParse(parts[1]) ?? 0;
          return hours + (minutes / 60.0);
        }
      }
    } catch (e) {
      debugPrint('Error parsing timezone: $e');
    }
    return 5.5;
  }

  /// Swap person 1 and person 2 data
  void swapPersons() {
    final tempName = person1NameController.text;
    person1NameController.text = person2NameController.text;
    person2NameController.text = tempName;

    final tempDate = person1DateController.text;
    person1DateController.text = person2DateController.text;
    person2DateController.text = tempDate;
    final tempDateObj = person1Date.value;
    person1Date.value = person2Date.value;
    person2Date.value = tempDateObj;

    final tempTime = person1TimeController.text;
    person1TimeController.text = person2TimeController.text;
    person2TimeController.text = tempTime;
    final tempTimeObj = person1Time.value;
    person1Time.value = person2Time.value;
    person2Time.value = tempTimeObj;

    final tempPlace = person1PlaceController.text;
    person1PlaceController.text = person2PlaceController.text;
    person2PlaceController.text = tempPlace;

    final tempLat = person1LatController.text;
    person1LatController.text = person2LatController.text;
    person2LatController.text = tempLat;
    final tempLon = person1LonController.text;
    person1LonController.text = person2LonController.text;
    person2LonController.text = tempLon;

    final tempTz = person1TzController.text;
    person1TzController.text = person2TzController.text;
    person2TzController.text = tempTz;
  }

  Future<void> selectPerson1Date(DateTime date) async {
    person1Date.value = date;
    person1DateController.text = DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> selectPerson1Time(TimeOfDay time) async {
    person1Time.value = time;
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    person1TimeController.text =
        '$hour12:${time.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> selectPerson2Date(DateTime date) async {
    person2Date.value = date;
    person2DateController.text = DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> selectPerson2Time(TimeOfDay time) async {
    person2Time.value = time;
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    person2TimeController.text =
        '$hour12:${time.minute.toString().padLeft(2, '0')} $period';
  }

  String _convertTo24Hour(String time12) {
    try {
      final parts = time12.split(' ');
      if (parts.length != 2) return '12:00';

      final timePart = parts[0];
      final period = parts[1].toUpperCase();
      final timeComponents = timePart.split(':');

      if (timeComponents.length != 2) return '12:00';

      int hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint('Error converting time: $e');
      return '12:00';
    }
  }

  String _convertDateFormat(String date) {
    return date.replaceAll('-', '/');
  }

  /// Validate and submit form
  Future<void> compareKundlis() async {
    // Validate Person 1 fields
    if (person1NameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter Person 1 name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (person1DateController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select Person 1 date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (person1TimeController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select Person 1 time of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (person1PlaceController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter Person 1 birth place',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate Person 2 fields
    if (person2NameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter Person 2 name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (person2DateController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select Person 2 date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (person2TimeController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select Person 2 time of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (person2PlaceController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter Person 2 birth place',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate coordinates
    if (person1LatController.text.trim().isEmpty ||
        person1LonController.text.trim().isEmpty) {
      Get.snackbar(
        'Location Error',
        'Please fetch coordinates for Person 1 birth place',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (person2LatController.text.trim().isEmpty ||
        person2LonController.text.trim().isEmpty) {
      Get.snackbar(
        'Location Error',
        'Please fetch coordinates for Person 2 birth place',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final boyDob = _convertDateFormat(person1DateController.text);
      final boyTob = _convertTo24Hour(person1TimeController.text);
      final boyTz = double.tryParse(person1TzController.text) ?? 5.5;
      final boyLat = double.tryParse(person1LatController.text);
      final boyLon = double.tryParse(person1LonController.text);

      final girlDob = _convertDateFormat(person2DateController.text);
      final girlTob = _convertTo24Hour(person2TimeController.text);
      final girlTz = double.tryParse(person2TzController.text) ?? 5.5;
      final girlLat = double.tryParse(person2LatController.text);
      final girlLon = double.tryParse(person2LonController.text);

      if (boyLat == null ||
          boyLon == null ||
          girlLat == null ||
          girlLon == null) {
        isLoading.value = false;
        Get.snackbar(
          'Location Error',
          'Invalid coordinates. Please re-enter birth places.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Save matchmaking profile if checkbox checked and new data
      if (saveMatchmakingChecked.value && editingMatchmakingId.value == null) {
        _saveMatchmakingProfile();
      }

      final result = await _matchMakingService.getAshtakootMatching(
        boyDob: boyDob,
        boyTob: boyTob,
        boyTz: boyTz,
        boyLat: boyLat,
        boyLon: boyLon,
        girlDob: girlDob,
        girlTob: girlTob,
        girlTz: girlTz,
        girlLat: girlLat,
        girlLon: girlLon,
        lang: selectedLanguage.value,
      );

      if (isGeneratePdfMode) {
        await _generateMatchingPdfReport(
          boyDob,
          boyTob,
          boyTz,
          boyLat,
          boyLon,
          girlDob,
          girlTob,
          girlTz,
          girlLat,
          girlLon,
        );
        return;
      }

      isLoading.value = false;

      if (result != null) {
        final status = result['status'];
        final responseValue = result['response'];

        if (status != null && status != 200 && responseValue is String) {
          Get.snackbar(
            'Error',
            responseValue,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        final formData = {
          'boyName': person1NameController.text.trim(),
          'girlName': person2NameController.text.trim(),
          'boyDob': boyDob,
          'boyTob': boyTob,
          'boyTz': boyTz,
          'boyLat': boyLat,
          'boyLon': boyLon,
          'girlDob': girlDob,
          'girlTob': girlTob,
          'girlTz': girlTz,
          'girlLat': girlLat,
          'girlLon': girlLon,
          'lang': selectedLanguage.value,
          'boyStar': '',
          'girlStar': '',
          'boySign': '',
          'girlSign': '',
        };

        UserMainController.pushInCurrentTab(
          '/match-making-result',
          arguments: {
            'response': responseValue is Map<String, dynamic>
                ? responseValue
                : (result['response'] ?? result),
            'formData': formData,
          },
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to get matching results',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Error comparing kundlis: $e');
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Save matchmaking profile via POST API (fire-and-forget)
  void _saveMatchmakingProfile() {
    // Build boy data for API
    String boyApiDob = '';
    try {
      final parts = person1DateController.text.split('-');
      if (parts.length == 3) {
        boyApiDob = '${parts[1]}/${parts[0]}/${parts[2]}'; // MM/dd/yyyy
      }
    } catch (e) {
      debugPrint('Error converting boy date: $e');
    }

    String girlApiDob = '';
    try {
      final parts = person2DateController.text.split('-');
      if (parts.length == 3) {
        girlApiDob = '${parts[1]}/${parts[0]}/${parts[2]}';
      }
    } catch (e) {
      debugPrint('Error converting girl date: $e');
    }

    // Build timezone strings
    String boyTzStr = 'IST +5:30';
    try {
      final tz = double.tryParse(person1TzController.text) ?? 5.5;
      final hours = tz.truncate();
      final minutes = ((tz - hours) * 60).round();
      boyTzStr = 'IST +$hours:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint('Error formatting boy timezone: $e');
    }

    String girlTzStr = 'IST +5:30';
    try {
      final tz = double.tryParse(person2TzController.text) ?? 5.5;
      final hours = tz.truncate();
      final minutes = ((tz - hours) * 60).round();
      girlTzStr = 'IST +$hours:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      debugPrint('Error formatting girl timezone: $e');
    }

    final boy = {
      'name': person1NameController.text.trim().isNotEmpty
          ? person1NameController.text.trim()
          : 'Unknown',
      'dateOfBirth': boyApiDob,
      'birthTime': person1TimeController.text,
      'birthPlace': person1PlaceController.text,
      'timezone': boyTzStr,
      'latitude': double.tryParse(person1LatController.text) ?? 0.0,
      'longitude': double.tryParse(person1LonController.text) ?? 0.0,
    };

    final girl = {
      'name': person2NameController.text.trim().isNotEmpty
          ? person2NameController.text.trim()
          : 'Unknown',
      'dateOfBirth': girlApiDob,
      'birthTime': person2TimeController.text,
      'birthPlace': person2PlaceController.text,
      'timezone': girlTzStr,
      'latitude': double.tryParse(person2LatController.text) ?? 0.0,
      'longitude': double.tryParse(person2LonController.text) ?? 0.0,
    };

    _matchMakingService
        .createMatchmakingProfile(boy: boy, girl: girl)
        .then((_) {
          debugPrint('Matchmaking profile saved successfully');
          fetchSavedMatchmakingProfiles();
        })
        .catchError((e) {
          debugPrint('Error saving matchmaking profile: $e');
        });
  }

  /// Internal method to handle PDF matching report generation
  Future<void> _generateMatchingPdfReport(
    String boyDob,
    String boyTob,
    double boyTz,
    double boyLat,
    double boyLon,
    String girlDob,
    String girlTob,
    double girlTz,
    double girlLat,
    double girlLon,
  ) async {
    try {
      final params = {
        'boy_name': person1NameController.text.trim().isNotEmpty
            ? person1NameController.text.trim()
            : 'Boy',
        'boy_dob': boyDob,
        'boy_tob': boyTob,
        'boy_tz': boyTz.toString(),
        'boy_lat': boyLat.toString(),
        'boy_lon': boyLon.toString(),
        'boy_place': person1PlaceController.text,
        'girl_name': person2NameController.text.trim().isNotEmpty
            ? person2NameController.text.trim()
            : 'Girl',
        'girl_dob': girlDob,
        'girl_tob': girlTob,
        'girl_tz': girlTz.toString(),
        'girl_lat': girlLat.toString(),
        'girl_lon': girlLon.toString(),
        'girl_place': person2PlaceController.text,
        'lang': selectedLanguage.value,
        'style': 'north',
      };

      final downloadUrl = await _reportService.generateMatchingReport(
        params: params,
        reportPath: reportKey,
      );

      print('MatchMakingController: Received downloadUrl: $downloadUrl');

      isLoading.value = false;

      if (downloadUrl != null && downloadUrl.isNotEmpty) {
        UserMainController.pushInCurrentTab(
          AppRoutes.reportPdfView,
          arguments: {'pdfUrl': downloadUrl, 'title': 'Matchmaking Report'},
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to generate PDF report. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on BadRequestException catch (e) {
      if (e.message.toLowerCase().contains('insufficient balance')) {
        double available = 0;
        double required = 0;

        try {
          if (e.fullBody is Map) {
            final data = (e.fullBody as Map)['data'] ?? e.fullBody;
            available = (data['available_balance'] ?? data['available'] ?? 0)
                .toDouble();
            required = (data['required_balance'] ?? data['required'] ?? 0)
                .toDouble();
          }
        } catch (err) {
          debugPrint('Error parsing balance from body: $err');
        }

        Get.dialog(
          ReportInsufficientBalanceDialog(
            currentBalance: available,
            requiredBalance: required,
            reportName: reportKey ?? 'Matchmaking Report',
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          e.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error generating matching PDF: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
