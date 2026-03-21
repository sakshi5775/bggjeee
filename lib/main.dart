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
import 'package:astrobharataiuser/core/services/app_firebase_state.dart';
import 'package:google_api_availability/google_api_availability.dart';

List<Locale>? _cachedSupportedLocales;

/// Whether Firebase Core initialized (used for navigator observers only).
bool _firebaseCoreInitialized = false;

void main() {
  runZonedGuarded(
    () async {
      // 1. Initialize bindings inside the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();
      AppFirebaseState.markNotReady();
      _firebaseCoreInitialized = false;

      // Reduce image cache pressure on low-RAM devices (helps avoid silent OOM kills).
      if (!kIsWeb) {
        PaintingBinding.instance.imageCache.maximumSize = 120;
        PaintingBinding.instance.imageCache.maximumSizeBytes = 48 << 20;
      }

      Get.put(DeepLinkHandler(), permanent: true);

      try {
        await Hive.initFlutter();
        await Hive.openBox('api_cache');
      } catch (e, st) {
        debugPrint('[main] Hive init/open api_cache failed: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.unknown,
          reason: 'HIVE_INIT_API_CACHE',
        );
      }
      // 2. Only treat zone errors as fatal in debug mode.
      // In release this flag kills the process on any unhandled async error,
      // turning recoverable zone exceptions into hard crashes.
      BindingBase.debugZoneErrorsAreFatal = kDebugMode;

      // 3. Setup global portrait lock
      try {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } catch (e) {
        debugPrint('[main] setPreferredOrientations: $e');
      }

      // 4. Firebase & Crashlytics setup
      final isFirebaseSupported =
          !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS);

      var shouldTryFirebase = isFirebaseSupported;

      // Android: check Play services without showing the system recovery dialog.
      // That dialog ("Check that Google Play is enabled…") comes from GMS when
      // Firebase (or other GMS APIs) run on a broken/outdated Play Services install.
      if (shouldTryFirebase && defaultTargetPlatform == TargetPlatform.android) {
        try {
          final gms = await GoogleApiAvailability.instance
              .checkGooglePlayServicesAvailability(false);
          if (gms != GooglePlayServicesAvailability.success) {
            debugPrint(
              '[main] Skipping Firebase: Google Play services status = $gms',
            );
            shouldTryFirebase = false;
          }
        } catch (e) {
          debugPrint('[main] Play services check failed, will try Firebase: $e');
        }
      }

      if (shouldTryFirebase) {
        try {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
          AppFirebaseState.markReady();
          _firebaseCoreInitialized = true;
        } catch (e, st) {
          AppFirebaseState.markNotReady();
          _firebaseCoreInitialized = false;
          debugPrint(
            '[main] Firebase.initializeApp failed (app continues): $e',
          );
          debugPrint(st.toString());
        }
      }

      if (isFirebaseSupported && _firebaseCoreInitialized) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
          kReleaseMode,
        );
      }

      // Never use recordFlutterFatalError — it can worsen perceived "crashes".
      // All framework errors are logged as non-fatal; ErrorWidget keeps UI alive.
      _installGlobalFlutterErrorHandling();

      try {
        final packageInfo = await PackageInfo.fromPlatform();
        await CrashlyticsService.initSession(
          appVersion: packageInfo.version,
          platform: defaultTargetPlatform.name,
          buildMode: kReleaseMode ? "release" : "debug",
        );
      } catch (e, st) {
        debugPrint('[main] PackageInfo / initSession: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.unknown,
          reason: 'PACKAGE_INFO_OR_SESSION',
        );
      }

      // 5. Downloader (Non-web platforms)
      if (!kIsWeb) {
        try {
          await FlutterDownloader.initialize(
            debug: kDebugMode,
            ignoreSsl: true,
          );
        } catch (e, st) {
          debugPrint('[main] FlutterDownloader.initialize: $e');
          CrashlyticsService.recordError(
            e,
            st,
            fatal: false,
            type: CrashErrorType.unknown,
            reason: 'FLUTTER_DOWNLOADER_INIT',
          );
        }
      }

      // 6. Serialized Storage Initialization (Guaranteed sequential to avoid FileSystemException)
      await _initializeAllStorage();

      // 7. Load Languages & Dependencies
      try {
        await LanguageModelService.loadLanguages();
      } catch (e, st) {
        debugPrint('[main] LanguageModelService.loadLanguages: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.unknown,
          reason: 'LOAD_LANGUAGES',
        );
      }

      _cachedSupportedLocales = await _getSupportedLocales();

      try {
        await dep.init();
      } catch (e, st) {
        debugPrint('[main] dep.init: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.unknown,
          reason: 'DEPENDENCIES_INIT',
        );
      }

      try {
        LanguageBinding().dependencies();
      } catch (e, st) {
        debugPrint('[main] LanguageBinding: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.ui,
          reason: 'LANGUAGE_BINDING',
        );
        try {
          if (!Get.isRegistered<LanguageControllerV2>()) {
            Get.put(LanguageControllerV2(), permanent: true);
          }
        } catch (e2, st2) {
          debugPrint('[main] LanguageControllerV2 fallback: $e2');
          CrashlyticsService.recordError(
            e2,
            st2,
            fatal: false,
            type: CrashErrorType.ui,
            reason: 'LANGUAGE_CONTROLLER_FALLBACK',
          );
        }
      }

      try {
        if (!Get.isRegistered<CustomTranslationService>()) {
          Get.put(CustomTranslationService(), permanent: true);
        }
      } catch (e, st) {
        debugPrint('[main] CustomTranslationService: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.ui,
          reason: 'CUSTOM_TRANSLATION_SERVICE',
        );
      }

      try {
        Get.put(GlobalNavController(), permanent: true);
      } catch (e, st) {
        debugPrint('[main] GlobalNavController: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.ui,
          reason: 'GLOBAL_NAV_CONTROLLER',
        );
      }

      AnalyticsService().logAppOpen();

      try {
        runApp(const MyApp());
      } catch (e, st) {
        debugPrint('[main] runApp: $e');
        CrashlyticsService.recordError(
          e,
          st,
          fatal: false,
          type: CrashErrorType.ui,
          reason: 'RUN_APP',
        );
        runApp(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Unable to start the full app. Please close and reopen, or reinstall from the store.\n\n($e)',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    },
    (error, stack) {
      final label = classifyFlutterException(error, error.toString());
      CrashlyticsService.recordError(
        error,
        stack,
        fatal: false,
        type: _crashTypeForClassifiedReason(label),
        reason: 'ZONE_GUARDED_$label',
      );
      debugPrint('Zone error (non-fatal): $error');
      debugPrint(stack.toString());
    },
  );
}

