import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/user_bottom_nav.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMainView extends GetView<UserMainController> {
  const UserMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      bottomNavigationBar: UserBottomNav(onTap: controller.changePage),
      body: Obx(() {
        if (controller.initialRoute.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Navigator(
          key: Get.nestedKey(1),
          initialRoute: controller.initialRoute.value,
          onGenerateRoute: controller.onGenerateRoute,
        );
      }),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return UserDashboardView.buildDrawer(context);
  }
}


