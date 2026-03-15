import 'dart:async';
import 'package:astrobharataiuser/content_moderation/moderation_helper.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/services/chat_balance_monitor.dart';
import 'package:astrobharataiuser/core/services/chat_minimize_manager.dart';
import 'package:astrobharataiuser/core/services/insufficient_wallet_exception.dart';
import 'package:astrobharataiuser/data_model/chat_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';
import 'package:astrobharataiuser/screens/chat/services/chat_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/widgets/wallet_recharge_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends BaseController {
  final ChatService _chatService = ChatService();
  final AiChatService _aiChatService = AiChatService();
  final PersonaModel persona;
  final UserProfileModel? chatProfile;
  final String? preferredLanguage;
  final Map<String, dynamic>? restoreState;

  final ChatBalanceMonitor _balanceMonitor = ChatBalanceMonitor();

  ChatController({
    required this.persona,
    this.chatProfile,
    this.preferredLanguage,
    this.restoreState,
  });

  // Messages
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  // Current conversation
  final RxString conversationId = ''.obs;
  final RxString displayedMessage = ''.obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoading = false.obs;

  // AutoTranslateText editing
  final TextEditingController messageController = TextEditingController();
  final RxString messageText = ''.obs; // Reactive variable for text field

  // Timer for typing animation
  Timer? _typingTimer;

  // Profile message tracking
  bool _profileMessageSent = false;

  // Topic selection
  final RxString selectedTopic = ''.obs;
  final RxBool showTopicChips = false.obs;

  // Pricing from voice-persona endpoint (visible to user)
  final RxDouble chatPricePerMinute = 0.0.obs;
  final RxDouble callPricePerMinute = 0.0.obs;

  // Listener function reference
  void _onMessageTextChanged() {
    messageText.value = messageController.text;
  }

  // Select a topic
  void selectTopic(String topic) {
    selectedTopic.value = topic;
    // Pre-fill the message input
    messageController.text = 'I want to know about $topic';
    messageText.value = messageController.text;
  }

  @override
  void onInit() {
    super.onInit();
    messageController.addListener(_onMessageTextChanged);
    _applyRestoreState();
  }

  void _applyRestoreState() {
    if (restoreState == null) return;
    final convId = restoreState!['conversationId']?.toString();
    final msgs = restoreState!['messages'] as List<dynamic>?;
    if (convId != null && convId.isNotEmpty) conversationId.value = convId;
    if (msgs != null && msgs.isNotEmpty) {
      messages.value = msgs
          .map((m) => ChatMessage(
                id: (m['id'] ?? '').toString(),
                role: (m['role'] ?? 'user').toString(),
                content: (m['content'] ?? '').toString(),
                timestamp: m['timestamp'] != null
                    ? DateTime.tryParse(m['timestamp'].toString()) ?? DateTime.now()
                    : DateTime.now(),
                tokenCount: (m['tokenCount'] as num?)?.toInt(),
              ))
          .toList();
    }
  }

  @override
  void onReady() {
    super.onReady();
    _loadPricing();
    if (conversationId.value.isEmpty && chatProfile != null) {
      _sendProfileMessageIfNeeded();
    } else if (conversationId.value.isNotEmpty && chatPricePerMinute.value > 0) {
      _startBalanceMonitor();
    }
  }

  void _startBalanceMonitor() {
    _balanceMonitor.start(
      chatPricePerMinute: chatPricePerMinute.value,
      onLowBalanceWarning: () {
        showInfoMessage(
          message: 'Your wallet balance is running low. Please recharge within 3 minutes to continue.',
        );
      },
      onBalanceDepleted: () {
        _balanceMonitor.stop();
        showErrorMessage(
          message: 'Insufficient balance. Chat ended. Please recharge to continue.',
        );
        if (Get.isRegistered<ChatMinimizeManager>()) {
          Get.find<ChatMinimizeManager>().endChat();
        }
        UserMainController.popCurrentTab();
      },
    );
  }

  /// Fetch Persona AI pricing from user-service for display
  Future<void> _loadPricing() async {
    try {
      final pricing = await _aiChatService.getPersonaPricing(persona.id);
      if (pricing != null) {
        chatPricePerMinute.value = pricing.effectiveChatPricePerMinute;
        callPricePerMinute.value = pricing.effectiveCallPricePerMinute;
      } else {
        chatPricePerMinute.value = persona.chatPricePerMinute ?? persona.pricePerMin ?? 0;
        callPricePerMinute.value = persona.callPricePerMinute ?? 0;
      }
    } catch (_) {
      chatPricePerMinute.value = persona.chatPricePerMinute ?? persona.pricePerMin ?? 0;
      callPricePerMinute.value = persona.callPricePerMinute ?? 0;
    }
  }

  @override
  void onClose() {
    _balanceMonitor.stop();
    _typingTimer?.cancel();
    messageController.removeListener(_onMessageTextChanged);
    messageController.dispose();
    super.onClose();
  }

  /// Load conversation history if conversationId exists
  Future<void> loadConversation(String conversationId) async {
    try {
      isLoading.value = true;
      final conversation = await _chatService.getConversation(
        persona.id,
        conversationId,
      );

      this.conversationId.value = conversation.id;
      messages.value = conversation.messages;

      // Display the last assistant message with typing animation if it exists
      final lastMessage = conversation.messages.lastOrNull;
      if (lastMessage != null && lastMessage.role == 'assistant') {
        // Temporarily remove last message, animate it, then add back
        final lastContent = lastMessage.content;
        messages.removeLast();
        await _animateMessage(lastContent);
        messages.add(lastMessage);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load conversation');
    } finally {
      isLoading.value = false;
    }
  }

  /// Send a message
  Future<void> sendMessage() async {
    final messageText = messageController.text.trim();
    if (messageText.isEmpty || isLoading.value || isTyping.value) return;

    // Content moderation: block abusive words, phone numbers, and links
    final moderationHelper = ModerationHelper(minWordLength: 2);
    final blocked = moderationHelper.getBlockedContentResult(messageText);
    if (blocked.blocked) {
      Get.snackbar('Not allowed', blocked.userMessage);
      return;
    }

    try {
      // Add user message immediately
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'user',
        content: messageText,
        timestamp: DateTime.now(),
      );
      messages.add(userMessage);
      messageController.clear();
      // Hide topic chips after user sends a message
      showTopicChips.value = false;
      selectedTopic.value = '';

      isLoading.value = true;
      // STEP 2 — OPEN RAZORPAY CHECKOUTI
      // On first message, don't send conversationId (it will be null/empty)
      // After first message, use the conversationId from the response
      // Only send profile data for the first message (when conversationId is empty)
      final response = await _chatService.sendMessage(
        persona.id,
        messageText,
        conversationId.value.isEmpty ? null : conversationId.value,
        userProfile: conversationId.value.isEmpty ? chatProfile : null,
        preferredLanguage: conversationId.value.isEmpty
            ? preferredLanguage
            : null,
      );

      // Update conversation ID - use the real conversationId from response for subsequent messages
      if (response.conversationId.isNotEmpty) {
        conversationId.value = response.conversationId;
        if (chatPricePerMinute.value > 0) _startBalanceMonitor();
      }

      // Create assistant message placeholder (will be added after animation)
      final assistantMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: response.response,
        timestamp: DateTime.now(),
      );

      // Don't add to messages yet - animate first
      // Animate the assistant response character by character
      await _animateMessage(response.response);

      // Add the full message to the list after animation completes
      messages.add(assistantMessage);

      // Clear displayed message after adding to list
      await Future.delayed(const Duration(milliseconds: 100));
      displayedMessage.value = '';
    } catch (e) {
      // Remove the user message if error occurred
      if (messages.isNotEmpty && messages.last.role == 'user') {
        messages.removeLast();
      }
      Get.snackbar('Error', 'Failed to send message. Please try again.');
    } finally {
      isLoading.value = false;
      displayedMessage.value = '';
      isTyping.value = false;
    }
  }

  /// Animate message character by character with delay
  Future<void> _animateMessage(String fullMessage) async {
    isTyping.value = true;
    displayedMessage.value = '';

    int charIndex = 0;

    while (charIndex < fullMessage.length) {
      // Check if we're at a double newline
      if (charIndex + 1 < fullMessage.length &&
          fullMessage[charIndex] == '\n' &&
          fullMessage[charIndex + 1] == '\n') {
        displayedMessage.value += '\n\n';
        charIndex += 2;
        await Future.delayed(const Duration(milliseconds: 50));
        continue;
      }
      // Check if we're at a single newline
      if (fullMessage[charIndex] == '\n') {
        displayedMessage.value += '\n';
        charIndex++;
        await Future.delayed(const Duration(milliseconds: 30));
        continue;
      }

      // Add character
      displayedMessage.value += fullMessage[charIndex];
      charIndex++;

      // Delay between characters (adjust for typing speed)
      // Using 20ms for smoother, more visible typing effect
      await Future.delayed(const Duration(milliseconds: 20));
    }
    // Keep typing state for a brief moment before clearing
    await Future.delayed(const Duration(milliseconds: 200));
    isTyping.value = false;
  }

  /// Delete conversation
  Future<void> deleteConversation() async {
    if (conversationId.value.isEmpty) {
      // Just clear messages if no conversation exists
      messages.clear();
      displayedMessage.value = '';
      return;
    }

    try {
      isLoading.value = true;
      final success = await _chatService.deleteConversation(
        persona.id,
        conversationId.value,
      );

      if (success) {
        conversationId.value = '';
        messages.clear();
        displayedMessage.value = '';
        Get.snackbar('Success', 'Conversation deleted');
        Get.back();
      } else {
        Get.snackbar('Error', 'Failed to delete conversation');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete conversation');
    } finally {
      isLoading.value = false;
    }
  }

  /// Format timestamp for display
  String formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format time string for message (convert 24h to 12h with AM/PM)
  String _formatTimeForMessage(String time24h) {
    try {
      final parts = time24h.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        return '$hour12:$minute $period';
      }
    } catch (e) {
      // If parsing fails, return original
    }
    return time24h;
  }

  /// Send profile message automatically when chat starts
  Future<void> _sendProfileMessageIfNeeded() async {
    if (_profileMessageSent ||
        chatProfile == null ||
        conversationId.value.isNotEmpty)
      return;
    _profileMessageSent = true;

    try {
      // Format profile details message (same format as astrologer chat)
      final name = chatProfile!.personalInfo?.fullName ?? 'User';
      // Correct mapping from ChatProfileDialog: DOB is in generatedAt
      final dob = chatProfile!.birthChart?.generatedAt ?? '';

      final birthTime = chatProfile!.birthChart?.birthTime;
      final tob = birthTime != null
          ? '${birthTime.hour.toString().padLeft(2, '0')}:${birthTime.minute.toString().padLeft(2, '0')}:${(birthTime.second ?? 0).toString().padLeft(2, '0')}'
          : '';

      final birthPlace = chatProfile!.birthChart?.birthPlace;
      final pob = [
        birthPlace?.city,
        birthPlace?.state,
        birthPlace?.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      // Format message to match the image: "Hello! I am seeking your guidance." + "My Details:" with bullet points
      final messageContent =
          'Hello! I am seeking your guidance.\n\n'
          'My Details:\n'
          '• Name: $name\n'
          '• Date of Birth: $dob\n'
          '• Time of Birth: ${tob.isNotEmpty ? _formatTimeForMessage(tob) : 'Not provided'}\n'
          '• Place of Birth: ${pob.isNotEmpty ? pob : 'Not provided'}';

      // Send the profile message with profile context
      // The chat service will automatically prepend the profile context to the message
      final response = await _chatService.sendMessage(
        persona.id,
        messageContent,
        null, // No conversationId for first message
        userProfile: chatProfile,
        preferredLanguage: preferredLanguage,
      );

      // Update conversation ID from response
      if (response.conversationId.isNotEmpty) {
        conversationId.value = response.conversationId;
      }

      // Add user message (profile details) to the list
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'user',
        content: messageContent,
        timestamp: DateTime.now(),
      );
      messages.add(userMessage);

      // Create assistant message and animate it
      final assistantMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: 'assistant',
        content: response.response,
        timestamp: DateTime.now(),
      );

      // Animate the assistant response
      await _animateMessage(response.response);

      // Add the full message to the list after animation completes
      messages.add(assistantMessage);

      // Show topic chips after AI's first response
      showTopicChips.value = true;

      // Clear displayed message after adding to list
      await Future.delayed(const Duration(milliseconds: 100));
      displayedMessage.value = '';
    } catch (e) {
      // Reset flag on error so it can be retried
      _profileMessageSent = false;
      if (Get.isSnackbarOpen == false) {
        Get.snackbar(
          'Error',
          'Failed to send profile message. Please try again.',
        );
      }
    }
  }
}
