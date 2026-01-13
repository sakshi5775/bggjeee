# Translation Instructions - How to Translate Your App

## Current Status

✅ **System is ready** - All 23 language JSON files are created
⚠️ **Files are placeholders** - Currently all files contain English text (copied from `en.json`)

## What You Need to Do

### Step 1: Translate Each Language File

Each language file needs to be translated. Currently all files are identical to `en.json`.

**Example: Hindi Translation (`hi.json`)**

```json
{
  "common": {
    "appName": "ज्योतिष ऐप"
  },
  "auth": {
    "login": "लॉगिन",
    "signUp": "साइन अप",
    "email": "ईमेल",
    "password": "पासवर्ड",
    ...
  },
  "navigation": {
    "home": "होम",
    "horoscope": "राशिफल",
    "shop": "दुकान",
    "chat": "चैट"
  }
}
```

### Step 2: Translation Files to Update

You need to translate these 22 files (English is already done):

1. `hi.json` - Hindi (हिन्दी)
2. `bn.json` - Bengali (বাংলা)
3. `te.json` - Telugu (తెలుగు)
4. `mr.json` - Marathi (मराठी)
5. `ta.json` - Tamil (தமிழ்)
6. `gu.json` - Gujarati (ગુજરાતી)
7. `ur.json` - Urdu (اردو)
8. `kn.json` - Kannada (ಕನ್ನಡ)
9. `ml.json` - Malayalam (മലയാളം)
10. `or.json` - Odia (ଓଡ଼ିଆ)
11. `pa.json` - Punjabi (ਪੰਜਾਬੀ)
12. `as.json` - Assamese (অসমীয়া)
13. `mai.json` - Maithili (मैथिली)
14. `bh.json` - Bodo (बोड़ो)
15. `ks.json` - Kashmiri (कॉशुर / كشميري)
16. `kok.json` - Konkani (कोंकणी)
17. `ne.json` - Nepali (नेपाली)
18. `sd.json` - Sindhi (سنڌي)
19. `sa.json` - Sanskrit (संस्कृतम्)
20. `mni.json` - Manipuri (মৈতৈলোন্ / মণিপুরী)
21. `sat.json` - Santali (ᱥᱟᱱᱛᱟᱲᱤ)
22. `doi.json` - Dogri (डोगरी)

### Step 3: How to Translate

**Option A: Manual Translation**
- Open each JSON file
- Translate each value (keep the keys the same)
- Save the file

**Option B: Use Translation Services**
- Use Google Translate API
- Use DeepL API
- Use professional translation services
- Use MLKit translation service (for dynamic content)

**Option C: Use Translation Tools**
- Copy `en.json` content to Google Translate
- Translate to target language
- Copy translated content back to JSON file
- Clean up formatting

### Step 4: Test Translation

After translating:
1. Select the language in the app
2. Check if all text is translated
3. Verify UI looks correct
4. Test with different languages

## Important Notes

### Keep Keys the Same
✅ **DO**: Translate only the values
```json
{
  "auth": {
    "login": "लॉगिन"  // ✅ Translated value
  }
}
```

❌ **DON'T**: Change the keys
```json
{
  "auth": {
    "loginKey": "लॉगिन"  // ❌ Wrong - key changed
  }
}
```

### Maintain JSON Structure
- Keep the same structure in all files
- All keys must match exactly
- Use proper JSON formatting
- Use UTF-8 encoding for special characters

### Missing Translations
If a translation is missing:
- The app will fallback to English (`en.json`)
- The app will still work, just show English text

## Quick Start Translation

For a quick start, you can:

1. **Start with Major Languages First**:
   - Hindi (hi.json)
   - Bengali (bn.json)
   - Telugu (te.json)
   - Marathi (mr.json)
   - Tamil (ta.json)
   - Gujarati (gu.json)
   - Urdu (ur.json)
   - Kannada (kn.json)
   - Malayalam (ml.json)

2. **Use Translation Services**:
   - Google Translate (free, but may need formatting)
   - Professional translators (best quality)
   - Translation APIs (automated)

3. **Test Each Language**:
   - After translating a file, test it in the app
   - Make sure all keys are translated
   - Check for any formatting issues

## Example Translation Workflow

1. Open `hi.json` (Hindi)
2. Copy content from `en.json`
3. Translate using your preferred method
4. Replace English text with Hindi text
5. Save file
6. Test in app
7. Repeat for other languages

## Current Translation Status

| Language | File | Status |
|----------|------|--------|
| English | `en.json` | ✅ Complete |
| Hindi | `hi.json` | ⚠️ Needs translation |
| Bengali | `bn.json` | ⚠️ Needs translation |
| Telugu | `te.json` | ⚠️ Needs translation |
| ... | ... | ⚠️ Needs translation |

## How It Works

1. User selects a language (e.g., Hindi)
2. App loads `hi.json` file
3. All `'section.key'.tr()` calls return Hindi text
4. Entire app UI updates to Hindi
5. Dynamic content can use MLKit for translation

## Need Help?

- Check `lib/core/localization/TRANSLATION_GUIDE.md` for detailed guide
- All translation files are in `assets/translations/`
- Main language is English (`en.json`)
- All 23 languages are supported








