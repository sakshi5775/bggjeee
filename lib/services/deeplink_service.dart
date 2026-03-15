// 1. Convert it to a GetxService
import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/kundli/service/kundli_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/address_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Deeplink host for kundli result (matches Android intent-filter host)
const String kundliResultHost = 'kundli-result';

class DeepLinkHandler extends GetxService {
  final _appLinks = AppLinks();

  /// Pending kundli args from deeplink when app was cold-started.
  /// Dashboard calls [processPendingKundliDeeplink] when ready to navigate.
  Map<String, dynamic>? _pendingKundliArgs;

  /// So we don't process the same cold-start link more than once when retrying getInitialLink.
  bool _initialLinkHandled = false;

  /// True as soon as we receive a kundli-result URI (cold start). Lets waiting screen skip dashboard.
  bool _launchedByKundliDeeplink = false;

  /// Completes when initial link has been checked (or after timeout). Waiting screen awaits this.
  Completer<void>? _initialLinkCompleter;
  static const Duration _initialLinkTimeout = Duration(milliseconds: 1200);

  /// Args set right before pushing kundli result from deeplink.
  /// KundliResultController uses this when Get.arguments is null (nested navigator).
  static Map<String, dynamic>? lastPushedKundliArgs;

  /// True if app was cold-started by "Open Kundli" deeplink from astrologer app.
  bool get wasLaunchedByKundliDeeplink => _launchedByKundliDeeplink;

  /// Future that completes when we have checked for an initial deeplink (or after [_initialLinkTimeout]).
  /// Waiting screen should await this before deciding to show dashboard vs staying for kundli.
  Future<void> get initialLinkChecked =>
      _initialLinkCompleter?.future ?? Future.value();

  @override
  void onInit() {
    super.onInit();
    _initialLinkCompleter = Completer<void>();
    initDeepLinks();
    // Ensure we never block forever if getInitialLink never resolves
    Future.delayed(_initialLinkTimeout, () {
      if (!_initialLinkCompleter!.isCompleted) {
        _initialLinkCompleter!.complete();
      }
    });
  }

