import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/widgets/phone_field_with_country_code.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/login/controller/login_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
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
          // Welcome AutoTranslateText
          AutoTranslateText(
            'Welcome Back',
            style: MyTextTheme.veryLargeWCB.copyWith(color: AppColors.saffron),
            textAlign: TextAlign.center,
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Sign in to continue',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(32),

          // Phone/Email Field - Show phone field by default
          Obx(() {
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
                validator: controller.validatePhone,
                onCountryChanged: controller.onCountryChanged,
                initialCountry: controller.selectedCountryCode.value,
              );
            }
          }),
          Spacing.h(20),

          // Password Field - Show for both email and phone login
          MyTextField(
            controller: controller.passwordController,
            headerText: 'Password',
            hintText: 'Enter your password',
            isPasswordField: true,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: controller.validatePassword,
          ),
          Spacing.h(20),

          // Continue with Email Button (when in phone mode)
          Obx(() {
            if (!controller.isEmailMode.value) {
              return TextButton.icon(
                onPressed: () {
                  controller.isEmailMode.value = true;
                  controller.emailController.clear();
                },
                icon: const Icon(Icons.email_outlined, color: AppColors.saffron),
                label: AutoTranslateText(
                  'Continue with Email',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else {
              // Show switch to phone option
              return TextButton.icon(
                onPressed: () {
                  controller.isEmailMode.value = false;
                  controller.emailController.clear();
                },
                icon: const Icon(Icons.phone_outlined, color: AppColors.saffron),
                label: AutoTranslateText(
                  'Continue with Phone',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
          }),
          Spacing.h(20),

          // Login Button
          Obx(
            () {
              // Access observable directly in Obx builder
              final isLoading = controller.isLoading.value;
              return MyButton(
                title: isLoading ? 'Logging In...' : 'Sign In',
                onPress: isLoading ? null : controller.login,
                prefixIcon: isLoading
                    ? SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.arrow_forward, color: Colors.white, size: 15),
              );
            },
          ),

          Spacing.h(20),

          // Forgot Password
          TextButton(
            onPressed: () {
              // Implement forgot password functionality
            },
            child: AutoTranslateText(
              'Forgot Password?',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.saffron,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
