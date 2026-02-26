import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
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
          if (Get.currentRoute == AppRoutes.userDashboard) return;
          if (Navigator.of(context).canPop()) {
            Get.back();
          } else {
            Get.offAllNamed(AppRoutes.userDashboard);
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
