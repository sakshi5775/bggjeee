import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/forgot_password/controller/forgot_password_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordOtpView extends GetView<ForgotPasswordController> {
  const ForgotPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.w,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.saffron),
      boxShadow: [
        BoxShadow(
          color: AppColors.saffron.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const AutoTranslateText(
          'Verify OTP',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: controller.otpFormKey,
                  child: Column(
                    children: [
                      Spacing.h(40),
                      const AutoTranslateText(
                        'Enter Verification Code',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Spacing.h(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AutoTranslateText(
                            'We have sent a 6-digit code to ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              controller.emailController.text,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Spacing.h(40),
                      Pinput(
                        length: 6,
                        controller: controller.otpController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        validator: controller.validateOtp,
                        onCompleted: (pin) => controller.verifyOtp(),
                      ),
                      Spacing.h(32),
                      Obx(
                        () => MyButton(
                          title: 'Verify & Proceed',
                          onPress: controller.isLoading.value
                              ? null
                              : () => controller.verifyOtp(),
                          suffixIcon: controller.isLoading.value
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Spacing.h(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AutoTranslateText(
                            "Didn't receive code? ",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () => controller.resendOtp(),
                              child: AutoTranslateText(
                                'Resend OTP',
                                style: TextStyle(
                                  color: controller.isLoading.value
                                      ? Colors.grey
                                      : AppColors.saffron,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
