import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
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
      height: 64.h,
      textStyle: MyTextTheme.veryLargeWCB.copyWith(color: AppColors.saffron),
      decoration: BoxDecoration(
        color: AppColors.cardLight,
        borderRadius: AppRadius.all(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.dividerLight, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.saffron, width: 2),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.error, width: 2),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppPaddings.symmetric(h: 24, v: 24),
            child: Container(
              padding: AppPaddings.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: AppRadius.all(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 20.r,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.saffron,
                        child: Center(
                          child: IconButton(
                            onPressed: () => controller.onBack(),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.lightBackground,
                              size: 16.h,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 54.h,
                        width: 54.h,
                        decoration: BoxDecoration(
                          color: AppColors.saffron,
                          borderRadius: AppRadius.all(16),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/app/logo.png",
                            height: 32.h,
                            width: 32.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(height: 54.h, width: 54.h),
                    ],
                  ),
                  Spacing.h(20),
                  AutoTranslateText(
                    'Verify Your Identity',
                    style: MyTextTheme.veryLargeWCB.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacing.h(8),
                  Obx(
                    () => AutoTranslateText(
                      'Please enter the 4-digit code sent to ${controller.maskedDestination.value.isEmpty ? 'your number' : controller.maskedDestination.value}.',
                      style: MyTextTheme.mediumBCN,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacing.h(24),
                  Center(
                    child: Pinput(
                      length: controller.otpLength,
                      controller: controller.otpTextController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: errorPinTheme,

                      // androidSmsAutoFillMethod:
                      //     AndroidSmsAutoFillMethod.smsRetrieverApi,
                      separatorBuilder: (index) => SizedBox(width: 14.w),
                      onCompleted: controller.submitOtp,
                      cursor: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 2,
                          height: 18.h,
                          color: AppColors.saffron,
                        ),
                      ),
                    ),
                  ),
                  Spacing.h(16),
                  Obx(
                    () => Align(
                      alignment: Alignment.center,
                      child: controller.secondsRemaining.value > 0
                          ? AutoTranslateText(
                              'Resend OTP in ${controller.secondsRemaining.value}s',
                              style: MyTextTheme.smallBCN,
                            )
                          : TextButton(
                              onPressed: controller.resendOtp,
                              child: AutoTranslateText(
                                'Resend OTP',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: AppColors.saffron,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Spacing.h(24),
                  Obx(
                    () => MyButton(
                      title: controller.isSubmitting.value
                          ? 'Verifying...'
                          : 'Verify & Proceed',
                      onPress: controller.isSubmitting.value
                          ? null
                          : () => controller.submitOtp(
                              controller.otpTextController.text.trim(),
                            ),
                      prefixIcon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Spacing.h(12),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: controller.changeNumber,
                      child: AutoTranslateText(
                        'I would like to change phone number',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.saffron,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
