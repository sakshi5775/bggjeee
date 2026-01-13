# Language Change Functionality - Usage Examples

## Quick Start Guide

### 1. For Static UI Strings (Most Common)

Replace all `Text` widgets with `LocalizedText`:

```dart
// ❌ Before
Text('Login', style: MyTextTheme.largeBCB)

// ✅ After
import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/core/localization/translations.dart' as AppTranslations;

LocalizedText(
  text: AppTranslations.Translations.login,
  style: MyTextTheme.largeBCB,
)
```

### 2. For Dynamic Content from API (English Only)

If your API returns English content only:

```dart
// API returns: blog.title = "Understanding Vedic Astrology"
LocalizedText(
  text: blog.title,
  style: MyTextTheme.largeBCB,
)
```

### 3. For Dynamic Content from API (With Translation Support)

If your API supports language parameter and returns translated content:

**Step 1: Add LanguageApiMixin to your controller**

```dart
import 'package:astrobharataiuser/core/base/language_api_mixin.dart';

class AllBlogsController extends BaseController with LanguageApiMixin {
  // ... existing code ...
  
  Future<void> loadBlogs() async {
    // Add language parameter to query
    final query = createQueryWithLanguage({
      'page': 1,
      'limit': 10,
      'status': selectedStatus,
    });
    // query now contains {'page': 1, 'limit': 10, 'status': 'active', 'lang': 'en'}
    
    final response = await _blogService.getBlogs(query: query);
    // API will return content based on 'lang' parameter
  }
}
```

**Step 2: Display API content (which is already translated by backend)**

```dart
// API returns translated content based on lang parameter
LocalizedText(
  text: blog.title, // Already translated by backend
  style: MyTextTheme.largeBCB,
)
```

### 4. For Dynamic Content with Translation Map

If your API returns content in multiple languages:

```dart
// API response structure:
// {
//   "title": {
//     "en": "Understanding Vedic Astrology",
//     "hi": "वैदिक ज्योतिष को समझना"
//   }
// }

LocalizedText(
  text: blog.title['en'] ?? '', // Fallback
  translationMap: blog.title, // Map with 'en' and 'hi' keys
  style: MyTextTheme.largeBCB,
)
```

### 5. Adding Language Selector to Any Screen

```dart
import 'package:astrobharataiuser/app_manager/widgets/language_selector_widget.dart';

// Option 1: Show as dialog
IconButton(
  onPressed: () => LanguageSelectorDialog.show(),
  icon: Icon(Icons.language),
)

// Option 2: Show in settings screen
LanguageSelectorWidget()
```

### 6. Programmatically Change Language

```dart
import 'package:astrobharataiuser/core/enums/app_language.dart';
import 'package:astrobharataiuser/core/localization/language_controller.dart';

final languageController = Get.find<LanguageController>();
await languageController.changeLanguage(AppLanguage.hindi);
```

## Complete Example: Blog List Screen

```dart
import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/core/base/language_api_mixin.dart';
import 'package:astrobharataiuser/core/localization/translations.dart' as AppTranslations;

// Controller
class AllBlogsController extends BaseController with LanguageApiMixin {
  final blogs = <Blog>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadBlogs();
  }
  
  Future<void> loadBlogs() async {
    setLoadingState(true);
    try {
      // Add language parameter automatically
      final query = createQueryWithLanguage({
        'page': 1,
        'limit': 10,
      });
      
      final response = await _blogService.getBlogs(query: query);
      blogs.value = response.data ?? [];
    } catch (e) {
      showErrorMessage(message: e.toString());
    } finally {
      setLoadingState(false);
    }
  }
}

// View
class AllBlogsView extends BasePage<AllBlogsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          text: AppTranslations.Translations.myBlogs,
          style: MyTextTheme.largeBCB,
        ),
        actions: [
          IconButton(
            onPressed: () => LanguageSelectorDialog.show(),
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.blogs.length,
        itemBuilder: (context, index) {
          final blog = controller.blogs[index];
          return Card(
            child: ListTile(
              title: LocalizedText(
                text: blog.title, // Already translated by API
                style: MyTextTheme.mediumBCB,
              ),
              subtitle: LocalizedText(
                text: blog.excerpt ?? '',
                style: MyTextTheme.smallBCN,
              ),
            ),
          );
        },
      )),
    );
  }
}
```

## Best Practices

1. ✅ **Always use LocalizedText for static strings** - Replace all `Text` widgets
2. ✅ **Add LanguageApiMixin to controllers** that make API calls
3. ✅ **Use `createQueryWithLanguage()`** to add language parameter
4. ✅ **Test both languages** to ensure proper display
5. ✅ **Add language selector** in settings/profile screens
6. ❌ **Don't hardcode text strings** - Use Translations class
7. ❌ **Don't forget to add language parameter** to API calls

## Migration Checklist

When updating a screen:

- [ ] Import `localized_text.dart` and `translations.dart`
- [ ] Replace all `Text` widgets with `LocalizedText`
- [ ] Use `AppTranslations.Translations.*` for static strings
- [ ] Add `LanguageApiMixin` to controller if making API calls
- [ ] Use `createQueryWithLanguage()` for API query parameters
- [ ] Test with both English and Hindi
- [ ] Add language selector button if needed

