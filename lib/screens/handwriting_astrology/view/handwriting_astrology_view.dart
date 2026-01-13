import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HandwritingAstrologyView extends StatelessWidget {
  const HandwritingAstrologyView({Key? key}) : super(key: key);

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
              
              // Main icon
              _buildMainIcon(),
              
              // Title
              _buildTitle(),
              
              Spacing.h(8),
              
              // Subtitle
              _buildSubtitle(),
              
              Spacing.h(32),
              
              // Unlock Your Handwriting Secrets section
              _buildUnlockSection(),
              
              Spacing.h(32),
              
              // What We Analyze section
              _buildWhatWeAnalyzeSection(),
              
              Spacing.h(32),
              
              // Handwriting Features We Read section
              _buildHandwritingFeaturesSection(),
              
              Spacing.h(32),
              
              // About Handwriting Astrology section
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
            onTap: () => Get.toNamed(AppRoutes.handwritingAstrologyHistory),
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
        child: Icon(
          Icons.edit_note,
          size: 80.w,
          color: '#EA632B'.toColor(),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'Writing Astrology',
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
        'Ancient Graphology • AI-Powered Analysis',
        style: MyTextTheme.mediumBCN.copyWith(
          color: '#3E2723'.toColor(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildUnlockSection() {
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
            // Start Your Analysis header
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: '#FF6B35'.toColor(),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Start Your Analysis',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#FF6B35'.toColor(),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h3),
                ),
              ],
            ),
            Spacing.h(12),
            // Heading
            AutoTranslateText(
              'Unlock Your Handwriting Secrets',
              style: MyTextTheme.largeBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.h(12),
            // Description
            AutoTranslateText(
              'Upload your handwriting sample and discover what your writing reveals about your personality, traits, and life path.',
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#666666'.toColor(),
                height: 1.5,
              ),
            ),
            Spacing.h(20),
            // Upload button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.handwritingAstrologyUpload),
                style: ElevatedButton.styleFrom(
                  backgroundColor: '#FF6B35'.toColor(),
                  foregroundColor: '#ffffff'.toColor(),
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 6,
                  shadowColor: '#FF6B35'.toColor().withOpacity(0.35),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.upload_file,
                      size: 20.w,
                      color: '#ffffff'.toColor(),
                    ),
                    Spacing.w(8),
                    Flexible(
                      child: AutoTranslateText(
                        'Upload & Analyze',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#ffffff'.toColor(),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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
            ),
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
                      icon: Icons.psychology,
                      title: 'Emotional Intelligence',
                      description: 'Discover your emotional awareness.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.trending_up,
                      title: 'Ambition & Goals',
                      description: 'Career and life aspirations.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.chat_bubble,
                      title: 'Communication Style',
                      description: 'How you express yourself.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildAnalyzeCard(
                      icon: Icons.lightbulb,
                      title: 'Creativity Level',
                      description: 'Creative thinking patterns.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.balance,
                      title: 'Stability & Balance',
                      description: 'Emotional stability signs.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.insights,
                      title: 'Personality Traits',
                      description: 'Core personality insights.',
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildHandwritingFeaturesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Handwriting Features We Read',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(16),
          // Grid of 8 items in 2 columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      title: 'Letter Size',
                      description: 'Self-esteem indicator.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Slant',
                      description: 'Emotional expression.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Pressure',
                      description: 'Energy levels.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Spacing',
                      description: 'Social boundaries.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      title: 'Baseline',
                      description: 'Mood stability.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Zones',
                      description: 'Intelligence balance.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Loops',
                      description: 'Practical focus.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Connections',
                      description: 'Logical thinking.',
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

  Widget _buildFeatureCard({
    required String title,
    required String description,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 120.h,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: '#FFFAF0'.toColor(),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: '#F5D7B8'.toColor(),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: '#E85C0D'.toColor(),
                size: 20.w,
              ),
            ),
            Spacing.h(8),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.body2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacing.h(4),
            Expanded(
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#666666'.toColor(),
                ).merge(AppTypography.label),
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              '#FF6B35'.toColor(),
              '#FF8C42'.toColor(),
            ],
          ),
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
                    colors: ['#FF8C42'.toColor().withOpacity(0.35), '#FF6B35'.toColor().withOpacity(0.15)],
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
                      Icons.auto_awesome,
                      color: '#ffffff'.toColor(),
                      size: 20.w,
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'About Writing Astrology',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'Handwriting analysis (Graphology) is an ancient practice that analyzes handwriting patterns to reveal personality traits, emotional states, and behavioral patterns. Your handwriting is unique and reflects your inner self.',
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

