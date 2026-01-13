# Quick Bulk Replacement Guide

## 🎯 Goal
Replace ALL `Text` widgets with `AutoTranslateText` across the entire app so every page translates.

## ⚡ Fastest Method (5 minutes)

### In VS Code / Android Studio:

1. **Open Find & Replace:**
   - VS Code: `Ctrl+Shift+H` (Windows) or `Cmd+Shift+H` (Mac)
   - Android Studio: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)

2. **Find:** `Text(`
   **Replace:** `AutoTranslateText(`
   **Scope:** Entire Project
   **File Pattern:** `**/*.dart`

3. **Click "Replace All"** (or review each match)

4. **Add Import to Modified Files:**
   - Find: `import 'package:flutter/material.dart';`
   - Add after it: `import 'package:astrobharataiuser/widgets/auto_translate_text.dart';`

## ✅ What's Already Done

- ✅ User Dashboard - Complete
- ✅ Bottom Navigation - Complete  
- ✅ E-commerce Home - Complete
- ✅ Cart View - Complete
- ✅ Profile View - Complete
- ✅ Search View - Complete
- ✅ Support Tickets - Complete
- ✅ Astrology Services - Complete

## ⚠️ Manual Review Needed

After bulk replacement, review and **keep as `Text()`**:

- User input: `TextField`, `TextFormField`
- Dynamic API content: `Text(product.name)`, `Text(user.email)`
- Numbers: `Text(count.toString())`
- Dates: `Text(DateFormat().format(date))`
- String interpolation: `Text('Price: \$$price')`

## 🎉 Result

After completion, **ALL pages** will translate instantly when language changes!










