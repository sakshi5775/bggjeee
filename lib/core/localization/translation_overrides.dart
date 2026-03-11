/// Translation Overrides for ML Kit
///
/// ML Kit sometimes translates UI terms incorrectly (e.g., "Call" as "to shout" instead of "phone call").
/// This file provides manual overrides for common UI terms to ensure accurate translations.
///
/// Format: "English Text" -> Map<LanguageCode, CorrectTranslation>
///
/// To add new overrides:
/// 1. Add the English text as the key
/// 2. Add translations for each supported language
/// 3. Use empty string "" for languages that should use ML Kit translation

class TranslationOverrides {
  /// Translation overrides map
  /// Key: English text (case-sensitive)
  /// Value: Map of language code -> correct translation
  static final Map<String, Map<String, String>> _overrides = {
    // Common UI Actions
    'AI': {'hi': 'एआई'},
    'Online': {'hi': 'ऑनलाइन'},
    'Offline': {'hi': 'ऑफलाइन'},
    'Live': {'hi': 'लाइव'}, // Transliteration as requested
    'Ramal': {'hi': 'रमल'}, // Transliteration as requested
    'Ramal\nShastra': {'hi': 'रमल\nशास्त्र'}, // Multiline version
    'Call': {
      'hi': 'कॉल करें', // Phone call, not "to shout"
      'bn': 'কল করুন',
      'te': 'కాల్ చేయండి',
      'mr': 'कॉल करा',
      'ta': 'அழைக்கவும்',
      'gu': 'કૉલ કરો',
      'kn': 'ಕರೆ ಮಾಡಿ',
      'ur': 'کال کریں',
      'ml': 'കോൾ ചെയ്യുക',
    },
    'Chat': {
      'hi': 'चैट',
      'bn': 'চ্যাট',
      'te': 'చాట్',
      'mr': 'चॅट',
      'ta': 'அரட்டை',
      'gu': 'ચેટ',
      'kn': 'ಚಾಟ್',
      'ur': 'چیٹ',
      'ml': 'ചാറ്റ്',
    },
    'Follow': {
      'hi': 'फॉलो',
      'bn': 'ফলো',
      'te': 'ఫాలో',
      'mr': 'फॉलो',
      'ta': 'பின்தொடர்',
      'gu': 'ફોલો',
      'kn': 'ಫಾಲೋ',
      'ur': 'فالو',
      'ml': 'ഫോളോ',
    },
    'Following': {
      'hi': 'फ़ॉलोइंग',
      'bn': 'ফলোয়িং',
      'te': 'ఫాలోయింగ్',
      'mr': 'फॉलोइंग',
      'ta': 'பின்தொடர்கிறது',
      'gu': 'ફોલોઇંગ',
      'kn': 'ಫಾಲೋಯಿಂಗ್',
      'ur': 'فالوئنگ',
      'ml': 'ഫോളോയിംഗ്',
    },
    'Video Call': {
      'hi': 'वीडियो कॉल',
      'bn': 'ভিডিও কল',
      'te': 'వీడియో కాల్',
      'mr': 'व्हिडिओ कॉल',
      'ta': 'வீடியோ அழைப்பு',
      'gu': 'વિડિયો કૉલ',
      'kn': 'ವೀಡಿಯೋ ಕರೆ',
      'ur': 'ویڈیو کال',
      'ml': 'വീഡിയോ കോൾ',
    },
    'Call and Chat': {
      'hi': 'कॉल और चैट',
      'bn': 'কল এবং চ্যাট',
      'te': 'కాల్ మరియు చాట్',
      'mr': 'कॉल आणि चॅट',
      'ta': 'அழைத்து அரட்டை',
      'gu': 'કૉલ અને ચેટ',
      'kn': 'ಕರೆ ಮತ್ತು ಚಾಟ್',
      'ur': 'کال اور چیٹ',
      'ml': 'കോൾ ചെയ്ത് ചാറ്റ്',
    },
    'View All': {
      'hi': 'सभी देखें',
      'bn': 'সব দেখুন',
      'te': 'అన్నీ వీక్షించండి',
      'mr': 'सर्व पहा',
      'ta': 'அனைத்தையும் காட்டு',
      'gu': 'બધું જુઓ',
      'kn': 'ಎಲ್ಲಾ ವೀಕ್ಷಿಸಿ',
      'ur': 'سب دیکھیں',
      'ml': 'എല്ലാം കാണുക',
    },
    'OUR SERVICES': {
      'hi': 'हमारी सेवाएं',
      'bn': 'আমাদের পরিষেবা',
      'te': 'మా సేవలు',
      'mr': 'आमच्या सेवा',
      'ta': 'எங்கள் சேவைகள்',
      'gu': 'અમારી સેવાઓ',
      'kn': 'ನಮ್ಮ ಸೇವೆಗಳು',
      'ur': 'ہماری خدمات',
      'ml': 'ഞങ്ങളുടെ സേവനങ്ങൾ',
    },
    'Hide': {
      'hi': 'छुपाएं',
      'bn': 'লুকান',
      'te': 'దాచండి',
      'mr': 'लपवा',
      'ta': 'மறை',
      'gu': 'છુપાવો',
      'kn': 'ಮರೆಮಾಡಿ',
      'ur': 'چھپائیں',
      'ml': 'മറയ്ക്കുക',
    },
    'Home': {
      'hi': 'होम',
      'bn': 'হোম',
      'te': 'హోమ్',
      'mr': 'होम',
      'ta': 'வீடு',
      'gu': 'હોમ',
      'kn': 'ಹೋಮ್',
      'ur': 'ہوم',
      'ml': 'ഹോം',
    },
    'Shop': {
      'hi': 'दुकान',
      'bn': 'দোকান',
      'te': 'షాప్',
      'mr': 'दुकान',
      'ta': 'கடை',
      'gu': 'દુકાન',
      'kn': 'ಅಂಗಡಿ',
      'ur': 'دکان',
      'ml': 'ഷോപ്പ്',
    },
    'Education': {
      'hi': 'शिक्षा',
      'bn': 'শিক্ষা',
      'te': 'విద్య',
      'mr': 'शिक्षण',
      'ta': 'கல்வி',
      'gu': 'શિક્ષણ',
      'kn': 'ಶಿಕ್ಷಣ',
      'ur': 'تعلیم',
      'ml': 'വിദ്യാഭ്യാസം',
    },
    'Profile': {
      'hi': 'प्रोफ़ाइल',
      'bn': 'প্রোফাইল',
      'te': 'ప్రొఫైల్',
      'mr': 'प्रोफाइल',
      'ta': 'சுயவிவரம்',
      'gu': 'પ્રોફાઇલ',
      'kn': 'ಪ್ರೊಫೈಲ್',
      'ur': 'پروفائل',
      'ml': 'പ്രൊഫൈൽ',
    },
    'Featured Products': {
      'hi': 'विशेष उत्पाद',
      'bn': 'বিশেষ পণ্য',
      'te': 'విశేష ఉత్పత్తులు',
      'mr': 'विशेष उत्पादने',
      'ta': 'சிறப்பு தயாரிப்புகள்',
      'gu': 'વિશેષ ઉત્પાદનો',
      'kn': 'ವಿಶೇಷ ಉತ್ಪನ್ನಗಳು',
      'ur': 'خصوصی مصنوعات',
      'ml': 'പ്രത്യേക ഉത്പന്നങ്ങൾ',
    },
    'Shop by Category': {
      'hi': 'श्रेणी के अनुसार खरीदें',
      'bn': 'বিভাগ অনুযায়ী কেনাকাটা',
      'te': 'వర్గం ప్రకారం షాపింగ్',
      'mr': 'श्रेणीनुसार खरेदी करा',
      'ta': 'வகை வாரியாக கடை',
      'gu': 'શ્રેણી પ્રમાણે ખરીદી',
      'kn': 'ವರ್ಗದ ಪ್ರಕಾರ ಶಾಪಿಂಗ್',
      'ur': 'زمرہ کے مطابق خریداری',
      'ml': 'വിഭാഗം അനുസരിച്ച് ഷോപ്പിംഗ്',
    },
    'Best Sellers': {
      'hi': 'सर्वश्रेष्ठ विक्रेता',
      'bn': 'সেরা বিক্রেতা',
      'te': 'అత్యుత్తమ విక్రేతలు',
      'mr': 'सर्वोत्तम विक्रेते',
      'ta': 'சிறந்த விற்பனையாளர்கள்',
      'gu': 'શ્રેષ્ઠ વિક્રેતાઓ',
      'kn': 'ಅತ್ಯುತ್ತಮ ಮಾರಾಟಗಾರರು',
      'ur': 'بہترین فروخت کنندگان',
      'ml': 'മികച്ച വിൽപ്പനക്കാർ',
    },
    'Recommended for you': {
      'hi': 'आपके लिए सुझाव',
      'bn': 'আপনার জন্য সুপারিশ',
      'te': 'మీ కోసం సిఫార్సు చేయబడింది',
      'mr': 'तुमच्यासाठी शिफारस',
      'ta': 'உங்களுக்கு பரிந்துரைக்கப்பட்டது',
      'gu': 'તમારા માટે ભલામણ',
      'kn': 'ನಿಮಗೆ ಶಿಫಾರಸು ಮಾಡಲಾಗಿದೆ',
      'ur': 'آپ کے لیے سفارش',
      'ml': 'നിങ്ങൾക്ക് ശുപാർശ ചെയ്തത്',
    },
    'Recently viewed': {
      'hi': 'हाल ही में देखा गया',
      'bn': 'সাম্প্রতিক দেখা',
      'te': 'ఇటీవల వీక్షించబడింది',
      'mr': 'अलीकडे पाहिले',
      'ta': 'சமீபத்தில் பார்த்தவை',
      'gu': 'તાજેતરમાં જોયેલું',
      'kn': 'ಇತ್ತೀಚೆಗೆ ನೋಡಲಾಗಿದೆ',
      'ur': 'حال ہی میں دیکھا گیا',
      'ml': 'ഇടയ്ക്ക് കണ്ടത്',
    },
    'Shopping Cart': {
      'hi': 'शॉपिंग कार्ट',
      'bn': 'শপিং কার্ট',
      'te': 'షాపింగ్ కార్ట్',
      'mr': 'शॉपिंग कार्ट',
      'ta': 'ஷாப்பிங் கார்ட்',
      'gu': 'શોપિંગ કાર્ટ',
      'kn': 'ಶಾಪಿಂಗ್ ಕಾರ್ಟ್',
      'ur': 'خریداری کی ٹوکری',
      'ml': 'ഷോപ്പിംഗ് കാർട്ട്',
    },
    'Contact Support': {
      'hi': 'सहायता से संपर्क करें',
      'bn': 'সাপোর্টে যোগাযোগ করুন',
      'te': 'సపోర్ట్‌తో సంప్రదించండి',
      'mr': 'समर्थनाशी संपर्क साधा',
      'ta': 'ஆதரவைத் தொடர்பு கொள்ளுங்கள்',
      'gu': 'સપોર્ટનો સંપર્ક કરો',
      'kn': 'ಸಪೋರ್ಟ್‌ಗೆ ಸಂಪರ್ಕಿಸಿ',
      'ur': 'سپورٹ سے رابطہ کریں',
      'ml': 'സപ്പോർട്ടുമായി ബന്ധപ്പെടുക',
    },
    'Notification Settings': {
      'hi': 'सूचना सेटिंग्स',
      'bn': 'বিজ্ঞপ্তি সেটিংস',
      'te': 'నోటిఫికేషన్ సెట్టింగ్‌లు',
      'mr': 'सूचना सेटिंग्ज',
      'ta': 'அறிவிப்பு அமைப்புகள்',
      'gu': 'સૂચના સેટિંગ્સ',
      'kn': 'ಅಧಿಸೂಚನೆ ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'ur': 'اطلاعات کی ترتیبات',
      'ml': 'അറിയിപ്പ് സെറ്റിംഗുകൾ',
    },
    'Email Notifications': {
      'hi': 'ईमेल सूचनाएं',
      'bn': 'ইমেইল বিজ্ঞপ্তি',
      'te': 'ఇమెయిల్ నోటిఫికేషన్‌లు',
      'mr': 'ईमेल सूचना',
      'ta': 'மின்னஞ்சல் அறிவிப்புகள்',
      'gu': 'ઇમેઇલ સૂચનાઓ',
      'kn': 'ಇಮೇಲ್ ಅಧಿಸೂಚನೆಗಳು',
      'ur': 'ای میل اطلاعات',
      'ml': 'ഇമെയിൽ അറിയിപ്പുകൾ',
    },
    'SMS Notifications': {
      'hi': 'एसएमएस सूचनाएं',
      'bn': 'এসএমএস বিজ্ঞপ্তি',
      'te': 'SMS నోటిఫికేషన్‌లు',
      'mr': 'SMS सूचना',
      'ta': 'SMS அறிவிப்புகள்',
      'gu': 'SMS સૂચનાઓ',
      'kn': 'SMS ಅಧಿಸೂಚನೆಗಳು',
      'ur': 'SMS اطلاعات',
      'ml': 'SMS അറിയിപ്പുകൾ',
    },
    'Push Notifications': {
      'hi': 'पुश सूचनाएं',
      'bn': 'পুশ বিজ্ঞপ্তি',
      'te': 'పుష్ నోటిఫికేషన్‌లు',
      'mr': 'पुश सूचना',
      'ta': 'புஷ் அறிவிப்புகள்',
      'gu': 'પુશ સૂચનાઓ',
      'kn': 'ಪುಷ್ ಅಧಿಸೂಚನೆಗಳು',
      'ur': 'پش اطلاعات',
      'ml': 'പുഷ് അറിയിപ്പുകൾ',
    },
    'WhatsApp Notifications': {
      'hi': 'व्हाट्सएप सूचनाएं',
      'bn': 'হোয়াটসঅ্যাপ বিজ্ঞপ্তি',
      'te': 'వాట్సాప్ నోటిఫికేషన్‌లు',
      'mr': 'व्हाट्सअॅप सूचना',
      'ta': 'வாட்ஸ்அப் அறிவிப்புகள்',
      'gu': 'વોટ્સએપ સૂચનાઓ',
      'kn': 'ವಾಟ್ಸಾಪ್ ಅಧಿಸೂಚನೆಗಳು',
      'ur': 'واٹس ایپ اطلاعات',
      'ml': 'വാട്സാപ്പ് അറിയിപ്പുകൾ',
    },
    'New Ticket': {
      'hi': 'नया टिकट',
      'bn': 'নতুন টিকিট',
      'te': 'కొత్త టికెట్',
      'mr': 'नवीन तिकीट',
      'ta': 'புதிய டிக்கெட்',
      'gu': 'નવું ટિકિટ',
      'kn': 'ಹೊಸ ಟಿಕೆಟ್',
      'ur': 'نیا ٹکٹ',
      'ml': 'പുതിയ ടിക്കറ്റ്',
    },
    'Clear Filters': {
      'hi': 'फ़िल्टर साफ़ करें',
      'bn': 'ফিল্টার সাফ করুন',
      'te': 'ఫిల్టర్‌లను క్లియర్ చేయండి',
      'mr': 'फिल्टर साफ करा',
      'ta': 'வடிகட்டிகளை அழிக்க',
      'gu': 'ફિલ્ટર સાફ કરો',
      'kn': 'ಫಿಲ್ಟರ್‌ಗಳನ್ನು ತೆರವುಗೊಳಿಸಿ',
      'ur': 'فلٹر صاف کریں',
      'ml': 'ഫിൽട്ടറുകൾ മായ്ക്കുക',
    },
    'Retry': {
      'hi': 'पुनः प्रयास करें',
      'bn': 'পুনরায় চেষ্টা করুন',
      'te': 'మళ్లీ ప్రయత్నించండి',
      'mr': 'पुन्हा प्रयत्न करा',
      'ta': 'மீண்டும் முயற்சிக்கவும்',
      'gu': 'ફરી પ્રયાસ કરો',
      'kn': 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ',
      'ur': 'دوبارہ کوشش کریں',
      'ml': 'വീണ്ടും ശ്രമിക്കുക',
    },
    // Zodiac Signs
    'Aries': {'hi': 'मेष'},
    'Taurus': {'hi': 'वृषभ'},
    'Gemini': {'hi': 'मिथुन'},
    'Cancer': {'hi': 'कर्क'},
    'Leo': {'hi': 'सिंह'},
    'Virgo': {'hi': 'कन्या'},
    'Libra': {'hi': 'तुला'},
    'Scorpio': {'hi': 'वृश्चिक'},
    'Sagittarius': {'hi': 'धनु'},
    'Capricorn': {'hi': 'मकर'},
    'Aquarius': {'hi': 'कुंभ'},
    'Pisces': {'hi': 'मीन'},
    'ARIES': {'hi': 'मेष'},
    'TAURUS': {'hi': 'वृषभ'},
    'GEMINI': {'hi': 'मिथुन'},
    'CANCER': {'hi': 'कर्क'},
    'LEO': {'hi': 'सिंह'},
    'VIRGO': {'hi': 'कन्या'},
    'LIBRA': {'hi': 'तुला'},
    'SCORPIO': {'hi': 'वृश्चिक'},
    'SAGITTARIUS': {'hi': 'धनु'},
    'CAPRICORN': {'hi': 'मकर'},
    'AQUARIUS': {'hi': 'कुंभ'},
    'PISCES': {'hi': 'मीन'},
    // Specific Product Terms
    'Karungali': {'hi': 'करुंगली'},
    'KARUNGALI': {'hi': 'करुंगली'},
    'karungali': {'hi': 'करुंगली'},
    'Karungali Bracelet': {'hi': 'करुंगली ब्रेसलेट'},
    'KARUNGALI BRACELET': {'hi': 'करुंगली ब्रेसलेट'},
    // App Tagline - DO NOT TRANSLATE
    'STAR ALIGN DESTINY DIVINE': {
      'hi': 'STAR ALIGN DESTINY DIVINE',
      'bn': 'STAR ALIGN DESTINY DIVINE',
      'te': 'STAR ALIGN DESTINY DIVINE',
      'mr': 'STAR ALIGN DESTINY DIVINE',
      'ta': 'STAR ALIGN DESTINY DIVINE',
      'gu': 'STAR ALIGN DESTINY DIVINE',
      'kn': 'STAR ALIGN DESTINY DIVINE',
      'ur': 'STAR ALIGN DESTINY DIVINE',
      'ml': 'STAR ALIGN DESTINY DIVINE',
    },
    'Stars Align, Destiny Divine': {
      'hi': 'Stars Align, Destiny Divine',
      'bn': 'Stars Align, Destiny Divine',
      'te': 'Stars Align, Destiny Divine',
      'mr': 'Stars Align, Destiny Divine',
      'ta': 'Stars Align, Destiny Divine',
      'gu': 'Stars Align, Destiny Divine',
      'kn': 'Stars Align, Destiny Divine',
      'ur': 'Stars Align, Destiny Divine',
      'ml': 'Stars Align, Destiny Divine',
    },
    'Free': {
      'hi': 'फ्री',
      'bn': 'বিনামূল্যে',
      'te': 'ఉచితం',
      'mr': 'मोफत',
      'ta': 'இலவசம்',
      'gu': 'મફત',
      'kn': 'ಉಚಿತ',
      'ur': 'مفت',
      'ml': 'സൗജന്യം',
    },
    'Followers': {
      'hi': 'फ़ॉलोअर्स',
      'bn': 'অনুসারী',
      'te': 'అనుచరులు',
      'mr': 'फॉलोअर्स',
      'ta': 'பின்தொடர்பவர்கள்',
      'gu': 'અનુયાયીઓ',
      'kn': 'ಅನುಯಾಯಿಗಳು',
      'ur': 'فالوورز',
      'ml': 'അനുയായികൾ',
    },
    'YouTube': {
      'hi': 'यूट्यूब',
      'bn': 'ইউটিউব',
      'te': 'యూట్యూబ్',
      'mr': 'यूट्यूब',
      'ta': 'யூடியூப்',
      'gu': 'યુટ્યુબ',
      'kn': 'ಯೂಟ್ಯೂಬ್',
      'ur': 'یوٹیوب',
      'ml': 'യೂട್ಯೂബ്',
    },
    'Instagram': {
      'hi': 'इंस्टाग्राम',
      'bn': 'ইনস্টাগ্রাম',
      'te': 'ఇన్‌స్టాగ్రామ్',
      'mr': 'इंस्टाग्राम',
      'ta': 'இன்ஸ்டாகிராம்',
      'gu': 'ઇન્સ્ટાગ્રામ',
      'kn': 'ಇನ್‌ಸ್ಟಾಗ್ರಾಮ್',
      'ur': 'انسٹاگرام',
      'ml': 'ഇൻസ്റ്റാഗ്രாம்',
    },
    // Course type: academic Bachelor degree (not "unmarried")
    'Bachelor': {'hi': 'स्नातक'},
    'Bachelor Course': {'hi': 'स्नातक पाठ्यक्रम'},
  };

  /// Get override translation for a text and language
  /// Returns null if no override exists
  static String? getOverride(String englishText, String targetLanguageCode) {
    final override = _overrides[englishText];
    if (override == null) return null;

    // Return override if exists, otherwise return null (use ML Kit)
    return override[targetLanguageCode];
  }

  /// Check if an override exists for the given text
  static bool hasOverride(String englishText) {
    return _overrides.containsKey(englishText);
  }

  /// Add a new override (for runtime additions if needed)
  static void addOverride(
    String englishText,
    String languageCode,
    String translation,
  ) {
    _overrides.putIfAbsent(englishText, () => {});
    _overrides[englishText]![languageCode] = translation;
  }

  /// Get all overrides for a specific language
  static Map<String, String> getOverridesForLanguage(String languageCode) {
    final result = <String, String>{};
    for (final entry in _overrides.entries) {
      final translation = entry.value[languageCode];
      if (translation != null && translation.isNotEmpty) {
        result[entry.key] = translation;
      }
    }
    return result;
  }
}
