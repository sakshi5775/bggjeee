import 'package:astrobharataiuser/binding/dashboard_binding/user_dashboard_binding.dart';

import 'package:astrobharataiuser/binding/e_mandir_binding/virtual_darshan_binding.dart';
import 'package:astrobharataiuser/binding/ecommerce_binding/ecommerce_binding.dart';
import 'package:astrobharataiuser/binding/courses_binding/courses_binding.dart';
import 'package:astrobharataiuser/core/controllers/global_nav_controller.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/routes/get_pages.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/view/virtual_darshan_view.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';

import 'package:astrobharataiuser/screens/ecommerce/view/ecommerce_home_view.dart';
import 'package:astrobharataiuser/screens/courses/views/courses_view.dart';

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
    AppRoutes.virtualDarshan,
    AppRoutes.ecommerceHome,
    AppRoutes.courses,
  ];

  // ─── Tab Switch ──────────────────────────────────────────
  /// Map to track initial arguments for each tab switch.
  /// This helps in passing data to root routes of newly activated tabs.
  final Map<int, Object?> _tabInitialArguments = {};

  @override
  void onInit() {
    super.onInit();
    // Default initial arguments for better UX on first visit
    _tabInitialArguments[1] = {'availability': 'CHAT'};
    _tabInitialArguments[3] = {'isFeatured': true};
  }

  void changeTab(int index, {Object? arguments}) {
    print(
      'UserMain: changeTab → $index (current=${currentIndex.value}) args=$arguments',
    );

    // Store arguments for root route build
    if (arguments != null) {
      _tabInitialArguments[index] = arguments;
    }

    // Always pop the target tab to its root (main page) when selected
    navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);

    if (index == currentIndex.value) {
      // If already on this tab, but we have new arguments,
      // we might want to refresh the root or push.
      // For now, specialized navigation in GlobalNav handles further pushes.
      return;
    }

    // Protect non-Home tabs that require login
    if (index >= 1 && index <= 4 && LoginGuard.isGuest) {
      final messages = [
        '',
        'Please login to consult astrologers.',
        'Please login to access Mandir.',
        'Please login to access Digital Mart.',
        'Please login to start your Learning journey.',
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
    var args = settings.arguments;

    // If no arguments provided by navigator but we have initial tab args
    if (args == null) {
      // Find if this route is a root route for any tab
      final tabIndex = tabInitialRoutes.indexOf(settings.name ?? '');
      if (tabIndex != -1 && _tabInitialArguments.containsKey(tabIndex)) {
        args = _tabInitialArguments[tabIndex];
        // We can consume them now or leave them for rebuilds
        // _tabInitialArguments.remove(tabIndex);
      }
    }

    if (args != null) {
      Get.routing.args = args;
    }

    // Capture arguments in settings for the route build
    final finalSettings = (args != null && settings.arguments == null)
        ? RouteSettings(name: settings.name, arguments: args)
        : settings;

    // -- Tab root screens (handled explicitly) --
    // Non-Home tabs ALWAYS show a back button at their root.
    switch (settings.name) {
      case '/user-home':
        return GetPageRoute(
          settings: finalSettings,
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );
      case AppRoutes.allAstrologers:
        return GetPageRoute(
          settings: finalSettings,
          page: () =>
              const AllAstrologersView(hideHeader: false, showBackButton: true),
        );
      case AppRoutes.virtualDarshan:
        return GetPageRoute(
          settings: finalSettings,
          page: () => const VirtualDarshanView(),
          binding: VirtualDarshanBinding(),
        );
      case AppRoutes.ecommerceHome:
        return GetPageRoute(
          settings: finalSettings,
          page: () =>
              const EcommerceHomeView(hideHeader: false, showBackButton: true),
          binding: EcommerceBinding(),
        );
      case AppRoutes.courses:
        return GetPageRoute(
          settings: finalSettings,
          page: () =>
              const CoursesView(hideHeader: false, showBackButton: true),
          binding: CoursesBinding(),
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

/// Specialized observer for tabbed navigators to keep the global bottom bar in sync.
class TabNavigatorObserver extends NavigatorObserver {
  final int tabIndex;
  TabNavigatorObserver({required this.tabIndex});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _syncGlobalNav(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _syncGlobalNav(route);
  }

  void _syncGlobalNav(Route? activeRoute) {
    if (activeRoute == null) return;

    // Use a post frame callback to avoid "set state during build" errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<UserMainController>() &&
          Get.isRegistered<GlobalNavController>()) {
        final ctrl = Get.find<UserMainController>();
        // ONLY SYNC IF THIS NAVIGATOR IS THE ACTIVE TAB
        if (ctrl.currentIndex.value == tabIndex) {
          final settings = activeRoute.settings;
          final routeName = settings.name?.split('?').first;
          if (routeName != null) {
            Get.find<GlobalNavController>().updateRoute(
              routeName,
              args: settings.arguments,
            );
          }
        }
      }
    });
  }
}
