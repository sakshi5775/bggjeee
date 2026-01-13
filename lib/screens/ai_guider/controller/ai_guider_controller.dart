import 'dart:async';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/language_service.dart';
import 'package:astrobharataiuser/screens/ai_guider/service/ai_guider_service.dart';
import 'package:astrobharataiuser/utils/language_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';

enum AiGuiderState {
  idle,
  listening,
  thinking,
  speaking,
  interrupted,
}

class AiGuiderController extends BaseController {
  final AiGuiderService _aiGuiderService = Get.find<AiGuiderService>();

  // State management
  final Rx<AiGuiderState> currentState = AiGuiderState.idle.obs;
  final RxString userQuery = ''.obs;
  final RxString aiReply = ''.obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isListening = false.obs;
  final RxBool isSpeaking = false.obs;
  final RxString transcribedText = ''.obs;

  // Session management
  final String sessionId = const Uuid().v4();
  final List<Map<String, String>> conversationHistory = [];

  // TTS
  late FlutterTts _flutterTts;
  bool _ttsInitialized = false;
  String _currentLanguageCode = 'en';
  bool _languageExplicitlySelected = false; // Track if user explicitly selected language

  // STT
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _sttInitialized = false;
  Timer? _listeningTimer;
  bool _hasUserResponded = false; // Track if user has responded during listening

  // Welcome message
  final RxBool hasShownWelcome = false.obs;
  bool _shouldAutoStartListening = false; // Flag to auto-start mic after welcome

  @override
  void onInit() {
    super.onInit();
    // Reset welcome flag for new session
    hasShownWelcome.value = false;
    _initializeTTS();
    _initializeSTT();
    // Load current language
    _loadCurrentLanguage();
  }

  /// Load current language from service
  Future<void> _loadCurrentLanguage() async {
    try {
      final currentLang = await LanguageService.getCurrentLanguage();
      _currentLanguageCode = currentLang.code;
      // If language is loaded from service, it means user has selected it (explicitly or via app settings)
      _languageExplicitlySelected = true; // Mark as explicitly selected
      debugPrint('AI Guider: Loaded language code: $_currentLanguageCode (explicitly selected: $_languageExplicitlySelected)');
      await _updateTTSLanguage();
    } catch (e) {
      debugPrint('Error loading current language: $e');
      _currentLanguageCode = 'en';
      _languageExplicitlySelected = true; // Default to English is also explicit
    }
  }

  @override
  void onClose() {
    _stopTTS();
    _stopListening();
    _listeningTimer?.cancel();
    super.onClose();
  }

  /// Initialize TTS
  Future<void> _initializeTTS() async {
    try {
      _flutterTts = FlutterTts();
      
      // Set up error handler only (completion handler will be set per-speech)
      _flutterTts.setErrorHandler((msg) {
        debugPrint('TTS Error: $msg');
        isSpeaking.value = false;
        currentState.value = AiGuiderState.idle;
        _shouldAutoStartListening = false; // Reset flag on error
      });

      // Set default language
      await _updateTTSLanguage();
      _ttsInitialized = true;
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
    }
  }

  /// Initialize STT
  Future<void> _initializeSTT() async {
    try {
      final available = await _speechToText.initialize(
        onError: (error) {
          debugPrint('STT Error: $error');
          // Only stop if it's a critical error, not just a warning
          if (error.errorMsg.contains('permission') || 
              error.errorMsg.contains('not available')) {
            isListening.value = false;
            currentState.value = AiGuiderState.idle;
          }
        },
        onStatus: (status) {
          debugPrint('STT Status: $status');
          // Only handle final statuses, ignore intermediate ones
          if (status == 'done') {
            // 'done' means final result received
            // Don't stop immediately - let the onResult handler with finalResult handle it
            // Only stop if we're not actually listening anymore after a longer delay
            // This allows pauseFor (5 seconds) to complete before stopping
            Future.delayed(const Duration(seconds: 6), () { // Wait 6 seconds to respect pauseFor of 5 seconds
              if (!_speechToText.isListening && isListening.value && transcribedText.value.isEmpty) {
                debugPrint('STT: Status is done, no result, and not listening after 6 seconds - stopping');
                isListening.value = false;
                if (currentState.value == AiGuiderState.listening) {
                  currentState.value = AiGuiderState.idle;
                }
              }
            });
          } else if (status == 'notListening') {
            // 'notListening' can be temporary during pauses - don't stop immediately
            // Wait longer to allow user to continue speaking (respect pauseFor of 5 seconds)
            Future.delayed(const Duration(seconds: 6), () { // Wait 6 seconds (longer than pauseFor) before stopping
              // Check again after delay - if still not listening and no speech received, then stop
              if (!_speechToText.isListening && isListening.value && transcribedText.value.isEmpty) {
                debugPrint('STT: Status is notListening for 6 seconds with no speech - stopping');
                isListening.value = false;
                if (currentState.value == AiGuiderState.listening) {
                  currentState.value = AiGuiderState.idle;
                }
              } else if (_speechToText.isListening) {
                // Started listening again, ignore the notListening status
                debugPrint('STT: Status was notListening but started listening again - ignoring');
              }
            });
          }
          // Ignore other statuses like 'listening', 'doneNoResult', etc.
        },
      );
      _sttInitialized = available;
      debugPrint('STT Initialized: $_sttInitialized');
    } catch (e) {
      debugPrint('Error initializing STT: $e');
      _sttInitialized = false;
    }
  }

