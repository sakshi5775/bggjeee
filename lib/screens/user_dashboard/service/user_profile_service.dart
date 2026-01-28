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
  /// Uses the new auth/profile endpoint which doesn't require userId
  Future<UserProfileModel?> getProfile([String? userId]) async {
    try {
      // Use new auth/profile endpoint (doesn't require userId in path)
      final response = await _apiRepository.getApi(
        EndPoints.profile,
      );

      if (response.body['success'] == true &&
          response.body['data'] is Map<String, dynamic>) {
        return UserProfileModel.fromJson(
            response.body['data'] as Map<String, dynamic>);
      }
      showErrorMessage(
        title: 'Profile',
        message:
            response.body['message']?.toString() ?? 'Failed to load profile',
      );
    } catch (e) {
      showErrorMessage(title: 'Profile', message: e.toString());
    }
    return null;
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
    try {
      // Prepare fields for multipart/form-data
      final fields = <String, String>{};

      // Add personalInfo as JSON string if provided
      if (personalInfo != null) {
        fields['personalInfo'] = jsonEncode(personalInfo.toJson());
      }

      // Add contactInfo as JSON string if provided
      // Exclude protected fields (email and phone) as they can only be updated through auth service
      if (contactInfo != null) {
        fields['contactInfo'] = jsonEncode(contactInfo.toJson(excludeProtectedFields: true));
      }

      // Add preferences as JSON string if provided
      if (preferences != null) {
        fields['preferences'] = jsonEncode(preferences.toJson());
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['success'] == true &&
            decoded['data'] is Map<String, dynamic>) {
          return UserProfileModel.fromJson(
              decoded['data'] as Map<String, dynamic>);
        }
        showErrorMessage(
          title: 'Profile',
          message: decoded['message']?.toString() ?? 'Profile update failed',
        );
      } else {
        final decoded = jsonDecode(response.body);
        final message = decoded is Map<String, dynamic>
            ? decoded['message']?.toString()
            : 'Profile update failed';
        showErrorMessage(
            title: 'Profile', message: message ?? 'Profile update failed');
      }
    } catch (e) {
      showErrorMessage(title: 'Profile', message: e.toString());
    }
    return null;
  }

  /// Update birth chart (PUT with application/json)
  Future<UserProfileModel?> updateBirthChart({
    required String userId,
    required BirthPlace birthPlace,
    required BirthTime birthTime,
    String? dateOfBirth,
  }) async {
    try {
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
        // The response contains birth chart data, but we can parse it
        final data = response.body['data'] as Map<String, dynamic>;
        // Return a partial UserProfileModel with birthChart updated
        final profile = UserProfileModel();
        profile.birthChart = BirthChart.fromJson(data);
        return profile;
      }
      showErrorMessage(
        title: 'Birth Chart',
        message: response.body['message']?.toString() ??
            'Failed to update birth chart',
      );
    } catch (e) {
      showErrorMessage(title: 'Birth Chart', message: e.toString());
    }
    return null;
  }
}

