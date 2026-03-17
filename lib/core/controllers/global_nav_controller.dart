import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavItem {
  final String label;
  final String icon;

  const BottomNavItem({required this.label, required this.icon});
}

class GlobalNavController extends GetxController {
  final RxString currentRoute = ''.obs;

  /// Routes where the global bottom nav is hidden (full-screen: live stream, call, chat, AI).
  final List<String> hiddenRoutes = [
    AppRoutes.chat,
    AppRoutes.astrologerChat,
    AppRoutes.astrologerVoiceCall,
    AppRoutes.astrologerVideoCall,
    AppRoutes.personaChat,
    AppRoutes.personaVoiceCall,
    AppRoutes.aichat,
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
    BottomNavItem(label: 'Mandir', icon: AppConstant.ePooja),
    BottomNavItem(label: 'Mart', icon: AppConstant.divineShop),
    BottomNavItem(label: 'Learning', icon: AppConstant.education),
  ];

  final RxInt _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  RxInt get selectedIndexRx => _selectedIndex;

  // Track if a sub-menu is currently active
  final activeSubMenuIndex = RxnInt();
  // Track the active item within the sub-menu
  final activeSubItemIndex = RxnInt();

  // Sub-menu definitions
  final Map<int, List<Map<String, dynamic>>> subMenuItems = {
    1: [
      // Consult tab
      {'label': 'Consult', 'icon': Icons.chat_bubble_outline},
      {'label': 'Astrostream', 'icon': Icons.live_tv_outlined},
      {'label': 'Remedies', 'icon': Icons.healing_outlined},
      {'label': 'Services', 'icon': Icons.auto_awesome_outlined},
    ],
    2: [
      // Mandir
      {'label': 'Library', 'icon': Icons.menu_book_outlined},
      {'label': 'Temple', 'icon': Icons.temple_hindu_outlined},
      {'label': 'Pooja', 'icon': Icons.auto_awesome_outlined},
      {'label': 'Music', 'icon': Icons.music_note_outlined},
    ],
    3: [
      // Mart
      {'label': 'Mart', 'icon': Icons.storefront_outlined},
      {'label': 'My Order', 'icon': Icons.receipt_long_outlined},
      {'label': 'Wishlist', 'icon': Icons.favorite_border},
      {'label': 'My Cart', 'icon': Icons.shopping_cart_outlined},
    ],
    4: [
      // Learning
      {'label': 'Digital Learning', 'icon': Icons.school_outlined},
      {'label': 'My Learning', 'icon': Icons.menu_book_outlined},
      {'label': 'Live Webinar', 'icon': Icons.broadcast_on_personal_outlined},
    ],
  };

  bool get showBottomNav {
    final route = currentRoute.value;
    if (hiddenRoutes.contains(route)) return false;
    // Live stream may be named by Get with runtimeType (e.g. LiveStreamView or /LiveStreamView)
    if (route.contains('LiveStreamView')) return false;
    return true;
  }

