import 'dart:async';
import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/free_services_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/free_service_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Global service to manage free service popup across the entire app
/// Shows popup every 3 minutes until free services are used
class GlobalFreeServiceManager extends GetxService {
  final FreeServicesService _freeServicesService = FreeServicesService();
  Timer? _checkTimer;
  bool _isDialogShowing = false;
  DateTime? _lastShownTime;
  static const Duration _checkInterval = Duration(minutes: 3);

  @override
  void onInit() {
    super.onInit();
    // Don't start automatically - will be started manually after login and dashboard load
  }
  
  /// Start the service (call this after user logs in and dashboard is loaded)
  void start() {
    if (_checkTimer != null) return; // Already running
    // Start checking after a delay to let dashboard load
    Future.delayed(const Duration(seconds: 2), () {
      _startPeriodicCheck();
    });
  }

  @override
  void onClose() {
    _checkTimer?.cancel();
    super.onClose();
  }

  /// Start periodic check every 3 minutes
  void _startPeriodicCheck() {
    // Check immediately on first run
    _checkAndShowDialog();
    
    // Then check every 3 minutes
    _checkTimer = Timer.periodic(_checkInterval, (timer) {
      _checkAndShowDialog();
    });
  }

  /// Check free services status and show dialog if available
  Future<void> _checkAndShowDialog() async {
    try {
      // Check if user is logged in (check if access token exists)
      try {
        final userData = UserData();
        final accessToken = userData.accessToken;
        if (accessToken == null || accessToken.isEmpty) {
          return; // User not logged in
        }
      } catch (e) {
        return; // User data not available
      }
      
      // Don't show if dialog is already showing
      if (_isDialogShowing) return;
      
      // Don't show if we just showed it (within last 2 minutes to avoid spam)
      if (_lastShownTime != null) {
        final timeSinceLastShow = DateTime.now().difference(_lastShownTime!);
        if (timeSinceLastShow.inMinutes < 2) {
          return;
        }
      }

      // Check if Get.context is available
      if (Get.context == null) return;

      final statusData = await _freeServicesService.getFreeServicesStatus();
      
      if (statusData != null && _freeServicesService.hasFreeServicesAvailable(statusData)) {
        // Check if dialog is already open
        if (Get.isDialogOpen == true) return;
        
        _isDialogShowing = true;
        _lastShownTime = DateTime.now();
        
        // Show dialog
        await Get.dialog(
          const FreeServiceDialog(),
          barrierDismissible: true,
        );
        
        _isDialogShowing = false;
      } else {
        // No free services available - stop checking
        stop();
      }
    } catch (e) {
      debugPrint('Error in GlobalFreeServiceManager: $e');
      _isDialogShowing = false;
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

