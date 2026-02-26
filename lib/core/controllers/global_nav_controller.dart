import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:get/get.dart';

class BottomNavItem {
  final String label;
  final String icon;

  const BottomNavItem({required this.label, required this.icon});
}

class GlobalNavController extends GetxController {
  final RxString currentRoute = ''.obs;

  final List<String> hiddenRoutes = [
    AppRoutes.chat,
    AppRoutes.astrologerVoiceCall,
    AppRoutes.astrologerVideoCall,
    AppRoutes.personaChat,
    AppRoutes.personaVoiceCall,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.signup,
    AppRoutes.otp,
    AppRoutes.root,
    AppRoutes.astrologerRegistrationIntro,
    AppRoutes.astrologerRegistrationForm,
    AppRoutes.astrologerRegistrationOtp,
    AppRoutes.forgotPassword,
    AppRoutes.forgotPasswordOtp,
    AppRoutes.resetPassword,
  ];

  final List<BottomNavItem> navItems = const [
    BottomNavItem(label: 'Home', icon: AppConstant.bottomHomeIcon),
    BottomNavItem(label: 'Consult', icon: AppConstant.bottomConsultationIcon),
    BottomNavItem(label: 'AstroStream', icon: AppConstant.bottomLiveStreamIcon),
    BottomNavItem(label: 'AI Guru', icon: AppConstant.aiAstrologer),
    BottomNavItem(label: 'Profile', icon: AppConstant.astroBharatLogo),
  ];

  final RxInt _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  RxInt get selectedIndexRx => _selectedIndex;

  bool get showBottomNav {
    final route = currentRoute.value;
    return !hiddenRoutes.contains(route);
  }

  /// Called by routingCallback in main.dart – keeps currentRoute in sync
  /// so that the bottom bar can show/hide correctly.
  void updateRoute(String route) {
    print('GlobalNav: updateRoute → $route');
    currentRoute.value = route;

    // If the route corresponds to a tab root inside the shell,
    // map it to the correct index (but do NOT trigger navigation).
    if (route == AppRoutes.userDashboard) {
      _selectedIndex.value = 0;
    }
  }

  /// Called by UserMainController to keep the highlight in sync
  /// after tab switches inside the shell.
  void syncFromTab(int index) {
    _selectedIndex.value = index;
  }

  // ─── Bottom bar tap ────────────────────────────────────────
  void onTabClick(int index) {
    print(
      'GlobalNav: onTabClick → $index (current selected=${_selectedIndex.value})',
    );

    // Update bottom nav highlight immediately
    _selectedIndex.value = index;
    print('GlobalNav: _selectedIndex NOW = ${_selectedIndex.value}');

    // Delegate actual tab switch to UserMainController
    if (Get.isRegistered<UserMainController>()) {
      final ctrl = Get.find<UserMainController>();
      print(
        'GlobalNav: calling changeTab($index), currentIndex was ${ctrl.currentIndex.value}',
      );
      ctrl.changeTab(index);
      print(
        'GlobalNav: after changeTab, currentIndex is ${ctrl.currentIndex.value}',
      );
    } else {
      print('GlobalNav: UserMainController NOT registered!');
    }
  }

  // ─── Global back navigation ────────────────────────────────
  bool handleBackNavigation() {
    print('GlobalNav: handleBackNavigation');

    // 1. If root navigator has pages above the shell → pop them first
    if (Get.key.currentState?.canPop() ?? false) {
      print('GlobalNav: root navigator can pop');
      Get.back();
      return true;
    }

    // 2. Delegate to UserMainController (IndexedStack back logic)
    if (Get.isRegistered<UserMainController>()) {
      return Get.find<UserMainController>().handleBackNavigation();
    }

    return false;
  }
}
