import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppBarBackButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  const AppBarBackButton({super.key, this.backgroundColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: GestureDetector(
        onTap: () {
          // Try to pop from nested navigator first
          final navigator = Get.nestedKey(1)?.currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
          } else {
            // If at root of nested navigator, navigate to home tab directly
            try {
              final mainController = Get.find<UserMainController>();
              mainController.selectedIndex.value = 0;
              // Use offNamed to replace current route with home
              Get.offNamed('/user-home', id: 1);
            } catch (e) {
              // Controller not found, fallback - should not happen in normal flow
              // But just in case, try to navigate using Get
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                // Last resort - navigate to dashboard
                Get.offAllNamed('/user-dashboard');
              }
            }
          }
        },
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.saffron,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18.w,
              color: iconColor ?? AppColors.lightBackground,
            ),
          ),
        ),
      ),
    );
  }
}