CrashErrorType _crashTypeForClassifiedReason(String reason) {
  switch (reason) {
    case 'NETWORK_HOST_LOOKUP':
    case 'HTTP_TLS_NETWORK':
    case 'HTTP_EXCEPTION':
    case 'TIMEOUT':
      return CrashErrorType.socket;
    default:
      return CrashErrorType.ui;
  }
}

/// Crashlytics label for an exception — used so we log without killing the process.
String classifyFlutterException(Object exception, String s) {
  if (exception is MissingPluginException) {
    if (s.contains('OneSignal')) return 'ONESIGNAL_MISSING_PLUGIN';
    return 'MISSING_PLUGIN';
  }
  if (s.contains('IOperationRepo') && s.contains('OneSignal')) {
    return 'ONESIGNAL_NATIVE_SERVICE_ERROR';
  }
  if (s.contains('No host specified in URI assets/')) {
    return 'ASSET_URI_PARSED_AS_NETWORK';
  }
  if (s.contains('CameraException(') &&
      s.contains('Disposed CameraController')) {
    return 'CAMERA_DISPOSED_CONTROLLER';
  }
  if (s.contains('"EQ" not found') ||
      s.contains('Get.put(EQ())') ||
      s.contains('Get.lazyPut(() => EQ())')) {
    return 'MISSING_GETX_DEP_EQ';
  }
  if (s.contains('Concurrent modification during iteration')) {
    return 'CONCURRENT_MODIFICATION_DURING_ITERATION';
  }
  if (s.contains('Bad state: Too many elements')) {
    return 'TOO_MANY_ELEMENTS';
  }
  if (s.contains('SocketException') ||
      s.contains('Failed host lookup') ||
      s.contains('No address associated with hostname')) {
    return 'NETWORK_HOST_LOOKUP';
  }
  if (s.contains('GooglePlayServices') ||
      s.contains('com.google.android.gms') ||
      s.contains('FirebaseException')) {
    return 'GOOGLE_PLAY_OR_FIREBASE_SDK';
  }
  if (s.contains('TimeoutException') || s.contains('timeout')) {
    return 'TIMEOUT';
  }
  if (s.contains('FormatException')) {
    return 'FORMAT_EXCEPTION';
  }
  if (s.contains('ClientException') ||
      s.contains('HandshakeException') ||
      s.contains('TlsException') ||
      s.contains('Connection terminated') ||
      s.contains('Connection closed')) {
    return 'HTTP_TLS_NETWORK';
  }
  if (s.contains('PlatformException')) {
    return 'PLATFORM_EXCEPTION';
  }
  if (s.contains('FileSystemException') ||
      s.contains('PathNotFoundException') ||
      s.contains('PathAccessException')) {
    return 'FILESYSTEM';
  }
  if (s.contains('HttpException')) {
    return 'HTTP_EXCEPTION';
  }
  if (s.contains('Null check operator used on a null value') ||
      s.contains('is not a subtype of')) {
    return 'NULL_OR_TYPE_CAST';
  }
  if (s.contains('Bad state:') || s.contains('StateError')) {
    return 'BAD_STATE';
  }
  if (s.contains('LateInitializationError')) {
    return 'LATE_INIT';
  }
  if (s.contains('RangeError')) {
    return 'RANGE_ERROR';
  }
  if (s.contains('NetworkImageLoadException') ||
      s.contains('ImageCodecException') ||
      s.contains('Failed to decode image')) {
    return 'IMAGE_DECODE';
  }
  if (s.contains('RenderBox') ||
      s.contains('RenderFlex') ||
      s.contains('viewport was given unbounded')) {
    return 'LAYOUT_ASSERTION';
  }
  return 'FLUTTER_FRAMEWORK_ERROR';
}

