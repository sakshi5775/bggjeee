# Translation Overrides Guide

## ✅ Problem Solved

ML Kit sometimes translates UI terms incorrectly. For example:
- "Call" → "पुकारना" (to shout) ❌
- Should be → "कॉल करें" (phone call) ✅

## 🎯 Solution

A **Translation Override System** has been created that:
1. Checks manual overrides **BEFORE** using ML Kit
2. Ensures accurate translations for UI terms
3. Uses hardcoded Dart (no JSON files)
4. Automatically integrated with `AutoTranslateText`

## 📁 Files

- **Override Definitions**: `lib/core/localization/translation_overrides.dart`
- **Service Integration**: `lib/core/services/mlkit_translation_service_v2.dart`

## ➕ How to Add New Overrides

### Step 1: Open the Override File

Open: `lib/core/localization/translation_overrides.dart`

### Step 2: Add Your Override

Find the `_overrides` map and add your entry:

```dart
'Your English Text': {
  'hi': 'हिंदी अनुवाद',
  'bn': 'বাংলা অনুবাদ',
  'te': 'తెలుగు అనువాదం',
  'mr': 'मराठी भाषांतर',
  'ta': 'தமிழ் மொழிபெயர்ப்பு',
  'gu': 'ગુજરાતી અનુવાદ',
  'kn': 'ಕನ್ನಡ ಅನುವಾದ',
  'ur': 'اردو ترجمہ',
  'ml': 'മലയാളം വിവർത്തനം',
},
```

### Step 3: Test

1. Run the app
2. Change language
3. Verify the translation is correct

## 🔍 Current Overrides

The following UI terms have overrides:

- ✅ **Call** - Fixed phone call translation
- ✅ **Chat** - Correct chat translation
- ✅ **Call and Chat** - Combined button text
- ✅ **View All** - Navigation text
- ✅ **OUR SERVICES** - Section header
- ✅ **Hide** - Toggle button
- ✅ **Home, Shop, Education, Profile** - Navigation tabs
- ✅ **Featured Products** - E-commerce section
- ✅ **Shop by Category** - E-commerce filter
- ✅ **Best Sellers** - Product section
- ✅ **Recommended for you** - Product section
- ✅ **Recently viewed** - Product section
- ✅ **Shopping Cart** - E-commerce
- ✅ **Contact Support** - Profile section
- ✅ **Notification Settings** - Profile section
- ✅ **Email/SMS/Push/WhatsApp Notifications** - Settings
- ✅ **New Ticket** - Support section
- ✅ **Clear Filters** - Filter section
- ✅ **Retry** - Error handling

## 🧪 How to Find Text That Needs Override

1. **Run the app** in a non-English language
2. **Look for incorrect translations**
3. **Note the English text** (exact match, case-sensitive)
4. **Add to overrides** with correct translation

## 📝 Example: Adding "Add to Cart" Override

```dart
'Add to Cart': {
  'hi': 'कार्ट में जोड़ें',
  'bn': 'কার্টে যোগ করুন',
  'te': 'కార్ట్‌లో జోడించండి',
  'mr': 'कार्टमध्ये जोडा',
  'ta': 'கார்ட்டில் சேர்',
  'gu': 'કાર્ટમાં ઉમેરો',
  'kn': 'ಕಾರ್ಟ್‌ಗೆ ಸೇರಿಸಿ',
  'ur': 'کارٹ میں شامل کریں',
  'ml': 'കാർട്ടിലേക്ക് ചേർക്കുക',
},
```

## ⚠️ Important Notes

1. **Case-Sensitive**: Override keys must match exactly (including capitalization)
2. **Trim Whitespace**: The system automatically trims text before checking overrides
3. **Empty String**: If you want ML Kit to translate (no override), use empty string `""`
4. **Language Codes**: Use 2-letter codes: `hi`, `bn`, `te`, `mr`, `ta`, `gu`, `kn`, `ur`, `ml`

## 🚀 Performance

- Overrides are checked **before** ML Kit translation
- Overrides are **cached** like ML Kit translations
- **Zero performance impact** - instant lookup

## ✅ Verification Checklist

After adding overrides:

- [ ] Test in Hindi (hi)
- [ ] Test in Bengali (bn)
- [ ] Test in Telugu (te)
- [ ] Test in Marathi (mr)
- [ ] Test in Tamil (ta)
- [ ] Test in Gujarati (gu)
- [ ] Test in Kannada (kn)
- [ ] Test in Urdu (ur)
- [ ] Test in Malayalam (ml)

## 🎯 Best Practices

1. **Add overrides for common UI terms** (buttons, labels, navigation)
2. **Let ML Kit handle dynamic content** (user messages, product descriptions)
3. **Test thoroughly** before committing
4. **Document why** an override was needed (add comment if complex)

## 📞 Need Help?

If you find incorrect translations:
1. Note the English text (exact)
2. Note the incorrect translation
3. Note the correct translation
4. Add to `translation_overrides.dart`









