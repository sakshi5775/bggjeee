import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/controller/login_controller.dart';
import 'package:astrobharataiuser/screens/login/widgets/login_form_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LoginView extends BasePage<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.lightBackground,
              AppColors.saffron.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: AppPaddings.symmetric(h: 24, v: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Section
              Container(
                margin: AppMargin.only(bottom: 30),
                child: Column(
                  children: [
                    // App Logo
                    Container(
                      height: 100.h,
                      width: 100.h,
                      decoration: BoxDecoration(
                        color: AppColors.saffron,
                        borderRadius: AppRadius.all(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 20.r,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                         "assets/app/logo.png",
                          height: 60.h,
                          width: 60.h,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image is not found
                            return Icon(
                              Icons.account_circle,
                              size: 60.h,
                              color: AppColors.saffron,
                            );
                          },
                        ),
                      ),
                    ),
                    Spacing.h(20),
                    // App Name
                    AutoTranslateText(
                      'AstroBharatAI',
                      style: MyTextTheme.veryLargeWCB.copyWith(
                        color: AppColors.saffron,
                      ),
                    ),
                  ],
                ),
              ),

              // Login Form Card
              Container(
                padding: AppPaddings.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: AppRadius.all(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 20.r,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: LoginFormWidget(controller: controller),
              ),

              // Sign Up Option
              Container(
                margin: AppMargin.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      "Don't have an account?",
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.signup);
                      },
                      child: AutoTranslateText(
                        'Sign Up',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
