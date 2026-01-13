import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BirthDetailsController extends BaseController {
  // Form data
  final formData = Rxn<Map<String, dynamic>>();
  
  // API data
  final planetDetailsData = Rxn<Map<String, dynamic>>();
  final mangalDoshData = Rxn<Map<String, dynamic>>();
  
  // Loading states
  final isLoadingPlanetDetails = false.obs;
  final isLoadingMangalDosh = false.obs;
  
  // Service
  final _kundliService = KundliService();
  final _userProfileService = UserProfileService();
  
  // User profile data
  final userProfile = Rxn<UserProfileModel>();

  @override
  void onInit() {
    super.onInit();
    _loadData();
    // Load user profile if available
    _loadUserProfile();
    // Fetch data automatically
    fetchAllData();
  }
  
  // Load user profile
  Future<void> _loadUserProfile() async {
    try {
      final userId = UserData().getLoginData.user?.userId;
      if (userId != null) {
        final profile = await _userProfileService.getProfile(userId);
        if (profile != null) {
          userProfile.value = profile;
        }
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  void _loadData() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      formData.value = arguments['formData'] as Map<String, dynamic>?;
      // If planet details are passed, use them
      if (arguments['planetDetailsData'] != null) {
        planetDetailsData.value = arguments['planetDetailsData'] as Map<String, dynamic>?;
      }
    }
  }

  // Fetch all required data
  Future<void> fetchAllData() async {
    await Future.wait([
      fetchPlanetDetails(),
      fetchMangalDosh(),
    ]);
  }

  // Fetch Planet Details
  Future<void> fetchPlanetDetails() async {
    if (planetDetailsData.value != null) {
      // Already loaded
      return;
    }
    
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Planet Details');
      return;
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

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Planet Details');
        isLoadingPlanetDetails.value = false;
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
      } else {
        debugPrint('Failed to fetch Planet Details data');
      }
    } catch (e) {
      isLoadingPlanetDetails.value = false;
      debugPrint('Error fetching Planet Details data: $e');
    }
  }

  // Fetch Mangal Dosh
  Future<void> fetchMangalDosh() async {
    if (mangalDoshData.value != null) {
      // Already loaded
      return;
    }
    
    if (formData.value == null) {
      debugPrint('Form data is null, cannot fetch Mangal Dosh');
      return;
    }

    try {
      isLoadingMangalDosh.value = true;
      
      final form = formData.value!;
      final date = form['date'] as String?;
      final time = form['time'] as String?;
      final latitude = form['latitude'] as double?;
      final longitude = form['longitude'] as double?;
      final tz = form['timezone'] as double?;
      final lang = form['language'] as String? ?? 'en';

      if (date == null || time == null || latitude == null || longitude == null || tz == null) {
        debugPrint('Missing required form data for Mangal Dosh');
        isLoadingMangalDosh.value = false;
        return;
      }

      final data = await _kundliService.getMangalDosh(
        date: date,
        time: time,
        latitude: latitude,
        longitude: longitude,
        tz: tz,
        lang: lang,
      );

      isLoadingMangalDosh.value = false;

      if (data != null) {
        mangalDoshData.value = data;
        debugPrint('Mangal Dosh data loaded successfully');
      } else {
        debugPrint('Failed to fetch Mangal Dosh data');
      }
    } catch (e) {
      isLoadingMangalDosh.value = false;
      debugPrint('Error fetching Mangal Dosh data: $e');
    }
  }

  // Get Name from form data, user profile, or return default
  String getName() {
    // First check form data
    if (formData.value != null) {
      final name = formData.value!['name']?.toString() ?? 
                   formData.value!['fullName']?.toString();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
    
    // Then check user profile
    if (userProfile.value != null && userProfile.value!.personalInfo != null) {
      final name = userProfile.value!.personalInfo!.fullName;
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
    
    return '-';
  }

  // Get Date from form data
  String getDate() {
    if (formData.value == null) return '-';
    return formData.value!['date']?.toString() ?? '-';
  }

  // Get Time from form data
  String getTime() {
    if (formData.value == null) return '-';
    final time = formData.value!['time']?.toString() ?? '-';
    // If time doesn't have seconds, add :00
    if (time != '-' && !time.contains(':')) {
      return '$time:00';
    }
    if (time != '-' && time.split(':').length == 2) {
      return '$time:00';
    }
    return time;
  }

  // Get Place from form data, user profile, or return default
  String getPlace() {
    // First check form data
    if (formData.value != null) {
      final place = formData.value!['place']?.toString() ?? 
                    formData.value!['city']?.toString() ?? 
                    formData.value!['birthPlace']?.toString() ??
                    formData.value!['selectedLocation']?.toString();
      if (place != null && place.isNotEmpty && place != 'Select Location' && place != 'Fetching Location...') {
        return place;
      }
    }
    
    // Then check user profile birth chart
    if (userProfile.value != null && 
        userProfile.value!.birthChart != null && 
        userProfile.value!.birthChart!.birthPlace != null) {
      final birthPlace = userProfile.value!.birthChart!.birthPlace!;
      final city = birthPlace.city;
      final state = birthPlace.state;
      
      if (city != null && city.isNotEmpty) {
        if (state != null && state.isNotEmpty) {
          return '$city, $state';
        }
        return city;
      }
    }
    
    // Check user profile contact address
    if (userProfile.value != null && 
        userProfile.value!.contactInfo != null && 
        userProfile.value!.contactInfo!.address != null) {
      final address = userProfile.value!.contactInfo!.address!;
      final city = address.city;
      if (city != null && city.isNotEmpty) {
        return city;
      }
    }
    
    return '-';
  }

  // Get Gender from form data, user profile, or return default
  String getGender() {
    // First check form data
    if (formData.value != null) {
      final gender = formData.value!['gender']?.toString();
      if (gender != null && gender.isNotEmpty && gender != '-') {
        return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
      }
    }
    
    // Then check user profile
    if (userProfile.value != null && userProfile.value!.personalInfo != null) {
      final gender = userProfile.value!.personalInfo!.gender;
      if (gender != null && gender.isNotEmpty) {
        // Format gender (MALE -> Male, FEMALE -> Female, etc.)
        if (gender.toUpperCase() == 'MALE') {
          return 'Male';
        } else if (gender.toUpperCase() == 'FEMALE') {
          return 'Female';
        } else {
          return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
        }
      }
    }
    
    return '-';
  }

  // Get Ayanamsa from planet details
  String getAyanamsa() {
    if (planetDetailsData.value == null) return '-';
    final panchang = planetDetailsData.value!['panchang'] as Map<String, dynamic>?;
    if (panchang == null) return '-';
    
    final ayanamsaName = panchang['ayanamsa_name']?.toString() ?? '';
    final ayanamsa = panchang['ayanamsa']?.toString() ?? '';
    
    if (ayanamsaName.isEmpty && ayanamsa.isEmpty) return '-';
    
    // Format ayanamsa as degrees
    String formattedAyanamsa = '';
    if (ayanamsa.isNotEmpty) {
      try {
        final ayanamsaValue = double.parse(ayanamsa);
        final degrees = ayanamsaValue.floor();
        final minutes = ((ayanamsaValue - degrees) * 60).floor();
        final seconds = (((ayanamsaValue - degrees) * 60 - minutes) * 60).floor();
        formattedAyanamsa = '${degrees.toString().padLeft(3, '0')}°${minutes.toString().padLeft(2, '0')}\'${seconds.toString().padLeft(2, '0')}"';
      } catch (e) {
        formattedAyanamsa = ayanamsa;
      }
    }
    
    if (ayanamsaName.isNotEmpty && formattedAyanamsa.isNotEmpty) {
      return '$ayanamsaName ($formattedAyanamsa)';
    } else if (ayanamsaName.isNotEmpty) {
      return ayanamsaName;
    } else {
      return formattedAyanamsa;
    }
  }

  // Get DST (Daylight Saving Time) - usually 0 for India
  String getDST() {
    if (formData.value == null) return '0';
    return formData.value!['dst']?.toString() ?? 
           formData.value!['daylightSaving']?.toString() ?? '0';
  }

  // Get Mangal Dosh status
  String getMangalDosh() {
    if (mangalDoshData.value != null) {
      final response = mangalDoshData.value!['response'] as Map<String, dynamic>?;
      if (response != null) {
        final hasDosh = response['has_dosh'] as bool? ?? false;
        final doshType = response['dosh_type']?.toString() ?? '';
        if (hasDosh) {
          if (doshType.isNotEmpty) {
            return 'Yes ($doshType)';
          }
          return 'Yes';
        }
        return 'No';
      }
    }
    
    // Fallback to planet details if available
    if (planetDetailsData.value != null) {
      // Check if mangal dosh info is in planet details
      // This is a fallback, actual API might have different structure
    }
    
    return '-';
  }

  // Get Rashi from planet details
  String getRashi() {
    if (planetDetailsData.value == null) return '-';
    return planetDetailsData.value!['rasi']?.toString() ?? '-';
  }

  // Calculate Age from date
  String getAge() {
    if (formData.value == null) return '-';
    final dateStr = formData.value!['date']?.toString();
    if (dateStr == null || dateStr == '-') return '-';
    
    try {
      // Parse date in dd/MM/yyyy format
      final dateParts = dateStr.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        final birthDate = DateTime(year, month, day);
        final now = DateTime.now();
        
        int years = now.year - birthDate.year;
        int months = now.month - birthDate.month;
        int days = now.day - birthDate.day;
        
        if (days < 0) {
          months--;
          final lastMonth = DateTime(now.year, now.month - 1, 0);
          days += lastMonth.day;
        }
        
        if (months < 0) {
          years--;
          months += 12;
        }
        
        return '${years}Y${months}M${days}D';
      }
    } catch (e) {
      debugPrint('Error calculating age: $e');
    }
    
    return '-';
  }

  // Get Bal Dasa from planet details
  String getBalDasa() {
    if (planetDetailsData.value == null) return '-';
    final birthDasa = planetDetailsData.value!['birth_dasa']?.toString() ?? '';
    final birthDasaTime = planetDetailsData.value!['birth_dasa_time']?.toString() ?? '';
    
    if (birthDasa.isEmpty && birthDasaTime.isEmpty) return '-';
    
    // Parse birth_dasa_time to extract years, months, days
    // Format might be like "14/12/2016" or "Ke 3 Y 7 M 12 D"
    if (birthDasaTime.isNotEmpty) {
      try {
        // Try to parse as date first
        final dateParts = birthDasaTime.split('/');
        if (dateParts.length == 3) {
          // It's a date, calculate difference
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          final dasaDate = DateTime(year, month, day);
          final now = DateTime.now();
          
          int years = now.year - dasaDate.year;
          int months = now.month - dasaDate.month;
          int days = now.day - dasaDate.day;
          
          if (days < 0) {
            months--;
            final lastMonth = DateTime(now.year, now.month - 1, 0);
            days += lastMonth.day;
          }
          
          if (months < 0) {
            years--;
            months += 12;
          }
          
          final dasaPlanet = birthDasa.split('/').isNotEmpty ? birthDasa.split('/').last : '';
          return '$dasaPlanet $years Y $months M $days D';
        }
      } catch (e) {
        // If parsing fails, return as is
        return birthDasaTime;
      }
    }
    
    return birthDasa;
  }
}

