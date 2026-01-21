import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/user_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class UserMainView extends GetView<UserMainController> {
  const UserMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.handleBackNavigation();
        return false;
      },
      child: Scaffold(
        body: Navigator(
          key: Get.nestedKey(1),
          initialRoute: controller.initialRoute,
          onGenerateRoute: controller.onGenerateRoute,
        ),
        bottomNavigationBar: UserBottomNav(
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
