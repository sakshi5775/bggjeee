import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart'
    show ServiceNotEnabledException;
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/chat_profile_dialog.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/services/chat_call_precheck_service.dart';

/// Helper class to initiate voice/video/chat calls directly without booking screen
class CallInitiationHelper {
  static final CallService _callService = CallService();
  static final AstrologerChatService _chatService = AstrologerChatService();
  static final ProfileCheckHelper _profileHelper = ProfileCheckHelper();
  static final ChatCallPrecheckService _precheckService =
      ChatCallPrecheckService();

  /// Initiate chat directly (bypasses booking screen)
  static Future<void> initiateChat(AstrologerModel astrologer) async {
    final context = Get.context;
    if (context == null) return;

    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final existingProfile = await _profileHelper.getUserProfile();
    final profileResult = await showPersonaChatProfileDialog(
      context,
      existingProfile,
    );

    if (profileResult == null) {
      return;
    }

    // Show charges confirmation: "Astrologer has these charges, do you want to proceed?"
    final chatPrice = astrologer.chatPricePerMin ?? astrologer.chatPrice ?? 0.0;
    final chargeText = chatPrice > 0
        ? '₹${chatPrice.toStringAsFixed(0)}/min'
        : 'As per plan';
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Chat charges'),
        content: Text(
          '${astrologer.displayName} charges $chargeText for chat. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDFB343),
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Proceed'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed != true) {
      return;
    }

    try {
      // Direct start/check session
      AstrologerChatSession? sessionToUse;

      try {
        final activeSessions = await _chatService.getActiveSessions();
        if (activeSessions.isNotEmpty) {
          // Find matching astrologer or use first valid
          sessionToUse = activeSessions.firstWhere(
            (s) => s.astrologerId == astrologer.astrologerId,
            orElse: () => activeSessions.first,
          );

          if (sessionToUse.status == 'COMPLETED' ||
              sessionToUse.status == 'EXPIRED') {
            sessionToUse = null; // Discard invalid
          }
        }
      } catch (e) {
        if (kDebugMode) print('Error checking active sessions: $e');
      }

      if (sessionToUse == null) {
        // Start new session
        sessionToUse = await _chatService.startSession(astrologer.astrologerId);
      }

      // Navigate to chat
      Get.toNamed(
        AppRoutes.astrologerChat,
        arguments: {
          'astrologer': astrologer,
          'chatId': sessionToUse.chatId,
          'chatProfile': profileResult.profile,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start chat session: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Initiate voice call directly (bypasses booking screen)
  static Future<void> initiateVoiceCall(AstrologerModel astrologer) async {
    final context = Get.context;
    if (context == null) return;

    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final pricePerMin = astrologer.voicePricePerMin ?? 0.0;
    final chargeText = pricePerMin > 0
        ? '₹${pricePerMin.toStringAsFixed(0)}/min'
        : 'As per plan';

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Voice call charges'),
        content: Text(
          '${astrologer.displayName} charges $chargeText for voice call. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDFB343),
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Proceed'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed != true) return;

    try {
      final response = await _callService.initiateCall(
        astrologerId: astrologer.astrologerId,
        callType: 'VOICE',
        durationMinutes: null,
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

      final walletBalance = response.data!.walletBalance ?? 0.0;
      final availableMinutes = response.data!.availableMinutes ?? 0;
      final pricePerMinute = response.data!.pricePerMinute;

      if (walletBalance < pricePerMinute || availableMinutes < 1) {
        await Get.dialog(
          WalletRechargeDialog(
            currentBalance: walletBalance,
            requiredBalance: pricePerMinute,
            astrologerName: astrologer.displayName,
          ),
          barrierDismissible: false,
        );
        return;
      }

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
    final context = Get.context;
    if (context == null) return;

    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final pricePerMin = astrologer.videoPricePerMin ?? 0.0;
    final chargeText = pricePerMin > 0
        ? '₹${pricePerMin.toStringAsFixed(0)}/min'
        : 'As per plan';

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Video call charges'),
        content: Text(
          '${astrologer.displayName} charges $chargeText for video call. Do you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDFB343),
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Proceed'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed != true) return;

    try {
      final response = await _callService.initiateCall(
        astrologerId: astrologer.astrologerId,
        callType: 'VIDEO',
        durationMinutes: null,
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

      final walletBalance = response.data!.walletBalance ?? 0.0;
      final availableMinutes = response.data!.availableMinutes ?? 0;
      final pricePerMinute = response.data!.pricePerMinute;

      if (walletBalance < pricePerMinute || availableMinutes < 1) {
        await Get.dialog(
          WalletRechargeDialog(
            currentBalance: walletBalance,
            requiredBalance: pricePerMinute,
            astrologerName: astrologer.displayName,
          ),
          barrierDismissible: false,
        );
        return;
      }

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
