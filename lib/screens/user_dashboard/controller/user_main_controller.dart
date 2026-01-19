import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/binding/dashboard_binding/user_dashboard_binding.dart';
import 'package:astrobharataiuser/binding/ecommerce_binding/ecommerce_binding.dart';
import 'package:astrobharataiuser/binding/ai_chat_binding/ai_chat_binding.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/ecommerce_home_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/view/profile_view.dart';
import 'package:astrobharataiuser/screens/ecommerce/binding/profile_binding.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainController extends GetxController {
  final selectedIndex = 0.obs;
  final pages = <String>[].obs;
  final initialRoute = ''.obs;

  @override
  void onInit() {
    super.onInit();
    pages.assignAll([
      '/user-home',
      '/user-shop',
      '/user-education',
      '/user-chat',
      '/user-profile',
    ]);
    initialRoute.value = pages.first;
  }

  Route? onGenerateRoute(RouteSettings settings) {
    // Check if showBackButton is specified in arguments, otherwise default to false (from bottom nav)
    final args = settings.arguments;
    final showBackButton = args is Map<String, dynamic>
        ? args['showBackButton'] as bool? ?? false
        : false;
    
    switch (settings.name) {
      case '/user-home':
        return GetPageRoute(
          settings: settings,
          page: () => const UserDashboardView(),
          binding: UserDashboardBinding(),
        );
      case '/user-shop':
        return GetPageRoute(
          settings: settings,
          page: () => EcommerceHomeView(showBackButton: showBackButton),
          binding: EcommerceBinding(),
        );
      case '/user-education':
        return GetPageRoute(
          settings: settings,
          page: () => _Placeholder('Education'),
        );
      case '/user-chat':
        return GetPageRoute(
          settings: settings,
          page: () => AiChatView(showBackButton: showBackButton),
          binding: AiChatBinding(),
        );
      case '/user-profile':
        return GetPageRoute(
          settings: settings,
          page: () => ProfileView(showBackButton: showBackButton),
          binding: ProfileBinding(),
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => _Placeholder('Empty'),
        );
    }
  }

  void changePage(int index) {
    // If clicking the same tab that's already selected, do nothing
    if (index == selectedIndex.value) {
      return;
    }

    // Protect education (courses) and chat tabs for guest users
    final requiresLogin = index == 2 || index == 3;
    if (requiresLogin && LoginGuard.isGuest) {
      LoginGuard.showLoginRequiredDialog(
        message: index == 2
            ? 'Please login to access courses.'
            : 'Please login to chat with astrologers.',
      );
      return;
    }

    // Check if we're currently on the courses page (outside nested navigator)
    final bool isOnCoursesPage = Get.currentRoute == AppRoutes.courses;

    // If we're on courses page and clicking a different tab
    if (isOnCoursesPage && index != 2) {
      // Navigate back from courses first, then navigate directly to selected tab
      Get.back(); // Navigate back from courses to nested navigator
      Future.delayed(const Duration(milliseconds: 200), () {
        selectedIndex.value = index;
        Get.offNamed(pages[index], id: 1);
      });
      return;
    }

    // Normal navigation within nested navigator
    _navigateToTab(index);
  }

  // Reusable method to navigate to a specific tab
  void _navigateToTab(int index) {
    selectedIndex.value = index;

    // If education tab is clicked, navigate to courses page
    if (index == 2) {
      Get.toNamed(
        AppRoutes.courses,
        arguments: {'showBackButton': false},
      );
      // Don't reset to home when coming back - let the user stay where they were
    } else {
      Get.offNamed(pages[index], id: 1);
    }
  }

  // Handle back navigation within nested navigator
  void handleBackNavigation() {
    final navigator = Get.nestedKey(1)?.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    } else {
      // If at root of current tab, navigate to home
      selectedIndex.value = 0;
      Get.offNamed(pages[0], id: 1);
    }
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LocalizedText(text: title),
      ),
      body: Center(child: LocalizedText(text: title)),
    );
  }
}
