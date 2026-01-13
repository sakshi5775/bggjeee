import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
import 'package:astrobharataiuser/screens/numerology/controller/numerology_form_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NumerologyFeaturesView extends BasePage<NumerologyFormController> {
  const NumerologyFeaturesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.h(20),
                    _buildInfoCard(),
                    Spacing.h(24),
                    _buildFeaturesGrid(),
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

  Widget _buildHeader() {
    return AstrologyHeaderWidget(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h, bottom: 20.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.h(8),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFFDFB343),
                  size: 24.w,
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  'Select Feature',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: const Color(0xFFDFB343),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              "#DFB343".toColor().withOpacity(0.1),
              "#DFB343".toColor().withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: "#DFB343".toColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: "#DFB343".toColor(),
              size: 24.w,
            ),
            Spacing.w(12),
            Expanded(
              child: AutoTranslateText(
                'Select any numerology feature to get detailed insights',
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#6F221E".toColor(),
                  height: 1.4,
                ).merge(AppTypography.body2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          final childAspectRatio = constraints.maxWidth > 600 ? 1.1 : 1.0;
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: controller.tabs.length,
            itemBuilder: (context, index) {
              final tab = controller.tabs[index];
              return _buildFeatureCard(tab, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> tab, int index) {
    return GestureDetector(
      onTap: () => controller.onTabSelected(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    "#DFB343".toColor().withOpacity(0.15),
                    "#DFB343".toColor().withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                tab['icon'] as IconData,
                color: "#DFB343".toColor(),
                size: 32.w,
              ),
            ),
            Spacing.h(12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: AutoTranslateText(
                tab['title'] as String,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: const Color(0xFF6F221E),
                  fontWeight: FontWeight.w600,
                ).merge(AppTypography.body1),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

