import 'dart:async';

import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/role_navigation_service.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaitingScreenController extends BaseController {

  final stageIndex = 0.obs;
  final List<Duration> _stageDurations = const [
    Duration(milliseconds: 600),
    Duration(milliseconds: 1200),
    Duration(milliseconds: 900),
    Duration(milliseconds: 1400),
    Duration(milliseconds: 800),
    Duration(milliseconds: 400),
  ];

  Timer? _stageTimer;
  var _navigationTriggered = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNextStage();
    });
  }

  void _scheduleNextStage() {
    _stageTimer?.cancel();
    final currentIndex = stageIndex.value;
    final duration = _stageDurations.elementAt(currentIndex);
    _stageTimer = Timer(duration, () {
      if (currentIndex < _stageDurations.length - 1) {
        stageIndex.value = currentIndex + 1;
        _scheduleNextStage();
      } else {
        _completeNavigation();
      }
    });
  }

  void _completeNavigation() {
    if (_navigationTriggered) return;
    _navigationTriggered = true;
    Future.delayed(const Duration(milliseconds: 120), () {
      final isLoggedIn = LoginGuard.isLoggedIn;
      if (isLoggedIn) {
        final userType = UserData().getLoginData.user?.userType ?? 'USER';
        RoleNavigationService.navigateToDashboard(userType);
      } else {
        // Allow guest users to browse the app before logging in.
        pushAndRemoveUntil(AppRoutes.userDashboard);
      }
    });
  }

  @override
  void onClose() {
    _stageTimer?.cancel();
    super.onClose();
  }
}
