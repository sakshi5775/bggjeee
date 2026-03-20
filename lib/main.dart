import 'dart:async';
import 'dart:ui';
import 'package:astrobharataiuser/binding/language_binding/language_binding.dart';
import 'package:astrobharataiuser/binding/waiting_screen_binding/waiting_screen_binding.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/routes/get_pages.dart';
import 'package:astrobharataiuser/screens/waiting_screen/waiting_screen/view/waiting_screen_view.dart';
import 'package:astrobharataiuser/firebase_options.dart';
import 'package:astrobharataiuser/services/deeplink_service.dart';
import 'package:astrobharataiuser/theme/app_theme.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';
// import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:astrobharataiuser/apihelper/network_service/network_service.dart';
import 'package:astrobharataiuser/widgets/floating_chat_bubble_overlay.dart';
import 'package:astrobharataiuser/widgets/global_offline_screen.dart';
import './apihelper/dependencies/dependencies.dart' as dep;
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/services/crashlytics_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:astrobharataiuser/core/controllers/global_nav_controller.dart';
import 'package:astrobharataiuser/core/services/chat_minimize_manager.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/user_bottom_nav.dart';
import 'package:astrobharataiuser/core/services/analytics_service.dart';

List<Locale>? _cachedSupportedLocales;

void main() {
  runZonedGuarded(
    () async {
      // 1. Initialize bindings inside the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();
      Get.put(DeepLinkHandler(), permanent: true);

      await Hive.initFlutter();
      await Hive.openBox('api_cache'); // Global cache box
      // 2. Only treat zone errors as fatal in debug mode.
      // In release this flag kills the process on any unhandled async error,
      // turning recoverable zone exceptions into hard crashes.
      BindingBase.debugZoneErrorsAreFatal = kDebugMode;

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
          final exception = details.exception;
          final stack = details.stack ?? StackTrace.current;
          final exceptionString = exception.toString();

          // Many of the issues we see in Crashlytics are recoverable and should
          // NOT be marked as "fatal" (they were historically causing app
          // crashes due to fatal recording + zone error handling).
          bool isNonFatal = false;
          CrashErrorType type = CrashErrorType.ui;
          String reason = "FLUTTER_ERROR_NON_FATAL";

          if (exception is MissingPluginException &&
              exceptionString.contains('OneSignal')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'ONESIGNAL_MISSING_PLUGIN';
          } else if (exceptionString.contains('IOperationRepo') &&
              exceptionString.contains('OneSignal')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'ONESIGNAL_NATIVE_SERVICE_ERROR';
          } else if (exceptionString.contains(
                  'No host specified in URI assets/images/') ||
              exceptionString.contains('No host specified in URI assets/')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'ASSET_URI_PARSED_AS_NETWORK';
          } else if (exceptionString.contains('CameraException(') &&
              exceptionString.contains('Disposed CameraController')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'CAMERA_DISPOSED_CONTROLLER';
          } else if (exceptionString.contains('"EQ" not found') ||
              exceptionString.contains('Get.put(EQ())') ||
              exceptionString.contains('Get.lazyPut(() => EQ())')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'MISSING_GETX_DEP_EQ';
          } else if (exceptionString.contains(
              'Concurrent modification during iteration')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'CONCURRENT_MODIFICATION_DURING_ITERATION';
          } else if (exceptionString.contains('Bad state: Too many elements')) {
            isNonFatal = true;
            type = CrashErrorType.ui;
            reason = 'TOO_MANY_ELEMENTS';
          } else if (exceptionString.contains('SocketException') ||
              exceptionString.contains('Failed host lookup') ||
              exceptionString.contains('No address associated with hostname')) {
            isNonFatal = true;
            type = CrashErrorType.socket;
            reason = 'NETWORK_HOST_LOOKUP';
          }

          if (isNonFatal) {
            CrashlyticsService.recordError(
              exception,
              stack,
              fatal: false,
              type: type,
              reason: reason,
            );
            return;
          }

          // Unknown/Unexpected Flutter error: keep it as fatal.
          FirebaseCrashlytics.instance.recordFlutterFatalError(details);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          // Skip FlutterErrors — already handled by FlutterError.onError above.
          // Recording both causes duplicate crash entries in Crashlytics.
          if (error is FlutterError) return true;
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
          final exceptionString = details.exception.toString();
          bool isNonFatal = false;
          CrashErrorType type = CrashErrorType.ui;
          String reason = "WIDGET_TREE_ERROR";

          if (exceptionString.contains('OneSignal') &&
              exceptionString.contains('MissingPluginException')) {
            isNonFatal = true;
            reason = 'ONESIGNAL_MISSING_PLUGIN';
          } else if (exceptionString.contains('IOperationRepo') &&
              exceptionString.contains('OneSignal')) {
            isNonFatal = true;
            reason = 'ONESIGNAL_NATIVE_SERVICE_ERROR';
          } else if (exceptionString.contains('No host specified in URI assets/')) {
            isNonFatal = true;
            reason = 'ASSET_URI_PARSED_AS_NETWORK';
          } else if (exceptionString.contains('CameraException(') &&
              exceptionString.contains('Disposed CameraController')) {
            isNonFatal = true;
            reason = 'CAMERA_DISPOSED_CONTROLLER';
          } else if (exceptionString.contains('"EQ" not found')) {
            isNonFatal = true;
            reason = 'MISSING_GETX_DEP_EQ';
          } else if (exceptionString.contains('Concurrent modification during iteration')) {
            isNonFatal = true;
            reason = 'CONCURRENT_MODIFICATION_DURING_ITERATION';
          } else if (exceptionString.contains('Bad state: Too many elements')) {
            isNonFatal = true;
            reason = 'TOO_MANY_ELEMENTS';
          } else if (exceptionString.contains('SocketException') ||
              exceptionString.contains('Failed host lookup') ||
              exceptionString.contains('No address associated with hostname')) {
            isNonFatal = true;
            type = CrashErrorType.socket;
            reason = 'NETWORK_HOST_LOOKUP';
          }

          CrashlyticsService.recordError(
            details.exception,
            details.stack ?? StackTrace.current,
            fatal: !isNonFatal,
            type: type,
            reason: reason,
          );

          return Material(
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
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

      // Log App Open event
      AnalyticsService().logAppOpen();

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
    final name = route.settings.name;
    // Unnamed routes are normal for modals (e.g. showModalBottomSheet); skip logging.
    if (name == null) return;
    CrashlyticsService.setKey("screen", name);
    CrashlyticsService.log("NAVIGATION:PUSH | screen:$name");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      final name = previousRoute.settings.name;
      if (name == null) return;
      CrashlyticsService.setKey("screen", name);
      CrashlyticsService.log("NAVIGATION:POP_TO | screen:$name");
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

/// Custom strings for the update-available dialog.
class CustomUpgraderMessages extends UpgraderMessages {
  @override
  String get title => 'Update Available!';

  @override
  String get body =>
      'A new version of the app is ready with improvements and bug fixes.';

  @override
  String get prompt => 'Would you like to update now?';

  @override
  String get buttonTitleIgnore => 'Skip this version';

  @override
  String get buttonTitleLater => 'Remind Me Later';

  @override
  String get buttonTitleUpdate => 'Update Now';
}

/// When [AppConstant.upgraderAppcastUrl] is set, use appcast for version check so the update
/// popup works even when Play/App Store lookup fails (e.g. no network to play.google.com).
UpgraderStoreController? get _upgraderStoreController {
  final url = AppConstant.upgraderAppcastUrl;
  if (url == null || url.isEmpty) return null;
  return UpgraderStoreController(
    onAndroid: () => UpgraderAppcastStore(
      appcastURL: url,
      osVersion: Version(0, 0, 0),
    ),
    oniOS: () => UpgraderAppcastStore(
      appcastURL: url,
      osVersion: Version(0, 0, 0),
    ),
  );
}

/// Single Upgrader instance used throughout the app.
/// Set [debugDisplayAlways] to true only to test the dialog without a real Play Store update.
final upgrader = Upgrader(
  debugDisplayAlways: false, // Set to false for production
  debugLogging: kDebugMode,
  durationUntilAlertAgain: const Duration(days: 1),
  minAppVersion: AppConstant.minAppVersion,
  messages: CustomUpgraderMessages(),
  storeController: _upgraderStoreController ?? UpgraderStoreController(),
  countryCode: 'in', // India; for Play Store lookup when appcast is not used
  willDisplayUpgrade: ({
    required bool display,
    String? installedVersion,
    UpgraderVersionInfo? versionInfo,
  }) {
    if (kDebugMode) {
      debugPrint('upgrader: willDisplayUpgrade → display=$display');
      debugPrint('   installed: $installedVersion');
      debugPrint('   store: ${versionInfo?.appStoreVersion}');
    }
  },
);

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

        // Wrap app with UpgradeAlert. When appcast URL is set in AppConstant, update popup
        // works even when Play/App Store lookup fails (e.g. network/DNS issues).
        final appWithUpgrader = UpgradeAlert(
          upgrader: upgrader,
          navigatorKey: Get.key,
          dialogStyle: UpgradeDialogStyle.material,
          barrierDismissible: false,
          showIgnore: true,
          showLater: true,
          shouldPopScope: () =>
              !(upgrader.blocked() || upgrader.isUpdateAvailable()),
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
                // When app is cold-started by deeplink, platform may pass URI as initial route;
                // GetX has no matching GetPage and PageRedirect.page throws. Force root so DeepLinkHandler can process the link.
                onGenerateInitialRoutes: (String initialRoute) {
                  // When cold-started via deeplink, platform passes URI; GetX has no matching GetPage and crashes.
                  final isDeeplink = initialRoute.startsWith('astrouser://') ||
                      (initialRoute.isNotEmpty && !initialRoute.startsWith('/'));
                  final routeToUse =
                      isDeeplink ? PageRoutes.INITIAL : initialRoute;
                  final match = PageRoutes.routes.cast<GetPage>().firstWhereOrNull(
                    (r) => r.name == routeToUse,
                  );
                  final page = match ??
                      PageRoutes.routes.cast<GetPage>().firstWhereOrNull(
                        (r) => r.name == PageRoutes.INITIAL,
                      );
                  if (page != null) {
                    return [
                      GetPageRoute(
                        settings: RouteSettings(name: page.name),
                        page: page.page,
                        binding: page.binding,
                      ),
                    ];
                  }
                  return [
                    GetPageRoute(
                      settings: RouteSettings(name: PageRoutes.INITIAL),
                      page: () => const WaitingScreenView(),
                      binding: WaitingScreenBinding(),
                    ),
                  ];
                },
                unknownRoute: GetPage(
                  name: AppRoutes.root,
                  page: () => const WaitingScreenView(),
                  binding: WaitingScreenBinding(),
                ),
                theme: AppTheme.lightTheme,
                themeMode: ThemeMode.light,
                navigatorObservers: [
                  CrashlyticsNavigatorObserver(),
                  FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
                ],

                routingCallback: (routing) {
                  if (routing == null) return;
                  final route = routing.current.split('?').first;
                  final args = routing.args;
                  print('GlobalNav: routingCallback route=$route args=$args');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Get.isRegistered<GlobalNavController>()) {
                      Get.find<GlobalNavController>().updateRoute(
                        route,
                        args: args,
                      );
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
                            Expanded(
                              child: Stack(
                                children: [
                                  // The actual app content (Navigator, etc.)
                                  child ?? const SizedBox.shrink(),

                                  // Offline overlay - preserved state behind it
                                  Obx(() {
                                    final isOnline = NetworkService
                                        .instance
                                        .isConnected
                                        .value;
                                    if (!isOnline) {
                                      return const GlobalOfflineScreen();
                                    }
                                    return const SizedBox.shrink();
                                  }),
                                  // Floating chat bubble (minimized chat)
                                  if (Get.isRegistered<ChatMinimizeManager>())
                                    const FloatingChatBubbleOverlay(),
                                ],
                              ),
                            ),
                            // Bottom Nav - always visible and interactive
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
                                return Material(
                                  color: Colors.white,
                                  elevation: 8.0,
                                  child: SafeArea(
                                    top: false,
                                    child: const UserBottomNav(),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
        return appWithUpgrader;
      },
    );
  }
}
