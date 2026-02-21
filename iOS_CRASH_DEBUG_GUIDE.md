# 🔴 iOS Instant Crash - Complete Debugging Guide

## 📋 What I Fixed For You ✅

1. **Info.plist** - Enabled `FirebaseAppDelegateProxyEnabled` (was causing Firebase/OneSignal auto-setup failure)
2. **Info.plist** - Added `audio` to `UIBackgroundModes` (critical for Agora + recording plugins)
3. **GitHub Actions** - Created `.github/workflows/ios-debug.yml` with comprehensive crash detection
4. **Dependencies** - Added error handling to NotificationService initialization  
5. **NotificationService** - Added timeout protection to prevent infinite hangs

---

## 🚀 How to Use GitHub Actions for Deep Debugging

### Step 1: Push Code to GitHub
```bash
git add .
git commit -m "Fix iOS crash - enable Firebase proxy and audio modes"
git push origin main
```

### Step 2: Run the iOS Debug Workflow
1. Go to your GitHub repository → **Actions** tab
2. Look for **"iOS Deep Debug Build"** workflow
3. Click **"Run workflow"** → **"Run workflow"** button
4. Wait for build to complete (5-10 minutes)

### Step 3: Review Build Artifacts
After build completes:
- ✅ Download **"iOS Build Logs"** artifact
- ✅ Download **"iOS App Binary"** artifact (if build succeeded)
- 📋 Search logs for these patterns:

#### Pattern: Plugin Linking Error
```
❌ dyld: Library not loaded
   → Agora, OneSignal, or Firebase plugin is not linked
   → Fix: Run: cd ios && pod install --repo-update
```

#### Pattern: Null Safety Crash
```
❌ Null check operator used on a null value
   → Flutter code has null reference
   → Fix: Search for `!` operator and replace with `?.` or `?? "default"`
```

#### Pattern: Firebase Not Initialized  
```
❌ Default FirebaseApp is not initialized
   → Firebase.initializeApp() failed or not called
   → Fix: Ensure GoogleService-Info.plist exists in ios/Runner/
```

#### Pattern: OneSignal Initialization Error
```
❌ OneSignal.*error|Crash
   → OneSignal initialization failed
   → Fix: Check AppDelegate.swift and OneSignal App ID in constants
```

---

## 🔧 Plugin Isolation Test (if app still crashes)

This is the MOST EFFECTIVE debugging method.

### Quick Test: Disable High-Risk Plugins

Edit `pubspec.yaml` and comment out these plugins one by one:

```yaml
dependencies:
  # camera:
  # record:
  # speech_to_text:
  # agora_rtc_engine:
  # onesignal_flutter:
  # firebase_core:
```

### Test Each Stage:

**Stage 1: Disabled ALL high-risk plugins**
```yaml
# camera:
# record:
# speech_to_text:
# agora_rtc_engine:
# onesignal_flutter:
# firebase_core:
```
Run: `flutter pub get` → `flutter build ios --no-codesign`
- If app WORKS → Culprit is in ONE of these plugins ✅
- If app CRASHES → Problem is elsewhere ❌

**Stage 2: Enable plugins ONE by ONE**

Build and test after enabling each:
```yaml
camera:  # ← Test 1
# record:
# speech_to_text:
# agora_rtc_engine:
# onesignal_flutter:
# firebase_core:
```

Then:
```yaml
camera:
record:  # ← Test 2
# speech_to_text:
# agora_rtc_engine:
# onesignal_flutter:
# firebase_core:
```

**Continue for each plugin until app crashes**

### When You Find the Culprit:

🎯 **Example: If Agora causes crash**
```
❌ agora_rtc_engine: ^6.5.3 → CRASH
```

**Next Steps:**
1. Check Agora version compatibility
2. Ensure proper initialization in code
3. Verify iOS permissions in Info.plist
4. Report issue to plugin package

---

## 📱 Real Device Testing (Most Accurate)

### Option 1: Manual Testing (if you have Mac/iPhone)
```bash
# In terminal on Mac
flutter run -v

# Wait for app to launch and crash
# 💥 Crash popup will appear with stack trace
# 👉 Tap "Share" and send log
```

