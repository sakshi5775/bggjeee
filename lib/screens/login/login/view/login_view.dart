import 'dart:ui';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/login/controller/login_controller.dart';
import 'package:astrobharataiuser/screens/login/login/widgets/login_form_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends BasePage<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.gradientBackground),
          child: Column(
            children: [
              // Container(
              //   width: double.infinity,
              //   height: 300,
              //   child: Column(
              //     children: [
              //       Image.asset(
              //         'assets/images/update-ganesh.jpg',
              //         fit: BoxFit.cover,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                height: 350.h, // Increased height to accommodate padding
                child: Padding(
                  padding: EdgeInsets.only(top: 0.h), // Added top spacing
                  child: Stack(
                    children: [
                      /// 🔹 Main Image
                      Positioned.fill(
                        child: Image.network(
                          AppConstant.cardConsultation,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                size: 48,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),

                      /// 🔹 Welcome Text Overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/star.png",
                                    height: 20.h,
                                    width: 30.w,
                                  ),
                                  SizedBox(width: 8.w),
                                  AutoTranslateText(
                                    'Welcome Back',
                                    style: MyTextTheme.veryLargeWCB.copyWith(
                                      color: AppColors.saffron,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 8.w),
                                  Image.asset(
                                    "assets/images/star.png",
                                    height: 20.h,
                                    width: 30.w,
                                  ),
                                ],
                              ),
                              Spacing.h(4),
                              AutoTranslateText(
                                'Continue your spiritual journey',
                                style: MyTextTheme.mediumBCN.copyWith(
                                  color: AppColors.saffron,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topCenter,
                      //       end: Alignment.bottomCenter,
                      //       colors: [
                      //         Color(0xFFFFFCF3).withValues(alpha: 0.2),
                      //         Colors.white.withValues(alpha: 0.0),
                      //       ],
                      //     ),
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.asset(
                      //             "assets/images/star.png",
                      //             height: 20,
                      //             width: 30,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           AutoTranslateText(
                      //             'Welcome Back',
                      //             style: MyTextTheme.veryLargeWCB.copyWith(
                      //               color: AppColors.saffron,
                      //             ),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const SizedBox(width: 8),
                      //           Image.asset(
                      //             "assets/images/star.png",
                      //             height: 20,
                      //             width: 30,
                      //           ),
                      //           const SizedBox(height: 8),
                      //         ],
                      //       ),
                      //       Spacing.h(4),
                      //       AutoTranslateText(
                      //         'Continue your spiritual journey',
                      //         style: MyTextTheme.mediumBCN.copyWith(
                      //           color: AppColors.saffron,
                      //         ),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Transform.translate(
                        offset: Offset(0, -20.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: LoginFormWidget(controller: controller),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
