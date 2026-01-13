import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/chat_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/chat/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends BaseController {
  final ChatService _chatService = ChatService();
  
  final PersonaModel persona;
  final UserProfileModel? chatProfile;
  final String? preferredLanguage;
  ChatController({
    required this.persona,
    this.chatProfile,
    this.preferredLanguage,
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
  
  // Listener function reference
  void _onMessageTextChanged() {
    messageText.value = messageController.text;
  }
  
  @override
  void onInit() {
    super.onInit();
    // Listen to text field changes
    messageController.addListener(_onMessageTextChanged);
    // Load conversation if conversationId exists
  }

  @override
  void onClose() {
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

      isLoading.value = true;

      // Send message to API
      // On first message, don't send conversationId (it will be null/empty)
      // After first message, use the conversationId from the response
      final response = await _chatService.sendMessage(
        persona.id,
        messageText,
        conversationId.value.isEmpty ? null : conversationId.value,
        userProfile: chatProfile,
        preferredLanguage: preferredLanguage,
      );

      // Update conversation ID - use the real conversationId from response for subsequent messages
      if (response.conversationId.isNotEmpty) {
        conversationId.value = response.conversationId;
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
}

