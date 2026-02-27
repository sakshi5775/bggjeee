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
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show
        BindingBase,
        defaultTargetPlatform,
        kDebugMode,
        kReleaseMode,
        kIsWeb,
        TargetPlatform;
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
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:astrobharataiuser/core/controllers/global_nav_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/user_bottom_nav.dart';

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
          !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS);

      if (isFirebaseSupported) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );

        // Enforce collection enablement ONLY in release mode
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          kReleaseMode,
        );

        FlutterError.onError = (FlutterErrorDetails details) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          CrashlyticsService.recordError(
            error,
            stack,
            fatal: true,
            reason: "PLATFORM_DISPATCHER_ERROR",
          );
          return true;
        };

        // UI-level crash protection
        ErrorWidget.builder = (FlutterErrorDetails details) {
          CrashlyticsService.recordError(
            details.exception,
            details.stack ?? StackTrace.current,
            fatal: true,
            type: CrashErrorType.ui,
            reason: "WIDGET_TREE_ERROR",
          );

          return Material(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Something went wrong",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: "#6F221E".toColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        };

        // Session Stitching & Cold Start Tracing
        final packageInfo = await PackageInfo.fromPlatform();
        await CrashlyticsService.initSession(
          appVersion: packageInfo.version,
          platform: defaultTargetPlatform.name,
          buildMode: kReleaseMode ? "release" : "debug",
        );

        debugPrint("Crashlytics Hardened");
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

      Get.put(GlobalNavController(), permanent: true);

      runApp(const MyApp());
    },
    (error, stack) {
      CrashlyticsService.recordError(
        error,
        stack,
        fatal: true,
        reason: "ZONE_GUARDED_CRITICAL_ERROR",
      );
      debugPrint('CRITICAL ERROR caught in runZonedGuarded: $error');
      debugPrint(stack.toString());
    },
  );
}

class CrashlyticsNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    CrashlyticsService.setKey("screen", route.settings.name ?? "unknown");
    CrashlyticsService.log("NAVIGATION:PUSH | screen:${route.settings.name}");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      CrashlyticsService.setKey(
        "screen",
        previousRoute.settings.name ?? "unknown",
      );
      CrashlyticsService.log(
        "NAVIGATION:POP_TO | screen:${previousRoute.settings.name}",
      );
    }
  }
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
                navigatorObservers: [CrashlyticsNavigatorObserver()],

                routingCallback: (routing) {
                  if (routing == null) return;
                  final route = routing.current.split('?').first;
                  print('GlobalNav: routingCallback route=$route');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.isRegistered<GlobalNavController>()) {
                      Get.find<GlobalNavController>().updateRoute(route);
                    }
                  });
                },

                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBackground,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(child: child ?? const SizedBox()),
                            Obx(() {
                              if (!Get.isRegistered<GlobalNavController>()) {
                                return const SizedBox.shrink();
                              }
                              final navController =
                                  Get.find<GlobalNavController>();
                              final showNav = navController.showBottomNav;
                              final isKeyboardOpen =
                                  MediaQuery.of(context).viewInsets.bottom > 0;

                              if (showNav && !isKeyboardOpen) {
                                return const SafeArea(
                                  top: false,
                                  child: Material(
                                    elevation: 8.0,
                                    child: UserBottomNav(),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ],
                        ),
                        Obx(() {
                          final isOnline =
                              NetworkService.instance.isConnected.value;
                          if (!isOnline) return const GlobalOfflineScreen();
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