  /// Update TTS language based on _currentLanguageCode (DO NOT overwrite it)
  Future<void> _updateTTSLanguage() async {
    try {
      // Use existing _currentLanguageCode - DO NOT reload from service
      // This preserves the detected language from user input
      String ttsLang = _getTTSLanguageCode(_currentLanguageCode);
      debugPrint('AI Guider: Setting TTS language to: $ttsLang (from $_currentLanguageCode)');
      
      await _flutterTts.setLanguage(ttsLang);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('Error updating TTS language: $e');
      // Fallback to English if TTS language fails
      try {
        await _flutterTts.setLanguage('en-US');
      } catch (_) {}
    }
  }

  /// Map app language codes to TTS language codes
  String _getTTSLanguageCode(String langCode) {
    final Map<String, String> langMap = {
      'en': 'en-US',
      'hi': 'hi-IN',
      'bn': 'bn-IN',
      'te': 'te-IN',
      'mr': 'mr-IN',
      'ta': 'ta-IN',
      'gu': 'gu-IN',
      'ur': 'ur-IN',
      'kn': 'kn-IN',
      'ml': 'ml-IN',
      'or': 'or-IN',
      'pa': 'pa-IN',
      'as': 'as-IN',
      'ne': 'ne-NP',
    };
    return langMap[langCode] ?? 'en-US';
  }

  /// Show welcome message on open
  Future<void> showWelcomeMessage({bool force = false}) async {
    if (hasShownWelcome.value && !force) return;
    
    // Ensure TTS is initialized
    if (!_ttsInitialized) {
      await _initializeTTS();
    }
    
    // Ensure language is loaded and TTS language is updated
    await _loadCurrentLanguage();
    await _updateTTSLanguage();
    
    // Small delay to ensure everything is ready
    await Future.delayed(const Duration(milliseconds: 300));
    
    hasShownWelcome.value = true;
    _shouldAutoStartListening = true; // Enable auto-start after welcome
    
    final welcomeText = _getWelcomeMessage();
    await speak(welcomeText);
  }

  /// Handle language change - reload language and re-greet
  Future<void> onLanguageChanged() async {
    // Reload current language from service
    await _loadCurrentLanguage();
    await _updateTTSLanguage();
    
    // Re-greet user in new language
    hasShownWelcome.value = false; // Reset to allow re-greeting
    await showWelcomeMessage(force: true);
  }

