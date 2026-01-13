import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_controller.dart';
import 'package:astrobharataiuser/screens/wallet/controller/wallet_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumerologyView extends BasePage<NumerologyController> {
  const NumerologyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.h(20),
                    // Feature Grid
                    _buildFeatureGrid(),
                    Spacing.h(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final walletController = Get.put(WalletController());
    
    return AstrologyHeaderWidget(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 20.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.h(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFFDFB343),
                  size: 24.w,
                ),
              ),
              // Title
              Expanded(
                child: AutoTranslateText(
                  'Numerology',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h2),
                  textAlign: TextAlign.center,
                ),
              ),
              // Wallet icon
              Obx(() => GestureDetector(
                onTap: () => Get.toNamed('/wallet'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  margin: EdgeInsets.only(right: 4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFB343).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: const Color(0xFFDFB343),
                        size: 18.w,
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        '₹${walletController.walletBalance.value.toStringAsFixed(0)}',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: const Color(0xFFDFB343),
                          fontWeight: FontWeight.w600,
                        ).merge(AppTypography.body2),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.1,
        ),
        itemCount: controller.numerologyFeatures.length,
        itemBuilder: (context, index) {
          final feature = controller.numerologyFeatures[index];
          return _buildFeatureCard(feature);
        },
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: () => controller.onFeatureTap(feature),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFDFB343).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: const Color(0xFFDFB343),
                size: 32.w,
              ),
            ),
            Spacing.h(12),
            AutoTranslateText(
              feature['title'] as String,
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF6F221E),
                fontWeight: FontWeight.w600,
              ).merge(AppTypography.body1),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

