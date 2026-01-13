import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class GlobalChatController extends GetxController {
  final AstrologerChatService _chatService = AstrologerChatService();
  final AstrologerService _astrologerService = AstrologerService();

  // Active session being tracked for the banner
  final Rx<AstrologerChatSession?> activeSession = Rx<AstrologerChatSession?>(
    null,
  );

  // Flag to hide banner when on chat screen
  final RxBool isChatScreenOpen = false.obs;

  // Banner visibility logic
  bool get showBanner => activeSession.value != null && !isChatScreenOpen.value;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    // Periodically check for active sessions as a fallback
    _startPeriodicCheck();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _startPeriodicCheck() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      updateActiveSession();
    });
    // Initial check
    updateActiveSession();
  }

  /// Fetches current active sessions and picks the most recently active one
  Future<void> updateActiveSession() async {
    try {
      if (UserData().accessToken == null || UserData().accessToken!.isEmpty)
        return;

      final sessions = await _chatService.getActiveSessions();
      if (sessions.isNotEmpty) {
        // Priority: Most recently started session
        sessions.sort((a, b) {
          final dateA = a.startedAt ?? a.createdAt;
          final dateB = b.startedAt ?? b.createdAt;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateB.compareTo(dateA);
        });

        final latestSession = sessions.first;

        // If it's a new session or status changed, update
        if (activeSession.value?.chatId != latestSession.chatId ||
            activeSession.value?.status != latestSession.status) {
          activeSession.value = latestSession;
        }
      } else {
        activeSession.value = null;
      }
    } catch (e) {
      if (kDebugMode) print('GlobalChatController Error: $e');
    }
  }

  /// Called when user enters the chat screen
  void setChatScreenStatus(bool isOpen) {
    // Avoid setState() during build by using microtask
    Future.microtask(() {
      isChatScreenOpen.value = isOpen;
    });
  }

  /// Manually update active session from local controller events
  void notifySessionUpdate(AstrologerChatSession session) {
    if (session.status == 'ACTIVE') {
      activeSession.value = session;
    } else {
      activeSession.value = null;
    }
  }

  /// Called when a session is ended locally
  void notifySessionEnded(String astrologerId) async {
    activeSession.value = null;

    // Check if we should show follow popup
    try {
      final status = await _astrologerService.getFollowStatus(astrologerId);
      final bool isFollowing = status?['isFollowing'] ?? false;

      if (!isFollowing && !isChatScreenOpen.value) {
        // Trigger follow popup logic here if needed globally,
        // or let the Dashboard handle it if they just exited.
        // For now, we rely on the specific screen's end logic,
        // but this controller can facilitate it if the app is minimized.
      }
    } catch (e) {
      if (kDebugMode) print('Follow Status Check Error: $e');
    }
  }

  /// Navigate to the active chat
  /// Simply passes chatId - the controller will handle fetching astrologer by ID from session
  /// This reuses the same logic as when chat is initialized from other places
  Future<void> resumeActiveChat() async {
    final session = activeSession.value;
    if (session == null || session.chatId.isEmpty) {
      if (kDebugMode) print('⚠️ [GlobalChat] No active session or chatId available');
      return;
    }

    if (kDebugMode) {
      print('✅ [GlobalChat] Navigating to chat with chatId: ${session.chatId}');
      print('✅ [GlobalChat] Controller will fetch astrologer using session.astrologerId');
    }

    // Just pass chatId - the controller already handles fetching astrologer by ID
    // This is the same approach as when chat is initialized from other places
    Get.toNamed(
      AppRoutes.astrologerChat,
      arguments: {'chatId': session.chatId},
    );
  }
}
