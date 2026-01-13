# Typography Migration Guide

## Overview
The project now uses a standardized typography system defined in `lib/theme/app_typography.dart`. All text styles throughout the app should use this system.

## Typography System

### Available Styles

1. **H1** - Baloo2, 30px, 36px line height, Bold
   - Use for: Main headings, large titles
   - Access: `AppTypography.h1` or `MyTextTheme.h1(color)`

2. **H2** - Baloo2, 18px, 24px line height, Bold
   - Use for: Section headings, sub-titles
   - Access: `AppTypography.h2` or `MyTextTheme.h2(color)`

3. **H3** - Baloo2, 14px, 28px line height, Bold
   - Use for: Small headings, labels
   - Access: `AppTypography.h3` or `MyTextTheme.h3(color)`

4. **Body-1** - Poppins Regular, 14px, 16px line height
   - Use for: Body text, descriptions
   - Access: `AppTypography.body1` or `MyTextTheme.body1(color)`

5. **Body-2** - Poppins Regular, 12px, 14px line height
   - Use for: Secondary text, captions
   - Access: `AppTypography.body2` or `MyTextTheme.body2(color)`

6. **Label** - Poppins Regular, 10px, 11px line height
   - Use for: Small labels, fine print
   - Access: `AppTypography.label` or `MyTextTheme.label(color)`

## Migration Pattern

### Before (Hardcoded Styles)
```dart
Text(
  'Hello World',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  ),
)
```

### After (Using AppTypography)
```dart
// Option 1: Direct use
Text(
  'Hello World',
  style: AppTypography.h2.copyWith(color: Colors.black),
)

// Option 2: Using MyTextTheme helper
Text(
  'Hello World',
  style: MyTextTheme.h2(Colors.black),
)

// Option 3: Using existing MyTextTheme constants
Text(
  'Hello World',
  style: MyTextTheme.veryLargeBCB.copyWith(color: Colors.black),
)
```

## Common Replacements

| Old Pattern | New Pattern |
|------------|-------------|
| `fontSize: 30, fontWeight: FontWeight.bold` | `AppTypography.h1` |
| `fontSize: 18, fontWeight: FontWeight.bold` | `AppTypography.h2` |
| `fontSize: 14, fontWeight: FontWeight.bold` | `AppTypography.h3` |
| `fontSize: 14, fontWeight: FontWeight.normal` | `AppTypography.body1` |
| `fontSize: 12, fontWeight: FontWeight.normal` | `AppTypography.body2` |
| `fontSize: 10, fontWeight: FontWeight.normal` | `AppTypography.label` |

## Files That Need Migration

Based on the scan, approximately **217 files** contain hardcoded `fontSize` values that should be migrated to use `AppTypography`. The most critical files to update are:

1. Common widgets (`lib/widgets/`, `lib/app_manager/`)
2. Screen views (`lib/screens/*/view/`)
3. Screen widgets (`lib/screens/*/widgets/`)

## Notes

- **Theme Integration**: The `AppTheme.lightTheme` and `AppTheme.darkTheme` already use `AppTypography` in their `textTheme`
- **MyTextTheme**: All `MyTextTheme` constants now use `AppTypography` under the hood
- **Responsive Sizing**: If you need responsive sizing with `.sp`, you can still use it, but the base typography should come from `AppTypography`
- **Color Overrides**: Always use `.copyWith(color: ...)` to add colors to typography styles

## Example Migration

### File: `lib/widgets/wallet_recharge_dialog.dart`

**Before:**
```dart
style: MyTextTheme.largeBCB.copyWith(
  fontSize: 18.sp,
  fontWeight: FontWeight.bold,
  color: const Color(0xFF5F2221),
),
```

**After:**
```dart
style: AppTypography.h2.copyWith(
  color: const Color(0xFF5F2221),
),
```

Note: Remove `fontSize` and `fontWeight` overrides as they're already defined in `AppTypography.h2`.














