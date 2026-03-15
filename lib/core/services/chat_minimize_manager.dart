import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/astrologer_model.dart';
import 'package:astrobharataiuser/data_model/chat_model.dart';
import 'package:astrobharataiuser/data_model/persona_model.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Manages chat minimize/expand and floating bubble for both Persona AI and real astrologer chat.
/// Chat persists until user/astrologer ends it or app is killed from RAM.
class ChatMinimizeManager extends GetxController with WidgetsBindingObserver {
  final RxBool isMinimized = false.obs;
  final RxString chatType = 'persona'.obs; // 'persona' | 'astrologer'
  final RxString displayName = ''.obs;
  final RxString imageUrl = ''.obs;

  PersonaModel? _persona;
  AstrologerModel? _astrologer;
  UserProfileModel? _chatProfile;
  String? _preferredLanguage;
  String _conversationId = '';
  List<ChatMessage> _messages = [];
  Map<String, dynamic>? _astrologerRestoreState;

  Object? get _routeArgs {
    if (chatType.value == 'persona' && _persona != null) {
      return {
        'persona': _persona,
        'chatProfile': _chatProfile,
        'languageCode': _preferredLanguage,
        'restoreState': {
          'conversationId': _conversationId,
          'messages': _messages
              .map((m) => {
                    'id': m.id,
                    'role': m.role,
                    'content': m.content,
                    'timestamp': m.timestamp.toIso8601String(),
                    'tokenCount': m.tokenCount,
                  })
              .toList(),
        },
      };
    }
    if (chatType.value == 'astrologer' && _astrologer != null) {
      final chatId = _astrologerRestoreState?['chatId']?.toString();
      return {
        'astrologer': _astrologer,
        if (chatId != null && chatId.isNotEmpty) 'chatId': chatId,
      };
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      onAppResumed();
    }
  }

  /// Call when app goes to background - minimize chat if on chat screen.
  /// Views should register and call this via a static/callback.
  void onAppPaused() {
    // Actual minimize is triggered by views that register lifecycle
  }

  void onAppResumed() {}

  /// Minimize Persona AI chat
  void minimizePersonaChat({
    required PersonaModel persona,
    UserProfileModel? chatProfile,
    String? preferredLanguage,
    required String conversationId,
    required List<ChatMessage> messages,
  }) {
    _persona = persona;
    _astrologer = null;
    _chatProfile = chatProfile;
    _preferredLanguage = preferredLanguage;
    _conversationId = conversationId;
    _messages = List.from(messages);
    _astrologerRestoreState = null;
    chatType.value = 'persona';
    displayName.value = persona.displayName;
    imageUrl.value = persona.image ?? '';
    _doMinimize(AppRoutes.personaChat);
  }

  /// Minimize Astrologer chat
  void minimizeAstrologerChat({
    required AstrologerModel astrologer,
    required Map<String, dynamic> restoreState,
  }) {
    _astrologer = astrologer;
    _persona = null;
    _chatProfile = null;
    _preferredLanguage = null;
    _conversationId = '';
    _messages = [];
    _astrologerRestoreState = Map<String, dynamic>.from(restoreState);
    chatType.value = 'astrologer';
    displayName.value = astrologer.displayName;
    imageUrl.value = astrologer.profilePicture ?? '';
    _doMinimize(AppRoutes.astrologerChat);
  }

  void _doMinimize(String route) {
    isMinimized.value = true;
    UserMainController.popCurrentTab();
  }

  /// Expand chat - push the chat route again
  void expandChat() {
    if (!isMinimized.value) return;
    final args = _routeArgs;
    if (args == null) {
      clearMinimized();
      return;
    }
    final r = chatType.value == 'persona' ? AppRoutes.personaChat : AppRoutes.astrologerChat;
    UserMainController.pushInCurrentTab(r, arguments: args);
    isMinimized.value = false;
  }

  /// End chat - clear minimized state
  void endChat() {
    clearMinimized();
  }

  void clearMinimized() {
    isMinimized.value = false;
    chatType.value = 'persona';
    displayName.value = '';
    imageUrl.value = '';
    _persona = null;
    _astrologer = null;
    _chatProfile = null;
    _conversationId = '';
    _messages = [];
    _astrologerRestoreState = null;
  }

  bool get hasMinimizedChat => isMinimized.value && _routeArgs != null;
}
