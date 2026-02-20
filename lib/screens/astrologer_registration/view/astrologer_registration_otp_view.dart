import 'package:astrobharataiuser/screens/astrologer_registration/controller/astrologer_registration_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class AstrologerRegistrationOtpView
    extends GetView<AstrologerRegistrationController> {
  const AstrologerRegistrationOtpView({super.key});

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
          color: AppColors.saffron.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CommonHeader(title: 'Verify Details'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    const AutoTranslateText(
                      'Enter Verification Code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => AutoTranslateText(
                        'We have sent a 6-digit code to ${controller.registeredPhone.value}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Pinput(
                      length: 6,
                      controller: controller.otpController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      onCompleted: (pin) => controller.verifyOtp(),
                    ),
                    SizedBox(height: 20.h),
                    Obx(
                      () => TextButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                controller.resendOtp();
                              },
                        child: const AutoTranslateText(
                          'Resend Code',
                          style: TextStyle(
                            color: AppColors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  controller.verifyOtp();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepOrange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const AutoTranslateText(
                                  'Verify & Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