  /// Get welcome message based on language
  String _getWelcomeMessage() {
    final lang = _currentLanguageCode;
    
    // Welcome messages for different languages
    final Map<String, String> welcomeMessages = {
      'hi': 'Namaskar  aap AstroBharat AI Guide se baat kar rahe hain. Aap kya jaanana chahte hain?',
      'en': 'Namaskar  You are talking to AstroBharat AI Guide. What would you like to know?',
      'bn': 'নমস্কার  আপনি AstroBharat AI Guide এর সাথে কথা বলছেন। আপনি কী জানতে চান?',
      'te': 'నమస్కారం  మీరు AstroBharat AI Guide తో మాట్లాడుతున్నారు. మీరు ఏమి తెలుసుకోవాలనుకుంటున్నారు?',
      'mr': 'नमस्कार  तुम्ही AstroBharat AI Guide शी बोलत आहात. तुम्हाला काय जाणून घ्यायचे आहे?',
      'ta': 'வணக்கம்  நீங்கள் AstroBharat AI Guide உடன் பேசுகிறீர்கள். நீங்கள் என்ன அறிய விரும்புகிறீர்கள்?',
      'gu': 'નમસ્કાર  તમે AstroBharat AI Guide સાથે વાત કરી રહ્યા છો. તમે શું જાણવા માંગો છો?',
      'ur': 'سلام  آپ AstroBharat AI Guide سے بات کر رہے ہیں۔ آپ کیا جاننا چاہتے ہیں؟',
      'kn': 'ನಮಸ್ಕಾರ  ನೀವು AstroBharat AI Guide ನೊಂದಿಗೆ ಮಾತನಾಡುತ್ತಿದ್ದೀರಿ. ನೀವು ಏನು ತಿಳಿಯಲು ಬಯಸುತ್ತೀರಿ?',
      'ml': 'നമസ്കാരം  നിങ്ങൾ AstroBharat AI Guide-നോട് സംസാരിക്കുന്നു. നിങ്ങൾക്ക് എന്ത് അറിയണം?',
      'or': 'ନମସ୍କାର  ଆପଣ AstroBharat AI Guide ସହିତ କହୁଛନ୍ତି। ଆପଣ କଣ ଜାଣିବାକୁ ଚାହୁଁଛନ୍ତି?',
      'pa': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ  ਤੁਸੀਂ AstroBharat AI Guide ਨਾਲ ਗੱਲ ਕਰ ਰਹੇ ਹੋ। ਤੁਸੀਂ ਕੀ ਜਾਣਨਾ ਚਾਹੁੰਦੇ ਹੋ?',
      'as': 'নমস্কাৰ  আপুনি AstroBharat AI Guide ৰ সৈতে কথা পাতিছে। আপুনি কি জানিব বিচাৰে?',
      'ne': 'नमस्ते  तपाईं AstroBharat AI Guide संग कुरा गर्दै हुनुहुन्छ। तपाईं के जान्न चाहनुहुन्छ?',
    };
    
    return welcomeMessages[lang] ?? welcomeMessages['en']!;
  }

  /// Speak text with TTS (interruptible)
  Future<void> speak(String text) async {
    if (!_ttsInitialized) {
      await _initializeTTS();
    }

    try {
      // Ensure TTS language is updated before speaking
      await _updateTTSLanguage();
      
      // Stop any ongoing speech WITHOUT triggering completion handler
      // We do this by temporarily setting an empty handler, stopping, then setting the real one
      _flutterTts.setCompletionHandler(() {}); // Set empty handler to prevent firing
      await _flutterTts.stop(); // Stop any ongoing speech
      
      // Small delay to ensure stop completes
      await Future.delayed(const Duration(milliseconds: 100));
      
      isSpeaking.value = true;
      currentState.value = AiGuiderState.speaking;
      
      // Set completion handler based on whether we should auto-start listening
      if (_shouldAutoStartListening) {
        // This is the welcome message - set handler to auto-start mic
        // Store a flag to track if this specific speech instance completed
        final String welcomeTextToSpeak = text; // Capture the text being spoken
        _flutterTts.setCompletionHandler(() async {
          debugPrint('AI Guider: Welcome message TTS completion handler fired for: "$welcomeTextToSpeak"');
          
          // Update state
          isSpeaking.value = false;
          if (currentState.value == AiGuiderState.speaking) {
            currentState.value = AiGuiderState.idle;
          }
          
          // Wait a moment after welcome message completes for smooth transition
          await Future.delayed(const Duration(milliseconds: 200)); // Reduced from 300ms to 200ms
          
          // Auto-start listening for 5 seconds after welcome (reduced for faster response)
          // Double-check all conditions to ensure we should start listening
          if (!isListening.value && hasShownWelcome.value && _shouldAutoStartListening) {
            debugPrint('AI Guider: Welcome message completed, auto-starting mic');
            _shouldAutoStartListening = false; // Reset flag
            await startListeningWithTimeout(timeout: const Duration(seconds: 5));
          } else {
            debugPrint('AI Guider: Not auto-starting mic - isListening: ${isListening.value}, hasShownWelcome: ${hasShownWelcome.value}, shouldAutoStart: $_shouldAutoStartListening');
          }
        });
      } else {
        // Normal completion handler for regular AI responses
        _flutterTts.setCompletionHandler(() {
          isSpeaking.value = false;
          if (currentState.value == AiGuiderState.speaking) {
            currentState.value = AiGuiderState.idle;
          }
        });
      }
      
      // Now speak the text
      await _flutterTts.speak(text);
      debugPrint('AI Guider: Started speaking, shouldAutoStart: $_shouldAutoStartListening');
    } catch (e) {
      debugPrint('Error speaking: $e');
      isSpeaking.value = false;
      currentState.value = AiGuiderState.idle;
      _shouldAutoStartListening = false; // Reset flag on error
    }
  }

