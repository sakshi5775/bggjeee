import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/login_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OtpService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  /// Send OTP to phone or email
  Future<bool> sendOtp({
    String? phone,
    String? email,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }

      if (body.isEmpty) {
        showErrorMessage(
          title: "Error",
          message: "Please provide either phone number or email.",
        );
        return false;
      }

      final response = await _apiRepository.postApi(
        EndPoints.sendOtp,
        body,
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        String errorMessage = "Failed to send OTP. Please try again.";
        if (response.body != null && response.body is Map) {
          final body = response.body as Map<String, dynamic>;
          errorMessage = body['message']?.toString() ?? errorMessage;
        }
        showErrorMessage(title: "Error", message: errorMessage);
        return false;
      }
    } catch (e) {
      showErrorMessage(
        title: "Error",
        message: "An error occurred while sending OTP. Please try again.",
      );
      return false;
    }
  }

  /// Verify OTP and complete registration/login
  Future<LoginModel?> verifyOtp({
    required String identifier,
    required String otp,
    required String userType,
  }) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.verifyOtp,
        {
          'identifier': identifier,
          'otp': otp,
          'userType': userType,
        },
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          try {
            Map<String, dynamic> jsonData;
            if (response.body is Map) {
              jsonData = response.body as Map<String, dynamic>;
            } else {
              if (kDebugMode) {
                print('OTP Service: Invalid response body type: ${response.body.runtimeType}');
              }
              showErrorMessage(
                title: "Verification Failed",
                message: "Invalid response format from server.",
              );
              return null;
            }

            // Handle nested data structure
            if (jsonData['data'] != null && jsonData['data'] is Map) {
              final data = jsonData['data'] as Map<String, dynamic>;
              try {
                final loginModel = LoginModel.fromJson(data);
                if (kDebugMode) {
                  print('OTP Service: Successfully parsed LoginModel');
                }
                return loginModel;
              } catch (parseError) {
                if (kDebugMode) {
                  print('OTP Service: Error parsing LoginModel: $parseError');
                  print('OTP Service: Data structure: $data');
                }
                showErrorMessage(
                  title: "Verification Failed",
                  message: "Failed to parse server response. Please try again.",
                );
                return null;
              }
            } else {
              // Fallback for direct structure
              try {
                final loginModel = LoginModel.fromJson(jsonData);
                if (kDebugMode) {
                  print('OTP Service: Successfully parsed LoginModel (direct structure)');
                }
                return loginModel;
              } catch (parseError) {
                if (kDebugMode) {
                  print('OTP Service: Error parsing LoginModel (direct): $parseError');
                  print('OTP Service: JSON structure: $jsonData');
                }
                showErrorMessage(
                  title: "Verification Failed",
                  message: "Failed to parse server response. Please try again.",
                );
                return null;
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('OTP Service: Exception during parsing: $e');
            }
            showErrorMessage(
              title: "Verification Failed",
              message: "Failed to parse server response. Please try again.",
            );
            return null;
          }
        } else {
          if (kDebugMode) {
            print('OTP Service: Response body is null');
          }
          showErrorMessage(
            title: "Verification Failed",
            message: "Invalid response from server. Please try again.",
          );
          return null;
        }
      } else {
        String errorMessage = "OTP verification failed. Please try again.";
        if (response.body != null && response.body is Map) {
          final body = response.body as Map<String, dynamic>;
          errorMessage = body['message']?.toString() ?? errorMessage;
        }
        if (kDebugMode) {
          print('OTP Service: Verification failed with status ${response.statusCode}: $errorMessage');
        }
        showErrorMessage(title: "Verification Failed", message: errorMessage);
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('OTP Service: Exception in verifyOtp: $e');
      }
      // Don't show error if it's a network exception that was already handled
      if (e.toString().contains('No Internet') || e.toString().contains('timeout')) {
        // Error already shown by ApiRepository
        return null;
      }
      showErrorMessage(
        title: "Error",
        message: "An error occurred during OTP verification. Please try again.",
      );
      return null;
    }
  }

  /// Resend OTP
  Future<bool> resendOtp({
    required String identifier,
  }) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.resendOtp,
        {
          'identifier': identifier,
        },
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        String errorMessage = "Failed to resend OTP. Please try again.";
        if (response.body != null && response.body is Map) {
          final body = response.body as Map<String, dynamic>;
          errorMessage = body['message']?.toString() ?? errorMessage;
        }
        showErrorMessage(title: "Error", message: errorMessage);
        return false;
      }
    } catch (e) {
      showErrorMessage(
        title: "Error",
        message: "An error occurred while resending OTP. Please try again.",
      );
      return false;
    }
  }

  /// Check if user exists (by email or phone)
  Future<Map<String, bool>?> checkExists({
    String? email,
    String? phone,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      if (phone != null && phone.isNotEmpty) {
        body['phone'] = phone;
      }

      if (body.isEmpty) {
        showErrorMessage(
          title: "Error",
          message: "Please provide either phone number or email.",
        );
        return null;
      }

      final response = await _apiRepository.postApi(
        EndPoints.checkExists,
        body,
        useAuthHeader: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body is Map) {
          final jsonData = response.body as Map<String, dynamic>;
          if (jsonData['data'] != null && jsonData['data'] is Map) {
            final data = jsonData['data'] as Map<String, dynamic>;
            return {
              'exists': data['exists'] == true,
              'emailExists': data['emailExists'] == true,
              'phoneExists': data['phoneExists'] == true,
            };
          }
        }
      }
      return null;
    } catch (e) {
      // Don't show error for check exists - it's just a validation check
      return null;
    }
  }
}
