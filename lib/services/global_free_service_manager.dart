import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:astrobharataiuser/screens/astrology_services/services/astrologer_service.dart';
import 'package:astrobharataiuser/screens/ai_chat/services/ai_chat_service.dart';

import '../screens/user_dashboard/widgets/free_service_dialog.dart';

/// Global service to manage free service popup across the entire app
/// Shows popup every 3 minutes until free services are used
class GlobalFreeServiceManager extends GetxService {
  Timer? _checkTimer;
  bool _isDialogShowing = false;
  DateTime? _lastShownTime;
  static const String _freeClaimedKey = 'first_consultation_free_claimed';

  static const Duration _checkInterval = Duration(minutes: 3);
  static const Duration _cooldownAfterShow = Duration(seconds: 20);

  bool _contextRetryScheduled = false;

  @override
  void onInit() {
    super.onInit();
    // Start immediately so popup appears after every app restart.
    start();
  }

  /// Start the service (call this after user logs in and dashboard is loaded)
  void start() {
    // If timer is already running (e.g. user re-opened dashboard tab),
    // still do a quick forced check so popup can appear without waiting
    // for the full 3-minute interval.
    if (_checkTimer != null) {
      Future.delayed(const Duration(seconds: 1), () => checkNow());
      return;
    }

    // Start checking after a delay to let dashboard load and context settle.
    Future.delayed(const Duration(seconds: 2), _startPeriodicCheck);
  }

  @override
  void onClose() {
    _checkTimer?.cancel();
    super.onClose();
  }

  /// Start periodic check every 3 minutes
  void _startPeriodicCheck() {
    print(
      "GlobalFreeServiceManager: Starting periodic check (interval: ${_checkInterval.inSeconds}s)",
    );
    // Check immediately once (so the user doesn't have to wait 3 minutes)
    _checkAndShowDialog();
    // Then check every 3 minutes
    _checkTimer = Timer.periodic(_checkInterval, (timer) {
      print("GlobalFreeServiceManager: Timer tick");
      _checkAndShowDialog();
    });
  }

  /// Check free services status and show dialog if available
  Future<void> _checkAndShowDialog() async {
    print("GlobalFreeServiceManager: _checkAndShowDialog called");
    try {
      // It's a free first consultation: show even if user is not logged-in.
      // (CTA navigation will be guarded by app routes if needed.)

      // Don't show if dialog is already showing
      if (_isDialogShowing) {
        print("GlobalFreeServiceManager: Dialog already showing");
        return;
      }

      // Don't show if we just showed it (within last 2 minutes to avoid spam)
      if (_lastShownTime != null) {
        final timeSinceLastShow = DateTime.now().difference(_lastShownTime!);
        if (timeSinceLastShow < _cooldownAfterShow) {
          print(
            "GlobalFreeServiceManager: Cooldown active (${timeSinceLastShow.inSeconds}s)",
          );
          return;
        }
      }

      // Check if Get.context is available
      if (Get.context == null) {
        print("GlobalFreeServiceManager: Get.context is null");
        // Retry once when context becomes available.
        if (!_contextRetryScheduled) {
          _contextRetryScheduled = true;
          Future.delayed(const Duration(seconds: 2), () {
            _contextRetryScheduled = false;
            _checkAndShowDialog();
          });
        }
        return;
      }

      final storage = GetStorage();
      final claimed = storage.read<bool>(_freeClaimedKey) ?? false;
      if (claimed) {
        print("GlobalFreeServiceManager: Free consultation already claimed.");
        stop();
        return;
      }

      // Check if dialog is already open
      if (Get.isDialogOpen == true) {
        print("GlobalFreeServiceManager: Dialog already open.");
        return;
      }

      _isDialogShowing = true;
      _lastShownTime = DateTime.now();
      final imageUrl = await _fetchPopupImageUrl();
      print("GlobalFreeServiceManager: Showing FreeServiceDialog");
      await Get.dialog(
        FreeServiceDialog(imageUrl: imageUrl),
        barrierDismissible: true,
      );
      _isDialogShowing = false;
    } catch (e) {
      debugPrint('Error in GlobalFreeServiceManager: $e');
      _isDialogShowing = false;
    }
  }

  /// Fetch a promo image from API (human astrologer or AI persona).
  /// We fetch only when the dialog is about to show (not every 3 minutes).
  Future<String?> _fetchPopupImageUrl() async {
    try {
      final astrologerService = AstrologerService();
      final aiChatService = AiChatService();

      final futures = await Future.wait([
        astrologerService.getAstrologers(
          page: 1,
          limit: 10,
          useCache: false,
          sortBy: 'rating',
        ),
        aiChatService.getPersonas(
          page: 1,
          limit: 10,
          featured: true,
          sortBy: 'popularity',
        ),
      ]);

      final astrologerResponse = futures[0] as dynamic;
      final personaResponse = futures[1] as dynamic;

      final humanUrls = <String>[];
      final aiUrls = <String>[];

      if (astrologerResponse != null) {
        for (final a in astrologerResponse.astrologers) {
          final url = a.profilePicture;
          if (url != null && url.isNotEmpty) humanUrls.add(url);
        }
      }

      if (personaResponse != null) {
        for (final p in personaResponse.personas) {
          final url = p.image;
          if (url != null && url.isNotEmpty) aiUrls.add(url);
        }
      }

      final all = <String>[
        ...humanUrls,
        ...aiUrls,
      ];
      if (all.isEmpty) return null;

      all.shuffle();
      return all.first;
    } catch (e) {
      debugPrint('GlobalFreeServiceManager: image fetch failed: $e');
      return null;
    }
  }

  /// Manually trigger check (can be called from anywhere)
  Future<void> checkNow() async {
    await _checkAndShowDialog();
  }

  /// Stop the periodic check
  void stop() {
    _checkTimer?.cancel();
    _checkTimer = null;
  }

  /// Restart the periodic check
  void restart() {
    stop();
    _startPeriodicCheck();
  }
}
