# Add AutoTranslateText Import to ALL Files

## ✅ Quick Method: IDE Find & Replace

### Step 1: Open Find & Replace

**VS Code:** `Ctrl+Shift+H`  
**Android Studio:** `Ctrl+Shift+R`

### Step 2: Add Import After Flutter Imports

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
- **Match Case:** ✅

**Click "Replace All"**

### Step 3: For Files Without Flutter Import

If a file doesn't have `import 'package:flutter/material.dart';`, add the import manually after the last import statement:

```dart
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
```

## 📊 Current Status

- **Files with import:** 13 files
- **Files without import:** ~521 files
- **Total Dart files:** ~534 files

## 🎯 After Adding Import

All files will have the import and can use `AutoTranslateText` widget!










