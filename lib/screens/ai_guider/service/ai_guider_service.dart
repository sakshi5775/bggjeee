import 'dart:convert';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiGuiderService extends GetxService {
  /// Base URL for AI Guider API
  /// Uses deployed backend URL: https://ai-guider.onrender.com/
  static String get _aiGuiderBaseUrl {
    // Use deployed backend URL for both debug and production
    return 'https://ai-guider.onrender.com';
  }

  /// Send query to AI backend
  /// Returns: { reply: String, intent: String?, page: String?, _meta: Map? }
  Future<Map<String, dynamic>?> sendQuery({
    required String query,
    required String language,
    required String sessionId,
  }) async {
    try {
      final uri = Uri.parse('$_aiGuiderBaseUrl/ai/query');
      
      // Get authorization token
      final currentToken = UserData().accessToken?.trim();

      // Prepare request body
      final requestBody = {
        'query': query,
        'language': language,
        'sessionId': sessionId,
      };

      if (kDebugMode) {
        debugPrint('AI Guider API URL: ${uri.toString()}');
        debugPrint('AI Guider Request Body: ${json.encode(requestBody)}');
        debugPrint('AI Guider Language being sent: $language');
      }

      // Make HTTP POST request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (currentToken != null && currentToken.isNotEmpty)
            'Authorization': 'Bearer $currentToken',
        },
        body: json.encode(requestBody),
      ).timeout(
        const Duration(seconds: 2), // Reduced to 2 seconds for faster response - use offline fallback if slow
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (kDebugMode) {
        debugPrint('AI Guider API Status: ${response.statusCode}');
        debugPrint('AI Guider API Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        return responseData;
      }

      return null;
    } catch (e) {
      // Only log connection errors in debug mode to avoid cluttering production logs
      // The offline fallback will handle the response
      if (kDebugMode) {
        // Check if it's a connection error (expected when backend is not available)
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('connection refused') || 
            errorString.contains('failed host lookup') ||
            errorString.contains('network is unreachable')) {
          debugPrint('AI Guider: Backend not available, using offline fallback');
        } else {
          debugPrint('Error sending AI query: $e');
        }
      }
      // Return null to trigger offline fallback
      return null;
    }
  }

  /// Offline fallback - rule-based responses
  /// Returns response in the same format as backend: { reply, intent, page, _meta }
  Map<String, dynamic> getOfflineFallback(String query, String language) {
    final lowerQuery = query.toLowerCase().trim();
    
    // Extract base language code (e.g., "hi-IN" -> "hi")
    final baseLang = language.split('-').first;
    
    // Intent detection
    String? intent;
    String? page;
    String reply;

    // Greeting detection (check first)
    if (_isGreeting(lowerQuery)) {
      intent = 'NONE';
      page = null;
      reply = _getGreetingResponse(baseLang);
    } else if (lowerQuery.contains('tarot') || 
               lowerQuery.contains('card') ||
               lowerQuery.contains('तारो') || // Hindi: tarot
               lowerQuery.contains('तारो कार्ड')) { // Hindi: tarot card
      intent = 'OPEN_PAGE';
      page = 'TAROT_HOME';
      reply = _getNavigationResponse(baseLang, 'tarot');
    } else if (lowerQuery.contains('kundli') || 
               lowerQuery.contains('chart') ||
               lowerQuery.contains('कुंडली') || // Hindi: kundli
               lowerQuery.contains('कुण्डली') || // Alternative spelling
               lowerQuery.contains('जन्मपत्री') || // Hindi: birth chart
               lowerQuery.contains('जन्म कुंडली')) { // Hindi: birth kundli
      intent = 'OPEN_PAGE';
      page = 'KUNDLI_FORM';
      reply = _getNavigationResponse(baseLang, 'kundli');
    } else if (lowerQuery.contains('horoscope') || 
               lowerQuery.contains('rashifal') ||
               lowerQuery.contains('राशिफल') || // Hindi: horoscope
               lowerQuery.contains('होरोस्कोप')) { // Hindi: horoscope (transliterated)
      intent = 'OPEN_PAGE';
      page = 'HOROSCOPE';
      reply = _getNavigationResponse(baseLang, 'horoscope');
    } else if (lowerQuery.contains('astrologer') || 
               lowerQuery.contains('live') || 
               lowerQuery.contains('consult') ||
               lowerQuery.contains('ज्योतिषी') || // Hindi: astrologer
               lowerQuery.contains('एस्ट्रोलॉजर') || // Hindi: astrologer (transliterated)
               lowerQuery.contains('लाइव ज्योतिषी')) { // Hindi: live astrologer
      intent = 'OPEN_PAGE';
      page = 'LIVE_ASTROLOGER';
      reply = _getNavigationResponse(baseLang, 'astrologer');
    } else if (lowerQuery.contains('panchang') ||
               lowerQuery.contains('पंचांग')) { // Hindi: panchang
      intent = 'OPEN_PAGE';
      page = 'PANCHANG';
      reply = _getNavigationResponse(baseLang, 'panchang');
    } else if (lowerQuery.contains('numerology') ||
               lowerQuery.contains('अंक ज्योतिष') || // Hindi: numerology
               lowerQuery.contains('न्यूमेरोलॉजी')) { // Hindi: numerology (transliterated)
      intent = 'OPEN_PAGE';
      page = 'NUMEROLOGY';
      reply = _getNavigationResponse(baseLang, 'numerology');
    } else if (lowerQuery.contains('palm') || 
               lowerQuery.contains('hast') ||
               lowerQuery.contains('हस्त') || // Hindi: palm/hand
               lowerQuery.contains('हस्त रेखा')) { // Hindi: palm reading
      intent = 'OPEN_PAGE';
      page = 'PALM_READING';
      reply = _getNavigationResponse(baseLang, 'palm');
    } else if (lowerQuery.contains('face') || 
               lowerQuery.contains('mukh') ||
               lowerQuery.contains('मुख') || // Hindi: face
               lowerQuery.contains('मुख रेखा')) { // Hindi: face reading
      intent = 'OPEN_PAGE';
      page = 'FACE_READING';
      reply = _getNavigationResponse(baseLang, 'face');
    } else if (lowerQuery.contains('match') || 
               lowerQuery.contains('kundali') ||
               lowerQuery.contains('मिलान') || // Hindi: match
               lowerQuery.contains('कुंडली मिलान')) { // Hindi: kundli matching
      intent = 'OPEN_PAGE';
      page = 'MATCH_MAKING';
      reply = _getNavigationResponse(baseLang, 'match');
    } else {
      // Generic response - no navigation
      intent = 'NONE';
      page = null;
      reply = _getGenericResponse(baseLang);
    }

    final response = {
      'reply': reply,
      'intent': intent,
      if (page != null) 'page': page,
      '_meta': {
        'responseTime': '0ms',
        'sessionId': 'offline_fallback',
      },
    };
    
    // Debug logging for offline fallback
    if (kDebugMode) {
      debugPrint('AI Guider Offline Fallback: intent=$intent, page=$page, reply=${reply.substring(0, reply.length > 50 ? 50 : reply.length)}...');
    }
    
    return response;
  }

  /// Check if query is a greeting
  bool _isGreeting(String query) {
    final greetings = [
      'hello', 'hi', 'hey', 'namaste', 'namaskar',
      'नमस्ते', 'नमस्कार', 'हैलो', 'हाय',
      'হ্যালো', 'নমস্কার', 'হাই',
      'வணக்கம்', 'ஹலோ', 'ஹாய்',
      'नमस्कार', 'हॅलो', 'हाय',
      'નમસ્તે', 'હેલો', 'હાય',
      'سلام', 'ہیلو', 'ہائے',
      'ನಮಸ್ಕಾರ', 'ಹಲೋ', 'ಹಾಯ್',
      'നമസ്കാരം', 'ഹലോ', 'ഹായ്',
      'ନମସ୍କାର', 'ହେଲୋ', 'ହାଏ',
      'ਸਤ ਸ੍ਰੀ ਅਕਾਲ', 'ਹੈਲੋ', 'ਹਾਏ',
      'নমস্কাৰ', 'হেলো', 'হাই',
      'नमस्ते', 'हेल्लो', 'हाइ',
    ];
    return greetings.any((greeting) => query.contains(greeting));
  }

  /// Get greeting response based on language
  String _getGreetingResponse(String lang) {
    final Map<String, String> greetings = {
      'hi': 'नमस्ते! मैं AstroBharat AI Guide हूं। मैं आपकी कैसे मदद कर सकता हूं?',
      'en': 'Hello! I am AstroBharat AI Guide. How can I help you?',
      'bn': 'নমস্কার! আমি AstroBharat AI Guide। আমি আপনাকে কীভাবে সাহায্য করতে পারি?',
      'te': 'నమస్కారం! నేను AstroBharat AI Guide. నేను మీకు ఎలా సహాయం చేయగలను?',
      'mr': 'नमस्कार! मी AstroBharat AI Guide आहे. मी तुम्हाला कशी मदत करू शकतो?',
      'ta': 'வணக்கம்! நான் AstroBharat AI Guide. நான் உங்களுக்கு எவ்வாறு உதவ முடியும்?',
      'gu': 'નમસ્તે! હું AstroBharat AI Guide છું. હું તમને કેવી રીતે મદદ કરી શકું?',
      'ur': 'سلام! میں AstroBharat AI Guide ہوں۔ میں آپ کی کس طرح مدد کر سکتا ہوں؟',
      'kn': 'ನಮಸ್ಕಾರ! ನಾನು AstroBharat AI Guide. ನಾನು ನಿಮಗೆ ಹೇಗೆ ಸಹಾಯ ಮಾಡಬಹುದು?',
      'ml': 'നമസ്കാരം! ഞാൻ AstroBharat AI Guide ആണ്. ഞാൻ നിങ്ങളെ എങ്ങനെ സഹായിക്കാം?',
      'or': 'ନମସ୍କାର! ମୁଁ AstroBharat AI Guide। ମୁଁ ଆପଣଙ୍କୁ କିପରି ସାହାଯ୍ୟ କରିପାରିବି?',
      'pa': 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ! ਮੈਂ AstroBharat AI Guide ਹਾਂ। ਮੈਂ ਤੁਹਾਡੀ ਕਿਵੇਂ ਮਦਦ ਕਰ ਸਕਦਾ ਹਾਂ?',
      'as': 'নমস্কাৰ! মই AstroBharat AI Guide। মই আপোনাক কেনেকৈ সহায় কৰিব পাৰোঁ?',
      'ne': 'नमस्ते! म AstroBharat AI Guide हुँ। म तपाईंलाई कसरी मद्दत गर्न सक्छु?',
    };
    return greetings[lang] ?? greetings['en']!;
  }

  /// Get navigation response based on language and page
  String _getNavigationResponse(String lang, String page) {
    final Map<String, Map<String, String>> responses = {
      'hi': {
        'tarot': 'मैं आपको तारो कार्ड रीडिंग के लिए ले जा रहा हूं।',
        'kundli': 'मैं आपको कुंडली बनाने के लिए ले जा रहा हूं।',
        'horoscope': 'मैं आपको राशिफल के लिए ले जा रहा हूं।',
        'astrologer': 'मैं आपको लाइव ज्योतिषी से बात करने के लिए ले जा रहा हूं।',
        'panchang': 'मैं आपको पंचांग के लिए ले जा रहा हूं।',
        'numerology': 'मैं आपको अंक ज्योतिष के लिए ले जा रहा हूं।',
        'palm': 'मैं आपको हस्त रेखा के लिए ले जा रहा हूं।',
        'face': 'मैं आपको मुख रेखा के लिए ले जा रहा हूं।',
        'match': 'मैं आपको कुंडली मिलान के लिए ले जा रहा हूं।',
      },
      'en': {
        'tarot': 'I\'m taking you to Tarot card reading.',
        'kundli': 'I\'m taking you to create your Kundli.',
        'horoscope': 'I\'m taking you to Horoscope.',
        'astrologer': 'I\'m taking you to chat with a live astrologer.',
        'panchang': 'I\'m taking you to Panchang.',
        'numerology': 'I\'m taking you to Numerology.',
        'palm': 'I\'m taking you to Palm Reading.',
        'face': 'I\'m taking you to Face Reading.',
        'match': 'I\'m taking you to Match Making.',
      },
    };
    
    // For other languages, use English as fallback
    return responses[lang]?[page] ?? responses['en']?[page] ?? 'I\'m taking you there.';
  }

  /// Get generic "I don't understand" response based on language
  String _getGenericResponse(String lang) {
    final Map<String, String> responses = {
      'hi': 'मुझे समझ नहीं आया। कृपया अपना प्रश्न स्पष्ट करें।',
      'en': 'I didn\'t understand. Please clarify your question.',
      'bn': 'আমি বুঝতে পারিনি। অনুগ্রহ করে আপনার প্রশ্নটি স্পষ্ট করুন।',
      'te': 'నాకు అర్థం కాలేదు। దయచేసి మీ ప్రశ్నను స్పష్టం చేయండి।',
      'mr': 'मला समजले नाही. कृपया आपला प्रश्न स्पष्ट करा.',
      'ta': 'எனக்கு புரியவில்லை. தயவுசெய்து உங்கள் கேள்வியை தெளிவுபடுத்தவும்.',
      'gu': 'મને સમજાયું નથી. કૃપા કરીને તમારો પ્રશ્ન સ્પષ્ટ કરો.',
      'ur': 'مجھے سمجھ نہیں آیا۔ براہ کرم اپنا سوال واضح کریں۔',
      'kn': 'ನನಗೆ ಅರ್ಥವಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ನಿಮ್ಮ ಪ್ರಶ್ನೆಯನ್ನು ಸ್ಪಷ್ಟಪಡಿಸಿ.',
      'ml': 'എനിക്ക് മനസ്സിലായില്ല. ദയവായി നിങ്ങളുടെ ചോദ്യം വ്യക്തമാക്കുക.',
      'or': 'ମୁଁ ବୁଝିପାରିଲି ନାହିଁ। ଦୟାକରି ଆପଣଙ୍କର ପ୍ରଶ୍ନ ସ୍ପଷ୍ଟ କରନ୍ତୁ।',
      'pa': 'ਮੈਨੂੰ ਸਮਝ ਨਹੀਂ ਆਈ। ਕਿਰਪਾ ਕਰਕੇ ਆਪਣਾ ਸਵਾਲ ਸਪੱਸ਼ਟ ਕਰੋ।',
      'as': 'মই বুজিব পৰা নাই। অনুগ্ৰহ কৰি আপোনাৰ প্ৰশ্নটো স্পষ্ট কৰক।',
      'ne': 'मैले बुझिन। कृपया आफ्नो प्रश्न स्पष्ट गर्नुहोस्।',
    };
    return responses[lang] ?? responses['en']!;
  }
}

