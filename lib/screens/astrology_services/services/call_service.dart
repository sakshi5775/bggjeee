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
    int?
    durationMinutes, // OPTIONAL - only for UI estimate, not used for billing
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

  /// Connect a call (Triggers billing start)
  ///
  /// [callId] - The ID of the call to connect
  Future<bool> connectCall(String callId) async {
    try {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📞 CALL CONNECT INITIATED: $callId');
        print('═══════════════════════════════════════════════════════════');
      }

      final response = await _apiRepository.postApi(
        EndPoints.callConnect(callId),
        {},
        useAuthHeader: true,
      );

      if (kDebugMode) {
        print('Connect call API response status: ${response.statusCode}');
        print('Connect call API response body: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error connecting call: $e');
      return false;
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
            print(
              '═══════════════════════════════════════════════════════════',
            );
            print('❌ CRITICAL: Backend ignored totalMinutes parameter!');
            print('   Sent: $totalMinutes, Received: $backendTotalMinutes');
            print(
              '   This indicates backend billing is NOT implemented for calls!',
            );
            print(
              '═══════════════════════════════════════════════════════════',
            );
          }

          if (totalAmount != null) {
            final expectedAmount = totalAmount.toInt();
            if (backendTotalAmount != expectedAmount) {
              print(
                '═══════════════════════════════════════════════════════════',
              );
              print('❌ CRITICAL: Backend amount mismatch!');
              print('   Sent: ₹$totalAmount, Received: ₹$backendTotalAmount');
              print('   Backend is NOT processing billing parameters!');
              print('   This means wallet is NOT being deducted on backend!');
              print(
                '═══════════════════════════════════════════════════════════',
              );
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

  /// Get call history
  Future<Map<String, dynamic>> getCallHistory({
    int page = 1,
    int limit = 20,
    String? callType,
    String? status,
  }) async {
    try {
      final query = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (callType != null && callType.isNotEmpty) {
        query['callType'] = callType;
      }
      if (status != null && status.isNotEmpty) {
        query['status'] = status;
      }

      final response = await _apiRepository.getApi(
        EndPoints.callHistory,
        query: query,
        useAuthHeader: true,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          'HTTP ${response.statusCode}: Failed to get call history',
        );
      }

      final body = response.body;
      if (body == null || body['success'] != true) {
        return {'sessions': <CallHistoryItem>[], 'pagination': null};
      }

      final data = body;
      List<dynamic> rawList = [];
      final payload = data['data'] ?? data['calls'] ?? data['history'];

      if (payload is List) {
        rawList = payload;
      } else if (payload is Map<String, dynamic>) {
        final inner = payload['calls'] ?? payload['data'] ?? payload['list'];
        if (inner is List) {
          rawList = inner;
        }
      }

      final List<CallHistoryItem> items = [];
      for (final s in rawList) {
        try {
          if (s is Map<String, dynamic>) {
            items.add(CallHistoryItem.fromJson(s));
          }
        } catch (e) {
          if (kDebugMode) {
            print('Skip invalid call history item: $e');
          }
        }
      }

      final pagination = data['pagination'];
      return {
        'sessions': items,
        'pagination': pagination is Map<String, dynamic> ? pagination : null,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Call history API error: $e');
      }
      rethrow;
    }
  }
}
