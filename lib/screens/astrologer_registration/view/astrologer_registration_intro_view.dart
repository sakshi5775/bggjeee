import 'package:astrobharataiuser/app_manager/myButton.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class AstrologerRegistrationIntroView extends StatelessWidget {
  const AstrologerRegistrationIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CommonHeader(title: 'Become Astrologer'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSectionTitle('AstroBharatAI Samvaad'),
                          SizedBox(height: 12.h),
                          const AutoTranslateText(
                            'AstroBharatAI Samvaad is a thoughtfully designed digital platform created to support astrologers in delivering astrology consultations using modern technology.\nThe app brings together astrologers and seekers in a structured, secure, and transparent environment.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _buildSectionTitle('What Makes Us Different'),
                          SizedBox(height: 12.h),
                          const AutoTranslateText(
                            'What makes AstroBharatAI Samvaad different is its unique multi-step onboarding process. Every astrologer joining the platform goes through KYC verification, personal interviews, training modules, and evaluation quizzes, ensuring authenticity and consistency across the ecosystem. Critical onboarding steps are further protected using biometric security, adding an additional layer of trust and reliability.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          _buildSectionTitle('Your Growth & Tools'),
                          SizedBox(height: 12.h),
                          const AutoTranslateText(
                            'Astrologers can create and manage detailed profiles, showcase their areas of expertise, and offer consultations through integrated chat, call, and video features. The platform also provides access to training resources and clear operational guidelines, helping astrologers understand consultation standards and workflows.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          const AutoTranslateText(
                            'AstroBharatAI Samvaad is designed to balance traditional astrological practices with modern digital tools, making it easier for astrologers to adapt to an evolving digital landscape while maintaining integrity and trust.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    MyButton(
                      title: 'Join Now',
                      onPress: () {
                        UserMainController.pushInCurrentTab(AppRoutes.astrologerRegistrationForm);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AutoTranslateText(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.saffron,
        ),
      ),
    );
  }
}
