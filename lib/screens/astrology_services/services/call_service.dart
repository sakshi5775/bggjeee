import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/data_model/call_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Exception for service not enabled error
class ServiceNotEnabledException implements Exception {
  final String message;
  final String serviceType; // "VOICE" or "VIDEO"

  ServiceNotEnabledException(this.message, this.serviceType);

  @override
  String toString() => message;
}

class CallService {
  final ApiRepository _apiRepository = Get.find(tag: 'chat');

  /// Initiate a call (voice or video) with an astrologer
  ///
  /// [astrologerId] - The ID of the astrologer to call
  /// [callType] - Either "VOICE" or "VIDEO"
  /// [durationMinutes] - Optional duration estimate (for UI display only, not used for billing)
  ///
  /// Throws [ServiceNotEnabledException] if the service is not enabled for the astrologer
  /// 
  /// Note: Billing is per-minute and handled by backend. durationMinutes is for UI estimate only.
  Future<CallInitiateResponse?> initiateCall({
    required String astrologerId,
    required String callType, // "VOICE" or "VIDEO"
    int? durationMinutes, // OPTIONAL - only for UI estimate, not used for billing
  }) async {
    try {
      final body = {
        'astrologerId': astrologerId,
        'callType': callType,
        if (durationMinutes != null) 'durationMinutes': durationMinutes,
      };

      final response = await _apiRepository.postApi(
        EndPoints.callInitiate,
        body,
        useAuthHeader: true, // Requires authentication
      );

      final data = response.body;

      // Check if request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return CallInitiateResponse.fromJson(data);
        }
      }

      // Handle error responses - extract message from response body
      final errorMessage =
          data['message'] as String? ?? 'Failed to initiate call';

      if (errorMessage.toLowerCase().contains('not enabled') ||
          errorMessage.toLowerCase().contains('service is not enabled')) {
        throw ServiceNotEnabledException(errorMessage, callType);
      }

      throw Exception(errorMessage);
    } on ServiceNotEnabledException {
      rethrow;
    } catch (e) {
      debugPrint('Error initiating call: $e');

      // Re-throw if it's already a ServiceNotEnabledException
      if (e is ServiceNotEnabledException) {
        rethrow;
      }

      // Try to extract message from exception string
      final errorString = e.toString();

      // Check if the error message contains service not enabled
      if (errorString.toLowerCase().contains('not enabled') ||
          errorString.toLowerCase().contains('service is not enabled')) {
        // Extract the actual message from the error string
        String message = errorString;
        // Remove the exception prefix if present
        if (message.contains('Error During Communication: ')) {
          message = message.replaceAll('Error During Communication: ', '');
        }
        if (message.contains('Error: ')) {
          message = message.replaceAll('Error: ', '');
        }
        throw ServiceNotEnabledException(message, callType);
      }

      return null;
    }
  }


  /// End a call
  ///
  /// [callId] - The ID of the call to end
  /// [totalMinutes] - The actual duration of the call in minutes (for billing)
  /// [totalAmount] - The total amount to deduct (calculated as totalMinutes * pricePerMinute)
  Future<bool> endCall({
    required String callId,
    int? totalMinutes,
    double? totalAmount,
  }) async {
    try {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📞 Ending call with billing parameters');
        print('   CallId: $callId');
        print('   Total Minutes: $totalMinutes');
        print('   Total Amount: $totalAmount');
        print('═══════════════════════════════════════════════════════════');
      }
      
      final body = <String, dynamic>{};
      
      // Include billing parameters if provided
      if (totalMinutes != null) {
        body['totalMinutes'] = totalMinutes;
      }
      if (totalAmount != null) {
        body['totalAmount'] = totalAmount;
      }
      
      final response = await _apiRepository.postApi(
        EndPoints.callEnd(callId),
        body,
        useAuthHeader: true, // Requires authentication
      );

      if (kDebugMode) {
        print('End call API response status: ${response.statusCode}');
        print('End call API response body: ${response.body}');
        
        // Check if backend processed our billing parameters
        final responseData = response.body['data'];
        if (responseData != null) {
          final backendTotalMinutes = responseData['totalMinutes'];
          final backendTotalAmount = responseData['totalAmount'];
          
          if (totalMinutes != null && backendTotalMinutes == null) {
            print('═══════════════════════════════════════════════════════════');
            print('❌ CRITICAL: Backend ignored totalMinutes parameter!');
            print('   Sent: $totalMinutes, Received: $backendTotalMinutes');
            print('   This indicates backend billing is NOT implemented for calls!');
            print('═══════════════════════════════════════════════════════════');
          }
          
          if (totalAmount != null) {
            final expectedAmount = totalAmount.toInt();
            if (backendTotalAmount != expectedAmount) {
              print('═══════════════════════════════════════════════════════════');
              print('❌ CRITICAL: Backend amount mismatch!');
              print('   Sent: ₹$totalAmount, Received: ₹$backendTotalAmount');
              print('   Backend is NOT processing billing parameters!');
              print('   This means wallet is NOT being deducted on backend!');
              print('═══════════════════════════════════════════════════════════');
            }
          }
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error ending call: $e');
      return false;
    }
  }
}
