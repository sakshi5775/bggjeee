import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/onboarding/controller/onboarding_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OnboardingView extends BasePage<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C2020), // Dark maroon background
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (optional - can be removed if not needed)
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  _buildFirstPage(),
                  _buildSecondPage(),
                  _buildThirdPage(),
                ],
              ),
            ),
            // Bottom navigation (hidden during auto-advance)
            Obx(() => controller.isAutoAdvancing.value
                ? const SizedBox.shrink()
                : _buildBottomNavigation(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/app/logo.png',
            width: 280.w,
            height: 280.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/app/horoscopelogo.png',
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 60.h),
          // AutoTranslateText
          AutoTranslateText(
            'Daily, weekly or monthly\nhoroscopes, birth charts,\nnumerology and memes.',
            style: AppTypography.h2.copyWith(
              color: Color(0xffF8E6B5),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildThirdPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo SVG
          SvgPicture.asset(
            'assets/app/fullchakra.svg',
            width: 300.w,
            height: 300.h,
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(
              Color(0xFFF5E6D3),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 60.h),
          // AutoTranslateText
          AutoTranslateText(
            'Explore the cosmos and\nconnect with astrologers.',
            style: AppTypography.h2.copyWith(
              color: const Color(0xFFF5E6D3),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Page indicators (simple horizontal dashes)
          Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  final isActive = index == controller.currentPage.value;
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: isActive ? 32.w : 24.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFF5E6D3)
                          : const Color(0xFF7A5A5A),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  );
                }),
              )),
          // Next button
          GestureDetector(
            onTap: controller.nextPage,
            child: Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6D3),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward,
                color: const Color(0xFF5C2020),
                size: 28.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

