import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';

class UserPrivacyPolicyView extends StatelessWidget {
  const UserPrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const CommonHeader(title: 'Privacy Policy & Terms'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Privacy Policy',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textColorMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    AutoTranslateText(
                      'Last updated: February 09, 2026',
                      style: AppTypography.body2.copyWith(color: Colors.grey),
                    ),
                    SizedBox(height: 16.h),
                    AutoTranslateText(
                      '1. Introduction\n\nWelcome to Astrobharata. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you as to how we look after your personal data when you visit our website or use our mobile application and tell you about your privacy rights and how the law protects you.\n\n2. Data We Collect\n\nWe may collect, use, store and transfer different kinds of personal data about you which we have grouped together follows: Identity Data, Contact Data, Financial Data, Transaction Data, Technical Data, Profile Data, Usage Data.\n\n3. How We Use Your Data\n\nWe will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances: Where we need to perform the contract we are about to enter into or have entered into with you.\n\n4. Data Security\n\nWe have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed.',
                      style: AppTypography.body1.copyWith(
                        color: "#3D0C11".toColor(),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Divider(color: Colors.grey[300]),
                    SizedBox(height: 24.h),
                    AutoTranslateText(
                      'Terms of Service',
                      style: AppTypography.h3.copyWith(
                        color: AppColors.textColorMaroon,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AutoTranslateText(
                      '1. Agreement to Terms\n\nBy accessing or using our Services, you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.\n\n2. Intellectual Property\n\nThe Service and its original content, features and functionality are and will remain the exclusive property of Astrobharata and its licensors.\n\n3. User Responsibilities\n\nYou differ to use the Service only for lawful purposes and in a way that does not infringe the rights of, restrict or inhibit anyone else\'s use and enjoyment of the Service.\n\n4. Termination\n\nWe may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
                      style: AppTypography.body1.copyWith(
                        color: "#3D0C11".toColor(),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24.h),
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