  /// Stop TTS immediately (for barge-in)
  /// This method stops TTS without triggering the completion handler
  Future<void> _stopTTS() async {
    try {
      if (_ttsInitialized) {
        // Set empty completion handler before stopping to prevent it from firing
        _flutterTts.setCompletionHandler(() {}); // Empty handler prevents firing
        await _flutterTts.stop();
      }
      isSpeaking.value = false;
      
      // If welcome message was interrupted, still auto-start listening
      if (_shouldAutoStartListening && hasShownWelcome.value) {
        _shouldAutoStartListening = false; // Reset flag
        // Wait a moment then auto-start listening for smooth transition
        Future.delayed(const Duration(milliseconds: 200), () { // Reduced from 500ms to 200ms
          if (!isListening.value && hasShownWelcome.value) {
            debugPrint('AI Guider: Welcome message interrupted, auto-starting mic');
            startListeningWithTimeout();
          }
        });
      }
      
      if (currentState.value == AiGuiderState.speaking) {
        currentState.value = AiGuiderState.interrupted;
        // Quick fade to idle
        Future.delayed(const Duration(milliseconds: 150), () { // Reduced from 300ms to 150ms
          currentState.value = AiGuiderState.idle;
        });
      }
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
      _shouldAutoStartListening = false; // Reset flag on error
    }
  }

