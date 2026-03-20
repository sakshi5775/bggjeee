import 'dart:convert';
import 'dart:io';

import 'package:astrobharataiuser/apihelper/api_provider/api_provider.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:get/get.dart';

class UserProfileService with ApiHelperMixin {
  final ApiClient _apiRepository = Get.find<ApiClient>();

  /// Get user profile
  /// Uses users/api/users/profile (Bearer token identifies current user)
  Future<UserProfileModel?> getProfile([String? userId]) async {
    // Current user profile: users/api/users/profile (no userId in path)
    final response = await _apiRepository.getApi(EndPoints.userProfileCurrent);

    if (response.body['success'] == true &&
        response.body['data'] is Map<String, dynamic>) {
      return UserProfileModel.fromJson(
        response.body['data'] as Map<String, dynamic>,
      );
    }

    throw response.body['message']?.toString() ?? 'Failed to load profile';
  }

  /// Update user profile (PATCH with multipart/form-data)
  /// Sends empty birthChart field as per API requirement
  Future<UserProfileModel?> updateProfile({
    required String userId,
    File? profilePicture,
    PersonalInfo? personalInfo,
    ContactInfo? contactInfo,
    Preferences? preferences,
  }) async {
    // Prepare fields for multipart/form-data
    final fields = <String, String>{};

    // Add personalInfo as JSON string; omit null values
    if (personalInfo != null) {
      final personalInfoMap = personalInfo.toJson();
      personalInfoMap.removeWhere((_, v) => v == null);
      fields['personalInfo'] = jsonEncode(personalInfoMap);
    }

    // Add contactInfo as JSON string
    if (contactInfo != null) {
      final contactInfoMap = contactInfo.toJson(excludeProtectedFields: true);
      contactInfoMap['address'] = contactInfo.address != null
          ? contactInfo.address!.toJson()
          : <String, dynamic>{};
      contactInfoMap.removeWhere((_, v) => v == null);
      fields['contactInfo'] = jsonEncode(contactInfoMap);
    }

    // Add preferences as JSON string
    if (preferences != null) {
      final preferencesMap = preferences.toJson();
      preferencesMap.removeWhere((_, v) => v == null);
      fields['preferences'] = jsonEncode(preferencesMap);
    }

    // Add empty birthChart as per API requirement
    fields['birthChart'] = '';

    // Prepare files
    final files = <String, File?>{};
    if (profilePicture != null) {
      files['profilePicture'] = profilePicture;
    }

    final response = await _apiRepository.patchDataByFormData(
      uri: EndPoints.updateUserProfile(userId),
      fields: fields,
      files: files,
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['success'] == true && decoded['data'] is Map<String, dynamic>) {
      return UserProfileModel.fromJson(decoded['data'] as Map<String, dynamic>);
    }

    throw decoded['message']?.toString() ?? 'Profile update failed';
  }

  /// Update birth chart (PUT with application/json)
  Future<UserProfileModel?> updateBirthChart({
    required String userId,
    required BirthPlace birthPlace,
    required BirthTime birthTime,
    String? dateOfBirth,
  }) async {
    final request = BirthChartUpdateRequest(
      birthPlace: birthPlace,
      birthTime: birthTime,
      dateOfBirth: dateOfBirth,
    );

    final response = await _apiRepository.putApi(
      EndPoints.updateBirthChart(userId),
      request.toJson(),
    );

    if (response.body['success'] == true &&
        response.body['data'] is Map<String, dynamic>) {
      // The response contains birthChart and dateOfBirth
      final data = response.body['data'] as Map<String, dynamic>;
      final birthChartData = data['birthChart'] as Map<String, dynamic>?;
      final profile = UserProfileModel();
      if (birthChartData != null) {
        profile.birthChart = BirthChart.fromJson(birthChartData);
      }
      return profile;
    }

    throw response.body['message']?.toString() ??
        'Failed to update birth chart';
  }

  /// Delete user profile (account) by email. Returns true if success.
  Future<bool> deleteProfile(String email) async {
    final response = await _apiRepository.deleteRequestWithBody(
      EndPoints.deleteUserByEmail,
      {'email': email},
      useAuthHeader: false, // endpoint is public; matches your curl
    );

    final body = response.body;
    if (body is Map<String, dynamic>) {
      return body['success'] == true;
    }
    return false;
  }
}
