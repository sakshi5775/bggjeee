import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/widgets/phone_field_with_country_code.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/guest_session_manager.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/login/controller/login_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class LoginFormWidget extends StatelessWidget {
  final LoginController controller;

  const LoginFormWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle: Login with Password | Login with OTP
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.isClosed) return;
                        controller.isOtpMode.value = false;
                        controller.otpSent.value = false;
                        controller.otpController.clear();
                        controller.resendSecondsRemaining.value = 0;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          gradient: !controller.isOtpMode.value
                              ? AppColors.orangeGradient
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            'Password',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: !controller.isOtpMode.value
                                  ? Colors.white
                                  : AppColors.saffron,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.isClosed) return;
                        controller.isOtpMode.value = true;
                        controller.otpSent.value = false;
                        controller.otpController.clear();
                        // OTP login is phone-only.
                        controller.isEmailMode.value = false;
                        controller.emailController.clear();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          gradient: controller.isOtpMode.value
                              ? AppColors.orangeGradient
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: AutoTranslateText(
                            'OTP',
                            style: MyTextTheme.mediumBCB.copyWith(
                              color: controller.isOtpMode.value
                                  ? Colors.white
                                  : AppColors.saffron,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Spacing.h(8),

          // Phone/Email Field.
          // In OTP mode we force phone-only even if isEmailMode was toggled before.
          Obx(() {
            if (controller.isOtpMode.value) {
              return PhoneFieldWithCountryCode(
                controller: controller.phoneController,
                headerText: 'Phone Number',
                hintText: 'Enter phone number',
                validator: (value) {
                  return controller.validatePhone(value);
                },
                onCountryChanged: controller.onCountryChanged,
                initialCountry: controller.selectedCountryCode.value,
              );
            }
            if (controller.isEmailMode.value) {
              // Email Field
              return MyTextField(
                controller: controller.emailController,
                headerText: 'Email Address',
                hintText: 'Enter your email',
                maxLine: 1,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: controller.validateEmail,
                keyboardType: TextInputType.emailAddress,
              );
            } else {
              // Phone Field with Country Code
              return PhoneFieldWithCountryCode(
                controller: controller.phoneController,
                headerText: 'Phone Number',
                hintText: 'Enter phone number',
                validator: (value) {
                  return controller.validatePhone(value);
                },
                onCountryChanged: controller.onCountryChanged,
                initialCountry: controller.selectedCountryCode.value,
              );
            }
          }),
          Spacing.h(8),

          // OTP flow: after Send OTP show OTP input + Resend + Verify
          Obx(() {
            if (controller.isOtpMode.value && controller.otpSent.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyTextField(
                    controller: controller.otpController,
                    headerText: 'Enter OTP',
                    hintText: '6-digit OTP',
                    maxLine: 1,
                    prefixIcon: const Icon(Icons.sms_outlined),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Please enter OTP';
                      if (v.trim().length != 6) return 'OTP must be 6 digits';
                      return null;
                    },
                  ),
                  Spacing.h(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: controller.resendSecondsRemaining.value > 0
                            ? null
                            : controller.resendOtpLogin,
                        child: AutoTranslateText(
                          controller.resendSecondsRemaining.value > 0
                              ? 'Resend OTP in ${controller.resendSecondsRemaining.value}s'
                              : 'Resend OTP',
                          style: MyTextTheme.smallBCB.copyWith(
                            color: AppColors.saffron,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Obx(() {
                        final loading = controller.isLoading.value;
                        return GestureDetector(
                          onTap: loading ? null : controller.verifyOtpLogin,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: AppColors.orangeGradient,
                            ),
                            child: loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : AutoTranslateText(
                                    'Verify OTP',
                                    style: MyTextTheme.mediumBCB.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ],
                  ),
                  Spacing.h(8),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Password Field + Forgot - show only when password mode
          Obx(() {
            if (controller.isOtpMode.value) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  controller: controller.passwordController,
                  headerText: 'Password',
                  hintText: 'Enter your password',
                  isPasswordField: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: controller.validatePassword,
                ),
                Spacing.h(3),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                    child: AutoTranslateText(
                      'Forgot Password?',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: AppColors.saffron,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),

          Obx(() {
            if (controller.isOtpMode.value && !controller.otpSent.value) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacing.h(8),
                  GestureDetector(
                    onTap: controller.isLoading.value ? null : controller.sendOtpLogin,
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: AppColors.orangeGradient,
                      ),
                      child: Center(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const AutoTranslateText(
                                'Send OTP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Spacing.h(16),
                ],
              );
            }
            return const SizedBox.shrink();
          }),

          // Login Button - show only for password mode
          Obx(() {
            if (controller.isOtpMode.value) return const SizedBox.shrink();
            final isLoading = controller.isLoading.value;
            return GestureDetector(
              onTap: isLoading ? null : controller.login,
              child: Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: AppColors.orangeGradient,
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            );
          }),

          Spacing.h(8),

          // Continue with Email/Phone (only in password mode)
          Obx(() {
            if (controller.isOtpMode.value) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: controller.isEmailMode.value
                  ? TextButton.icon(
                      onPressed: () {
                        if (controller.isClosed) return;
                        controller.isEmailMode.value = false;
                        controller.emailController.clear();
                      },
                      icon: const Icon(
                        Icons.phone_outlined,
                        color: AppColors.saffron,
                      ),
                      label: AutoTranslateText(
                        'Continue with Phone',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : TextButton.icon(
                      onPressed: () {
                        if (controller.isClosed) return;
                        controller.isEmailMode.value = true;
                        controller.emailController.clear();
                      },
                      icon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.saffron,
                      ),
                      label: AutoTranslateText(
                        'Continue with Email',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.saffron,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            );
          }),

          Spacing.h(16),

          // Terms and Privacy Checkbox
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: controller.isTermsAccepted.value,
                      onChanged: (value) {
                        controller.isTermsAccepted.value = value ?? false;
                      },
                      activeColor: AppColors.saffron,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        AutoTranslateText(
                          'By continuing, you agree to our ',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: AppColors.gray,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.userPrivacyPolicy);
                            //  launchUrl(
                            //   Uri.parse(
                            //     'https://astrobharatai.com/privacypolicy',
                            //   ),
                            //   mode: LaunchMode.externalApplication,
                            // );
                          },
                          child: AutoTranslateText(
                            'Terms of Service',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.saffron,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        AutoTranslateText(
                          ' and ',
                          style: MyTextTheme.smallBCN.copyWith(
                            color: AppColors.gray,
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.userPrivacyPolicy);
                          },
                          child: AutoTranslateText(
                            'Privacy Policy',
                            style: MyTextTheme.smallBCB.copyWith(
                              color: AppColors.saffron,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacing.h(8),

          // Signup Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoTranslateText(
                "Already haven't account? ",
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.gray,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.signup);
                },
                child: AutoTranslateText(
                  'Signup',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: AppColors.deepOrangemix,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Spacing.h(8),

          TextButton(
            onPressed: () async {
              if (!controller.isTermsAccepted.value) {
                Get.snackbar(
                  'Required',
                  'Please accept Terms of Service and Privacy Policy to continue',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              // Enable guest mode
              await GuestSessionManager.enableGuestMode();

              // Navigate to user dashboard
              Get.offAllNamed(AppRoutes.userDashboard);
            },
            child: Text(
              'Continue as a Guest',
              style: MyTextTheme.smallBCB.copyWith(
                color: AppColors.deepOrangemix,
                fontSize: 14,
              ),
            ),
          ),
          // Forgot Password
        ],
      ),
    );
  }
}
