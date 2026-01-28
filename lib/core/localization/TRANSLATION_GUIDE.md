# Dynamic Multi-Language Translation System

This app supports **23 languages** with a dynamic translation system using:
- **easy_localization** for static UI text (buttons, labels, menus)
- **google_mlkit_translation** for dynamic content (API data, chat messages)

## Architecture

### 1. Static Translations (easy_localization)
- **Location**: `assets/translations/{language_code}.json`
- **Usage**: For all UI text, buttons, labels, navigation tabs
- **Example**: `'auth.login'.tr()`

### 2. Dynamic Translations (MLKit)
- **Service**: `MLKitTranslationService`
- **Usage**: For API content, chat messages, product descriptions
- **Example**: `await TranslationHelper.translateDynamicContent(...)`

## Supported Languages (23)

1. English (en) - Main language
2. Hindi (hi)
3. Bengali (bn)
4. Telugu (te)
5. Marathi (mr)
6. Tamil (ta)
7. Gujarati (gu)
8. Urdu (ur)
9. Kannada (kn)
10. Malayalam (ml)
11. Odia (or)
12. Punjabi (pa)
13. Assamese (as)
14. Maithili (mai)
15. Bodo (bh)
16. Kashmiri (ks)
17. Konkani (kok)
18. Nepali (ne)
19. Sindhi (sd)
20. Sanskrit (sa)
21. Manipuri (mni)
22. Santali (sat)
23. Dogri (doi)

## Usage

### For Static UI Text

Replace hardcoded strings with translation keys:

```dart
// Before
Text('Login')

// After
Text('auth.login'.tr())
```

### Translation Key Structure

Keys follow the pattern: `{section}.{key}`

- `common.appName` - App name
- `auth.login` - Login button
- `auth.signUp` - Sign up button
- `navigation.home` - Home tab
- `navigation.horoscope` - Horoscope tab
- `navigation.shop` - Shop tab
- `navigation.chat` - Chat tab
- `profile.profile` - Profile tab
- etc.

### For Dynamic Content (API/User-Generated)

Use MLKit translation service:

```dart
import 'package:astrobharataiuser/core/utils/translation_helper.dart';
import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

// Get current language
final languageController = Get.find<LanguageController>();
final targetLanguage = languageController.currentLanguageCode;

// Translate dynamic content
final translatedText = await TranslationHelper.translateDynamicContent(
  text: apiContent,
  sourceLanguageCode: 'en', // Assuming API returns English
  targetLanguageCode: targetLanguage,
);
```

### Changing Language

```dart
import 'package:astrobharataiuser/core/localization/language_controller.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

// Get language controller
final languageController = Get.find<LanguageController>();

// Get all available languages
final languages = await LanguageModelService.getLanguages();

// Change language
await languageController.changeLanguage(selectedLanguage);
```

## Translation Files

### Structure
Each language file (`assets/translations/{code}.json`) follows this structure:

```json
{
  "common": {
    "appName": "Astrology App"
  },
  "auth": {
    "login": "Login",
    "signUp": "Sign Up",
    ...
  },
  "navigation": {
    "home": "Home",
    "horoscope": "Horoscope",
    "shop": "Shop",
    "chat": "Chat"
  },
  ...
}
```

### Adding New Translations

1. Add the key-value pair to `assets/translations/en.json`
2. Copy the key to all other language files
3. Translate the value in each language file
4. Use `'section.key'.tr()` in your code

### Fallback Behavior

- If a translation key is missing in a language file, easy_localization will use the English fallback
- If MLKit doesn't support a language, it will return the original text

## Creating Translation Files

To create translation files for all 23 languages, you can:

1. **Copy English file**: Copy `en.json` to all other language codes
2. **Translate manually**: Translate each value in the JSON files
3. **Use translation tools**: Use Google Translate API or similar services to batch translate

### Quick Setup Script

You can create a simple script to generate all translation files:

```dart
// Run this in a Dart script to generate all language files
import 'dart:io';
import 'dart:convert';

void main() async {
  final enFile = File('assets/translations/en.json');
  final enContent = json.decode(await enFile.readAsString());
  
  final languages = ['hi', 'bn', 'te', 'mr', 'ta', 'gu', 'ur', 'kn', 'ml', 'or', 'pa', 'as', 'mai', 'bh', 'ks', 'kok', 'ne', 'sd', 'sa', 'mni', 'sat', 'doi'];
  
  for (final lang in languages) {
    final file = File('assets/translations/$lang.json');
    await file.writeAsString(
      JsonEncoder.withIndent('  ').convert(enContent),
    );
  }
}
```

## Best Practices

1. **Always use translation keys** for static text - never hardcode strings
2. **Use MLKit for dynamic content** - API responses, user messages, etc.
3. **Test with different languages** - Ensure UI works with RTL languages
4. **Keep translations updated** - When adding new features, update all language files
5. **Handle missing translations gracefully** - The system will fallback to English

## Troubleshooting

### "Translation key not found"
- Ensure the key exists in `en.json`
- Check the key format: `section.key`
- Run `flutter pub get` to ensure assets are loaded

### "Language not changing"
- Check that the language file exists in `assets/translations/`
- Verify `LanguageController` is initialized
- Ensure `EasyLocalization` is properly set up in `main.dart`

### "MLKit translation not working"
- Check if the language is supported by MLKit
- Ensure MLKit models are downloaded (they download automatically on first use)
- Check device has internet connection for initial model download

## Files Structure

```
lib/
├── core/
│   ├── models/
│   │   └── app_language_model.dart      # Dynamic language model
│   ├── services/
│   │   ├── language_service.dart         # Language storage service
│   │   └── mlkit_translation_service.dart # MLKit translation service
│   ├── localization/
│   │   ├── language_controller.dart     # Language state management
│   │   └── TRANSLATION_GUIDE.md         # This file
│   └── utils/
│       └── translation_helper.dart      # Translation utilities
assets/
├── languages.json                        # All 23 languages metadata
└── translations/
    ├── en.json                          # English translations
    ├── hi.json                          # Hindi translations
    ├── bn.json                          # Bengali translations
    └── ...                              # All 23 language files
```

## Notes

- The system is fully dynamic - adding new languages only requires:
  1. Adding the language to `assets/languages.json`
  2. Creating a translation file in `assets/translations/{code}.json`
  3. No code changes needed!

- MLKit translation works offline after initial model download
- Static translations are loaded from JSON files (no network required)
- Both systems work seamlessly together for a complete translation experience








