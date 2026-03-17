import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/chat_profile_dialog.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:astrobharataiuser/services/chat_call_precheck_service.dart';
import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInitiationHelper {
  static final ChatCallPrecheckService _precheckService =
      ChatCallPrecheckService();
  static final AstrologerChatService _chatService = AstrologerChatService();
  static final ProfileCheckHelper _profileHelper = ProfileCheckHelper();

  /// Initiates the chat flow: Wallet Check -> Profile Dialog -> Start Session -> Navigation
  static Future<void> initiateChat(AstrologerModel astrologer) async {
    try {
      // 1. Check Wallet balance (Bypass profile completeness check as per user request)
      final pricePerMinute = astrologer.services.chat.pricePerMinute ??
          astrologer.chatPricePerMin ??
          astrologer.chatPrice ??
          0.0;
      final chatEnabled = astrologer.services.chat.enabled == true;
      if (!chatEnabled || pricePerMinute <= 0) {
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

      final isWalletSufficient = await _precheckService.checkBeforeProceeding(
        astrologer: astrologer,
        pricePerMinute: pricePerMinute,
        estimatedMinutes: 15,
      );

      if (!isWalletSufficient) return;

      // 2. Show Persona/Chat Profile Dialog
      final context = Get.context;
      if (context == null) return;

      final existingProfile = await _profileHelper.getUserProfile();
      final profileResult = await showPersonaChatProfileDialog(
        context,
        existingProfile,
      );

      if (profileResult == null) return; // User cancelled

      // 3. Start/Check Chat Session
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFFDFB343)),
        ),
        barrierDismissible: false,
      );

      AstrologerChatSession? sessionToUse;
      try {
        final activeSessions = await _chatService.getActiveSessions();
        // Correctly find ONLY sessions matching THIS astrologer
        final matchingSessions = activeSessions.where(
          (s) => s.astrologerId == astrologer.astrologerId,
        );

        if (matchingSessions.isNotEmpty) {
          sessionToUse = matchingSessions.first;

          // If session is already ending/ended, don't reuse it
          if (sessionToUse.status == 'COMPLETED' ||
              sessionToUse.status == 'EXPIRED') {
            sessionToUse = null;
          }
        }
      } catch (e) {
        if (kDebugMode) print('Error checking active sessions: $e');
      }

      if (sessionToUse == null) {
        sessionToUse = await _chatService.startSession(astrologer.astrologerId);
      }

      // Close loader
      if (Get.isDialogOpen ?? false) Get.back();

      // 4. Navigate to Chat
      Get.toNamed(
        AppRoutes.astrologerChat,
        arguments: {
          'astrologer': astrologer,
          'chatId': sessionToUse.chatId,
          'chatProfile': profileResult.profile,
        },
      );
    } catch (e) {
      // Close loader if open
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'Failed to start chat: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
