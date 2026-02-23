import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/user_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainView extends GetView<UserMainController> {
  const UserMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canPopApp =
          controller.selectedIndex.value == 0 && !controller.canPopNested.value;
      return PopScope(
        canPop: canPopApp,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final shouldPop = await controller.handleBackNavigation();
          if (shouldPop) {
            // Unlikely to hit this if canPopApp accurately works, but safe fallback
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          body: Navigator(
            key: Get.nestedKey(1),
            initialRoute: controller.initialRoute,
            onGenerateRoute: controller.onGenerateRoute,
            observers: [controller.observer],
          ),
          bottomNavigationBar: UserBottomNav(onTap: controller.changePage),
        ),
      );
    });
  }
}
