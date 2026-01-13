/// Language detection utility for detecting language from text
/// Supports multiple languages using Unicode script ranges
class LanguageDetector {
  /// Detect language from text using Unicode script ranges
  /// Returns ISO 639-1 language code (e.g., 'en', 'hi', 'bn', etc.)
  static String detectLanguage(String text) {
    if (text.trim().isEmpty) return 'en';

    final lowerText = text.toLowerCase().trim();

    // First, check for transliterated Hindi (Roman script Hindi)
    // This must be checked BEFORE script detection for Latin characters
    if (_isTransliteratedHindi(lowerText)) {
      return 'hi';
    }

    // Remove whitespace and punctuation for analysis
    final cleanText = text.replaceAll(RegExp(r'[\s\p{P}]+', unicode: true), '');
    if (cleanText.isEmpty) return 'en';

    // Count characters in each script
    final scriptCounts = <String, int>{};

    for (final char in cleanText.runes) {
      final script = _getScriptForChar(char);
      scriptCounts[script] = (scriptCounts[script] ?? 0) + 1;
    }

    // Find the script with the most characters
    if (scriptCounts.isEmpty) return 'en';

    final dominantScript = scriptCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Map script to language code
    return _scriptToLanguageCode(dominantScript);
  }

  /// Detect if text is transliterated Hindi (Roman script)
  /// Checks for common Hindi words and patterns in transliterated form
  static bool _isTransliteratedHindi(String text) {
    // Common Hindi words in transliterated form
    final hindiWords = [
      // Pronouns and common words
      'mujhe', 'main', 'tum', 'aap', 'ham', 'hum', 'unhe', 'usne', 'unka', 'unki',
      'kya', 'kaise', 'kahan', 'kab', 'kyun', 'kis', 'kisne', 'kisko', 'kiski',
      'yeh', 'woh', 'yah', 'vah', 'is', 'us', 'inke', 'unke',
      
      // Verbs and auxiliaries
      'hai', 'hain', 'ho', 'hoga', 'hogi', 'honge', 'hona', 'hota', 'hoti',
      'dekhni', 'karni', 'karna', 'chahiye', 'chahie', 'chahiye', 'karna',
      'karo', 'kare', 'karein', 'kar', 'karne', 'karunga', 'karungi',
      'jao', 'jaye', 'jayein', 'ja', 'jane', 'jaunga', 'jaungi',
      'aao', 'aaye', 'aayein', 'aa', 'aane', 'aaunga', 'aaungi',
      'lo', 'le', 'lelo', 'lena', 'lene',
      'do', 'de', 'dedo', 'dena', 'dene',
      
      // Common phrases
      'kya hai', 'kya hain', 'kya ho', 'kya hoga',
      'kaise hai', 'kaise hain', 'kaise ho',
      'kahan hai', 'kahan hain', 'kahan ho',
      'kab hai', 'kab hain', 'kab ho',
      
      // Astrology-related terms (common in this app)
      // NOTE: Don't include English words like 'horoscope', 'tarot', 'astrologer' etc.
      // as they are used in both English and Hindi contexts
      'kundli', 'kundali', 'rashifal', 'rashi',
      'jyotish', 'jyotishi',
      'upay', 'upaye',
      'panchang', 'panchangam',
      'ank jyotish',
      'hast rekha',
      'samudrik shastra',
      'kundali milan',
      'varshaphal',
      
      // Question words and common patterns
      'dekhni hai', 'karni hai', 'chahiye', 'chahie',
      'bataye', 'batayen', 'batana', 'batao', 'bata',
      'puchna', 'puchne', 'pucho', 'puch', 'puchta',
      'samjhana', 'samjha', 'samjho', 'samajh',
    ];

    // Check if text contains any Hindi words
    for (final word in hindiWords) {
      if (text.contains(word)) {
        return true;
      }
    }

    // Check for common Hindi sentence patterns
    // Pattern: "mujhe/kya/kaise + verb + hai/hain/ho"
    final hindiPatterns = [
      RegExp(r'\b(mujhe|main|tum|aap|ham|hum)\s+\w+\s+(hai|hain|ho|chahiye|chahie)', caseSensitive: false),
      RegExp(r'\b(kya|kaise|kahan|kab|kyun)\s+\w+\s+(hai|hain|ho)', caseSensitive: false),
      RegExp(r'\b\w+\s+(dekhni|karni|karna|chahiye|chahie)\s+(hai|hain)', caseSensitive: false),
    ];

    for (final pattern in hindiPatterns) {
      if (pattern.hasMatch(text)) {
        return true;
      }
    }

    return false;
  }

