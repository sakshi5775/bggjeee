/// Centralized language mapping for ML Kit Translation
/// 
/// This is the SINGLE SOURCE OF TRUTH for language support.
/// To add a new language:
/// 1. Add it to assets/languages.json
/// 2. Check if ML Kit supports it (see MLKitTranslationServiceV2)
/// 3. If supported, add mapping in MLKitTranslationServiceV2._languageMap
/// 
/// Supported languages by ML Kit (as of current version):
/// - English (en) - Source language
/// - Hindi (hi)
/// - Bengali (bn)
/// - Telugu (te)
/// - Marathi (mr)
/// - Tamil (ta)
/// - Gujarati (gu)
/// - Urdu (ur)
/// - Kannada (kn)
/// 
/// Languages NOT supported by ML Kit will show English text (no translation).
/// This is intentional - ML Kit has limited language support compared to
/// the full list in languages.json.

/// Initial required languages (from requirements)
const List<String> initialRequiredLanguages = [
  'en', // English
  'hi', // Hindi - हिन्दी
  'ta', // Tamil - தமிழ்
  'te', // Telugu - తెలుగు
  'mr', // Marathi - मराठी
  'bn', // Bengali - বাংলা
  'gu', // Gujarati - ગુજરાતી
  'ml', // Malayalam - മലയാളം (not supported by ML Kit - will show English)
  'kn', // Kannada - ಕನ್ನಡ
];










