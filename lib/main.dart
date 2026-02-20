// import 'dart:async';
// import 'package:astrobharataiuser/binding/language_binding/language_binding.dart';
// import 'package:astrobharataiuser/binding/waiting_screen_binding/waiting_screen_binding.dart';
// import 'package:astrobharataiuser/core/models/app_language_model.dart';
// import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
// import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
// import 'package:astrobharataiuser/core/routes/get_pages.dart';
// import 'package:astrobharataiuser/firebase_options.dart';
// import 'package:astrobharataiuser/theme/app_theme.dart';
// import 'package:astrobharataiuser/utils/app_constant.dart';
// // import 'package:astrobharataiuser/widgets/global_chat_banner.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kDebugMode, kIsWeb, TargetPlatform;
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:upgrader/upgrader.dart';
// import 'package:astrobharataiuser/core/services/notification_service.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:astrobharataiuser/apihelper/network_service/network_service.dart';
// import 'package:astrobharataiuser/widgets/global_offline_screen.dart';
// import './apihelper/dependencies/dependencies.dart' as dep;

// // Cache supported locales globally
// List<Locale>? _cachedSupportedLocales;

// void main() async {
//   await runZonedGuarded(
//     () async {
//       // Initialize Flutter bindings first (required before Firebase initialization)
//       WidgetsFlutterBinding.ensureInitialized();

//       // Initialize FlutterDownloader for report downloads
//       if (!kIsWeb) {
//         await FlutterDownloader.initialize(
//           debug:
//               kDebugMode, // optional: set to false to disable printing logs to console (default: true)
//           ignoreSsl:
//               true, // option: set to false to disable HTTP with certificate which can't be verified
//         );
//       }

//       // Initialize Firebase with error handling
//       // Check if platform supports Firebase before initializing
//       final isFirebaseSupported =
//           kIsWeb ||
//           defaultTargetPlatform == TargetPlatform.android ||
//           defaultTargetPlatform == TargetPlatform.iOS ||
//           defaultTargetPlatform == TargetPlatform.macOS ||
//           defaultTargetPlatform == TargetPlatform.windows;

//       if (isFirebaseSupported) {
//         try {
//           await Firebase.initializeApp(
//             options: DefaultFirebaseOptions.currentPlatform,
//           );
//           debugPrint('Firebase initialized successfully');
//         } catch (e, stackTrace) {
//           debugPrint('Firebase initialization error: $e');
//           debugPrint('Stack trace: $stackTrace');
//           // Continue app initialization even if Firebase fails
//         }
//       } else {
//         debugPrint(
//           'Firebase not supported on current platform: $defaultTargetPlatform',
//         );
//       }

//       await GetStorage.init();
//       await GetStorage.init('loginData');
//       await GetStorage.init('language');
//       await GetStorage.init('personaFollows');
//       await GetStorage.init('guestSession');

//       // Load languages
//       await LanguageModelService.loadLanguages();

//       // Cache supported locales
//       _cachedSupportedLocales = await _getSupportedLocales();

//       // Initialize dependencies (includes NotificationService)
//       await dep.init();

//       // Initialize language controller (single source of truth)
//       LanguageBinding().dependencies();

//       // Initialize CustomTranslationService globally so it's available for all views
//       // Use Get.put with permanent: true to ensure it stays registered
//       if (!Get.isRegistered<CustomTranslationService>()) {
//         Get.put(CustomTranslationService(), permanent: true);
//       }

