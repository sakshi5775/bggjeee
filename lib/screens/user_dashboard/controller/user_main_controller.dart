import 'package:astrobharataiuser/binding/dashboard_binding/user_dashboard_binding.dart';
import 'package:astrobharataiuser/binding/ecommerce_binding/ecommerce_binding.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/astrology_services_view.dart';
import 'package:astrobharataiuser/screens/e_mandir/e_mandir_home/view/namaste_home_view.dart';
import 'package:astrobharataiuser/binding/e_mandir_binding/namaste_home_binding.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/ecommerce_home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainController extends GetxController {
  final selectedIndex = 0.obs;

  final pages = [
    '/user-home',
    AppRoutes.ecommerceHome,
    AppRoutes.namasteHome,
    AppRoutes.astrologyServices,
    AppRoutes.courses,
  ];

  String get initialRoute => pages.first;

  // ---------------- ROUTING ----------------
  Route? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    final showBackButton = args?['showBackButton'] ?? false;

    switch (settings.name) {
      case '/user-home':
        return GetPageRoute(
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );

      case AppRoutes.ecommerceHome:
        return GetPageRoute(
          page: () => EcommerceHomeView(showBackButton: showBackButton),
          binding: EcommerceBinding(),
        );

      case AppRoutes.namasteHome:
        return GetPageRoute(
          page: () => const NamasteHomeView(),
          binding: NamasteHomeBinding(),
        );

      case AppRoutes.astrologyServices:
        return GetPageRoute(
          page: () => const AstrologyServicesView(),
        );

      case AppRoutes.courses:
        // Navigate to courses route from get_pages.dart (main router)
        return null; // Let main router handle it

      default:
        // If route not found, check if it's an e-mandir route and go to namasteHome
        // Otherwise go to home
        if (settings.name?.contains('mandir') == true || 
            settings.name?.contains('darshan') == true ||
            settings.name?.contains('punya') == true ||
            settings.name?.contains('devotional') == true ||
            settings.name?.contains('bhakti') == true ||
            settings.name?.contains('passbook') == true) {
          return GetPageRoute(
            page: () => const NamasteHomeView(),
            binding: NamasteHomeBinding(),
          );
        }
        return GetPageRoute(
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );
    }
  }

  // ---------------- TAB CHANGE ----------------
  void changePage(int index) {
    if (index == selectedIndex.value) return;

    // Protect Consult & Education
    final requiresLogin = index == 3 || index == 4;
    if (requiresLogin && LoginGuard.isGuest) {
      LoginGuard.showLoginRequiredModal(
        message: index == 4
            ? 'Please login to access courses.'
            : 'Please login to consult astrologers.',
      );
      return;
    }

    // If coming from courses full page
    if (Get.currentRoute == AppRoutes.courses && index != 4) {
      Get.back();
      Future.delayed(const Duration(milliseconds: 200), () {
        _navigate(index);
      });
      return;
    }

    _navigate(index);
  }

  void _navigate(int index) {
    selectedIndex.value = index;

    if (index == 4) {
      // Navigate to courses using main router (not nested navigator)
      // Transition is set in get_pages.dart route definition
      Get.toNamed(
        AppRoutes.courses,
        arguments: {'showBackButton': false},
      );
    } else {
      Get.offNamed(pages[index], id: 1);
    }
  }

  // ---------------- BACK HANDLER ----------------
  void handleBackNavigation() {
    final nav = Get.nestedKey(1)?.currentState;

    if (nav != null && nav.canPop()) {
      nav.pop();
    } else {
      // If at root of nested navigator, go to the current tab's main page
      // instead of always going to home
      final currentIndex = selectedIndex.value;
      selectedIndex.value = currentIndex;
      Get.offNamed(pages[currentIndex], id: 1);
    }
  }
}