void _installGlobalFlutterErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final stack = details.stack ?? StackTrace.current;
    final exceptionString = exception.toString();
    final reason = classifyFlutterException(exception, exceptionString);
    final type = _crashTypeForClassifiedReason(reason);
    CrashlyticsService.recordError(
      exception,
      stack,
      fatal: false,
      type: type,
      reason: reason,
    );
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (error is FlutterError) return true;
    final label = classifyFlutterException(error, error.toString());
    CrashlyticsService.recordError(
      error,
      stack,
      fatal: false,
      type: _crashTypeForClassifiedReason(label),
      reason: 'PLATFORM_DISPATCHER_$label',
    );
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    final exception = details.exception;
    final stack = details.stack ?? StackTrace.current;
    final exceptionString = exception.toString();
    final label = classifyFlutterException(exception, exceptionString);
    CrashlyticsService.recordError(
      exception,
      stack,
      fatal: false,
      type: _crashTypeForClassifiedReason(label),
      reason: 'ERROR_WIDGET_$label',
    );
    return _defaultBrokenWidgetPlaceholder();
  };
}

Widget _defaultBrokenWidgetPlaceholder() {
  return Material(
    child: Container(
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: "#6F221E".toColor(),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Please go back or restart the app. If this keeps happening, "
                  "update the app from the Play Store and ensure Google Play "
                  "services are enabled and up to date.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
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
                  try {
                    // When cold-started via deeplink, platform passes URI; GetX has no matching GetPage and crashes.
                    final isDeeplink =
                        initialRoute.startsWith('astrouser://') ||
                        (initialRoute.isNotEmpty &&
                            !initialRoute.startsWith('/'));
                    final routeToUse =
                        isDeeplink ? PageRoutes.INITIAL : initialRoute;
                    final match =
                        PageRoutes.routes.cast<GetPage>().firstWhereOrNull(
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
                  } catch (e, st) {
                    debugPrint('[main] onGenerateInitialRoutes: $e');
                    CrashlyticsService.recordError(
                      e,
                      st,
                      fatal: false,
                      type: CrashErrorType.ui,
                      reason: 'GENERATE_INITIAL_ROUTES',
                    );
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
                  if (_firebaseCoreInitialized)
                    FirebaseAnalyticsObserver(
                      analytics: FirebaseAnalytics.instance,
                    ),
                ],

                routingCallback: (routing) {
                  try {
                    if (routing == null) return;
                    final route = routing.current.split('?').first;
                    final args = routing.args;
                    if (kDebugMode) {
                      debugPrint(
                        'GlobalNav: routingCallback route=$route args=$args',
                      );
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      try {
                        if (Get.isRegistered<GlobalNavController>()) {
                          Get.find<GlobalNavController>().updateRoute(
                            route,
                            args: args,
                          );
                        }
                      } catch (e, st) {
                        debugPrint('[main] routingCallback postFrame: $e');
                        CrashlyticsService.recordError(
                          e,
                          st,
                          fatal: false,
                          type: CrashErrorType.ui,
                          reason: 'ROUTING_CALLBACK_POSTFRAME',
                        );
                      }
                    });
                  } catch (e, st) {
                    debugPrint('[main] routingCallback: $e');
                    CrashlyticsService.recordError(
                      e,
                      st,
                      fatal: false,
                      type: CrashErrorType.ui,
                      reason: 'ROUTING_CALLBACK',
                    );
                  }
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
