import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HandwritingAstrologyView extends StatelessWidget {
  const HandwritingAstrologyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Header with back button
            CommonHeader(
              title: 'Handwriting Astrology',
              subtitle: AutoTranslateText(
                'Ancient Graphology • AI Analysis',
                style: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.templeGold.withValues(alpha: 0.9),
                ),
              ),
              customActions: [
                IconButton(
                  icon: Icon(
                    Icons.history,
                    color: AppColors.templeGold,
                    size: 24.w,
                  ),
                  onPressed: () async {
                    final ok = await LoginGuard.ensureLoggedIn(
                      message:
                          'Login to view your handwriting reading history.',
                    );
                    if (ok) {
                      Get.toNamed(AppRoutes.handwritingAstrologyHistory);
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
          ],
        ),
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 140.w,
      height: 140.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Icon(Icons.edit_note, size: 80.w, color: '#EA632B'.toColor()),
      ),
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'Writing Astrology',
      style: MyTextTheme.veryLargeBCB
          .copyWith(color: '#3E2723'.toColor(), fontWeight: FontWeight.bold)
          .merge(AppTypography.h1),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AutoTranslateText(
        'Ancient Graphology • AI-Powered Analysis',
        style: MyTextTheme.mediumBCN.copyWith(color: '#3E2723'.toColor()),
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
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1.5),
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
                  color: "#F38B3B".toColor(),
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Start Your Analysis',
                  style: MyTextTheme.mediumBCB
                      .copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h3),
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
                  onPressed: () =>
                      Get.toNamed(AppRoutes.handwritingAstrologyUpload),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: '#ffffff'.toColor(),
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 16.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatWeAnalyzeSection() {
    final analyzeItems = [
      {
        'icon': Icons.psychology,
        'title': 'Emotional Intelligence',
        'desc': 'Discover your emotional awareness.',
      },
      {
        'icon': Icons.trending_up,
        'title': 'Ambition & Goals',
        'desc': 'Career and life aspirations.',
      },
      {
        'icon': Icons.chat_bubble,
        'title': 'Communication Style',
        'desc': 'How you express yourself.',
      },
      {
        'icon': Icons.lightbulb,
        'title': 'Creativity Level',
        'desc': 'Creative thinking patterns.',
      },
      {
        'icon': Icons.balance,
        'title': 'Stability & Balance',
        'desc': 'Emotional stability signs.',
      },
      {
        'icon': Icons.insights,
        'title': 'Personality Traits',
        'desc': 'Core personality insights.',
      },
    ];

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
          // Responsive Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.w,
              mainAxisExtent: 158.h,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: analyzeItems.length,
            itemBuilder: (context, index) {
              final item = analyzeItems[index];
              return _buildAnalyzeCard(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                description: item['desc'] as String,
              );
            },
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
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
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
            child: Icon(icon, color: '#E85C0D'.toColor(), size: 22.w),
          ),
          Spacing.h(10),
          AutoTranslateText(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacing.h(4),
          AutoTranslateText(
            description,
            style: MyTextTheme.smallBCN.copyWith(
              color: '#666666'.toColor(),
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
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
              child: Icon(Icons.edit, color: '#E85C0D'.toColor(), size: 20.w),
            ),
            Spacing.h(8),
            AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.body2),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Spacing.h(4),
            Expanded(
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN
                    .copyWith(color: '#666666'.toColor())
                    .merge(AppTypography.label),
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
                    colors: [
                      "#DD2914".toColor().withOpacity(0.35),
                      "#F38B3B".toColor().withOpacity(0.15),
                    ],
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
