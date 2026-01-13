# Typography Update Status

## ✅ Completed

### Core System
- ✅ Created `lib/theme/app_typography.dart` with all 6 text styles
- ✅ Updated `pubspec.yaml` with correct font weights (700 for Baloo2, 400 for Poppins)
- ✅ Updated `lib/theme/app_theme.dart` (light & dark themes)
- ✅ Updated `lib/app_manager/my_text_theme.dart` to use AppTypography

### Files Updated
1. ✅ `lib/widgets/wallet_recharge_dialog.dart`
2. ✅ `lib/widgets/profile_completion_dialog.dart`
3. ✅ `lib/screens/wallet/widgets/recharge_dialog.dart`
4. ✅ `lib/screens/wallet/view/wallet_view.dart`
5. ✅ `lib/screens/onboarding/view/onboarding_view.dart`
6. ✅ `lib/app_manager/app_dialog.dart`
7. ✅ `lib/app_manager/progressDialog.dart`
8. ✅ `lib/utils/getx_snackbar.dart` (already using MyTextTheme)

## ⏳ Remaining Work

Approximately **210+ files** still contain hardcoded `fontSize` values that need to be migrated to use `AppTypography`.

### Common Patterns to Replace

1. **fontSize: 30 + bold** → `AppTypography.h1`
2. **fontSize: 18 + bold** → `AppTypography.h2`
3. **fontSize: 14 + bold** → `AppTypography.h3`
4. **fontSize: 14 + normal** → `AppTypography.body1`
5. **fontSize: 12 + normal** → `AppTypography.body2`
6. **fontSize: 10 + normal** → `AppTypography.label`

### Quick Update Steps

1. Add import: `import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';`
2. Replace hardcoded fontSize with appropriate AppTypography style
3. Remove `fontSize` and `fontWeight` overrides
4. Keep color overrides using `.copyWith(color: ...)`

### Files by Directory

#### High Priority (Common/Shared)
- `lib/app_manager/widgets/phone_field_with_country_code.dart` (has fontSize: 0 for errorStyle - intentional, can skip)
- `lib/app_manager/common/new_dropdown.dart` (mostly commented out)

#### Screen Views
- All files in `lib/screens/*/view/` directories

#### Screen Widgets  
- All files in `lib/screens/*/widgets/` directories

## Migration Guide

See `TYPOGRAPHY_MIGRATION_GUIDE.md` and `BULK_TYPOGRAPHY_UPDATE.md` for detailed patterns and examples.














