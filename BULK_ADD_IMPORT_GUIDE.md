# 🚀 Bulk Add Import to ALL Files

## ✅ Method 1: IDE Find & Replace (Fastest - 2 Minutes)

### Step 1: Open Find & Replace

**VS Code:**
- Press `Ctrl+Shift+H` (Windows) or `Cmd+Shift+H` (Mac)

**Android Studio:**
- Press `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)

### Step 2: Add Import After Flutter Import

**Find:**
```dart
import 'package:flutter/material.dart';
```

**Replace:**
```dart
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
```

**Settings:**
- **Scope:** Entire Project
- **File Pattern:** `**/*.dart`
- **Match Case:** ✅ (checked)

**Click "Replace All"**

This will add the import to **ALL files** that have `import 'package:flutter/material.dart';`

### Step 3: For Files Without Flutter Import

For files that don't have `import 'package:flutter/material.dart';`, manually add after the last import:

```dart
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
```

## ✅ Method 2: Multiple Find & Replace Patterns

If Method 1 doesn't catch all files, try these patterns:

### Pattern 1: After Get import
**Find:** `import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';`  
**Replace:** 
```dart
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
```

### Pattern 2: After ScreenUtil import
**Find:** `import 'package:flutter_screenutil/flutter_screenutil.dart';`  
**Replace:**
```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
```

## 📊 Current Status

- **Files with import:** ~13 files
- **Files without import:** ~521 files
- **Total Dart files:** ~534 files

## 🎯 After Adding Import

All files will have the import and can use `AutoTranslateText` widget!

## ✅ Files Already Updated

- ✅ `our_services_section.dart`
- ✅ `waiting_screen_view.dart`
- ✅ `free_service_dialog.dart`
- ✅ `ComingSoonPage.dart`










