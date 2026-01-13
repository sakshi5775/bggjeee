import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/sign_up/controller/signup_controller.dart';
import 'package:astrobharataiuser/screens/sign_up/widgets/signup_form_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpView extends BasePage<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  Container(
                    margin: AppMargin.only(top: 20, bottom: 10),
                    child: Column(
                      children: [
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
                                return Icon(
                                  Icons.account_circle,
                                  size: 60.h,
                                  color: AppColors.saffron,
                                );
                              },
                            ),
                          ),
                        ),
                        Spacing.h(10),
                        AutoTranslateText(
                          'AstroBharatAI',
                          style: MyTextTheme.veryLargeWCB.copyWith(
                            color: AppColors.saffron,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SingleChildScrollView(
                padding: AppPaddings.symmetric(h: 12, v: 40),
                child: Column(
                  children: [
                    SizedBox(height: 130.h),
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
                      child: SignUpFormWidget(controller: controller),
                    ),

                    SizedBox(height: 100.h),
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
