import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/match_making/service/match_making_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchMakingFormController extends BaseController {
  final MatchMakingService _matchMakingService = MatchMakingService();

  // Person 1 (Groom) Controllers - All dynamic, no hardcoded values
  final person1NameController = TextEditingController();
  final person1DateController = TextEditingController();
  final person1TimeController = TextEditingController();
  final person1PlaceController = TextEditingController();
  final person1LatController = TextEditingController();
  final person1LonController = TextEditingController();
  final person1TzController = TextEditingController();

  // Person 2 (Bride) Controllers - All dynamic, no hardcoded values
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

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
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
    // Set default timezone (IST) - can be updated when user enters place
    person1TzController.text = '5.5';
    person2TzController.text = '5.5';

    // Coordinates will be fetched when user enters place
    // No hardcoded values - fully dynamic
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

      // Fetch timezone for these coordinates
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
        // Default to IST if error
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

      // Fetch timezone for these coordinates
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
        // Default to IST if error
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

        // Get timezone
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

        // Get timezone
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
      // Parse timezone string like "+05:30" or "Asia/Kolkata"
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
    return 5.5; // Default IST
  }

  /// Swap person 1 and person 2 data
  void swapPersons() {
    // Swap names
    final tempName = person1NameController.text;
    person1NameController.text = person2NameController.text;
    person2NameController.text = tempName;

    // Swap dates
    final tempDate = person1DateController.text;
    person1DateController.text = person2DateController.text;
    person2DateController.text = tempDate;
    final tempDateObj = person1Date.value;
    person1Date.value = person2Date.value;
    person2Date.value = tempDateObj;

    // Swap times
    final tempTime = person1TimeController.text;
    person1TimeController.text = person2TimeController.text;
    person2TimeController.text = tempTime;
    final tempTimeObj = person1Time.value;
    person1Time.value = person2Time.value;
    person2Time.value = tempTimeObj;

    // Swap places
    final tempPlace = person1PlaceController.text;
    person1PlaceController.text = person2PlaceController.text;
    person2PlaceController.text = tempPlace;

    // Swap coordinates
    final tempLat = person1LatController.text;
    person1LatController.text = person2LatController.text;
    person2LatController.text = tempLat;
    final tempLon = person1LonController.text;
    person1LonController.text = person2LonController.text;
    person2LonController.text = tempLon;

    // Swap timezone
    final tempTz = person1TzController.text;
    person1TzController.text = person2TzController.text;
    person2TzController.text = tempTz;
  }

  /// Select date for person 1
  Future<void> selectPerson1Date(DateTime date) async {
    person1Date.value = date;
    person1DateController.text = DateFormat('dd-MM-yyyy').format(date);
  }

  /// Select time for person 1
  Future<void> selectPerson1Time(TimeOfDay time) async {
    person1Time.value = time;
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    person1TimeController.text =
        '$hour12:${time.minute.toString().padLeft(2, '0')} $period';
  }

  /// Select date for person 2
  Future<void> selectPerson2Date(DateTime date) async {
    person2Date.value = date;
    person2DateController.text = DateFormat('dd-MM-yyyy').format(date);
  }

  /// Select time for person 2
  Future<void> selectPerson2Time(TimeOfDay time) async {
    person2Time.value = time;
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    person2TimeController.text =
        '$hour12:${time.minute.toString().padLeft(2, '0')} $period';
  }

  /// Convert 12-hour time to 24-hour format
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

  /// Convert date format from dd-MM-yyyy to dd/MM/yyyy
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

    // Validate coordinates are available
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
      // Convert dates and times
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

      // Final validation for coordinates
      if (boyLat == null ||
          boyLon == null ||
          girlLat == null ||
          girlLon == null) {
        isLoading.value = false;
        Get.snackbar(
          'Location Error',
          'Invalid coordinates. Please re-enter birth places and fetch coordinates.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
        lang: selectedLanguage.value,
      );

      isLoading.value = false;

      if (result != null) {
        // Check for error status in response
        final status = result['status'];
        final responseValue = result['response'];

        // If status indicates error (not 200) and response is a string, show error
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
          // Optional placeholders for additional tabs
          'boyStar': '',
          'girlStar': '',
          'boySign': '',
          'girlSign': '',
        };

        Get.toNamed(
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
}
