import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/sign_up/controller/signup_controller.dart';
import 'package:astrobharataiuser/screens/sign_up/widgets/signup_form_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpView extends BasePage<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Ganesh Image Header (matching login page)
              Container(
                width: double.infinity,
                height: 350.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
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
                    // Back button overlay
                    // SafeArea(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(16.w),
                    //     child: GestureDetector(
                    //       onTap: () => controller.goToLogin(),
                    //       child: Container(
                    //         padding: EdgeInsets.all(8.w),
                    //         decoration: BoxDecoration(
                    //           color: Colors.white.withValues(alpha: 0.9),
                    //           shape: BoxShape.circle,
                    //           boxShadow: [
                    //             BoxShadow(
                    //               color: Colors.black.withValues(alpha: 0.1),
                    //               blurRadius: 8,
                    //               offset: const Offset(0, 2),
                    //             ),
                    //           ],
                    //         ),
                    //         child: Icon(
                    //           Icons.arrow_back_ios,
                    //           color: AppColors.saffron,
                    //           size: 18.sp,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Form Container
              Container(
                width: double.infinity,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowMedium.withValues(alpha: 0.15),
                            blurRadius: 20.r,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SignUpFormWidget(controller: controller),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}


