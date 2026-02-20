import 'dart:io';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/auth_service.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/data_model/order_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/ecommerce/controller/wishlist_controller.dart';
import 'package:astrobharataiuser/screens/ecommerce/service/ecommerce_service.dart';

import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class ProfileController extends BaseController {
  final EcommerceService _ecommerceService = EcommerceService();
  final UserProfileService _profileService = UserProfileService();
  final AstrologerService _astrologerService = AstrologerService();

  final isLoading = false.obs;
  final isUpdatingProfile = false.obs;

  final profile = Rxn<UserProfileModel>();
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final profileImageUrl = ''.obs;
  final emailVerified = false.obs;
  final phoneVerified = false.obs;
  final lastLoginText = ''.obs;

  // Personal Info Controllers
  final fullNameController = TextEditingController();
  final genderController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final occupationController = TextEditingController();
  final profilePicture = Rxn<File>();

  // Dropdown values
  final selectedGender = Rxn<String>();
  final selectedMaritalStatus = Rxn<String>();

  // Dropdown options
  static const List<String> genderOptions = ['MALE', 'FEMALE', 'OTHER'];
  static const List<String> maritalStatusOptions = ['SINGLE', 'MARRIED'];

  // Contact Info Controllers
  final alternatePhoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController(text: 'India');

  // Birth Chart Controllers
  final birthDateController = TextEditingController();
  final selectedBirthDate = Rxn<DateTime>();
  final birthCityController = TextEditingController();
  final birthStateController = TextEditingController();
  final birthCountryController = TextEditingController(text: 'India');
  final birthLatitudeController = TextEditingController();
  final birthLongitudeController = TextEditingController();
  final birthTimezoneController = TextEditingController();
  final birthHourController = TextEditingController();
  final birthMinuteController = TextEditingController();
  final birthSecondController = TextEditingController();
  final isFetchingCoordinates = false.obs;

  // Preferences Controllers
  final languageController = TextEditingController();
  final emailNotificationController = true.obs;
  final smsNotificationController = false.obs;
  final pushNotificationController = true.obs;
  final whatsappNotificationController = false.obs;
  final interestsController = <String>[].obs;

  final ordersCount = 0.obs;
  final addressesCount = 0.obs;
  final couponCount = 0.obs;
  final followingCount = 0.obs;
  final recentOrders = <OrderModel>[].obs;

  AuthService get _authService => Get.find<AuthService>();

  WishlistController? get wishlistController =>
      Get.isRegistered<WishlistController>()
      ? Get.find<WishlistController>()
      : null;

  int get wishlistCount => wishlistController?.items.length ?? 0;

  String? get userId => UserData().getLoginData.user?.userId;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    genderController.dispose();
    maritalStatusController.dispose();
    occupationController.dispose();
    alternatePhoneController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    countryController.dispose();
    birthDateController.dispose();
    birthCityController.dispose();
    birthStateController.dispose();
    birthCountryController.dispose();
    birthLatitudeController.dispose();
    birthLongitudeController.dispose();
    birthTimezoneController.dispose();
    birthHourController.dispose();
    birthMinuteController.dispose();
    birthSecondController.dispose();
    languageController.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      // Only call auth-required APIs when user is logged in to avoid 401 and accidental force logout
      if (LoginGuard.isLoggedIn) {
        await _loadUserProfile();
        await _loadRecentOrders();
        await _loadCounts();
      }
    } catch (e) {
      showErrorMessage(title: 'Profile', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUserProfile() async {
    // Profile API uses Bearer token; userId optional (backend identifies user from token)
    final result = await _profileService.getProfile(userId);
    if (result != null) {
      _applyProfile(result);
    }
  }

  Future<void> _loadRecentOrders() async {
    try {
      final response = await _ecommerceService.getOrders(page: 1, limit: 5);
      if (response != null) {
        ordersCount.value =
            response.pagination?.totalItems ?? response.items.length;
        recentOrders
          ..clear()
          ..addAll(response.items);
      }
    } catch (e) {
      // Silently handle errors - user may not have ecommerce access
      // Don't throw error to avoid logout
      ordersCount.value = 0;
      recentOrders.clear();
      if (kDebugMode) {
        print('Failed to load orders: $e');
      }
    }
  }

  Future<void> _loadCounts() async {
    try {
      final addresses = await _ecommerceService.getAddresses();
      addressesCount.value = addresses.length;
    } catch (e) {
      // Silently handle errors - user may not have ecommerce access
      addressesCount.value = 0;
      if (kDebugMode) {
        print('Failed to load addresses: $e');
      }
    }

    try {
      final coupons = await _ecommerceService.getAvailableCoupons();
      couponCount.value = coupons.length;
    } catch (e) {
      // Silently handle errors - user may not have ecommerce access
      couponCount.value = 0;
      if (kDebugMode) {
        print('Failed to load coupons: $e');
      }
    }

    try {
      final result = await _astrologerService.getFollowingAstrologers(
        page: 1,
        limit: 1,
      );
      if (result != null) {
        final pagination = result['pagination'] as Map<String, dynamic>?;
        followingCount.value = pagination?['totalFollowing'] as int? ?? 0;
      }
    } catch (e) {
      // Silently handle errors
      followingCount.value = 0;
      if (kDebugMode) {
        print('Failed to load following count: $e');
      }
    }
  }

  void _applyProfile(UserProfileModel userProfile) {
    profile.value = userProfile;
    userName.value =
        userProfile.personalInfo?.fullName?.trim().isNotEmpty == true
        ? userProfile.personalInfo!.fullName!.trim()
        : 'Guest User';
    userEmail.value = userProfile.contactInfo?.email?.trim() ?? '';
    userPhone.value = userProfile.contactInfo?.phone?.trim() ?? '';
    profileImageUrl.value = userProfile.personalInfo?.profilePicture ?? '';
    emailVerified.value = userProfile.metadata?.isVerified ?? false;
    phoneVerified.value = userProfile.metadata?.isVerified ?? false;
    lastLoginText.value = _formatDate(userProfile.metadata?.updatedAt);

    // Populate form fields
    if (userProfile.personalInfo != null) {
      fullNameController.text = userProfile.personalInfo!.fullName ?? '';
      selectedGender.value = userProfile.personalInfo!.gender;
      if (selectedGender.value != null) {
        genderController.text = selectedGender.value!;
      }
      selectedMaritalStatus.value = userProfile.personalInfo!.maritalStatus;
      if (selectedMaritalStatus.value != null) {
        maritalStatusController.text = selectedMaritalStatus.value!;
      }
      occupationController.text = userProfile.personalInfo!.occupation ?? '';
    }

    if (userProfile.contactInfo != null) {
      alternatePhoneController.text =
          userProfile.contactInfo!.alternatePhone ?? '';
      if (userProfile.contactInfo!.address != null) {
        cityController.text = userProfile.contactInfo!.address!.city ?? '';
        stateController.text = userProfile.contactInfo!.address!.state ?? '';
        pincodeController.text =
            userProfile.contactInfo!.address!.pincode ?? '';
        countryController.text =
            userProfile.contactInfo!.address!.country ?? 'India';
      }
    }

    // Populate birth date from personalInfo.dateOfBirth first, then birthChart.generatedAt
    String? dateStr = userProfile.personalInfo?.dateOfBirth;
    if (dateStr == null && userProfile.birthChart?.generatedAt != null) {
      dateStr = userProfile.birthChart!.generatedAt!;
    }
    if (dateStr != null && dateStr.isNotEmpty) {
      try {
        final isoDate = DateTime.tryParse(dateStr);
        if (isoDate != null) {
          selectedBirthDate.value = isoDate;
          birthDateController.text = DateFormat('dd/MM/yyyy').format(isoDate);
        } else {
          final parts = dateStr.split('/');
          if (parts.length == 3) {
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            if (day != null && month != null && year != null) {
              selectedBirthDate.value = DateTime(year, month, day);
              birthDateController.text = dateStr;
            }
          }
        }
      } catch (e) {
        // Keep empty if parsing fails
      }
    }

    if (userProfile.birthChart != null &&
        userProfile.birthChart!.birthPlace != null) {
      final birthPlace = userProfile.birthChart!.birthPlace!;
      birthCityController.text = birthPlace.city ?? '';
      birthStateController.text = birthPlace.state ?? '';
      birthCountryController.text = birthPlace.country ?? 'India';
      birthLatitudeController.text = birthPlace.latitude?.toString() ?? '';
      birthLongitudeController.text = birthPlace.longitude?.toString() ?? '';
      birthTimezoneController.text = birthPlace.timezone ?? '';
    }

    if (userProfile.birthChart != null &&
        userProfile.birthChart!.birthTime != null) {
      final birthTime = userProfile.birthChart!.birthTime!;
      birthHourController.text = birthTime.hour?.toString() ?? '';
      birthMinuteController.text = birthTime.minute?.toString() ?? '';
      birthSecondController.text = birthTime.second?.toString() ?? '';
    }

    if (userProfile.preferences != null) {
      languageController.text = userProfile.preferences!.language ?? '';
      if (userProfile.preferences!.notificationSettings != null) {
        emailNotificationController.value =
            userProfile.preferences!.notificationSettings!.email ?? false;
        smsNotificationController.value =
            userProfile.preferences!.notificationSettings!.sms ?? false;
        pushNotificationController.value =
            userProfile.preferences!.notificationSettings!.push ?? false;
        whatsappNotificationController.value =
            userProfile.preferences!.notificationSettings!.whatsapp ?? false;
      }
      interestsController.value = List<String>.from(
        userProfile.preferences!.interests ?? [],
      );
    }
  }

  /// Autofetch address details when contact info city changes
  Future<void> onContactCityChanged() async {
    if (cityController.text.trim().isEmpty) {
      return;
    }

    try {
      isFetchingCoordinates.value = true;
      final addressDetails = await AddressHelper.fetchAddressDetails(
        city: cityController.text.trim(),
        state: stateController.text.trim().isNotEmpty
            ? stateController.text.trim()
            : null,
        country: countryController.text.trim().isNotEmpty
            ? countryController.text.trim()
            : null,
        pincode: pincodeController.text.trim().isNotEmpty
            ? pincodeController.text.trim()
            : null,
      );

      if (addressDetails != null) {
        // Update state if found and field is empty or needs update
        if (addressDetails['state'] != null) {
          final extractedState = addressDetails['state']?.toString() ?? '';
          if (extractedState.isNotEmpty) {
            // Only update if current state is empty or significantly different
            final currentState = stateController.text.trim().toLowerCase();
            final newState = extractedState.toLowerCase();
            if (currentState.isEmpty ||
                !currentState.contains(newState) &&
                    !newState.contains(currentState)) {
              stateController.text = extractedState;
            }
          }
        }

        // Update country if found
        if (addressDetails['country'] != null) {
          final extractedCountry = addressDetails['country']?.toString() ?? '';
          if (extractedCountry.isNotEmpty) {
            final currentCountry = countryController.text.trim().toLowerCase();
            final newCountry = extractedCountry.toLowerCase();
            if (currentCountry.isEmpty ||
                !currentCountry.contains(newCountry) &&
                    !newCountry.contains(currentCountry)) {
              countryController.text = extractedCountry;
            }
          }
        }

        // Update pincode if found
        if (addressDetails['pincode'] != null) {
          final extractedPincode = addressDetails['pincode']?.toString() ?? '';
          if (extractedPincode.isNotEmpty &&
              pincodeController.text.trim().isEmpty) {
            pincodeController.text = extractedPincode;
          }
        }

        // Also update city if a more accurate name was found
        if (addressDetails['city'] != null) {
          final extractedCity = addressDetails['city']?.toString() ?? '';
          if (extractedCity.isNotEmpty &&
              extractedCity.toLowerCase() !=
                  cityController.text.trim().toLowerCase()) {
            // Only update if the extracted city is more specific or matches better
            final currentCity = cityController.text.trim().toLowerCase();
            final newCity = extractedCity.toLowerCase();
            if (!currentCity.contains(newCity) &&
                newCity.contains(currentCity)) {
              cityController.text = extractedCity;
            }
          }
        }
      }
    } catch (e) {
      // Silently fail - don't show error for autofill
      print('Failed to autofill contact address: $e');
    } finally {
      isFetchingCoordinates.value = false;
    }
  }

  /// Autofetch coordinates and address when birth city changes
  Future<void> onBirthCityChanged() async {
    if (birthCityController.text.trim().isEmpty) {
      birthLatitudeController.clear();
      birthLongitudeController.clear();
      birthTimezoneController.clear();
      birthStateController.clear();
      return;
    }

    try {
      isFetchingCoordinates.value = true;
      final addressDetails = await AddressHelper.fetchAddressDetails(
        city: birthCityController.text.trim(),
        state: birthStateController.text.trim().isNotEmpty
            ? birthStateController.text.trim()
            : null,
        country: birthCountryController.text.trim().isNotEmpty
            ? birthCountryController.text.trim()
            : null,
      );

      if (addressDetails != null) {
        // Always update coordinates and timezone - these are critical
        birthLatitudeController.text =
            addressDetails['latitude']?.toString() ?? '';
        birthLongitudeController.text =
            addressDetails['longitude']?.toString() ?? '';
        birthTimezoneController.text =
            addressDetails['timezone']?.toString() ?? '';

        // Update state if found and more accurate
        if (addressDetails['state'] != null) {
          final extractedState = addressDetails['state']?.toString() ?? '';
          if (extractedState.isNotEmpty) {
            final currentState = birthStateController.text.trim().toLowerCase();
            final newState = extractedState.toLowerCase();
            // Update if empty or if the extracted state is more specific
            if (currentState.isEmpty ||
                (!currentState.contains(newState) &&
                    newState.contains(currentState))) {
              birthStateController.text = extractedState;
            }
          }
        }

        // Update country if found and more accurate
        if (addressDetails['country'] != null) {
          final extractedCountry = addressDetails['country']?.toString() ?? '';
          if (extractedCountry.isNotEmpty) {
            final currentCountry = birthCountryController.text
                .trim()
                .toLowerCase();
            final newCountry = extractedCountry.toLowerCase();
            if (currentCountry.isEmpty ||
                (!currentCountry.contains(newCountry) &&
                    newCountry.contains(currentCountry))) {
              birthCountryController.text = extractedCountry;
            }
          }
        }

        // Update city if a more accurate name was found
        if (addressDetails['city'] != null) {
          final extractedCity = addressDetails['city']?.toString() ?? '';
          if (extractedCity.isNotEmpty &&
              extractedCity.toLowerCase() !=
                  birthCityController.text.trim().toLowerCase()) {
            final currentCity = birthCityController.text.trim().toLowerCase();
            final newCity = extractedCity.toLowerCase();
            // Only update if extracted city is more specific
            if (!currentCity.contains(newCity) &&
                newCity.contains(currentCity)) {
              birthCityController.text = extractedCity;
            }
          }
        }
      }
    } catch (e) {
      // Show error only if critical fields failed
      showErrorMessage(
        title: 'Address',
        message:
            'Failed to fetch address details. Please verify and enter coordinates manually.',
      );
    } finally {
      isFetchingCoordinates.value = false;
    }
  }

  Future<bool> updateProfile() async {
    // Use userId from login data, or fallback to profile (from GET profile response)
    final effectiveUserId = userId ?? profile.value?.userId;
    if (effectiveUserId == null || effectiveUserId.isEmpty) {
      showErrorMessage(
        title: 'Profile',
        message: 'User ID not found. Please log in again.',
      );
      return false;
    }

    try {
      isUpdatingProfile.value = true;

      // Format dateOfBirth for API (personalInfo expects yyyy-MM-dd)
      String? dateOfBirthStr;
      if (selectedBirthDate.value != null) {
        dateOfBirthStr = DateFormat(
          'yyyy-MM-dd',
        ).format(selectedBirthDate.value!);
      } else if (profile.value?.birthChart?.generatedAt != null) {
        dateOfBirthStr = _formatDateToISO(
          profile.value!.birthChart!.generatedAt!,
        );
      }

      // Prepare PersonalInfo (API expects fullName, dateOfBirth, gender, maritalStatus, occupation)
      final personalInfo = PersonalInfo(
        fullName: fullNameController.text.trim().isNotEmpty
            ? fullNameController.text.trim()
            : null,
        dateOfBirth: dateOfBirthStr,
        gender: selectedGender.value?.isNotEmpty == true
            ? selectedGender.value
            : (genderController.text.trim().isNotEmpty
                  ? genderController.text.trim()
                  : null),
        maritalStatus: selectedMaritalStatus.value?.isNotEmpty == true
            ? selectedMaritalStatus.value
            : (maritalStatusController.text.trim().isNotEmpty
                  ? maritalStatusController.text.trim()
                  : null),
        occupation: occupationController.text.trim().isNotEmpty
            ? occupationController.text.trim()
            : null,
      );

      // Prepare ContactInfo
      final contactInfo = ContactInfo(
        alternatePhone: alternatePhoneController.text.trim().isNotEmpty
            ? alternatePhoneController.text.trim()
            : null,
        address:
            (cityController.text.trim().isNotEmpty ||
                stateController.text.trim().isNotEmpty ||
                pincodeController.text.trim().isNotEmpty)
            ? Address(
                city: cityController.text.trim().isNotEmpty
                    ? cityController.text.trim()
                    : null,
                state: stateController.text.trim().isNotEmpty
                    ? stateController.text.trim()
                    : null,
                country: countryController.text.trim().isNotEmpty
                    ? countryController.text.trim()
                    : null,
                pincode: pincodeController.text.trim().isNotEmpty
                    ? pincodeController.text.trim()
                    : null,
              )
            : null,
      );

      // Prepare Preferences
      final preferences = Preferences(
        language: languageController.text.trim().isNotEmpty
            ? languageController.text.trim()
            : null,
        notificationSettings: NotificationSettings(
          email: emailNotificationController.value,
          sms: smsNotificationController.value,
          push: pushNotificationController.value,
          whatsapp: whatsappNotificationController.value,
        ),
        interests: interestsController.isNotEmpty
            ? interestsController.toList()
            : null,
      );

      // Call PATCH API to update profile (with empty birthChart)
      final profileUpdated = await _profileService.updateProfile(
        userId: effectiveUserId,
        profilePicture: profilePicture.value,
        personalInfo: personalInfo,
        contactInfo: contactInfo,
        preferences: preferences,
      );

      if (profileUpdated == null) {
        showErrorMessage(title: 'Profile', message: 'Failed to update profile');
        return false;
      }

      // Prepare BirthChart data if provided
      bool shouldUpdateBirthChart =
          birthCityController.text.trim().isNotEmpty ||
          birthHourController.text.trim().isNotEmpty;

      if (shouldUpdateBirthChart) {
        // Parse coordinates
        double? latitude = birthLatitudeController.text.trim().isNotEmpty
            ? double.tryParse(birthLatitudeController.text.trim())
            : null;
        double? longitude = birthLongitudeController.text.trim().isNotEmpty
            ? double.tryParse(birthLongitudeController.text.trim())
            : null;

        // Parse birth time
        int? hour = birthHourController.text.trim().isNotEmpty
            ? int.tryParse(birthHourController.text.trim())
            : null;
        int? minute = birthMinuteController.text.trim().isNotEmpty
            ? int.tryParse(birthMinuteController.text.trim())
            : null;
        int? second = birthSecondController.text.trim().isNotEmpty
            ? int.tryParse(birthSecondController.text.trim())
            : null;

        final birthPlace = BirthPlace(
          city: birthCityController.text.trim().isNotEmpty
              ? birthCityController.text.trim()
              : null,
          state: birthStateController.text.trim().isNotEmpty
              ? birthStateController.text.trim()
              : null,
          country: birthCountryController.text.trim().isNotEmpty
              ? birthCountryController.text.trim()
              : null,
          latitude: latitude,
          longitude: longitude,
          timezone: birthTimezoneController.text.trim().isNotEmpty
              ? birthTimezoneController.text.trim()
              : null,
        );

        final birthTime = BirthTime(hour: hour, minute: minute, second: second);

        // Extract and format dateOfBirth from selected date or profile
        String? dateOfBirth;
        if (selectedBirthDate.value != null) {
          dateOfBirth = DateFormat(
            'yyyy-MM-dd',
          ).format(selectedBirthDate.value!);
        } else if (profile.value?.birthChart?.generatedAt != null) {
          dateOfBirth = _formatDateToISO(
            profile.value!.birthChart!.generatedAt!,
          );
        }

        if (dateOfBirth == null || dateOfBirth.isEmpty) {
          showErrorMessage(
            title: 'Birth Chart',
            message: 'Please enter date of birth to update birth chart.',
          );
          await loadProfile();
          showSuccessMessage(
            title: 'Profile',
            message: 'Profile updated successfully',
          );
          return true;
        }

        // Backend requires age between 13 and 120 years; skip birth chart update if invalid
        if (!_isValidBirthDateForChart(dateOfBirth)) {
          showErrorMessage(
            title: 'Birth Chart',
            message:
                'Age must be between 13 and 120 years. Birth chart was not updated.',
          );
          await loadProfile();
          showSuccessMessage(
            title: 'Profile',
            message: 'Profile updated successfully',
          );
          return true;
        }

        // Call PUT API to update birth chart
        final birthChartUpdated = await _profileService.updateBirthChart(
          userId: effectiveUserId,
          birthPlace: birthPlace,
          birthTime: birthTime,
          dateOfBirth: dateOfBirth,
        );

        if (birthChartUpdated == null) {
          showErrorMessage(
            title: 'Birth Chart',
            message: 'Profile updated but birth chart update failed',
          );
          // Still return true since profile was updated
          return true;
        }
      }

      // Reload profile to get updated data
      await loadProfile();

      showSuccessMessage(
        title: 'Profile',
        message: 'Profile updated successfully',
      );
      return true;
    } catch (e) {
      // Filter out "account has been deactivated" message
      String errorMessage = e.toString();
      if (errorMessage.toLowerCase().contains('account has been deactivated')) {
        errorMessage = 'An error occurred. Please try again.';
      }
      showErrorMessage(title: 'Profile', message: errorMessage);
      return false;
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  /// Returns true if dateOfBirth (yyyy-MM-dd) is valid for birth chart API: not in future, age 13â€“120.
  bool _isValidBirthDateForChart(String dateOfBirthStr) {
    final birth = DateTime.tryParse(dateOfBirthStr);
    if (birth == null) return false;
    final now = DateTime.now();
    if (birth.isAfter(now)) return false;
    int age = now.year - birth.year;
    if (birth.month > now.month ||
        (birth.month == now.month && birth.day > now.day)) {
      age--;
    }
    return age >= 13 && age <= 120;
  }

  /// Format date to ISO format (yyyy-MM-dd)
  /// Handles both DD/MM/YYYY and ISO formats
  String? _formatDateToISO(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;

    try {
      // Try parsing as ISO date first
      final isoDate = DateTime.tryParse(dateStr);
      if (isoDate != null) {
        return '${isoDate.year.toString().padLeft(4, '0')}-${isoDate.month.toString().padLeft(2, '0')}-${isoDate.day.toString().padLeft(2, '0')}';
      }

      // Try parsing as DD/MM/YYYY
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
        }
      }
    } catch (e) {
      // Return default if parsing fails
    }

    return '1990-01-15'; // Default date as per requirement
  }

  /// Select birth date
  Future<void> selectBirthDate() async {
    final pickedDate = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate:
          selectedBirthDate.value ??
          DateTime.now().subtract(Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );
    if (pickedDate != null) {
      selectedBirthDate.value = pickedDate;
      birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  /// Select birth time (same as kundli time picker)
  Future<void> selectBirthTime() async {
    final hour = int.tryParse(birthHourController.text.trim()) ?? 12;
    final minute = int.tryParse(birthMinuteController.text.trim()) ?? 0;
    final pickedTime = await TimePickerHelper.showTimePicker12h(
      Get.context!,
      initialTime: TimeOfDay(
        hour: hour.clamp(0, 23),
        minute: minute.clamp(0, 59),
      ),
    );
    if (pickedTime != null) {
      birthHourController.text = pickedTime.hour.toString();
      birthMinuteController.text = pickedTime.minute.toString();
      birthSecondController.text = '0';
    }
  }

  /// Called when user selects birth place from location bottom sheet (city, state, country);
  /// fills controllers and fetches lat/long/timezone.
  Future<void> onBirthPlaceSelectedFromSheet(
    String city,
    String? state,
    String? country,
  ) async {
    birthCityController.text = city;
    birthStateController.text = state ?? '';
    birthCountryController.text = country ?? 'India';
    await onBirthCityChanged();
  }

  /// Set profile picture
  void setProfilePicture(File? file) {
    profilePicture.value = file;
    if (file != null) {
      profileImageUrl.value = '';
    }
  }

  void onCouponsTap() {
    Get.toNamed(AppRoutes.coupons);
  }

  void onHelpCenterTap() {
    Get.snackbar(
      'Support',
      'Help Center integration is coming soon.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onAddressesTap() {
    Get.toNamed(AppRoutes.addresses);
  }

  void onFollowingTap() {
    Get.toNamed(AppRoutes.followingAstrologers);
  }

  Future<void> onLogoutTap({bool allDevices = false}) async {
    final result =
        await Get.dialog<String?>(
          AlertDialog(
            title: const AutoTranslateText('Sign out'),
            content: const AutoTranslateText(
              'Choose how you would like to logout.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: null),
                child: const AutoTranslateText('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: 'all'),
                child: const AutoTranslateText('Logout all devices'),
              ),
              TextButton(
                onPressed: () => Get.back(result: 'single'),
                child: const AutoTranslateText('Logout'),
              ),
            ],
          ),
        ) ??
        null;

    if (result == null) return;

    final logoutAll = result == 'all';
    await _authService.logout(logoutFromAllDevices: logoutAll);
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM yyyy Â· hh:mm a').format(date);
    } catch (_) {
      return '';
    }
  }

  String get userInitials {
    final name = userName.value.trim();
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = parts[1].isNotEmpty ? parts[1][0] : '';
    final combined = '$first$second'.toUpperCase();
    return combined.isNotEmpty ? combined : name[0].toUpperCase();
  }
}