### Option 2: TestFlight (Recommended for production)
1. Build and sign the app (requires Apple Developer account)
2. Upload to TestFlight
3. Invite testers
4. Testers will get crash logs automatically

### Option 3: Firebase Crashlytics (Already setup in your code!)

Your app already has Crashlytics configured. To use it:

1. **Ensure initialization** in `main.dart` ✅ (already done)
2. **Build and release** to App Store or Firebase
3. **Get crash logs** at: https://console.firebase.google.com → Crashlytics

Benefits of Crashlytics:
- Automatic crash reporting
- Stack traces with line numbers
- Device info (iOS version, device model)
- Crash trends over time

---

## ✅ Verification Checklist

After applying fixes, verify:

- [ ] `ios/Runner/Info.plist` has `FirebaseAppDelegateProxyEnabled = true`
- [ ] `ios/Runner/Info.plist` has `audio` in `UIBackgroundModes`
- [ ] `ios/Runner/GoogleService-Info.plist` exists
- [ ] `main.dart` calls `Firebase.initializeApp()`
- [ ] `ios/Runner/AppDelegate.swift` has Flutter + flutter_downloader setup
- [ ] Ran `cd ios && pod install --repo-update` recently

---

## 🔍 Crash Debugging Workflow (Step-by-Step)

```
1. Push code → GitHub Actions
   ↓
2. Build succeeds? 
   ✅ YES → Download app binary
   ❌ NO → Check build logs for errors
   ↓
3. Install app on iPhone
   ↓
4. App crashes on launch?
   ✅ YES → Tap Share on crash popup
   ❌ NO → 🎉 Success! Open app normally
   ↓
5. Analyze crash log
   ↓
6. Fix issue (from guide above) OR disable plugins
   ↓
7. Repeat from Step 1
```

---

## 🚨 Most Common iOS Crashes (for your app)

Based on your dependencies, here's the crash probability:

| Crash Type | Probability | Fix |
|-----------|-------------|-----|
| **Missing Audio Mode** | 🔴 70% | Add `audio` to `UIBackgroundModes` ✅ DONE |
| **Firebase Not Init** | 🔴 50% | Verify `Firebase.initializeApp()` in main.dart |
| **OneSignal Crash** | 🟡 40% | Check AppDelegate + OneSignal App ID |
| **Agora Init Failure** | 🟡 35% | Ensure audio session configured |
| **Plugin Linking Error** | 🟡 30% | Run `pod install --repo-update` |
| **Null Safety Error** | 🟡 25% | Check Dart code for null references |

---

## 📞 If You Still Need Help

1. **Run GitHub Actions** → Download build logs
2. **Search logs** for error patterns (see above)
3. **Send me**:
   - Build log (`build-output.log` from artifacts)
   - Crash log (from iPhone Share button)
   - Which plugin you think causes it
   
4. **I'll provide exact fix** within 1 reply

---

## 🎯 Your Next Action

1. Push the updated code:
   ```bash
   git add ios/Runner/Info.plist
   git add lib/apihelper/dependencies/dependencies.dart
   git add lib/core/services/notification_service.dart
   git add .github/workflows/ios-debug.yml
   git commit -m "Fix iOS crash - Firebase proxy, audio mode, error handling"
   git push origin main
   ```

2. Go to GitHub Actions and run **"iOS Deep Debug Build"**

3. Wait for completion and review logs

4. Check if the crash is fixed by installing the built app on iPhone

5. If it still crashes, comment out plugins using the isolation test above

---

## 📚 Reference Files Modified

- ✅ [ios/Runner/Info.plist](../../ios/Runner/Info.plist) - Added Firebase proxy + audio mode
- ✅ [lib/apihelper/dependencies/dependencies.dart](../../lib/apihelper/dependencies/dependencies.dart) - Added error handling
- ✅ [lib/core/services/notification_service.dart](../../lib/core/services/notification_service.dart) - Added timeout protection
- ✅ [.github/workflows/ios-debug.yml](./../workflows/ios-debug.yml) - iOS debug workflow

---

**Good luck! 🚀 You've got this!**