  /// Start listening for voice input with 15 second timeout
  Future<void> startListeningWithTimeout({Duration? timeout}) async {
    if (!_sttInitialized) {
      await _initializeSTT();
    }

    if (!_sttInitialized) {
      debugPrint('STT not available');
      return;
    }

    try {
      // Stop TTS if speaking (barge-in)
      await _stopTTS();
      
      // Stop any ongoing listening
      await _stopListening();

      isListening.value = true;
      currentState.value = AiGuiderState.listening;
      transcribedText.value = '';
      _hasUserResponded = false; // Reset response flag

      // Use detected language for STT, or current language, or fallback to English
      String sttLangCode = _getSTTLanguageCode(_currentLanguageCode);
      debugPrint('AI Guider: Starting STT with language: $sttLangCode (current: $_currentLanguageCode)');
      
      await _speechToText.listen(
        onResult: (result) {
          transcribedText.value = result.recognizedWords;
          
          // If user has spoken something, mark as responded
          if (result.recognizedWords.isNotEmpty) {
            _hasUserResponded = true;
            // Cancel the timeout timer since user is responding
            _listeningTimer?.cancel();
            
            // Detect language from user's speech in real-time (for logging)
            final detectedLang = LanguageDetector.detectLanguage(result.recognizedWords);
            debugPrint('AI Guider: Detected language from speech: $detectedLang (current: $_currentLanguageCode)');
          }
          
          if (result.finalResult) {
            userQuery.value = result.recognizedWords;
            _hasUserResponded = true;
            _stopListening();
            
            // Language will be detected and updated in _processQuery
            _processQuery(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5), // 5 seconds pause after user stops speaking before finalizing
        localeId: sttLangCode,
        partialResults: true, // Enable partial results for better language detection
        cancelOnError: false, // Don't cancel on minor errors
      );

      // Auto-stop after 5 seconds if no user response (reduced for faster timeout)
      final timeoutDuration = timeout ?? const Duration(seconds: 5);
      _listeningTimer?.cancel();
      _listeningTimer = Timer(timeoutDuration, () {
        if (isListening.value && !_hasUserResponded && transcribedText.value.isEmpty) {
          debugPrint('AI Guider: No user response in ${timeoutDuration.inSeconds} seconds, stopping mic');
          _stopListening();
        }
      });
    } catch (e) {
      debugPrint('Error starting listening: $e');
      isListening.value = false;
      currentState.value = AiGuiderState.idle;
    }
  }

  /// Start listening for voice input (public method)
  Future<void> startListening() async {
    await startListeningWithTimeout();
  }

  /// Stop listening
  Future<void> _stopListening() async {
    try {
      if (_sttInitialized && _speechToText.isListening) {
        await _speechToText.stop();
      }
      isListening.value = false;
      _listeningTimer?.cancel();
      if (currentState.value == AiGuiderState.listening) {
        currentState.value = AiGuiderState.idle;
      }
    } catch (e) {
      debugPrint('Error stopping listening: $e');
    }
  }

  /// Map app language codes to STT language codes
  String _getSTTLanguageCode(String langCode) {
    final Map<String, String> langMap = {
      'en': 'en_US',
      'hi': 'hi_IN',
      'bn': 'bn_IN',
      'te': 'te_IN',
      'mr': 'mr_IN',
      'ta': 'ta_IN',
      'gu': 'gu_IN',
      'ur': 'ur_IN',
      'kn': 'kn_IN',
      'ml': 'ml_IN',
      'or': 'or_IN',
      'pa': 'pa_IN',
      'as': 'as_IN',
      'ne': 'ne_NP',
    };
    return langMap[langCode] ?? 'en_US';
  }

  /// Convert language code to backend format (e.g., "hi" -> "hi-IN")
  String _getBackendLanguageCode(String langCode) {
    final Map<String, String> langMap = {
      'en': 'en-IN',
      'hi': 'hi-IN',
      'bn': 'bn-IN',
      'te': 'te-IN',
      'mr': 'mr-IN',
      'ta': 'ta-IN',
      'gu': 'gu-IN',
      'ur': 'ur-IN',
      'kn': 'kn-IN',
      'ml': 'ml-IN',
      'or': 'or-IN',
      'pa': 'pa-IN',
      'as': 'as-IN',
      'ne': 'ne-IN',
    };
    return langMap[langCode] ?? 'en-IN';
  }

  /// Process user query (text or voice)
  Future<void> _processQuery(String query) async {
    if (query.trim().isEmpty) return;

    userQuery.value = query;
    currentState.value = AiGuiderState.thinking;
    aiReply.value = '';
    suggestions.value = [];

    // Detect language from user's input (text or speech)
    final detectedLang = LanguageDetector.detectLanguage(query);
    debugPrint('AI Guider: Detected language from query: "$detectedLang" (current: "$_currentLanguageCode", explicitlySelected: $_languageExplicitlySelected)');
    debugPrint('AI Guider: Query text: "$query"');
    
    // Only update language if:
    // 1. User has NOT explicitly selected a language, OR
    // 2. Detected language matches the selected language (confidence check)
    if (_languageExplicitlySelected) {
      // User explicitly selected a language - respect their choice
      // Only update if detected language is very confident and matches selected language
      debugPrint('AI Guider: Language explicitly selected by user, keeping "$_currentLanguageCode" (detected: "$detectedLang")');
      // Keep the explicitly selected language - don't override
    } else if (detectedLang.isNotEmpty) {
      // No explicit selection - use detected language
      if (detectedLang != _currentLanguageCode) {
        debugPrint('AI Guider: UPDATING language from "$_currentLanguageCode" to "$detectedLang" based on user input');
        _currentLanguageCode = detectedLang;
        await _updateTTSLanguage();
      } else {
        debugPrint('AI Guider: Language already set to "$detectedLang", keeping it');
      }
    } else {
      // If detection fails (empty), only load from service if current is also empty
      if (_currentLanguageCode.isEmpty) {
        debugPrint('AI Guider: No language detected and current is empty, loading from app settings');
        await _loadCurrentLanguage();
      } else {
        debugPrint('AI Guider: Detection failed but current language is "$_currentLanguageCode", keeping it');
      }
    }

    // Add to conversation history
    conversationHistory.add({
      'role': 'user',
      'content': query,
    });

    try {
      // Use detected/current language for backend (convert to backend format)
      final backendLanguage = _getBackendLanguageCode(_currentLanguageCode);
      debugPrint('AI Guider: Sending query with language: $backendLanguage (current: $_currentLanguageCode)');
      
      // Try backend with very short timeout for instant response
      Map<String, dynamic>? response;
      try {
        response = await _aiGuiderService.sendQuery(
          query: query,
          language: backendLanguage,
          sessionId: sessionId,
        ).timeout(
          const Duration(milliseconds: 1500), // 1.5 seconds timeout - use offline fallback if backend is slow
          onTimeout: () {
            debugPrint('AI Guider: Backend timeout after 1.5 seconds, using offline fallback for instant response');
            return null;
          },
        );
      } catch (e) {
        debugPrint('AI Guider: Backend error, using offline fallback: $e');
        response = null;
      }

      if (response != null) {
        _handleAIResponse(response);
      } else {
        // Offline fallback - use backend language format for consistency - INSTANT response
        final fallback = _aiGuiderService.getOfflineFallback(query, backendLanguage);
        debugPrint('AI Guider: Using offline fallback with language: $backendLanguage - INSTANT');
        _handleAIResponse(fallback);
      }
    } catch (e) {
      debugPrint('Error processing query: $e - using offline fallback');
      // Use offline fallback immediately - use backend language format
      final backendLanguage = _getBackendLanguageCode(_currentLanguageCode);
      final fallback = _aiGuiderService.getOfflineFallback(query, backendLanguage);
      debugPrint('AI Guider: Error fallback with language: $backendLanguage - INSTANT');
      _handleAIResponse(fallback);
    }
  }

  /// Handle AI response
  void _handleAIResponse(Map<String, dynamic> response) {
    aiReply.value = response['reply'] ?? '';
    final intent = response['intent'] as String?;
    final page = response['page'] as String?;
    final meta = response['_meta'] as Map<String, dynamic>?;
    
    // Debug logging for response
    debugPrint('AI Guider: Response received - intent: $intent, page: $page, reply: ${aiReply.value.substring(0, aiReply.value.length > 50 ? 50 : aiReply.value.length)}...');
    
    // Update session ID from meta if available
    if (meta != null && meta['sessionId'] != null) {
      // Session ID is already set, but we can log it
      debugPrint('AI Response sessionId: ${meta['sessionId']}');
    }

    // Add to conversation history
    conversationHistory.add({
      'role': 'assistant',
      'content': aiReply.value,
    });

    // Clear suggestions (backend doesn't send suggestions in this format)
    suggestions.value = [];

    // Speak the reply FIRST, then navigate - ensure TTS language matches current language
    // DO NOT reload from service - use the detected language from user input
    if (aiReply.value.isNotEmpty) {
      // Make sure we don't auto-start listening for regular AI responses
      _shouldAutoStartListening = false;
      
      // Start TTS first, then navigate after TTS starts (but don't wait for completion)
      _updateTTSLanguage().then((_) async {
        // Start speaking - wait for it to start (but not complete)
        await speak(aiReply.value);
        
        // Navigate AFTER TTS has started (small delay to ensure TTS is playing)
        if (intent == 'OPEN_PAGE' && page != null && page.toUpperCase() != 'NONE') {
          debugPrint('AI Guider: Navigating to page: $page (intent: $intent) - AFTER TTS STARTED');
          // Small delay to ensure TTS has started playing before navigation
          await Future.delayed(const Duration(milliseconds: 200));
          _navigateToPage(page);
        } else {
          debugPrint('AI Guider: No navigation - intent: $intent, page: $page');
        }
      });
    } else {
      // No reply to speak, navigate immediately if needed
      if (intent == 'OPEN_PAGE' && page != null && page.toUpperCase() != 'NONE') {
        debugPrint('AI Guider: Navigating to page: $page (intent: $intent) - NO REPLY');
        _navigateToPage(page);
      } else {
        debugPrint('AI Guider: No navigation - intent: $intent, page: $page');
      }
      currentState.value = AiGuiderState.idle;
    }
  }

  /// Navigate to page based on backend page value
  /// Maps backend page values (e.g., "TAROT_HOME") to actual routes using AppRoutes constants
  /// Navigates IMMEDIATELY without any delay
  void _navigateToPage(String page) {
    final pageUpper = page.toUpperCase();
    debugPrint('AI Guider: _navigateToPage called with: $pageUpper - INSTANT NAVIGATION');
    
    // Navigate IMMEDIATELY - no delay for instant response
    // Map backend page values to AppRoutes constants
    switch (pageUpper) {
      case 'TAROT_HOME':
      case 'TAROT':
        debugPrint('AI Guider: Navigating to Tarot: ${AppRoutes.tarotReading}');
        Get.toNamed(AppRoutes.tarotReading);
        break;
      case 'KUNDLI_FORM':
      case 'KUNDLI':
        debugPrint('AI Guider: Navigating to Kundli: ${AppRoutes.kundliForm}');
        Get.toNamed(AppRoutes.kundliForm);
        break;
      case 'HOROSCOPE':
      case 'HOROSCOPE_MAIN':
        debugPrint('AI Guider: Navigating to Horoscope: ${AppRoutes.horoscope}');
        Get.toNamed(AppRoutes.horoscope);
        break;
      case 'LIVE_ASTROLOGER':
      case 'ASTROLOGER':
        debugPrint('AI Guider: Navigating to Live Astrologer: ${AppRoutes.liveAstrologers}');
        Get.toNamed(AppRoutes.liveAstrologers);
        break;
      case 'ASTROLOGY_SERVICES':
        debugPrint('AI Guider: Navigating to Astrology Services: ${AppRoutes.astrologyServices}');
        Get.toNamed(AppRoutes.astrologyServices);
        break;
      case 'PANCHANG':
      case 'PANCHANG_HOME':
        debugPrint('AI Guider: Navigating to Panchang: ${AppRoutes.panchang}');
        Get.toNamed(AppRoutes.panchang);
        break;
      case 'NUMEROLOGY':
      case 'NUMEROLOGY_HOME':
        debugPrint('AI Guider: Navigating to Numerology: ${AppRoutes.numerology}');
        Get.toNamed(AppRoutes.numerology);
        break;
      case 'PALM_READING':
      case 'PALM_READING_HOME':
        debugPrint('AI Guider: Navigating to Palm Reading: ${AppRoutes.palmReading}');
        Get.toNamed(AppRoutes.palmReading);
        break;
      case 'FACE_READING':
      case 'FACE_READING_HOME':
        debugPrint('AI Guider: Navigating to Face Reading: ${AppRoutes.faceReading}');
        Get.toNamed(AppRoutes.faceReading);
        break;
      case 'MATCH_MAKING':
      case 'MATCH_MAKING_HOME':
        debugPrint('AI Guider: Navigating to Match Making: ${AppRoutes.matchMakingGif}');
        Get.toNamed(AppRoutes.matchMakingGif);
        break;
      case 'WALLET':
        debugPrint('AI Guider: Navigating to Wallet: ${AppRoutes.wallet}');
        Get.toNamed(AppRoutes.wallet);
        break;
      case 'BLOGS':
      case 'BLOG_HOME':
        debugPrint('AI Guider: Navigating to Blogs: ${AppRoutes.allBlogs}');
        Get.toNamed(AppRoutes.allBlogs);
        break;
      case 'COURSES':
      case 'COURSES_HOME':
        debugPrint('AI Guider: Navigating to Courses: ${AppRoutes.courses}');
        Get.toNamed(AppRoutes.courses);
        break;
      case 'HANDWRITING_ASTROLOGY':
      case 'HANDWRITING':
        debugPrint('AI Guider: Navigating to Handwriting: ${AppRoutes.handwritingAstrology}');
        Get.toNamed(AppRoutes.handwritingAstrology);
        break;
      case 'USER_DASHBOARD':
      case 'DASHBOARD':
      case 'HOME':
        debugPrint('AI Guider: Navigating to Dashboard: ${AppRoutes.userDashboard}');
        Get.toNamed(AppRoutes.userDashboard);
        break;
      default:
        debugPrint('AI Guider: Unknown page value: $page');
        break;
    }
  }

  /// Submit text query
  void submitTextQuery(String query) {
    if (query.trim().isEmpty) return;
    _processQuery(query.trim());
  }

  /// Toggle listening
  Future<void> toggleListening() async {
    if (isListening.value) {
      await _stopListening();
    } else {
      await startListening();
    }
  }

  /// Handle suggestion tap
  void onSuggestionTap(String suggestion) {
    submitTextQuery(suggestion);
  }

  /// Close AI Guider
  void closeGuider() {
    _stopTTS();
    _stopListening();
    Get.back();
  }
}

