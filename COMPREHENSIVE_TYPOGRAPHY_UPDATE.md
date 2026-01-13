# Comprehensive Typography Update - All Files

## Status: IN PROGRESS

### Files Updated (8/216)
1. ✅ `lib/widgets/wallet_recharge_dialog.dart`
2. ✅ `lib/widgets/profile_completion_dialog.dart`
3. ✅ `lib/screens/wallet/widgets/recharge_dialog.dart`
4. ✅ `lib/screens/wallet/view/wallet_view.dart`
5. ✅ `lib/screens/onboarding/view/onboarding_view.dart`
6. ✅ `lib/app_manager/app_dialog.dart`
7. ✅ `lib/app_manager/progressDialog.dart`
8. ✅ `lib/utils/getx_snackbar.dart`

### Files In Progress
- `lib/screens/user_dashboard/view/user_dashboard_view.dart` (91 fontSize instances remaining)

### Remaining Files: ~208 files

## Replacement Patterns

### Exact Matches
- `fontSize: 30` + `fontWeight: bold` → `AppTypography.h1`
- `fontSize: 18` + `fontWeight: bold` → `AppTypography.h2`
- `fontSize: 14` + `fontWeight: bold` → `AppTypography.h3`
- `fontSize: 14` + `fontWeight: normal` → `AppTypography.body1`
- `fontSize: 12` + `fontWeight: normal` → `AppTypography.body2`
- `fontSize: 10` + `fontWeight: normal` → `AppTypography.label`

### Close Matches (use closest)
- `fontSize: 28-32` → `AppTypography.h1` (30px)
- `fontSize: 16-20` → `AppTypography.h2` (18px)
- `fontSize: 13-15` → `AppTypography.body1` (14px) or `h3` (14px bold)
- `fontSize: 11-13` → `AppTypography.body2` (12px) or `label` (10px)
- `fontSize: 9-11` → `AppTypography.label` (10px)

## Update Process

For each file:
1. Add import: `import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';`
2. Find all `fontSize:` patterns
3. Replace with appropriate `AppTypography` style
4. Remove `fontSize`, `fontWeight`, and `fontFamily` overrides
5. Keep color and other properties using `.copyWith()`

## Next Steps

Continue updating files systematically, starting with:
- High-traffic screens (user_dashboard, astrology_services, etc.)
- Common widgets
- Screen views
- Screen widgets














