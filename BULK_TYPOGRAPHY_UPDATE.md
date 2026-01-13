# Bulk Typography Update Guide

## Status
- ✅ Typography system created (`lib/theme/app_typography.dart`)
- ✅ Theme files updated (`lib/theme/app_theme.dart`)
- ✅ MyTextTheme updated (`lib/app_manager/my_text_theme.dart`)
- ✅ Sample files updated (widgets, wallet dialogs)
- ⏳ **217 files remaining** with hardcoded fontSize values

## Common Replacement Patterns

### Pattern 1: fontSize: 30 + fontWeight: bold → AppTypography.h1
```dart
// Before
TextStyle(fontSize: 30, fontWeight: FontWeight.bold)

// After
AppTypography.h1
```

### Pattern 2: fontSize: 18 + fontWeight: bold → AppTypography.h2
```dart
// Before
MyTextTheme.largeBCB.copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)
TextStyle(fontSize: 18, fontWeight: FontWeight.bold)

// After
AppTypography.h2.copyWith(color: ...)
```

### Pattern 3: fontSize: 14 + fontWeight: bold → AppTypography.h3
```dart
// Before
MyTextTheme.mediumBCB.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold)
TextStyle(fontSize: 14, fontWeight: FontWeight.bold)

// After
AppTypography.h3.copyWith(color: ...)
```

### Pattern 4: fontSize: 14 + fontWeight: normal → AppTypography.body1
```dart
// Before
MyTextTheme.mediumBCN.copyWith(fontSize: 14.sp)
TextStyle(fontSize: 14, fontWeight: FontWeight.normal)

// After
AppTypography.body1.copyWith(color: ...)
```

### Pattern 5: fontSize: 12 + fontWeight: normal → AppTypography.body2
```dart
// Before
MyTextTheme.smallBCN.copyWith(fontSize: 12.sp)
TextStyle(fontSize: 12, fontWeight: FontWeight.normal)

// After
AppTypography.body2.copyWith(color: ...)
```

### Pattern 6: fontSize: 10 + fontWeight: normal → AppTypography.label
```dart
// Before
TextStyle(fontSize: 10, fontWeight: FontWeight.normal)

// After
AppTypography.label.copyWith(color: ...)
```

## Files Updated So Far
1. ✅ `lib/widgets/wallet_recharge_dialog.dart`
2. ✅ `lib/widgets/profile_completion_dialog.dart`
3. ✅ `lib/screens/wallet/widgets/recharge_dialog.dart`
4. ✅ `lib/app_manager/app_dialog.dart`
5. ✅ `lib/app_manager/progressDialog.dart`
6. ✅ `lib/utils/getx_snackbar.dart` (already using MyTextTheme)

## Remaining Files by Directory

### High Priority (Common/Shared Files)
- `lib/app_manager/widgets/phone_field_with_country_code.dart`
- `lib/app_manager/common/new_dropdown.dart`
- `lib/app_manager/my_appbar.dart`

### Screen Views (lib/screens/*/view/)
- All view files in `lib/screens/` directories

### Screen Widgets (lib/screens/*/widgets/)
- All widget files in `lib/screens/` directories

## Quick Update Steps

1. **Add import** (if not present):
```dart
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
```

2. **Find and replace patterns**:
   - Search for `fontSize: 18.sp` or `fontSize: 18,` with `fontWeight: FontWeight.bold` → Replace with `AppTypography.h2`
   - Search for `fontSize: 14.sp` or `fontSize: 14,` with `fontWeight: FontWeight.bold` → Replace with `AppTypography.h3`
   - Search for `fontSize: 14.sp` or `fontSize: 14,` with `fontWeight: FontWeight.normal` → Replace with `AppTypography.body1`
   - Search for `fontSize: 12.sp` or `fontSize: 12,` → Replace with `AppTypography.body2`
   - Search for `fontSize: 10.sp` or `fontSize: 10,` → Replace with `AppTypography.label`

3. **Remove fontSize and fontWeight overrides** when using AppTypography:
```dart
// Remove these lines when using AppTypography:
fontSize: 14.sp,
fontWeight: FontWeight.bold,
```

4. **Keep color overrides**:
```dart
AppTypography.h2.copyWith(color: Colors.black)
```

## Verification

After updating, verify:
- No hardcoded `fontSize:` values remain (except in special cases like errorStyle with fontSize: 0)
- All text uses AppTypography or MyTextTheme (which now uses AppTypography)
- Font families are correct (Baloo2 for headings, Poppins for body text)














