import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RamalShastraView extends StatelessWidget {
  const RamalShastraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header with back button
              _buildHeader(),
              Spacing.h(32),
              // Main icon
              _buildMainIcon(),
              Spacing.h(24),
              // Title
              _buildTitle(),
              Spacing.h(8),
              // Subtitle
              _buildSubtitle(),
              Spacing.h(32),
              // Start Your Reading section
              _buildStartReadingSection(),
              Spacing.h(32),
              // What We Analyze section
              _buildWhatWeAnalyzeSection(),
              Spacing.h(32),
              // About Ramal Shastra section
              _buildAboutSection(),
              Spacing.h(32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
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
          Spacer(),
          // History button
          GestureDetector(
            onTap: () async {
              final ok = await LoginGuard.ensureLoggedIn(
                message: 'Login to view your Ramal Shastra history.',
              );
              if (ok) {
                Get.toNamed(AppRoutes.ramalShastraHistory);
              }
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#ffffff'.toColor(),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.history,
                color: '#EA632B'.toColor(),
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 140.w,
      height: 140.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Image.asset(
          AppConstant.ramalShastra,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: '#EA632B'.toColor(),
            child: Icon(
              Icons.casino,
              size: 60.w,
              color: '#ffffff'.toColor(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'Ramal Shastra',
      style: MyTextTheme.veryLargeBCB.copyWith(
        color: '#3E2723'.toColor(),
        fontWeight: FontWeight.bold,
      ).merge(AppTypography.h1),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AutoTranslateText(
        'Ancient Binary Divination System',
        style: MyTextTheme.mediumBCN.copyWith(
          color: '#3E2723'.toColor(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStartReadingSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: '#F5D7B8'.toColor(),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Your Reading header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: "#F38B3B".toColor(),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Start Your Reading',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: "#F38B3B".toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            // Heading
            AutoTranslateText(
              'Instant Question Prediction',
              style: MyTextTheme.largeBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
            Spacing.h(12),
            // Description
            AutoTranslateText(
              'Ask a clear question and receive guidance using Ramal Shastra based on dots, dice, and synchronicity.',
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#666666'.toColor(),
                height: 1.5,
              ),
            ),
            Spacing.h(20),
            // Start Reading button
            SizedBox(
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
                  onPressed: () async {
                    final ok = await LoginGuard.ensureLoggedIn(
                      message: 'Please login to continue with Ramal Shastra reading.',
                    );
                    if (ok) {
                      Get.toNamed(AppRoutes.ramalShastraQuestion);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: '#ffffff'.toColor(),
                    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.casino,
                      size: 20.w,
                      color: '#ffffff'.toColor(),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Start Reading',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatWeAnalyzeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'What We Analyze',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(16),
          // Grid of 6 items in 2 columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildAnalyzeCard(
                      icon: Icons.work,
                      title: 'Career',
                      description: 'Professional guidance.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.favorite,
                      title: 'Love & Relationships',
                      description: 'Romantic insights.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.business,
                      title: 'Business',
                      description: 'Business decisions.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildAnalyzeCard(
                      icon: Icons.health_and_safety,
                      title: 'Health',
                      description: 'Wellness guidance.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.account_balance_wallet,
                      title: 'Finance',
                      description: 'Financial fortune.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.family_restroom,
                      title: 'Family',
                      description: 'Family matters.',
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

  Widget _buildAnalyzeCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return SizedBox(
      height: 158.h,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: '#ffffff'.toColor(),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: '#F5D7B8'.toColor(),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: '#E85C0D'.toColor(),
                size: 22.w,
              ),
            ),
            Spacing.h(10),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(4),
            Expanded(
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#666666'.toColor(),
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: AppColors.orangeGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -30.h,
              right: -40.w,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: ["#DD2914".toColor().withOpacity(0.35), "#F38B3B".toColor().withOpacity(0.15)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: '#ffffff'.toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'About Ramal Shastra',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'Ramal Shastra is an ancient divination system using binary patterns (dots, dice, or cards) to answer questions. It analyzes synchronicity and patterns to provide guidance on various aspects of life.',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#ffffff'.toColor(),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


