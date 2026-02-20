import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumerologyView extends BasePage<NumerologyController> {
  const NumerologyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header
            const CommonHeader(title: 'Numerology'),
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
              color: Colors.black.withValues(alpha: 0.05),
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
                color: const Color(0xFFDFB343).withValues(alpha: 0.1),
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
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: const Color(0xFF6F221E),
                    fontWeight: FontWeight.w600,
                  )
                  .merge(AppTypography.body1),
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


