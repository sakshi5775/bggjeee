import 'dart:async';
import 'package:astrobharataiuser/binding/language_binding/language_binding.dart';
import 'package:astrobharataiuser/binding/waiting_screen_binding/waiting_screen_binding.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:astrobharataiuser/core/routes/get_pages.dart';
import 'package:astrobharataiuser/firebase_options.dart';
import 'package:astrobharataiuser/theme/app_theme.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
// import 'package:astrobharataiuser/widgets/global_chat_banner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kDebugMode, kIsWeb, TargetPlatform;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:upgrader/upgrader.dart';
import './apihelper/dependencies/dependencies.dart' as dep;

// Cache supported locales globally
List<Locale>? _cachedSupportedLocales;

void main() async {
  await runZonedGuarded(
    () async {
      // Initialize Flutter bindings first (required before Firebase initialization)
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase with error handling
      // Check if platform supports Firebase before initializing
      final isFirebaseSupported =
          kIsWeb ||
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows;

      if (isFirebaseSupported) {
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          debugPrint('Firebase initialized successfully');
        } catch (e, stackTrace) {
          debugPrint('Firebase initialization error: $e');
          debugPrint('Stack trace: $stackTrace');
          // Continue app initialization even if Firebase fails
        }
      } else {
        debugPrint(
          'Firebase not supported on current platform: $defaultTargetPlatform',
        );
      }

      await GetStorage.init();
      await GetStorage.init('loginData');
      await GetStorage.init('language');
      await GetStorage.init('personaFollows');
      await GetStorage.init('guestSession');

      // Load languages
      await LanguageModelService.loadLanguages();

      // Cache supported locales
      _cachedSupportedLocales = await _getSupportedLocales();

      dep.init();

      // Initialize language controller (single source of truth)
      LanguageBinding().dependencies();

      // Initialize CustomTranslationService globally so it's available for all views
      // Use Get.put with permanent: true to ensure it stays registered
      if (!Get.isRegistered<CustomTranslationService>()) {
        Get.put(CustomTranslationService(), permanent: true);
      }

      runApp(const MyApp());
    },
    (error, stack) {
      // Log unhandled exceptions
      debugPrint('Unhandled exception: $error\nStack trace: $stack');
    },
  );
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
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

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
                  return Stack(children: [child! /* , const GlobalChatBanner() */]);
                },
              );
            },
          ),
        );
      },
    );
  }
}
