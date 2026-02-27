import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shell view that uses an [IndexedStack] so each tab keeps its own
/// independent navigation stack alive.
///
/// Uses StatefulWidget to ensure the Navigator children list is created
/// exactly ONCE and never recreated on parent rebuilds.
class UserMainView extends StatefulWidget {
  const UserMainView({super.key});

  @override
  State<UserMainView> createState() => _UserMainViewState();
}

class _UserMainViewState extends State<UserMainView> {
  late final UserMainController controller;
  late final List<Widget> _children;
  late final List<TabNavigatorObserver> _observers;

  @override
  void initState() {
    super.initState();
    controller = Get.find<UserMainController>();

    // Build observers to track each tab's navigation
    _observers = List.generate(
      controller.navigatorKeys.length,
      (i) => TabNavigatorObserver(tabIndex: i),
    );

    // Build navigators exactly ONCE.
    _children = List.generate(
      controller.navigatorKeys.length,
      (i) => Navigator(
        key: controller.navigatorKeys[i],
        observers: [_observers[i]],
        onGenerateInitialRoutes: (navigator, initialRoute) {
          return [
            controller.onGenerateRoute(
              RouteSettings(name: controller.tabInitialRoutes[i]),
            )!,
          ];
        },
        onGenerateRoute: controller.onGenerateRoute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final handled = controller.handleBackNavigation();
        if (!handled) {
          // If not handled by our custom logic, it means we are at the root of the Home tab.
          // We can now allow the app to exit.
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Obx(() {
          final idx = controller.currentIndex.value;
          print('UserMainView: Obx rebuild, showing tab index=$idx');
          return IndexedStack(index: idx, children: _children);
        }),
      ),
    );
  }
}
