# Localization System

This app supports English and Hindi languages. The localization system is designed to work with both static content (app UI strings) and dynamic content from APIs.

## Components

### 1. AppLanguage Enum (`lib/core/enums/app_language.dart`)
- Defines supported languages (English, Hindi)
- Each language has a code, English name, and native name

### 2. LanguageController (`lib/core/localization/language_controller.dart`)
- Manages the current language state
- Persists language preference using GetStorage
- Updates app locale when language changes

### 3. LanguageService (`lib/core/services/language_service.dart`)
- Handles language preference storage
- Retrieves saved language on app startup

### 4. Translations (`lib/core/localization/translations.dart`)
- Static translations for app UI strings
- Use `AppTranslations.Translations.login` to get translated text

### 5. LocalizedText Widget (`lib/app_manager/localized_text.dart`)
- Reusable widget that replaces `Text` widget
- Automatically reacts to language changes
- Supports both static translations and dynamic API content

## Usage

### For Static Content (UI Strings)

Replace `Text` widgets with `LocalizedText`:

```dart
// Before
Text('Login', style: MyTextTheme.largeBCB)

// After
LocalizedText(
  text: AppTranslations.Translations.login,
  style: MyTextTheme.largeBCB,
)
```

### For Dynamic Content from APIs

#### Option 1: API Returns Translated Content

If your API returns content based on language parameter, use it directly:

```dart
// API call with language parameter
final query = {'lang': languageController.currentLanguageCode};
final response = await getBlogs(query);

// Display API content
LocalizedText(
  text: blog.title, // API returns translated title based on lang param
  style: MyTextTheme.largeBCB,
)
```

#### Option 2: API Returns Multi-language Content

If your API returns content with multiple language fields:

```dart
// API response: 
// {
//   "title": {"en": "Blog Title", "hi": "ब्लॉग शीर्षक"},
//   "content": {"en": "Content", "hi": "सामग्री"}
// }

LocalizedText(
  text: blog.title['en'], // Fallback
  translationMap: blog.title, // Map with 'en' and 'hi' keys
  style: MyTextTheme.largeBCB,
)
```

#### Option 3: API Doesn't Support Translation

If API doesn't support translation, use English content:

```dart
LocalizedText(
  text: blog.title, // Always English from API
  style: MyTextTheme.largeBCB,
)
```

### Adding Language Parameter to API Calls

Use `LanguageApiMixin` in your controllers:

```dart
class MyController extends BaseController with LanguageApiMixin {
  Future<void> loadBlogs() async {
    final query = createQueryWithLanguage({
      'page': 1,
      'limit': 10,
    });
    // query now contains {'page': 1, 'limit': 10, 'lang': 'en'} or {'lang': 'hi'}
    
    final response = await _apiRepository.getApi(
      EndPoints.blogs,
      query: query,
    );
  }
}
```

## Changing Language

### Using Language Selector Widget

```dart
// Show language selector dialog
LanguageSelectorDialog.show();

// Or use the widget directly in settings
LanguageSelectorWidget()
```

### Programmatically

```dart
final languageController = Get.find<LanguageController>();
await languageController.changeLanguage(AppLanguage.hindi);
```

## Adding New Translations

1. Add new translation strings to `Translations` class:

```dart
// In lib/core/localization/translations.dart
static String get newFeature => _getTranslation('New Feature', 'नई सुविधा');
```

2. Use in your widgets:

```dart
LocalizedText(
  text: AppTranslations.Translations.newFeature,
  style: MyTextTheme.largeBCB,
)
```

## Best Practices

1. **Always use LocalizedText instead of Text** for user-facing strings
2. **Pass language parameter to API calls** using `LanguageApiMixin`
3. **Handle dynamic content appropriately** based on your API structure
4. **Add translations to Translations class** for all static strings
5. **Test both languages** to ensure proper display

## Example: Complete Usage in a Screen

```dart
import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/core/localization/translations.dart' as AppTranslations;
import 'package:astrobharataiuser/core/base/language_api_mixin.dart';

class MyScreen extends BasePage<MyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          text: AppTranslations.Translations.myScreen,
          style: MyTextTheme.largeBCB,
        ),
      ),
      body: Column(
        children: [
          // Static translation
          LocalizedText(
            text: AppTranslations.Translations.welcome,
            style: MyTextTheme.largeBCB,
          ),
          
          // Dynamic content from API (if API supports translation)
          Obx(() => LocalizedText(
            text: controller.blogTitle.value,
            style: MyTextTheme.mediumBCB,
          )),
          
          // Dynamic content with translation map
          Obx(() => LocalizedText(
            text: controller.blogContent.value['en'] ?? '',
            translationMap: controller.blogContent.value,
            style: MyTextTheme.mediumBCN,
          )),
        ],
      ),
    );
  }
}

// Controller with API language support
class MyController extends BaseController with LanguageApiMixin {
  Future<void> loadData() async {
    final query = createQueryWithLanguage({'page': 1});
    await _apiRepository.getApi(EndPoints.blogs, query: query);
  }
}
```