//       // Request notification permission after the first frame renders
//       // and a short delay (ensures splash screen has passed so the
//       // permission dialog is visible to the user).
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Future.delayed(const Duration(seconds: 3), () {
//           if (Get.isRegistered<NotificationService>()) {
//             NotificationService.instance.requestPermission();
//             // If user is already logged in, link their identity
//             NotificationService.instance.linkCurrentUser();
//           }
//         });
//       });

//       // ✅ SET PORTRAIT MODE HERE (Global Default)
//       await SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);

//       runApp(const MyApp());
//     },
//     (error, stack) {
//       // Log unhandled exceptions
//       debugPrint('Unhandled exception: $error\nStack trace: $stack');
//     },
//   );
// }

import 'dart:async';
import 'dart:ui';
import 'package:astrobharataiuser/binding/language_binding/language_binding.dart';
import 'package:astrobharataiuser/binding/waiting_screen_binding/waiting_screen_binding.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:astrobharataiuser/core/routes/get_pages.dart';
import 'package:astrobharataiuser/firebase_options.dart';
import 'package:astrobharataiuser/theme/app_theme.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show BindingBase, defaultTargetPlatform, kDebugMode, kIsWeb, TargetPlatform;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:upgrader/upgrader.dart';
// import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:astrobharataiuser/apihelper/network_service/network_service.dart';
import 'package:astrobharataiuser/widgets/global_offline_screen.dart';
import './apihelper/dependencies/dependencies.dart' as dep;

List<Locale>? _cachedSupportedLocales;

void main() {
  runZonedGuarded(
    () async {
      // 1. Initialize bindings inside the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();

      // 2. Prevent zone-related bugs by ensuring consistency
      BindingBase.debugZoneErrorsAreFatal = true;

      // 3. Setup global portrait lock
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // 4. Firebase & Crashlytics setup
      final isFirebaseSupported =
          kIsWeb ||
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows;

      if (isFirebaseSupported) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        if (!kIsWeb &&
            (defaultTargetPlatform == TargetPlatform.android ||
                defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS)) {
          FlutterError.onError =
              FirebaseCrashlytics.instance.recordFlutterFatalError;

          PlatformDispatcher.instance.onError = (error, stack) {
            FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
            return true;
          };
          debugPrint("Crashlytics initialized");
        }
        debugPrint("Firebase initialized");
      }

      // 5. Downloader (Non-web platforms)
      if (!kIsWeb) {
        await FlutterDownloader.initialize(debug: kDebugMode, ignoreSsl: true);
      }

      // 6. Serialized Storage Initialization (Guaranteed sequential to avoid FileSystemException)
      await _initializeAllStorage();

      // 7. Load Languages & Dependencies
      await LanguageModelService.loadLanguages();
      _cachedSupportedLocales = await _getSupportedLocales();

      await dep.init();
      LanguageBinding().dependencies();

      if (!Get.isRegistered<CustomTranslationService>()) {
        Get.put(CustomTranslationService(), permanent: true);
      }

      runApp(const MyApp());
    },
    (error, stack) {
      debugPrint('CRITICAL ERROR caught in runZonedGuarded: $error');
      debugPrint(stack.toString());
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}

/// Helper to ensure all storage containers are initialized sequentially.
Future<void> _initializeAllStorage() async {
  try {
    await GetStorage.init();
    await GetStorage.init('loginData');
    await GetStorage.init('language');
    await GetStorage.init('personaFollows');
    await GetStorage.init('guestSession');
    await GetStorage.init('api_cache');
    await GetStorage.init('onboardingVal');
    await GetStorage.init('baseUrl');
    debugPrint("All storage containers initialized successfully");
  } catch (e) {
    debugPrint("Storage initialization error: $e");
    // Depending on the error, we might want to continue or show a fatal error screen
  }
}

/// Get all supported locales from languages.json
Future<List<Locale>> _getSupportedLocales() async {
  try {
    final languages = await LanguageModelService.getLanguages();
    return languages.map((lang) => lang.locale).toList();
  } catch (e) {
    print('Error loading supported locales: $e');
    return [const Locale('en')];
  }
}

/// Check if a locale is supported by Flutter's MaterialLocalizations
/// Flutter supports limited locales, so we need to check
bool _isFlutterSupportedLocale(Locale locale) {
  // Flutter's officially supported locales
  final flutterSupported = [
    'en',
    'hi',
    'bn',
    'te',
    'mr',
    'ta',
    'gu',
    'ur',
    'kn',
    'ml',
    'or',
    'pa',
    'as',
    'ne',
  ];
  return flutterSupported.contains(locale.languageCode);
}

/// Get MaterialLocalizations supported locales (only Flutter-supported ones)
List<Locale> _getMaterialSupportedLocales(List<Locale> allLocales) {
  final flutterSupported = [
    'en',
    'hi',
    'bn',
    'te',
    'mr',
    'ta',
    'gu',
    'ur',
    'kn',
    'ml',
    'or',
    'pa',
    'as',
    'ne',
  ];
  return allLocales
      .where((locale) => flutterSupported.contains(locale.languageCode))
      .toList();
}

/// Get safe locale for MaterialLocalizations (fallback to English if not supported)
Locale _getSafeMaterialLocale(Locale locale) {
  if (_isFlutterSupportedLocale(locale)) {
    return locale;
  }
  return const Locale('en');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        // ]);

        // Get supported locales for MaterialLocalizations (use cached value)
        final materialSupportedLocales = _getMaterialSupportedLocales(
          _cachedSupportedLocales ?? [const Locale('en')],
        );

        // Use Flutter's built-in delegates for MaterialLocalizations
        final localizationsDelegates = [
          GlobalMaterialLocalizations
              .delegate, // MaterialLocalizations (for Flutter widgets)
          GlobalCupertinoLocalizations.delegate, // CupertinoLocalizations
          GlobalWidgetsLocalizations.delegate, // WidgetsLocalizations
        ];

        // Mandatory app update: users must update before proceeding (Play Store only).
        final appUpgrader = Upgrader(
          minAppVersion: AppConstant.minAppVersion,
          durationUntilAlertAgain: Duration.zero,
          debugLogging: kDebugMode,
        );

        // Use GetBuilder to rebuild when language changes (lightweight)
        return UpgradeAlert(
          dialogStyle: UpgradeDialogStyle.material,
          barrierDismissible: false,
          showIgnore: false,
          showLater: false,
          // Block back/dismiss when update is available or user is below min version
          shouldPopScope: () =>
              !(appUpgrader.blocked() || appUpgrader.isUpdateAvailable()),
          upgrader: appUpgrader,
          child: GetBuilder<LanguageControllerV2>(
            builder: (languageController) {
              // Get current locale from language controller
              final locale =
                  languageController.currentLanguageValue?.locale ??
                  const Locale('en');
              final safeLocale = _getSafeMaterialLocale(locale);

              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: localizationsDelegates,
                supportedLocales: materialSupportedLocales.isNotEmpty
                    ? materialSupportedLocales
                    : [const Locale('en')],
                locale: safeLocale,
                fallbackLocale: const Locale('en'),
                initialRoute: PageRoutes.INITIAL,
                initialBinding: WaitingScreenBinding(),
                getPages: PageRoutes.routes,
                theme: AppTheme.lightTheme,
                themeMode: ThemeMode.light,
                builder: (context, child) {
                  return Obx(() {
                    final isOnline = NetworkService.instance.isConnected.value;
                    return Stack(
                      children: [
                        child!,
                        if (!isOnline) const GlobalOfflineScreen(),
                      ],
                    );
                  });
                },
              );
            },
          ),
        );
      },
    );
  }
}
