import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/widgets/phone_field_with_country_code.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/sign_up/controller/signup_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

class SignUpFormWidget extends StatelessWidget {
  final SignUpController controller;

  const SignUpFormWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome AutoTranslateText
          AutoTranslateText(
            'Create Account',
            style: MyTextTheme.veryLargeWCB.copyWith(color: AppColors.saffron),
            textAlign: TextAlign.center,
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Join us to get started',
            style: MyTextTheme.mediumBCN.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.h(32),

          // Phone Number Field with Country Code
          PhoneFieldWithCountryCode(
            controller: controller.phoneController,
            headerText: 'Phone Number',
            hintText: 'Enter your phone number',
            validator: controller.validatePhone,
            onCountryChanged: controller.onCountryChanged,
            initialCountry: controller.selectedCountryCode.value,
          ),
          Spacing.h(20),

          // Email Field
          MyTextField(
            controller: controller.emailController,
            headerText: 'Email Address',
            hintText: 'Enter your email',
            maxLine: 1,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: controller.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          Spacing.h(20),

          // Username Field
          MyTextField(
            controller: controller.usernameController,
            headerText: 'Username',
            hintText: 'Choose a username',
            maxLine: 1,
            prefixIcon: const Icon(Icons.person_outline),
            validator: controller.validateUsername,
            keyboardType: TextInputType.text,
          ),
          Spacing.h(20),

          // Password Field
          MyTextField(
            controller: controller.passwordController,
            headerText: 'Password',
            hintText: 'Create a strong password',
            isPasswordField: true,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: controller.validatePassword,
          ),
          Spacing.h(20),

          // Confirm Password Field
          MyTextField(
            controller: controller.confirmPasswordController,
            headerText: 'Confirm Password',
            hintText: 'Confirm your password',
            isPasswordField: true,
            prefixIcon: const Icon(Icons.lock_outline),
            validator: controller.validateConfirmPassword,
          ),
          Spacing.h(32),

          // Sign Up Button
          Obx(
            () => MyButton(
              title: controller.isLoading.value
                  ? 'Creating Account...'
                  : 'Sign Up',
              onPress: controller.isLoading.value ? null : controller.signUp,
              prefixIcon: controller.isLoading.value
                  ? SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.person_add, color: Colors.white, size: 15),
            ),
          ),

          Spacing.h(20),

          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoTranslateText(
                "Already have an account?",
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: controller.goToLogin,
                child: AutoTranslateText(
                  'Sign In',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.saffron,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
