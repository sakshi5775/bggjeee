import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/otp/controller/otp_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTPView extends BasePage<OTPController> {
  const OTPView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.w,
      textStyle: MyTextTheme.veryLargeWCB.copyWith(
        color: AppColors.saffron,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.2),
            blurRadius: 20.r,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.saffron.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.saffron, width: 2),
      boxShadow: [
        BoxShadow(
          color: AppColors.saffron.withValues(alpha: 0.3),
          blurRadius: 12.r,
          offset: const Offset(0, 6),
        ),
      ],
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.error, width: 2),
    );

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            AppBar(title: Text('Verify OTP')),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Spacing.h(40),
                      // Form Container
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowMedium.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title with stars
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
                                  'Verify OTP',
                                  style: MyTextTheme.veryLargeWCB.copyWith(
                                    color: AppColors.saffron,
                                    fontSize: 24.sp,
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
                            Spacing.h(8),
                            AutoTranslateText(
                              'Enter the verification code',
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: AppColors.saffron,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Spacing.h(4),
                            Obx(
                              () => AutoTranslateText(
                                'Sent to ${controller.maskedDestination.value.isEmpty ? 'your number' : controller.maskedDestination.value}',
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: AppColors.gray,
                                  fontSize: 12.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Spacing.h(32),
                            // OTP Input
                            Center(
                              child: Pinput(
                                length: controller.otpLength,
                                controller: controller.otpTextController,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                errorPinTheme: errorPinTheme,
                                separatorBuilder: (index) =>
                                    SizedBox(width: 12.w),
                                onCompleted: controller.submitOtp,
                                cursor: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 2.w,
                                    height: 26.sp,
                                    color: AppColors.saffron,
                                  ),
                                ),
                              ),
                            ),
                            Spacing.h(24),
                            // Resend OTP
                            Obx(
                              () => Align(
                                alignment: Alignment.center,
                                child: controller.secondsRemaining.value > 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: 16.sp,
                                            color: AppColors.gray,
                                          ),
                                          SizedBox(width: 6.w),
                                          AutoTranslateText(
                                            'Resend OTP in ${controller.secondsRemaining.value}s',
                                            style: MyTextTheme.smallBCN
                                                .copyWith(
                                                  color: AppColors.gray,
                                                  fontSize: 13.sp,
                                                ),
                                          ),
                                        ],
                                      )
                                    : TextButton.icon(
                                        onPressed: controller.resendOtp,
                                        icon: Icon(
                                          Icons.refresh,
                                          color: AppColors.saffron,
                                          size: 18.sp,
                                        ),
                                        label: AutoTranslateText(
                                          'Resend OTP',
                                          style: MyTextTheme.mediumBCB.copyWith(
                                            color: AppColors.saffron,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Spacing.h(32),
                            // Verify Button
                            Obx(() {
                              final isLoading = controller.isSubmitting.value;
                              return GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () => controller.submitOtp(
                                        controller.otpTextController.text
                                            .trim(),
                                      ),
                                child: Container(
                                  height: 52.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFF38B3B),
                                        Color(0xFFDD2914),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withValues(
                                          alpha: 0.45,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: isLoading
                                        ? SizedBox(
                                            height: 22.h,
                                            width: 22.w,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Colors.white),
                                                ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AutoTranslateText(
                                                "Verify & Continue",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(width: 8.w),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.white,
                                                size: 18.sp,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            }),
                            Spacing.h(16),
                            // Change Number Button
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  controller.changeNumber();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: AutoTranslateText(
                                  'Change Phone Number',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: AppColors.saffron,
                                    fontSize: 13.sp,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacing.h(40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
