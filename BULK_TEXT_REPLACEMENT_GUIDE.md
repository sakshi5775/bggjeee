# Bulk Text Replacement Guide

## Quick Fix: Replace All Text with AutoTranslateText

To make ALL text in the app translate automatically, follow these steps:

### Method 1: IDE Find & Replace (Recommended)

1. **Open the file** you want to update (e.g., `lib/screens/user_dashboard/view/user_dashboard_view.dart`)

2. **Find & Replace:**
   - **Find:** `Text(`
   - **Replace:** `AutoTranslateText(`
   - **Scope:** Current file or entire project

3. **Add import** at the top of the file:
   ```dart
   import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
   ```

4. **Important:** Some Text widgets might need special handling:
   - **User input** (TextField, TextFormField) - Keep as Text, don't translate
   - **Dynamic API content** - Already translated by API, keep as Text
   - **Numbers, dates, codes** - Keep as Text (no translation needed)

### Method 2: Use the T() Helper (Easier)

1. **Import the helper:**
   ```dart
   import 'package:astrobharataiuser/utils/text_replacement_helper.dart';
   ```

2. **Replace Text with T:**
   - **Find:** `Text(`
   - **Replace:** `T(`
   - This is a shorter alias for AutoTranslateText

### Method 3: Use String Extension

```dart
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

// Instead of:
Text('Hello', style: TextStyle(fontSize: 16))

// Use:
'Hello'.toAutoTranslate(style: TextStyle(fontSize: 16))
```

## Files to Update (Priority Order)

1. ✅ `lib/screens/user_dashboard/view/user_dashboard_view.dart` - **PARTIALLY DONE**
   - Already updated: "OUR SERVICES", "View All", service cards, hero section
   - Still need: ~90 more Text widgets

2. `lib/screens/user_dashboard/widgets/user_bottom_nav.dart` - Bottom navigation labels

3. All other screen files in `lib/screens/`

## What NOT to Replace

❌ **Don't replace these:**
- `TextField` or `TextFormField` - User input
- Text from API responses (already translated)
- Numbers, dates, phone numbers
- Error messages that come from backend
- URLs, email addresses

✅ **DO replace these:**
- Static UI labels ("Home", "Shop", "Profile")
- Button text ("Submit", "Cancel", "Save")
- Section headers ("OUR SERVICES", "Featured Products")
- Placeholder text in search bars
- Menu items, navigation labels

## Verification

After replacement:
1. Change language in app
2. All replaced text should translate instantly
3. Check console for translation logs
4. Verify UI updates without flicker

## Performance Note

- Translations are cached automatically
- First translation may take 100-200ms
- Subsequent translations are instant (from cache)
- No performance impact on scrolling