  void initDeepLinks() {
    // Handle app completely closed - call immediately and retry after delay (Android intent can arrive late)
    void tryInitialLink() {
      _appLinks.getInitialLink().then((Uri? uri) {
        if (!_initialLinkCompleter!.isCompleted) {
          _initialLinkCompleter!.complete();
        }
        if (uri != null && !_initialLinkHandled) {
          _initialLinkHandled = true;
          if (kDebugMode) debugPrint('Deeplink: getInitialLink received uri=$uri');
          _processDeepLink(uri);
        }
      });
    }

    tryInitialLink();
    // Retry after 400ms and 1000ms - on Android the launch intent is sometimes not ready immediately
    Future.delayed(const Duration(milliseconds: 400), tryInitialLink);
    Future.delayed(const Duration(milliseconds: 1000), tryInitialLink);

    // Handle app open in background (or link when already running)
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null) return;
      // Avoid processing the same link twice when cold-started by deeplink
      // (getInitialLink and uriLinkStream can both fire with the same URI).
      if (_initialLinkHandled &&
          uri.host == kundliResultHost &&
          _pendingKundliArgs != null) {
        if (kDebugMode) debugPrint('Deeplink: uriLinkStream skipped (already handled as initial link)');
        return;
      }
      if (kDebugMode) debugPrint('Deeplink: uriLinkStream received uri=$uri');
      _processDeepLink(uri);
    });
  }

  /// Process deeplink - same data structure as chat_profile_dialog / astrologer app sends.
  /// Params: name, gender, dob, tob, pob, language. (maritalStatus accepted from URL but not used for kundli)
  void _processDeepLink(Uri uri) {
    if (kDebugMode) debugPrint('Deeplink: received uri=$uri scheme=${uri.scheme} host=${uri.host}');
    if (uri.scheme != 'astrouser') return;
    // Android host is "kundli-result"; path can vary
    final host = uri.host.isEmpty ? (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '') : uri.host;
    if (host != kundliResultHost && host != 'kundli-result') return;
    _launchedByKundliDeeplink = true; // So waiting screen skips dashboard and stays on splash until we open kundli
    if (kDebugMode) debugPrint('Deeplink: matched kundli-result, params=${uri.queryParameters}');

    final params = uri.queryParameters;
    final name = params['name'] ?? '';
    final gender = params['gender'] ?? '';
    final dob = params['dob'] ?? '';
    final tob = params['tob'] ?? '';
    final pob = params['pob'] ?? '';
    final language = _normalizeLanguage(params['language'] ?? 'en');

    if (dob.isEmpty || tob.isEmpty || pob.isEmpty) {
      if (kDebugMode) {
        debugPrint('Deeplink: missing required params (dob=$dob, tob=$tob, pob=$pob)');
      }
      return;
    }

    _generateKundliAndNavigate(
      name: name,
      gender: gender,
      dob: dob,
      tob: tob,
      pob: pob,
      language: language,
    );
  }

  Future<void> _generateKundliAndNavigate({
    required String name,
    required String gender,
    required String dob,
    required String tob,
    required String pob,
    required String language,
  }) async {
    try {
      // Parse pob -> city, state, country for geocoding
      final placeParts = pob.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final city = placeParts.isNotEmpty ? placeParts[0] : pob;
      final state = placeParts.length > 1 ? placeParts[1] : null;
      final country = placeParts.length > 2 ? placeParts[2] : 'India';

      // Fetch coordinates from place of birth
      final coords = await AddressHelper.fetchCoordinatesFromCity(
        city: city,
        state: state,
        country: country,
      );

      if (coords == null) {
        if (kDebugMode) debugPrint('Deeplink: could not geocode pob=$pob');
        _showErrorAndExit();
        return;
      }

      final lat = coords['latitude'] as double;
      final lon = coords['longitude'] as double;
      double tz = 5.5;
      if (coords['timezone'] != null) {
        final tzOffset = await AddressHelper.getTimezoneOffsetFromCoordinates(lat, lon);
        if (tzOffset != null) tz = tzOffset;
      }

      // Parse dob -> dd/MM/yyyy for kundli API
      String dateStr = _parseDobToKundliFormat(dob);
      if (dateStr.isEmpty) {
        if (kDebugMode) debugPrint('Deeplink: could not parse dob=$dob');
        _showErrorAndExit();
        return;
      }

      // Parse tob -> HH:mm for kundli API (24h)
      String timeStr = _parseTobToKundliFormat(tob);
      if (timeStr.isEmpty) {
        if (kDebugMode) debugPrint('Deeplink: could not parse tob=$tob');
        _showErrorAndExit();
        return;
      }

      const colorHex = '#ed6f30';
      final kundliService = KundliService();
      final data = await kundliService.generateKundli(
        date: dateStr,
        time: timeStr,
        latitude: lat,
        longitude: lon,
        tz: tz,
        lang: language.isNotEmpty ? language : 'en',
        style: 'north',
        coloredPlanets: true,
        color: colorHex,
      );

      if (data == null) {
        if (kDebugMode) debugPrint('Deeplink: kundli API returned null');
        _showErrorAndExit();
        return;
      }

      final formDataMap = <String, dynamic>{
        'name': name.isNotEmpty ? name : 'User',
        'gender': gender.isNotEmpty ? gender : 'Male',
        'date': dateStr,
        'time': timeStr,
        'latitude': lat,
        'longitude': lon,
        'timezone': tz,
        'language': language.isNotEmpty ? language : 'en',
        'style': 'north',
        'coloredPlanets': true,
        'color': colorHex,
        'selectedLocation': pob,
        'place': pob,
        'city': pob,
      };

      final args = {'kundliData': data, 'formData': formDataMap};
      lastPushedKundliArgs = args;

      // Replace current route with Kundli result so user lands directly on kundli (no dashboard on stack).
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (_pendingKundliArgs == null) return; // already cleared by processPendingKundliDeeplink (warm path)
          Get.offNamed(AppRoutes.kundliResult, arguments: args);
          _pendingKundliArgs = null;
        });
      });
      _pendingKundliArgs = args;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Deeplink error: $e');
        debugPrint('$st');
      }
      _showErrorAndExit();
    }
  }

  String _parseDobToKundliFormat(String dob) {
    if (dob.isEmpty) return '';
    final trimmed = dob.trim();
    if (trimmed.isEmpty) return '';
    try {
      // Try ISO (yyyy-MM-dd)
      var d = DateTime.tryParse(trimmed);
      if (d != null) {
        return DateFormat('dd/MM/yyyy').format(d);
      }
      // Try dd/MM/yyyy, dd-MM-yyyy, or MM/dd/yyyy
      final normalized = trimmed.replaceAll('-', '/').replaceAll('.', '/');
      final parts = normalized.split('/');
      if (parts.length == 3) {
        final p0 = int.tryParse(parts[0].trim()) ?? 0;
        final p1 = int.tryParse(parts[1].trim()) ?? 0;
        final p2 = int.tryParse(parts[2].trim()) ?? 0;
        int day, month, year;
        if (p1 > 12) {
          month = p0;
          day = p1;
          year = p2;
        } else if (p0 > 12) {
          day = p0;
          month = p1;
          year = p2;
        } else {
          day = p0;
          month = p1;
          year = p2;
        }
        if (year > 0 && month >= 1 && month <= 12 && day >= 1 && day <= 31) {
          d = DateTime(year, month, day);
          return DateFormat('dd/MM/yyyy').format(d);
        }
      }
      // Try "15 January 1990" or "Jan 15, 1990" (use en so month names parse)
      const locale = 'en_US';
      final formats = [
        'dd MMMM yyyy',
        'd MMMM yyyy',
        'MMM d, yyyy',
        'MMMM d, yyyy',
        'dd-MMM-yyyy',
      ];
      for (final fmt in formats) {
        try {
          d = DateFormat(fmt, locale).parse(trimmed);
          return DateFormat('dd/MM/yyyy').format(d);
        } catch (_) {}
      }
    } catch (_) {}
    return '';
  }

  /// Map language from chat (e.g. "English", "Hindi") to API code.
  String _normalizeLanguage(String lang) {
    if (lang.trim().isEmpty) return 'en';
    final lower = lang.trim().toLowerCase();
    const map = {
      'english': 'en',
      'hindi': 'hi',
      'gujarati': 'gu',
      'telegu': 'te',
      'telugu': 'te',
      'tamil': 'ta',
      'kannada': 'ka',
      'marathi': 'mr',
      'malayalam': 'ml',
      'bengali': 'be',
      'odiya': 'or',
      'odia': 'or',
    };
    return map[lower] ?? (lower.length <= 3 ? lower : 'en');
  }

  String _parseTobToKundliFormat(String tob) {
    if (tob.isEmpty) return '';
    try {
      final normalized = tob.trim().toLowerCase();
      // HH:mm or HH:mm:ss (24h)
      final match24 = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(tob);
      if (match24 != null) {
        int h = int.parse(match24.group(1)!);
        final m = int.parse(match24.group(2)!);
        if (h >= 0 && h <= 23 && m >= 0 && m <= 59) {
          return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
        }
      }
      // 12h: "10:30 AM", "10:30:00 PM"
      final match12 = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(am|pm)$').firstMatch(normalized);
      if (match12 != null) {
        int h = int.parse(match12.group(1)!);
        final m = int.parse(match12.group(2)!);
        final isPm = match12.group(4) == 'pm';
        if (isPm && h != 12) h += 12;
        if (!isPm && h == 12) h = 0;
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
      }
      // Try DateFormat for "hh:mm a"
      final fmt = DateFormat('hh:mm a');
      final dt = fmt.parse(tob);
      return DateFormat('HH:mm').format(dt);
    } catch (_) {}
    return '';
  }

  void _showErrorAndExit() {
    Get.snackbar(
      'Error',
      'Could not open Kundli. Please check the link or try again.',
    );
  }

  /// Call from dashboard when UserMainController is ready.
  /// Navigates to kundli result if a deeplink was received during cold start.
  static Future<void> processPendingKundliDeeplink() async {
    final handler = Get.isRegistered<DeepLinkHandler>()
        ? Get.find<DeepLinkHandler>()
        : null;
    if (handler == null) return;

    final args = handler._pendingKundliArgs;
    if (args == null) return;

    if (!Get.isRegistered<UserMainController>()) return;

    // Delay + retry: wait for navigator to be fully ready (avoids blank screen)
    const maxAttempts = 6;
    const initialDelayMs = 1200;
    const retryDelayMs = 300;

    Future<void> tryNavigate(int attempt) async {
      await Future.delayed(Duration(
        milliseconds: attempt == 0 ? initialDelayMs : retryDelayMs,
      ));
      if (!Get.isRegistered<UserMainController>()) return;

      final ctrl = Get.find<UserMainController>();
      final navKey = ctrl.navigatorKeys[ctrl.currentIndex.value];
      if (navKey.currentState != null) {
        handler._pendingKundliArgs = null;
        Get.routing.args = args;
        lastPushedKundliArgs = args;
        navKey.currentState!.pushNamed(AppRoutes.kundliResult, arguments: args);
        return;
      }
      if (attempt < maxAttempts - 1) {
        tryNavigate(attempt + 1);
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((_) => tryNavigate(0));
  }
}
