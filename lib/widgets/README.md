# AutoTranslateText Widget

## Quick Start

`AutoTranslateText` is a drop-in replacement for Flutter's `AutoTranslateText` widget that automatically translates English text to the user's selected language.

### Basic Usage

```dart
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

// Simple usage
AutoTranslateText('Hello World')

// With styling
AutoTranslateText(
  'Welcome to our app',
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)

// With all AutoTranslateText widget properties
AutoTranslateText(
  'Click here to continue',
  style: TextStyle(color: Colors.blue),
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Extension Method

```dart
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

'Hello World'.toAutoTranslate(style: TextStyle(fontSize: 16))
```

### Disable Translation

For critical text that should not be translated (legal, OTP, etc.):

```dart
AutoTranslateText('OTP: 123456', translate: false)
```

### Migration from AutoTranslateText

```dart
// Before
AutoTranslateText('Login', style: MyTextTheme.largeBCB)

// After
AutoTranslateText('Login', style: MyTextTheme.largeBCB)
```

## Features

- ✅ Zero configuration needed
- ✅ Automatic translation based on current language
- ✅ Aggressive caching (no repeated translations)
- ✅ No UI flicker
- ✅ Fail-safe (falls back to English)
- ✅ Works with all AutoTranslateText widget properties

## Performance

- Translations are cached at the service level
- Same text is translated only once
- Original text shown while translating
- No blocking operations

## Notes

- Only English text should be passed to `AutoTranslateText`
- Translations happen automatically based on `LanguageControllerV2`
- Unsupported languages will show English text










