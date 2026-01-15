import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_controller.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumerologyView extends BasePage<NumerologyController> {
  const NumerologyView({super.key});

  @override
  Widget build(BuildContext context) {
    final walletController = Get.put(WalletController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              // Header using CommonHeader
              CommonHeader(title: 'Numerology', titleColor: Colors.white),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.h(24),
                      // Welcome Section
                      _buildWelcomeSection(),
                      Spacing.h(24),
                      // Feature Grid
                      _buildFeatureGrid(),
                      Spacing.h(24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: '#68171E'.toColor().withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.numbers,
                  color: AppColors.templeGold,
                  size: 28.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoTranslateText(
                      'Discover Your Numbers',
                      style: MyTextTheme.largeBCB.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    AutoTranslateText(
                      'Unlock the secrets of numerology',
                      style: MyTextTheme.smallBCB.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 16.h),
          child: AutoTranslateText(
            'Numerology Services',
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#68171E'.toColor(),
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.85,
          ),
          itemCount: controller.numerologyFeatures.length,
          itemBuilder: (context, index) {
            final feature = controller.numerologyFeatures[index];
            return _buildFeatureCard(feature);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: () => controller.onFeatureTap(feature),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: "#68171E".toColor().withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.onFeatureTap(feature),
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container with gradient background
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: "#DD2914".toColor(),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: Colors.white,
                      size: 32.w,
                    ),
                  ),
                  Spacing.h(14),
                  // Title
                  AutoTranslateText(
                    feature['title'] as String,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: "#68171E".toColor(),
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