  void updateRoute(String route, {Object? args}) {
    print('GlobalNav: updateRoute → $route with args: $args');

    // Stop animations if leaving Virtual Darshan page
    if (currentRoute.value == AppRoutes.virtualDarshan &&
        route != AppRoutes.virtualDarshan) {
      if (Get.isRegistered<VirtualDarshanController>()) {
        Get.find<VirtualDarshanController>().stopAllAnimationsForTabSwitch();
      }
    }

    currentRoute.value = route;

    // Sync sub-menu state based on route and arguments
    if (route == AppRoutes.userDashboard ||
        route == AppRoutes.root ||
        route == '/user-home') {
      _selectedIndex.value = 0;
      activeSubMenuIndex.value = null;
      activeSubItemIndex.value = null;
    } else if (route == AppRoutes.consultHome) {
      activeSubMenuIndex.value = 1;
      activeSubItemIndex.value = 0; // Consult
    } else if (route == AppRoutes.allAstrologers) {
      activeSubMenuIndex.value =
          1; // Consult (still on Consult submenu when in astrologers list)
      activeSubItemIndex.value = 0; // Consult
    } else if (route == AppRoutes.liveAstrologers) {
      activeSubMenuIndex.value = 1; // Consult
      activeSubItemIndex.value = 1; // Astrostream
    } else if (route == AppRoutes.remedies) {
      activeSubMenuIndex.value = 1; // Consult
      activeSubItemIndex.value = 2; // Remedies
    } else if (route == AppRoutes.allServices) {
      activeSubMenuIndex.value = 1; // Consult
      activeSubItemIndex.value = 3; // Services
    } else if (route == AppRoutes.eMandirWallpaper) {
      activeSubMenuIndex.value = 2; // Mandir
      activeSubItemIndex.value = 0; // Library
    } else if (route == AppRoutes.virtualDarshan) {
      activeSubMenuIndex.value = 2; // Mandir
      activeSubItemIndex.value = 1; // Temple
    } else if (route == AppRoutes.bookPuja) {
      activeSubMenuIndex.value = 2; // Mandir
      activeSubItemIndex.value = 2; // Pooja
    } else if (route == AppRoutes.devotionalLibrary) {
      activeSubMenuIndex.value = 2; // Mandir
      activeSubItemIndex.value = 3; // Music
    } else if (route == AppRoutes.ecommerceHome) {
      activeSubMenuIndex.value = 3; // Mart
      activeSubItemIndex.value = 0; // Mart
    } else if (route == AppRoutes.orders) {
      activeSubMenuIndex.value = 3; // Mart
      activeSubItemIndex.value = 1; // My Order
    } else if (route == AppRoutes.wishlist) {
      activeSubMenuIndex.value = 3; // Mart
      activeSubItemIndex.value = 2; // Wishlist
    } else if (route == AppRoutes.cart) {
      activeSubMenuIndex.value = 3; // Mart
      activeSubItemIndex.value = 3; // My Cart
    } else if (route == AppRoutes.courses) {
      activeSubMenuIndex.value = 4; // Learning
      activeSubItemIndex.value = 0; // Digital Learning
    } else if (route == AppRoutes.myLearning) {
      activeSubMenuIndex.value = 4; // Learning
      activeSubItemIndex.value = 1; // My Learning
    } else if (route == AppRoutes.liveWebinars) {
      activeSubMenuIndex.value = 4; // Learning
      activeSubItemIndex.value = 2; // Live Webinar
    }

    // Sync selected index with active sub-menu if applicable
    if (activeSubMenuIndex.value != null) {
      _selectedIndex.value = activeSubMenuIndex.value!;
    }
  }

  void syncFromTab(int index, {String? tabRootRoute}) {
    print('GlobalNav: syncFromTab → $index');
    _selectedIndex.value = index;
    // Update currentRoute so drawer shows tab-relevant menu (dynamic side nav)
    if (tabRootRoute != null && tabRootRoute.isNotEmpty) {
      currentRoute.value = tabRootRoute;
    }

    if (index == 0) {
      activeSubMenuIndex.value = null;
      activeSubItemIndex.value = null;
    } else if (subMenuItems.containsKey(index)) {
      activeSubMenuIndex.value = index;
      // When syncing from a direct tab switch (if possible via changeTab),
      // we might want a default sub-item if none selected.
      if (activeSubItemIndex.value == null) {
        if (index == 1)
          activeSubItemIndex.value = 0; // Consult
        else if (index == 2)
          activeSubItemIndex.value = 0; // Library (Mandir opens Library)
        else if (index == 3)
          activeSubItemIndex.value = 0; // Mart
        else if (index == 4)
          activeSubItemIndex.value = 0; // Digital Learning
      }
    } else {
      activeSubMenuIndex.value = null;
      activeSubItemIndex.value = null;
    }
  }