  /// Get script name for a Unicode character
  static String _getScriptForChar(int char) {
    // Devanagari (Hindi, Marathi, Nepali, Sanskrit)
    if (char >= 0x0900 && char <= 0x097F) return 'Devanagari';
    
    // Bengali
    if (char >= 0x0980 && char <= 0x09FF) return 'Bengali';
    
    // Tamil
    if (char >= 0x0B80 && char <= 0x0BFF) return 'Tamil';
    
    // Telugu
    if (char >= 0x0C00 && char <= 0x0C7F) return 'Telugu';
    
    // Gujarati
    if (char >= 0x0A80 && char <= 0x0AFF) return 'Gujarati';
    
    // Kannada
    if (char >= 0x0C80 && char <= 0x0CFF) return 'Kannada';
    
    // Malayalam
    if (char >= 0x0D00 && char <= 0x0D7F) return 'Malayalam';
    
    // Odia
    if (char >= 0x0B00 && char <= 0x0B7F) return 'Odia';
    
    // Punjabi (Gurmukhi)
    if (char >= 0x0A00 && char <= 0x0A7F) return 'Gurmukhi';
    
    // Urdu (Arabic script)
    if (char >= 0x0600 && char <= 0x06FF) return 'Arabic';
    
    // Assamese (uses Bengali script)
    if (char >= 0x0980 && char <= 0x09FF) return 'Bengali';
    
    // Latin (English, Spanish, French, etc.)
    if ((char >= 0x0000 && char <= 0x007F) || 
        (char >= 0x0080 && char <= 0x00FF) ||
        (char >= 0x0100 && char <= 0x017F) ||
        (char >= 0x0180 && char <= 0x024F)) {
      // Check if it's likely English or another Latin-based language
      // For now, default to English, but could be enhanced with more detection
      return 'Latin';
    }
    
    // Chinese (Simplified)
    if (char >= 0x4E00 && char <= 0x9FFF) return 'Han';
    
    // Japanese (Hiragana, Katakana)
    if ((char >= 0x3040 && char <= 0x309F) || 
        (char >= 0x30A0 && char <= 0x30FF)) return 'Japanese';
    
    // Korean
    if (char >= 0xAC00 && char <= 0xD7AF) return 'Hangul';
    
    // Thai
    if (char >= 0x0E00 && char <= 0x0E7F) return 'Thai';
    
    // Vietnamese (uses Latin with diacritics)
    if (char >= 0x1E00 && char <= 0x1EFF) return 'Latin';
    
    // Russian (Cyrillic)
    if (char >= 0x0400 && char <= 0x04FF) return 'Cyrillic';
    
    // Default to Latin for unknown scripts
    return 'Latin';
  }

  /// Map script name to ISO 639-1 language code
  static String _scriptToLanguageCode(String script) {
    switch (script) {
      case 'Devanagari':
        // Most common: Hindi, but could be Marathi, Nepali, Sanskrit
        // Default to Hindi as it's most common
        return 'hi';
      case 'Bengali':
        return 'bn';
      case 'Tamil':
        return 'ta';
      case 'Telugu':
        return 'te';
      case 'Gujarati':
        return 'gu';
      case 'Kannada':
        return 'kn';
      case 'Malayalam':
        return 'ml';
      case 'Odia':
        return 'or';
      case 'Gurmukhi':
        return 'pa';
      case 'Arabic':
        // Could be Urdu, Arabic, Persian, etc.
        // Default to Urdu as it's common in India
        return 'ur';
      case 'Han':
        return 'zh';
      case 'Japanese':
        return 'ja';
      case 'Hangul':
        return 'ko';
      case 'Thai':
        return 'th';
      case 'Cyrillic':
        return 'ru';
      case 'Latin':
      default:
        // Default to English for Latin script
        // Could be enhanced to detect Spanish, French, etc. based on common words
        return 'en';
    }
  }

  /// Detect if text contains mixed languages
  static bool isMixedLanguage(String text) {
    final scripts = <String>{};
    for (final char in text.runes) {
      final script = _getScriptForChar(char);
      if (script != 'Latin' || (char >= 0x0000 && char <= 0x007F)) {
        scripts.add(script);
      }
    }
    return scripts.length > 1;
  }

  /// Get confidence score for language detection (0.0 to 1.0)
  static double getConfidence(String text, String detectedLanguage) {
    if (text.trim().isEmpty) return 0.0;

    final cleanText = text.replaceAll(RegExp(r'[\s\p{P}]+', unicode: true), '');
    if (cleanText.isEmpty) return 0.0;

    final scriptCounts = <String, int>{};
    for (final char in cleanText.runes) {
      final script = _getScriptForChar(char);
      scriptCounts[script] = (scriptCounts[script] ?? 0) + 1;
    }

    if (scriptCounts.isEmpty) return 0.0;

    final totalChars = scriptCounts.values.reduce((a, b) => a + b);
    final expectedScript = _languageCodeToScript(detectedLanguage);
    final scriptCount = scriptCounts[expectedScript] ?? 0;

    return scriptCount / totalChars;
  }

  /// Map language code to script name
  static String _languageCodeToScript(String langCode) {
    switch (langCode) {
      case 'hi':
      case 'mr':
      case 'ne':
      case 'sa':
        return 'Devanagari';
      case 'bn':
      case 'as':
        return 'Bengali';
      case 'ta':
        return 'Tamil';
      case 'te':
        return 'Telugu';
      case 'gu':
        return 'Gujarati';
      case 'kn':
        return 'Kannada';
      case 'ml':
        return 'Malayalam';
      case 'or':
        return 'Odia';
      case 'pa':
        return 'Gurmukhi';
      case 'ur':
      case 'ar':
        return 'Arabic';
      case 'zh':
        return 'Han';
      case 'ja':
        return 'Japanese';
      case 'ko':
        return 'Hangul';
      case 'th':
        return 'Thai';
      case 'ru':
        return 'Cyrillic';
      case 'en':
      default:
        return 'Latin';
    }
  }
}




