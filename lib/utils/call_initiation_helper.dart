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

    final chatRate = astrologer.services.chat.pricePerMinute ??
        astrologer.chatPricePerMin ??
        astrologer.chatPrice ??
        0.0;
    final chatEnabled = astrologer.services.chat.enabled == true;
    if (!chatEnabled || chatRate <= 0) {
      Get.snackbar(
        'Service Not Available',
        '${astrologer.displayName} is not available for chat service right now.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      pricePerMinute: chatRate,
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
    final chargeText = '₹${chatRate.toStringAsFixed(0)}/min';
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

    final voiceRate = astrologer.services.voice.pricePerMinute ??
        astrologer.voicePricePerMin ??
        0.0;
    final voiceEnabled = astrologer.services.voice.enabled == true;
    if (!voiceEnabled || voiceRate <= 0) {
      Get.snackbar(
        'Service Not Available',
        '${astrologer.displayName} is not available for voice call service right now.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      pricePerMinute: voiceRate,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final chargeText = '₹${voiceRate.toStringAsFixed(0)}/min';

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

    final videoRate = astrologer.services.video.pricePerMinute ??
        astrologer.videoPricePerMin ??
        0.0;
    final videoEnabled = astrologer.services.video.enabled == true;
    if (!videoEnabled || videoRate <= 0) {
      Get.snackbar(
        'Service Not Available',
        '${astrologer.displayName} is not available for video call service right now.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      pricePerMinute: videoRate,
      estimatedMinutes: 15,
    );
    if (!canProceed) return;

    final chargeText = '₹${videoRate.toStringAsFixed(0)}/min';

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
