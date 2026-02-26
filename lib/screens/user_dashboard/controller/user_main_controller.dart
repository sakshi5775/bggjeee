import 'package:astrobharataiuser/binding/ai_chat_binding/ai_chat_binding.dart';
import 'package:astrobharataiuser/binding/dashboard_binding/user_dashboard_binding.dart';
import 'package:astrobharataiuser/core/controllers/global_nav_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/routes/get_pages.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/profile_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/profile_view.dart';
import 'package:astrobharataiuser/screens/live_astrologers/view/live_astrologers_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainController extends GetxController {
  // ─── Tab State ───────────────────────────────────────────
  final currentIndex = 0.obs;

  /// History of visited tab indices (for cross-tab back navigation).
  /// Tracks the user's exact journey across tabs.
  final List<int> _tabHistory = [0]; // starts on Home

  /// A navigator key for every tab – IndexedStack keeps all alive.
  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    5,
    (_) => GlobalKey<NavigatorState>(),
  );

  /// The initial / root route of each tab.
  final List<String> tabInitialRoutes = const [
    '/user-home',
    AppRoutes.allAstrologers,
    AppRoutes.liveAstrologers,
    AppRoutes.aichat,
    AppRoutes.profile,
  ];

  // ─── Tab Switch ──────────────────────────────────────────
  void changeTab(int index) {
    print('UserMain: changeTab → $index (current=${currentIndex.value})');

    if (index == currentIndex.value) {
      // same tab → pop to root
      navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
      return;
    }

    // Protect non-Home tabs that require login
    if (index >= 1 && index <= 4 && LoginGuard.isGuest) {
      final messages = [
        '',
        'Please login to consult astrologers.',
        'Please login to view AstroStream.',
        'Please login to access AI Guru.',
        'Please login to view profile.',
      ];
      LoginGuard.showLoginRequiredModal(message: messages[index]);
      return;
    }

    // Push current tab to history before switching
    _tabHistory.add(index);
    currentIndex.value = index;

    // Sync highlight in the global bottom bar
    if (Get.isRegistered<GlobalNavController>()) {
      Get.find<GlobalNavController>().syncFromTab(index);
    }
  }

  // ─── Back Navigation (history-based cross-tab aware) ──────
  /// Returns true if the back action was consumed.
  bool handleBackNavigation() {
    final currentNav = navigatorKeys[currentIndex.value].currentState;

    // Priority 1: Pop inside current tab if there are inner pages
    if (currentNav != null && currentNav.canPop()) {
      print('UserMain: back → pop inside tab ${currentIndex.value}');
      currentNav.pop();
      return true;
    }

    // Priority 2: Go back to previous tab in history
    // Remove current tab from history
    while (_tabHistory.isNotEmpty && _tabHistory.last == currentIndex.value) {
      _tabHistory.removeLast();
    }

    if (_tabHistory.isNotEmpty) {
      final previousTab = _tabHistory.last;
      print(
        'UserMain: back → returning to previous tab $previousTab from ${currentIndex.value}',
      );
      currentIndex.value = previousTab;
      if (Get.isRegistered<GlobalNavController>()) {
        Get.find<GlobalNavController>().syncFromTab(previousTab);
      }
      return true;
    }

    // Priority 3: If somehow no history but not on Home, go Home
    if (currentIndex.value != 0) {
      print('UserMain: back → fallback to Home from ${currentIndex.value}');
      currentIndex.value = 0;
      _tabHistory.add(0);
      if (Get.isRegistered<GlobalNavController>()) {
        Get.find<GlobalNavController>().syncFromTab(0);
      }
      return true;
    }

    // Priority 4: On Home root with no history → exit app
    print('UserMain: back → Home root, allowing exit');
    return false;
  }

  // ─── Static helper for controllers without context ───────
  /// Push a named route onto the CURRENT tab's navigator.
  static Future<T?> pushInCurrentTab<T>(
    String route, {
    Object? arguments,
  }) async {
    // Bridge: sync arguments so GetX controllers (Get.arguments) work
    // inside nested tab navigators (they normally only track root nav).
    Get.routing.args = arguments;
    final ctrl = Get.find<UserMainController>();
    final navKey = ctrl.navigatorKeys[ctrl.currentIndex.value];
    return navKey.currentState?.pushNamed<T>(route, arguments: arguments);
  }

  // ─── Route Resolution ────────────────────────────────────
  /// Shared across all five tab navigators.
  /// Tries the tab-root routes first, falls back to PageRoutes.routes.
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    print('UserMain: onGenerateRoute → ${settings.name}');

    // Bridge: keep Get.arguments in sync for nested navigators
    if (settings.arguments != null) {
      Get.routing.args = settings.arguments;
    }

    // -- Tab root screens (handled explicitly) --
    // Non-Home tabs ALWAYS show a back button at their root.
    switch (settings.name) {
      case '/user-home':
        return GetPageRoute(
          settings: settings,
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );
      case AppRoutes.allAstrologers:
        return GetPageRoute(
          settings: settings,
          page: () =>
              const AllAstrologersView(hideHeader: false, showBackButton: true),
        );
      case AppRoutes.liveAstrologers:
        return GetPageRoute(
          settings: settings,
          page: () => const LiveAstrologersView(showBackButton: true),
        );
      case AppRoutes.aichat:
        return GetPageRoute(
          settings: settings,
          page: () => const AiChatView(showBackButton: true),
          binding: AiChatBinding(),
        );
      case AppRoutes.profile:
        return GetPageRoute(
          settings: settings,
          page: () => const ProfileView(showBackButton: true),
          binding: ProfileBinding(),
        );
    }

    // -- Any other route: look it up in the global route table --
    final match = PageRoutes.routes.cast<GetPage>().firstWhereOrNull(
      (r) => r.name == settings.name,
    );
    if (match != null) {
      return GetPageRoute(
        settings: settings,
        page: match.page,
        binding: match.binding,
        transition: match.transition ?? Transition.rightToLeft,
        transitionDuration:
            match.transitionDuration ?? const Duration(milliseconds: 300),
      );
    }

    // -- Fallback: show dashboard --
    return GetPageRoute(
      settings: settings,
      page: () => const UserDashboardView(),
      binding: UserDashboardBinding(),
    );
  }
}
