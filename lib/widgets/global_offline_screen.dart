import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/apihelper/network_service/network_service.dart';

class GlobalOfflineScreen extends StatelessWidget {
  const GlobalOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 80.w,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32.h),

            /// Title
            Text(
              "No Internet Connection",
              style: MyTextTheme.largeBCB.copyWith(
                fontSize: 24.sp,
                color: AppColors.saffron,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            /// Description
            Text(
              "Please check your internet settings and try again. The app will automatically reconnect once you're back online.",
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.saffron,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 48.h),

            /// Retry Button
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  Get.showOverlay(
                    asyncFunction: () =>
                        NetworkService.instance.checkConnectivity(),
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 48.w,
                    vertical: 16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Retry",
                  style: MyTextTheme.mediumBCB.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
