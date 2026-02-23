import 'package:astrobharataiuser/binding/ai_chat_binding/ai_chat_binding.dart';
import 'package:astrobharataiuser/binding/dashboard_binding/user_dashboard_binding.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/profile_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/profile_view.dart';
import 'package:astrobharataiuser/screens/live_astrologers/view/live_astrologers_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Model for a single bottom nav item (dynamic labels/icons).
class BottomNavItem {
  final String label;
  final String icon;

  const BottomNavItem({required this.label, required this.icon});
}

class UserMainController extends GetxController {
  final selectedIndex = 0.obs;

  /// Bottom nav items: Home, Chat, Call, AI, Profile. Update this list to change nav dynamically.
  final RxList<BottomNavItem> navItems = <BottomNavItem>[
    const BottomNavItem(label: 'Home', icon: AppConstant.bottomHomeIcon),
    const BottomNavItem(
      label: 'Consult',
      icon: AppConstant.bottomConsultationIcon,
    ),
    const BottomNavItem(
      label: 'AstroStream',
      icon: AppConstant.bottomLiveStreamIcon,
    ),
    const BottomNavItem(label: 'AI Guru', icon: ''),
    const BottomNavItem(label: 'Profile', icon: ''),
  ].obs;

  final pages = [
    '/user-home',
    AppRoutes.allAstrologers,
    AppRoutes.liveAstrologers,
    AppRoutes.aichat,
    AppRoutes.profile,
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

      case AppRoutes.allAstrologers:
        return GetPageRoute(
          page: () => AllAstrologersView(
            hideHeader: false,
            showBackButton: showBackButton,
          ),
        );

      case AppRoutes.liveAstrologers:
        return GetPageRoute(
          page: () => LiveAstrologersView(showBackButton: showBackButton),
        );

      case AppRoutes.aichat:
        return GetPageRoute(
          page: () => AiChatView(showBackButton: showBackButton),
          binding: AiChatBinding(),
        );

      case AppRoutes.profile:
        return GetPageRoute(
          page: () => ProfileView(showBackButton: showBackButton),
          binding: ProfileBinding(),
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

    // Protect Chat, Call, AI, Profile (require login)
    final requiresLogin = index >= 1 && index <= 4;
    if (requiresLogin && LoginGuard.isGuest) {
      final messages = [
        '',
        'Please login to view chat.',
        'Please login to consult astrologers.',
        'Please login to access AI chat.',
        'Please login to view profile.',
      ];
      LoginGuard.showLoginRequiredModal(message: messages[index]);
      return;
    }

    _navigate(index);
  }

  void _navigate(int index) {
    selectedIndex.value = index;
    // All tabs use nested navigator (id: 1) so bottom nav stays visible.
    // Chat, Call, AI, Profile: no back button when opened from bottom nav.
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
