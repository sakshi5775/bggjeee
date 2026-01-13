# Complete App Translation Guide

## ✅ Already Completed
- ✅ `user_dashboard_view.dart` - All Text widgets replaced
- ✅ `user_bottom_nav.dart` - Navigation labels replaced
- ✅ `ecommerce_home_view.dart` - All section titles replaced

## 🔄 Quick Bulk Replacement Method

### For VS Code / Android Studio:

1. **Open Find & Replace (Ctrl+Shift+H / Cmd+Shift+H)**

2. **Find:** `Text(`
   **Replace:** `AutoTranslateText(`
   **Scope:** Entire Project

3. **Add Import to each file:**
   ```dart
   import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
   ```

4. **Manual Review Required:**
   - Keep `Text` for user input (TextField, TextFormField)
   - Keep `Text` for dynamic API content
   - Keep `Text` for numbers, dates, codes

### Alternative: Use T() Helper

1. **Find:** `Text(`
   **Replace:** `T(`
   **Add Import:**
   ```dart
   import 'package:astrobharataiuser/utils/global_text_replacement.dart';
   ```

## 📋 Priority Files to Update

### High Priority (User-Facing):
1. `lib/screens/ecommerce/view/profile_view.dart`
2. `lib/screens/ecommerce/view/product_detail_view.dart`
3. `lib/screens/ecommerce/view/cart_view.dart`
4. `lib/screens/ecommerce/view/orders_view.dart`
5. `lib/screens/ecommerce/view/search_view.dart`
6. `lib/screens/courses/views/courses_view.dart`
7. `lib/screens/ai_chat/views/ai_chat_view.dart`
8. `lib/screens/astrology_services/view/astrology_services_view.dart`
9. `lib/screens/live_astrologers/view/live_astrologers_view.dart`
10. `lib/screens/support/view/support_tickets_list_view.dart`

### Medium Priority:
- All other view files in `lib/screens/`

## ⚠️ What NOT to Replace

❌ **Don't replace:**
- `TextField` / `TextFormField` - User input
- API response text (already translated by backend)
- Numbers, dates, phone numbers
- Error messages from backend
- URLs, email addresses
- Code values, IDs

✅ **DO replace:**
- Static UI labels
- Button text
- Section headers
- Menu items
- Placeholder text (hintText in TextField is fine)

## 🎯 Verification

After replacement:
1. Change language in app
2. Navigate through all screens
3. Verify all text translates
4. Check console for translation logs

## 📊 Progress Tracking

Total files with Text widgets: ~241
Completed: 3
Remaining: ~238

Use Find & Replace to complete the rest!










