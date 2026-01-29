import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingView extends StatelessWidget {
  const PalmReadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PalmReadingController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(), // Match face reading background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header with back button and history button
                  _buildHeader(context),

                  // Main icon with star badge
                  _buildMainIcon(),

                  // Title
                  _buildTitle(),

                  Spacing.h(16),

                  // Description
                  _buildDescription(),

                  Spacing.h(32),

                  // Feature highlights grid
                  _buildFeatureGrid(),

                  Spacing.h(32),

                  // Start Reading button
                  _buildStartButton(context, controller),

                  Spacing.h(32),

                  // What You'll Get section
                  _buildBenefitsSection(),

                  Spacing.h(32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16, v: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: '#3E2723'.toColor(),
                size: 20.w,
              ),
            ),
          ),

          // History button
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.palmReadingHistory),
            child: Container(
              padding: AppPaddings.symmetric(h: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF5F2221).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: '#3E2723'.toColor(),
                    size: 18.w,
                  ),
                  Spacing.w(8),
                  AutoTranslateText(
                    'History',
                    style: MyTextTheme.mediumBCB
                        .copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.w600,
                        )
                        .merge(AppTypography.body1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIcon() {
    return SizedBox(
      height: 120.h,
      child: Center(
        child: Transform.scale(
          scale: 2.0,
          child: Image.network(
            AppConstant.palmreadingscreen,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: AutoTranslateText(
        'Palm Reading',
        style: MyTextTheme.veryLargeBCB
            .copyWith(color: '#3E2723'.toColor(), fontWeight: FontWeight.bold)
            .merge(AppTypography.h1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: AppPaddings.symmetric(h: 24),
      child: AutoTranslateText(
        'Upload your palm photo and get an AI-generated palm reading with detailed insights about your life, personality, and future.',
        style: MyTextTheme.mediumBCN
            .copyWith(color: '#3E2723'.toColor(), height: 1.5)
            .merge(AppTypography.body1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.remove_red_eye,
                  iconColor: "#F38B3B".toColor(),
                  title: 'AI Detection',
                  subtitle: 'Smart line analysis',
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.gps_fixed,
                  iconColor: "#F38B3B".toColor(),
                  title: 'Accurate',
                  subtitle: 'Precise predictions',
                ),
              ),
            ],
          ),
          Spacing.h(12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.flash_on,
                  iconColor: "#F38B3B".toColor(),
                  title: 'Instant',
                  subtitle: 'Results in seconds',
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.bar_chart,
                  iconColor: "#F38B3B".toColor(),
                  title: 'Detailed',
                  subtitle: 'Complete report',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32.w),
          Spacing.h(12),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.body1),
            textAlign: TextAlign.center,
          ),
          Spacing.h(4),
          AutoTranslateText(
            subtitle,
            style: MyTextTheme.smallBCN
                .copyWith(color: Colors.grey[600])
                .merge(AppTypography.body2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: '#3E2723'.toColor(), size: 20.w),
              Spacing.w(8),
              AutoTranslateText(
                'What You\'ll Get:',
                style: MyTextTheme.mediumBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h3),
              ),
            ],
          ),
          Spacing.h(16),
          ..._buildBenefitsList(),
        ],
      ),
    );
  }

  List<Widget> _buildBenefitsList() {
    final benefits = [
      'Major & Minor palm lines analysis',
      'Mount interpretation & strength',
      'Special markings & their meanings',
      'Personality insights & predictions',
      'Career, love & health guidance',
    ];

    return benefits.map((benefit) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle, color: "#F38B3B".toColor(), size: 20.w),
            Spacing.w(12),
            Expanded(
              child: AutoTranslateText(
                benefit,
                style: MyTextTheme.mediumBCN
                    .copyWith(color: '#3E2723'.toColor(), height: 1.4)
                    .merge(AppTypography.body1),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildStartButton(
    BuildContext context,
    PalmReadingController controller,
  ) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: "#F38B3B".toColor().withOpacity(0.35),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.palmReadingForm),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              padding: AppPaddings.symmetric(v: 16, h: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 20.w, color: Colors.white),
                Spacing.w(8),
                AutoTranslateText(
                  'Upload Photo & Analyze',
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
