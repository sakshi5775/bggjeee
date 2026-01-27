import 'package:astrobharataiuser/binding/ai_chat_binding/ai_chat_binding.dart';
import 'package:astrobharataiuser/binding/dashboard_binding/user_dashboard_binding.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/live_astrologers/view/live_astrologers_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/consultation_history_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainController extends GetxController {
  final selectedIndex = 0.obs;

  final pages = [
    '/user-home',
    AppRoutes.consultationHistory,
    AppRoutes.astrologyServices,
    AppRoutes.aichat,
    AppRoutes.liveAstrologers,
  ];

  String get initialRoute => pages.first;

  // ---------------- ROUTING ----------------
  Route? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final showBackButton = args?['showBackButton'] as bool? ?? false;

    switch (settings.name) {
      case '/user-home':
        return GetPageRoute(
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );

      case AppRoutes.consultationHistory:
        return GetPageRoute(
          page: () => ConsultationHistoryView(showBackButton: showBackButton),
        );

      case AppRoutes.astrologyServices:
        return GetPageRoute(
          page: () => AstrologyServicesView(showBackButton: showBackButton),
        );

      case AppRoutes.aichat:
        return GetPageRoute(
          page: () => AiChatView(showBackButton: showBackButton),
          binding: AiChatBinding(),
        );

      case AppRoutes.liveAstrologers:
        return GetPageRoute(
          page: () => LiveAstrologersView(showBackButton: showBackButton),
        );

      default:
        return GetPageRoute(
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );
    }
  }

  // ---------------- TAB CHANGE ----------------
  void changePage(int index) {
    if (index == selectedIndex.value) return;

    // Protect History, Consult, AI, and Live
    final requiresLogin = index == 1 || index == 2 || index == 3 || index == 4;
    if (requiresLogin && LoginGuard.isGuest) {
      LoginGuard.showLoginRequiredModal(
        message: index == 1
            ? 'Please login to view history.'
            : index == 2
                ? 'Please login to consult astrologers.'
                : index == 3
                    ? 'Please login to access AI chat.'
                    : 'Please login to view live astrologers.',
      );
      return;
    }

    _navigate(index);
  }

  void _navigate(int index) {
    selectedIndex.value = index;
    // All tabs use nested navigator (id: 1) so bottom nav stays visible.
    // History, Consult, AI, Live: no back button when opened from bottom nav.
    final noBack = index != 0;
    final args = noBack ? {'showBackButton': false} : null;
    Get.offNamed(pages[index], id: 1, arguments: args);
  }

  // ---------------- BACK HANDLER ----------------
  void handleBackNavigation() {
    final nav = Get.nestedKey(1)?.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
    // At tab root: bottom nav visible, no back — do nothing.
  }
}