  void onTabClick(int index) {
    print('GlobalNav: onTabClick → $index');

    if (index == 0) {
      activeSubMenuIndex.value = null;
      activeSubItemIndex.value = null;
      _selectedIndex.value = 0;
      if (Get.isRegistered<UserMainController>()) {
        Get.find<UserMainController>().changeTab(0);
      }
      return;
    }

    // 1. DETERMINE DEFAULT ARGUMENTS FOR TAB ROOT
    Object? initialArgs;
    if (index == 1) {
      // Consult: no availability filter = show Chat, Call, Video on each card
      initialArgs = null;
    }

    // 2. SWITCH TAB WITH ARGUMENTS
    _selectedIndex.value = index;
    if (Get.isRegistered<UserMainController>()) {
      Get.find<UserMainController>().changeTab(index, arguments: initialArgs);
    }

    // 3. UPDATE UI STATE (Highlighting)
    if (subMenuItems.containsKey(index)) {
      activeSubMenuIndex.value = index;
      if (index == 1) {
        activeSubItemIndex.value = 0; // Chat
      } else if (index == 2) {
        activeSubItemIndex.value = 0; // Library (Mandir opens Library)
      } else if (index == 3) {
        activeSubItemIndex.value = 0; // Mart
      } else if (index == 4) {
        activeSubItemIndex.value = 0; // Digital Learning
      }
    } else {
      activeSubMenuIndex.value = null;
      activeSubItemIndex.value = null;
    }
  }

  void onSubItemClick(int subIndex) {
    final parentIndex = activeSubMenuIndex.value;
    if (parentIndex == null) return;

    final item = subMenuItems[parentIndex]?[subIndex];
    if (item == null) return;

    activeSubItemIndex.value = subIndex;
    final label = item['label'] as String;
    print('GlobalNav: sub-item $label clicked');

    switch (parentIndex) {
      case 1:
        _handleConsultSubItem(subIndex);
        break;
      case 2:
        _handleMandirSubItem(subIndex);
        break;
      case 3:
        _handleMartSubItem(subIndex);
        break;
      case 4:
        _handleLearningSubItem(subIndex);
        break;
    }
  }

  void _handleConsultSubItem(int subIndex) {
    if (subIndex == 0) {
      // Consult - Consult home (Astrologer | AI Astrologer tabs with filters and sliders)
      UserMainController.popCurrentTabToRoot();
    } else if (subIndex == 1) {
      // Astrostream
      UserMainController.pushInCurrentTab(AppRoutes.liveAstrologers);
    } else if (subIndex == 2) {
      // Remedies
      UserMainController.pushInCurrentTab(AppRoutes.remedies);
    } else if (subIndex == 3) {
      // Services
      UserMainController.pushInCurrentTab(AppRoutes.allServices);
    }
  }

  void _handleMandirSubItem(int subIndex) {
    if (subIndex == 0) {
      // Library — open with Library tab selected
      UserMainController.pushInCurrentTab(
        AppRoutes.eMandirWallpaper,
        arguments: {'initialFilter': 'Library'},
      );
    } else if (subIndex == 1) {
      // Temple
      UserMainController.pushInCurrentTab(AppRoutes.virtualDarshan);
    } else if (subIndex == 2) {
      // Pooja
      UserMainController.pushInCurrentTab(AppRoutes.bookPuja);
    } else if (subIndex == 3) {
      // Music
      UserMainController.pushInCurrentTab(AppRoutes.devotionalLibrary);
    }
  }

  void _handleMartSubItem(int subIndex) {
    if (subIndex == 0) {
      // Mart
      UserMainController.pushInCurrentTab(AppRoutes.ecommerceHome);
    } else if (subIndex == 1) {
      // My Order
      UserMainController.pushInCurrentTab(AppRoutes.orders);
    } else if (subIndex == 2) {
      // Wishlist
      UserMainController.pushInCurrentTab(AppRoutes.wishlist);
    } else if (subIndex == 3) {
      // My Cart
      UserMainController.pushInCurrentTab(AppRoutes.cart);
    }
  }

  void _handleLearningSubItem(int subIndex) {
    if (subIndex == 0) {
      // Digital Learning
      UserMainController.pushInCurrentTab(AppRoutes.courses);
    } else if (subIndex == 1) {
      // My Learning
      UserMainController.pushInCurrentTab(AppRoutes.myLearning);
    } else if (subIndex == 2) {
      // Live Webinar
      UserMainController.pushInCurrentTab(AppRoutes.liveWebinars);
    }
  }

  bool handleBackNavigation() {
    print('GlobalNav: handleBackNavigation');

    if (activeSubMenuIndex.value != null) {
      activeSubMenuIndex.value = null;
      activeSubItemIndex.value = null;
      return true;
    }

    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
      return true;
    }

    if (Get.isRegistered<UserMainController>()) {
      return Get.find<UserMainController>().handleBackNavigation();
    }

    return false;
  }
}
