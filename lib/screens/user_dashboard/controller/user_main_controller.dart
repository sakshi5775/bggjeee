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
import 'package:astrobharataiuser/screens/user_dashboard/view/consultation_history_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/kundli_report_history_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/orders_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/orders_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/wishlist_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/wishlist_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/coupons_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/coupons_binding.dart';
import 'package:astrobharataiuser/screens/support/view/support_tickets_list_view.dart';
import 'package:astrobharataiuser/screens/support/binding/support_ticket_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/order_detail_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/order_detail_binding.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/addresses_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/address_binding.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/following_astrologers_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Model for a single bottom nav item (dynamic labels/icons).
class BottomNavItem {
  final String label;
  final IconData icon;

  const BottomNavItem({required this.label, required this.icon});
}

class NestedNavObserver extends NavigatorObserver {
  final VoidCallback onStackChanged;

  NestedNavObserver(this.onStackChanged);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    onStackChanged();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onStackChanged();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    onStackChanged();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onStackChanged();
  }
}

class UserMainController extends GetxController {
  final selectedIndex = 0.obs;
  final canPopNested = false.obs;

  late final NestedNavObserver observer;

  @override
  void onInit() {
    super.onInit();
    observer = NestedNavObserver(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final nav = Get.nestedKey(1)?.currentState;
        canPopNested.value = nav?.canPop() ?? false;
      });
    });
  }

  /// Bottom nav items: Home, Chat, Call, AI, Profile. Update this list to change nav dynamically.
  final RxList<BottomNavItem> navItems = <BottomNavItem>[
    const BottomNavItem(label: 'Home', icon: Icons.home),
    const BottomNavItem(label: 'Consult', icon: Icons.chat_bubble_outline),
    const BottomNavItem(label: 'AstroStream', icon: Icons.live_tv_rounded),
    const BottomNavItem(label: 'AI Guru', icon: Icons.smart_toy),
    const BottomNavItem(label: 'Profile', icon: Icons.person),
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
    final showBackButton = args?['showBackButton'] as bool? ?? true;

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

      case AppRoutes.kundliReportHistory:
        return GetPageRoute(
          page: () => KundliReportHistoryView(showBackButton: showBackButton),
          binding: ProfileBinding(),
        );

      case AppRoutes.orders:
        return GetPageRoute(
          page: () => OrdersView(showBackButton: showBackButton),
          binding: OrdersBinding(),
        );

      case AppRoutes.wishlist:
        return GetPageRoute(
          page: () => WishlistView(showBackButton: showBackButton),
          binding: WishlistBinding(),
        );

      case AppRoutes.coupons:
        return GetPageRoute(
          page: () => CouponsView(showBackButton: showBackButton),
          binding: CouponsBinding(),
        );

      case AppRoutes.supportTickets:
        return GetPageRoute(
          page: () => SupportTicketsListView(showBackButton: showBackButton),
          binding: SupportTicketBinding(),
        );

      case AppRoutes.orderDetail:
        return GetPageRoute(
          page: () => OrderDetailView(showBackButton: showBackButton),
          binding: OrderDetailBinding(),
        );

      case AppRoutes.consultationHistory:
        return GetPageRoute(
          page: () => ConsultationHistoryView(showBackButton: showBackButton),
        );

      case AppRoutes.addresses:
        return GetPageRoute(
          page: () => AddressesView(showBackButton: showBackButton),
          binding: AddressBinding(),
        );

      case AppRoutes.followingAstrologers:
        return GetPageRoute(
          page: () => FollowingAstrologersView(showBackButton: showBackButton),
        );

      default:
        return GetPageRoute(page: () => const UserDashboardView());
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
    Get.offAllNamed(pages[index], id: 1, arguments: args);
  }

  // ---------------- BACK HANDLER ----------------
  Future<bool> handleBackNavigation() async {
    final nav = Get.nestedKey(1)?.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return false;
    }

    if (selectedIndex.value != 0) {
      changePage(0);
      return false;
    }

    return true;
  }
}
