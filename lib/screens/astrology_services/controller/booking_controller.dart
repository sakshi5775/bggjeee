import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/astrologer_chat_model.dart';
import 'package:astrobharataiuser/services/chat_call_precheck_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/call_service.dart'
    show ServiceNotEnabledException;
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_chat_service.dart';

import 'package:astrobharataiuser/utils/profile_check_helper.dart';
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/ai_chat/widgets/chat_profile_dialog.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/core/services/analytics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum CallType { chat, voice, video }

class BookingController extends GetxController {
  late AstrologerModel astrologer;
  late CallType callType;
  final ChatCallPrecheckService _precheckService = ChatCallPrecheckService();
  final CallService _callService = CallService();
  final AstrologerChatService _chatService = AstrologerChatService();
  final ProfileCheckHelper _profileHelper = ProfileCheckHelper();
  final RxDouble walletBalance = 0.0.obs;
  final RxBool isLoadingWallet = false.obs;

  // Time slot selection
  final RxString selectedTimeSlot = 'Start Now'.obs;
  final List<String> timeSlots = [
    'Start Now',
    'In 30 minutes',
    'In 1 hour',
    'In 2 hours',
  ];

  // Duration selection - for chat, these map to package types: 15MIN, 30MIN, 60MIN
  final RxInt selectedDuration = 15.obs; // in minutes
  final List<int> durations = [
    15,
    30,
    60,
  ]; // Chat package types: 15MIN, 30MIN, 60MIN

  // Payment method selection
  final RxString selectedPaymentMethod = 'Wallet'.obs;
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Wallet',
      'icon': Icons.account_balance_wallet,
      'color': const Color(0xFFDFB343),
      'balance': '₹2450',
    },
    {
      'name': 'UPI',
      'icon': Icons.phone_android,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'color': const Color(0xFF5D1C21),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Get astrologer and call type from arguments
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      astrologer = args['astrologer'] as AstrologerModel;
      callType = args['callType'] as CallType;
    } else {
      // Handle error case
      Get.back();
    }
    // Load wallet balance
    loadWalletBalance();
  }

  Future<void> loadWalletBalance() async {
    isLoadingWallet.value = true;
    try {
      final balance = await _profileHelper.getWalletBalance();
      walletBalance.value = balance;
      // Update payment method balance display
      final walletMethod = paymentMethods.firstWhere(
        (method) => method['name'] == 'Wallet',
        orElse: () => paymentMethods[0],
      );
      final index = paymentMethods.indexOf(walletMethod);
      if (index != -1) {
        paymentMethods[index]['balance'] = '₹${balance.toStringAsFixed(0)}';
      }
    } catch (e) {
      print('Error loading wallet balance: $e');
    } finally {
      isLoadingWallet.value = false;
    }
  }

  void setTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;
  }

  void setDuration(int duration) {
    selectedDuration.value = duration;
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  // Get price per minute based on call type
  double getPricePerMinute() {
    switch (callType) {
      case CallType.voice:
        return astrologer.voicePricePerMin ?? 299.0;
      case CallType.video:
        return astrologer.videoPricePerMin ?? 299.0;
      case CallType.chat:
        return astrologer.chatPrice ?? 299.0;
    }
  }

  // Calculate subtotal
  double getSubtotal() {
    return getPricePerMinute() * selectedDuration.value;
  }

  // Calculate discount (10% for first session)
  double getDiscount() {
    return getSubtotal() * 0.10;
  }

  // Calculate total
  double getTotal() {
    return getSubtotal() - getDiscount();
  }

  // Get header title based on call type
  String getHeaderTitle() {
    switch (callType) {
      case CallType.chat:
        return 'Book Chat';
      case CallType.voice:
        return 'Book Voice Call';
      case CallType.video:
        return 'Book Video Call';
    }
  }

  // Get header icon based on call type
  IconData getHeaderIcon() {
    switch (callType) {
      case CallType.chat:
        return Icons.chat_bubble_outline;
      case CallType.voice:
        return Icons.phone;
      case CallType.video:
        return Icons.videocam;
    }
  }

  // Get confirm button text
  String getConfirmButtonText() {
    switch (callType) {
      case CallType.chat:
        return 'Confirm & Start Chat';
      case CallType.voice:
        return 'Confirm & Start Voice Call';
      case CallType.video:
        return 'Confirm & Start Video Call';
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Auto-start booking flow for chat and calls (per-minute pricing - no duration selection needed)
    confirmBooking();
  }

  Future<void> confirmBooking() async {
    // Check wallet balance first for all paid actions - user cannot proceed without sufficient balance
    final canProceed = await _precheckService.checkBeforeProceeding(
      astrologer: astrologer,
      pricePerMinute: getPricePerMinute(),
      estimatedMinutes: selectedDuration.value,
    );
    if (!canProceed) return;

    // Handle chat session purchase - show profile dialog first
    if (callType == CallType.chat) {
      final context = Get.context;
      if (context == null) return;

      final existingProfile = await _profileHelper.getUserProfile();
      final profileResult = await showPersonaChatProfileDialog(
        context,
        existingProfile,
      );
      if (profileResult == null) {
        // User cancelled the dialog, so we go back from the BookingView as well
        Get.back();
        return;
      }

      // Proceed with chat booking using profile data
      await _handleChatBooking(profileResult.profile);
      return;
    }

    // For voice/video calls, initiate call API directly (per-minute billing - no duration selection)
    try {
      final callTypeString = callType == CallType.voice ? 'VOICE' : 'VIDEO';

      // Call API to initiate call - durationMinutes is optional (for UI estimate only)
      // Backend handles per-minute billing automatically
      final response = await _callService.initiateCall(
        astrologerId: astrologer.astrologerId,
        callType: callTypeString,
        durationMinutes: null, // Optional - not used for billing, just UI estimate
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

      // Wallet balance is sufficient, proceed with call
      // Pass call data to call screen
      switch (callType) {
        case CallType.voice:
          AnalyticsService().logBookService(
            serviceName: 'Voice Call',
            price: getTotal(),
          );
          Get.offNamed(
            '/astrologer-voice-call',
            arguments: {'astrologer': astrologer, 'callData': response.data},
          );
          break;
        case CallType.video:
          AnalyticsService().logBookService(
            serviceName: 'Video Call',
            price: getTotal(),
          );
          Get.offNamed(
            '/astrologer-video-call',
            arguments: {'astrologer': astrologer, 'callData': response.data},
          );
          break;
        case CallType.chat:
          // Already handled above
          break;
      }
    } on ServiceNotEnabledException catch (e) {
      // Handle service not enabled error with user-friendly message
      Get.snackbar(
        'Service Not Available',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to initiate call: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Handle chat booking - start session and navigate to chat
  Future<void> _handleChatBooking(UserProfileModel? chatProfile) async {
    try {
      // Direct start/check session
      // The service startSession now handles the "active session check" internally or via backend
      // But we can check active sessions here too if we want to be safe, adhering to the new flow:

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
        sessionToUse = await _chatService.startSession(astrologer.astrologerId);
      }

      // Log Analytics
      AnalyticsService().logBookService(
        serviceName: 'Chat Session',
        price: getTotal(),
      );

      // Navigate to chat
      Get.offNamed(
        AppRoutes.astrologerChat,
        arguments: {
          'astrologer': astrologer,
          'chatId': sessionToUse.chatId,
          'chatProfile': chatProfile,
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
}
