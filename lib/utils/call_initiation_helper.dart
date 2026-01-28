import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart' show ServiceNotEnabledException;
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Helper class to initiate voice/video calls directly without booking screen
class CallInitiationHelper {
  static final CallService _callService = CallService();

  /// Initiate voice call directly (bypasses booking screen)
  static Future<void> initiateVoiceCall(AstrologerModel astrologer) async {
    try {
      // Call API to initiate call - durationMinutes is optional (not used for billing)
      // Backend handles per-minute billing automatically
      final response = await _callService.initiateCall(
        astrologerId: astrologer.astrologerId,
        callType: 'VOICE',
        durationMinutes: null, // Optional - backend handles per-minute billing
      );

      if (response == null || !response.success || response.data == null) {
        Get.snackbar(
          'Error',
          response?.message ?? 'Failed to initiate call',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Check wallet balance using availableMinutes from response
      final walletBalance = response.data!.walletBalance ?? 0.0;
      final availableMinutes = response.data!.availableMinutes ?? 0;
      final pricePerMinute = response.data!.pricePerMinute;

      // Check if user has at least 1 minute worth of balance
      if (walletBalance < pricePerMinute || availableMinutes < 1) {
        // Show wallet recharge dialog
        await Get.dialog(
          WalletRechargeDialog(
            currentBalance: walletBalance,
            requiredBalance: pricePerMinute, // Minimum needed for 1 minute
            astrologerName: astrologer.displayName,
          ),
          barrierDismissible: false,
        );
        // User may have recharged, try again
        await initiateVoiceCall(astrologer);
        return;
      }

      // Wallet balance is sufficient, proceed with call
      Get.offNamed(
        '/astrologer-voice-call',
        arguments: {'astrologer': astrologer, 'callData': response.data},
      );
    } on ServiceNotEnabledException catch (e) {
      Get.snackbar(
        'Service Not Available',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      if (kDebugMode) print('Error initiating voice call: $e');
      Get.snackbar(
        'Error',
        'Failed to initiate call: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Initiate video call directly (bypasses booking screen)
  static Future<void> initiateVideoCall(AstrologerModel astrologer) async {
    try {
      // Call API to initiate call - durationMinutes is optional (not used for billing)
      // Backend handles per-minute billing automatically
      final response = await _callService.initiateCall(
        astrologerId: astrologer.astrologerId,
        callType: 'VIDEO',
        durationMinutes: null, // Optional - backend handles per-minute billing
      );

      if (response == null || !response.success || response.data == null) {
        Get.snackbar(
          'Error',
          response?.message ?? 'Failed to initiate call',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Check wallet balance using availableMinutes from response
      final walletBalance = response.data!.walletBalance ?? 0.0;
      final availableMinutes = response.data!.availableMinutes ?? 0;
      final pricePerMinute = response.data!.pricePerMinute;

      // Check if user has at least 1 minute worth of balance
      if (walletBalance < pricePerMinute || availableMinutes < 1) {
        // Show wallet recharge dialog
        await Get.dialog(
          WalletRechargeDialog(
            currentBalance: walletBalance,
            requiredBalance: pricePerMinute, // Minimum needed for 1 minute
            astrologerName: astrologer.displayName,
          ),
          barrierDismissible: false,
        );
        // User may have recharged, try again
        await initiateVideoCall(astrologer);
        return;
      }

      // Wallet balance is sufficient, proceed with call
      Get.offNamed(
        '/astrologer-video-call',
        arguments: {'astrologer': astrologer, 'callData': response.data},
      );
    } on ServiceNotEnabledException catch (e) {
      Get.snackbar(
        'Service Not Available',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      if (kDebugMode) print('Error initiating video call: $e');
      Get.snackbar(
        'Error',
        'Failed to initiate call: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
