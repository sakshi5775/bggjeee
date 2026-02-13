import 'dart:io';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';

class UserProfileController extends BaseController {
  final UserProfileService _service = UserProfileService();

  // Profile data
  final profile = Rxn<UserProfileModel>();
  final isLoading = false.obs;
  final isUpdating = false.obs;

  // Personal Info
  final fullNameController = TextEditingController();
  final genderController = TextEditingController();
  final maritalStatusController = TextEditingController();
  final occupationController = TextEditingController();
  final profilePicture = Rxn<File>();
  final profilePictureUrl = ''.obs;

  // Contact Info
  final alternatePhoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController(text: 'India');

  // Birth Chart
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

  // Preferences
  final languageController = TextEditingController();
  final emailNotificationController = true.obs;
  final smsNotificationController = false.obs;
  final pushNotificationController = true.obs;
  final whatsappNotificationController = false.obs;
  final interestsController = <String>[].obs;

  String? get userId => UserData().getLoginData.user?.userId;

  @override
  void onInit() {
    super.onInit();
    if (userId != null) {
      loadProfile();
    }
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

  /// Load user profile
  Future<void> loadProfile() async {
    if (userId == null) return;

    await runWithLoading(
      () async {
        final loadedProfile = await _service.getProfile(userId!);
        if (loadedProfile != null) {
          profile.value = loadedProfile;
          _populateFieldsFromProfile(loadedProfile);
        }
      },
      showBusy: true, // Show global loader for profile load
      showError: true,
    );
  }

  /// Populate form fields from profile data
  void _populateFieldsFromProfile(UserProfileModel profile) {
    // Personal Info
    if (profile.personalInfo != null) {
      fullNameController.text = profile.personalInfo!.fullName ?? '';
      genderController.text = profile.personalInfo!.gender ?? '';
      maritalStatusController.text = profile.personalInfo!.maritalStatus ?? '';
      occupationController.text = profile.personalInfo!.occupation ?? '';
      profilePictureUrl.value = profile.personalInfo!.profilePicture ?? '';
    }

    // Contact Info
    if (profile.contactInfo != null) {
      alternatePhoneController.text = profile.contactInfo!.alternatePhone ?? '';
      if (profile.contactInfo!.address != null) {
        cityController.text = profile.contactInfo!.address!.city ?? '';
        stateController.text = profile.contactInfo!.address!.state ?? '';
        pincodeController.text = profile.contactInfo!.address!.pincode ?? '';
        countryController.text =
            profile.contactInfo!.address!.country ?? 'India';
      }
    }

    // Birth Chart - Populate birth date from generatedAt
    if (profile.birthChart != null && profile.birthChart!.generatedAt != null) {
      final dateStr = profile.birthChart!.generatedAt!;
      try {
        // Try parsing as ISO date first
        final isoDate = DateTime.tryParse(dateStr);
        if (isoDate != null) {
          selectedBirthDate.value = isoDate;
          birthDateController.text = DateFormat('dd/MM/yyyy').format(isoDate);
        } else {
          // Try parsing as DD/MM/YYYY
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

    if (profile.birthChart != null && profile.birthChart!.birthPlace != null) {
      final birthPlace = profile.birthChart!.birthPlace!;
      birthCityController.text = birthPlace.city ?? '';
      birthStateController.text = birthPlace.state ?? '';
      birthCountryController.text = birthPlace.country ?? 'India';
      birthLatitudeController.text = birthPlace.latitude?.toString() ?? '';
      birthLongitudeController.text = birthPlace.longitude?.toString() ?? '';
      birthTimezoneController.text = birthPlace.timezone ?? '';
    }

    if (profile.birthChart != null && profile.birthChart!.birthTime != null) {
      final birthTime = profile.birthChart!.birthTime!;
      birthHourController.text = birthTime.hour?.toString() ?? '';
      birthMinuteController.text = birthTime.minute?.toString() ?? '';
      birthSecondController.text = birthTime.second?.toString() ?? '';
    }

    // Preferences
    if (profile.preferences != null) {
      languageController.text = profile.preferences!.language ?? '';
      if (profile.preferences!.notificationSettings != null) {
        emailNotificationController.value =
            profile.preferences!.notificationSettings!.email ?? false;
        smsNotificationController.value =
            profile.preferences!.notificationSettings!.sms ?? false;
        pushNotificationController.value =
            profile.preferences!.notificationSettings!.push ?? false;
        whatsappNotificationController.value =
            profile.preferences!.notificationSettings!.whatsapp ?? false;
      }
      interestsController.value = List<String>.from(
        profile.preferences!.interests ?? [],
      );
    }
  }

  /// Autofetch coordinates when birth city changes
  Future<void> onBirthCityChanged() async {
    if (birthCityController.text.trim().isEmpty) {
      birthLatitudeController.clear();
      birthLongitudeController.clear();
      birthTimezoneController.clear();
      return;
    }

    await runWithLoading(
      () async {
        isFetchingCoordinates.value = true;
        final addressDetails = await AddressHelper.fetchAddressDetails(
          city: birthCityController.text.trim(),
          state: birthStateController.text.trim().isNotEmpty
              ? birthStateController.text.trim()
              : null,
          country: birthCountryController.text.trim().isNotEmpty
              ? birthCountryController.text.trim()
              : 'India',
        );

        if (addressDetails != null) {
          birthLatitudeController.text =
              addressDetails['latitude']?.toString() ?? '';
          birthLongitudeController.text =
              addressDetails['longitude']?.toString() ?? '';
          birthTimezoneController.text =
              addressDetails['timezone']?.toString() ?? '';

          // Optionally update state and country if found
          if (addressDetails['state'] != null &&
              birthStateController.text.isEmpty) {
            birthStateController.text =
                addressDetails['state']?.toString() ?? '';
          }
          if (addressDetails['country'] != null &&
              birthCountryController.text.isEmpty) {
            birthCountryController.text =
                addressDetails['country']?.toString() ?? '';
          }
        }
      },
      showBusy: false, // Don't show global loader for coordinate fetch
      showError: true,
    );
    isFetchingCoordinates.value = false;
  }

  /// Autofetch coordinates for contact address city
  Future<void> onCityChanged() async {
    // Similar implementation for contact address if needed
    // For now, we'll focus on birth chart city autofetch
  }

  /// Update profile - calls both PATCH and PUT APIs
  Future<bool> updateProfile() async {
    if (userId == null) {
      showErrorMessage(title: 'Profile', message: 'User ID not found');
      return false;
    }

    return await runWithLoading(
          () async {
            // Prepare PersonalInfo
            final personalInfo = PersonalInfo(
              fullName: fullNameController.text.trim().isNotEmpty
                  ? fullNameController.text.trim()
                  : null,
              gender: genderController.text.trim().isNotEmpty
                  ? genderController.text.trim()
                  : null,
              maritalStatus: maritalStatusController.text.trim().isNotEmpty
                  ? maritalStatusController.text.trim()
                  : null,
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

            // Call PATCH API to update profile
            final profileUpdated = await _service.updateProfile(
              userId: userId!,
              profilePicture: profilePicture.value,
              personalInfo: personalInfo,
              contactInfo: contactInfo,
              preferences: preferences,
            );

            if (profileUpdated == null) {
              throw 'Failed to update profile';
            }

            // Prepare BirthChart data if provided
            bool shouldUpdateBirthChart =
                birthCityController.text.trim().isNotEmpty ||
                birthHourController.text.trim().isNotEmpty;

            if (shouldUpdateBirthChart) {
              double? latitude = birthLatitudeController.text.trim().isNotEmpty
                  ? double.tryParse(birthLatitudeController.text.trim())
                  : null;
              double? longitude =
                  birthLongitudeController.text.trim().isNotEmpty
                  ? double.tryParse(birthLongitudeController.text.trim())
                  : null;

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

              final birthTime = BirthTime(
                hour: hour,
                minute: minute,
                second: second,
              );

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

              final birthChartUpdated = await _service.updateBirthChart(
                userId: userId!,
                birthPlace: birthPlace,
                birthTime: birthTime,
                dateOfBirth: dateOfBirth,
              );

              if (birthChartUpdated == null) {
                // Log warning but continue as profile was updated
                debugPrint('Profiling updated but birth chart update failed');
              }
            }

            // Reload profile
            await loadProfile();
            return true;
          },
          showBusy: true,
          successMessage: 'Profile updated successfully',
        ) ??
        false;
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

  /// Set profile picture
  void setProfilePicture(File? file) {
    profilePicture.value = file;
    if (file != null) {
      // Clear the URL when a new file is selected
      profilePictureUrl.value = '';
    }
  }
}
