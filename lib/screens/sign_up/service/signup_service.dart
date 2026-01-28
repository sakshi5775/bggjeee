import 'dart:convert';

import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/signup_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../apihelper/api_provider/end_points.dart';

class SignUpService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  Future<SignUpModel?> register({
    required String phone,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
    required String userType,
  }) async {
    try {
      // Registration doesn't require authentication
      final response = await _apiRepository.postApi(
        EndPoints.register,
        {
          'phone': phone,
          'email': email,
          'username': username,
          'password': password,
          'confirmPassword': confirmPassword,
          'userType': userType,
        },
        useAuthHeader: false, // Registration doesn't require auth
      );

      // Debug logging
      if (kDebugMode) {
        print('Registration Response Status: ${response.statusCode}');
        print('Registration Response Body Type: ${response.body.runtimeType}');
        print('Registration Response Body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          try {
            // Handle both Map and String response bodies
            Map<String, dynamic> jsonData;
            if (response.body is Map) {
              jsonData = response.body as Map<String, dynamic>;
            } else if (response.body is String) {
              // Try to parse string as JSON
              jsonData = json.decode(response.body as String) as Map<String, dynamic>;
            } else {
              showErrorMessage(
                title: "Registration Failed",
                message: "Invalid response format from server.",
              );
              return null;
            }

            final signUpModel = SignUpModel.fromJson(jsonData);
            
            // Verify success - registration now returns OTP info instead of tokens
            if (signUpModel.success == true && signUpModel.user != null) {
              return signUpModel;
            } else {
              showErrorMessage(
                title: "Registration Failed",
                message: signUpModel.message ?? "Registration was not successful. Please try again.",
              );
              return null;
            }
          } catch (e) {
            if (kDebugMode) {
              print('Error parsing registration response: $e');
            }
            showErrorMessage(
              title: "Registration Failed",
              message: "Failed to parse server response. Please try again.",
            );
            return null;
          }
        } else {
          showErrorMessage(
            title: "Registration Failed",
            message: "Invalid response from server. Please try again.",
          );
          return null;
        }
      } else {
        // Try to extract error message from response
        String errorMessage = "Failed to create account. Please try again.";
        if (response.body != null) {
          try {
            Map<String, dynamic>? bodyMap;
            if (response.body is Map) {
              bodyMap = response.body as Map<String, dynamic>;
            } else if (response.body is String) {
              bodyMap = json.decode(response.body as String) as Map<String, dynamic>;
            }
            
            if (bodyMap != null) {
              // Check for specific validation errors
              if (bodyMap['errors'] != null && bodyMap['errors'] is List) {
                final errors = bodyMap['errors'] as List;
                if (errors.isNotEmpty) {
                  final firstError = errors.first;
                  if (firstError is Map) {
                    // Extract the validation message
                    final fieldMessage = firstError['message']?.toString() ?? 
                                       firstError['msg']?.toString();
                    if (fieldMessage != null && fieldMessage.isNotEmpty) {
                      errorMessage = fieldMessage;
                    } else {
                      // Fallback to field name if message is not available
                      final field = firstError['field']?.toString();
                      if (field != null) {
                        errorMessage = "Invalid $field. Please check and try again.";
                      }
                    }
                  } else if (firstError is String) {
                    errorMessage = firstError;
                  }
                }
              } else {
                // Check for duplicate data errors
                final message = bodyMap['message']?.toString() ?? '';
                if (message.toLowerCase().contains('email') && 
                    (message.toLowerCase().contains('already') || 
                     message.toLowerCase().contains('exists') ||
                     message.toLowerCase().contains('duplicate'))) {
                  errorMessage = "This email is already registered. Please use a different email or try logging in.";
                } else if (message.toLowerCase().contains('username') && 
                          (message.toLowerCase().contains('already') || 
                           message.toLowerCase().contains('exists') ||
                           message.toLowerCase().contains('duplicate'))) {
                  errorMessage = "This username is already taken. Please choose a different username.";
                } else if (message.toLowerCase().contains('phone') && 
                          (message.toLowerCase().contains('already') || 
                           message.toLowerCase().contains('exists') ||
                           message.toLowerCase().contains('duplicate'))) {
                  errorMessage = "This phone number is already registered. Please use a different phone number or try logging in.";
                } else {
                  errorMessage = message.isNotEmpty ? message : 
                                bodyMap['error']?.toString() ?? 
                                errorMessage;
                }
              }
            }
          } catch (_) {}
        }
        showErrorMessage(
          title: "Registration Failed",
          message: errorMessage,
        );
        return null;
      }
    } catch (e, stackTrace) {
      // Enhanced error logging
      if (kDebugMode) {
        print('Registration Error: $e');
        print('Stack Trace: $stackTrace');
      }
      
      // Extract more specific error message based on error type
      String errorMessage = "An error occurred during registration. Please try again.";
      final errorStr = e.toString().toLowerCase();
      
      // Internet/Network errors
      if (errorStr.contains("no internet connection") || 
          errorStr.contains("network connection error") ||
          errorStr.contains("cannot reach server") ||
          errorStr.contains("failed host lookup") ||
          errorStr.contains("name resolution")) {
        errorMessage = "No internet connection. Please check your network and try again.";
      } 
      // Timeout errors
      else if (errorStr.contains("timeout") || errorStr.contains("timed out")) {
        errorMessage = "Request timed out. Please check your connection and try again.";
      } 
      // Server/Response errors
      else if (errorStr.contains("invalid response") || 
               errorStr.contains("bad response format") ||
               errorStr.contains("server error")) {
        errorMessage = "Server error occurred. Please try again later.";
      }
      // Duplicate data errors (from API response)
      else if (errorStr.contains("email") && 
               (errorStr.contains("already") || errorStr.contains("exists") || errorStr.contains("duplicate"))) {
        errorMessage = "This email is already registered. Please use a different email or try logging in.";
      } 
      else if (errorStr.contains("username") && 
               (errorStr.contains("already") || errorStr.contains("exists") || errorStr.contains("duplicate"))) {
        errorMessage = "This username is already taken. Please choose a different username.";
      } 
      else if (errorStr.contains("phone") && 
               (errorStr.contains("already") || errorStr.contains("exists") || errorStr.contains("duplicate"))) {
        errorMessage = "This phone number is already registered. Please use a different phone number or try logging in.";
      }
      // Validation errors
      else if (errorStr.contains("validation") || errorStr.contains("invalid")) {
        // Try to extract specific validation message
        try {
          final parts = errorStr.split("message");
          if (parts.length > 1) {
            final afterMessage = parts[1];
            final colonIndex = afterMessage.indexOf(':');
            if (colonIndex != -1 && colonIndex < afterMessage.length - 1) {
              final valuePart = afterMessage.substring(colonIndex + 1).trim();
              String cleaned = valuePart;
              if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
                cleaned = cleaned.substring(1, cleaned.length - 1);
              } else if (cleaned.startsWith("'") && cleaned.endsWith("'")) {
                cleaned = cleaned.substring(1, cleaned.length - 1);
              }
              if (cleaned.isNotEmpty) {
                errorMessage = cleaned.split(',').first.trim();
              }
            }
          }
        } catch (_) {
          errorMessage = "Invalid data provided. Please check your information and try again.";
        }
      }
      // Generic error with message extraction
      else if (errorStr.contains("message")) {
        try {
          final parts = errorStr.split("message");
          if (parts.length > 1) {
            final afterMessage = parts[1];
            final colonIndex = afterMessage.indexOf(':');
            if (colonIndex != -1 && colonIndex < afterMessage.length - 1) {
              final valuePart = afterMessage.substring(colonIndex + 1).trim();
              String cleaned = valuePart;
              if (cleaned.startsWith('"') && cleaned.endsWith('"')) {
                cleaned = cleaned.substring(1, cleaned.length - 1);
              } else if (cleaned.startsWith("'") && cleaned.endsWith("'")) {
                cleaned = cleaned.substring(1, cleaned.length - 1);
              }
              if (cleaned.isNotEmpty) {
                errorMessage = cleaned.split(',').first.trim();
              }
            }
          }
        } catch (_) {
          // If extraction fails, use default message
        }
      }
      
      showErrorMessage(
        title: "Error",
        message: errorMessage,
      );
      return null;
    }
  }
}
