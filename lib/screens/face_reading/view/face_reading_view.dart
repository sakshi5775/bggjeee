import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FaceReadingView extends StatelessWidget {
  const FaceReadingView({Key? key}) : super(key: key);

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
              
              // Unlock Your Facial Secrets section
              _buildUnlockSection(),
              
              Spacing.h(32),
              
              // What We Analyze section
              _buildWhatWeAnalyzeSection(),
              
              Spacing.h(32),
              
              // Facial Features We Read section
              _buildFacialFeaturesSection(),
              
              Spacing.h(32),
              
              // About Face Reading section
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
                message: 'Login to view your face reading history.',
              );
              if (ok) {
                Get.toNamed(AppRoutes.faceReadingHistory);
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
                color: AppColors.deepOrange,
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
          'assets/app/FaceReadingHub.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.face_retouching_natural,
            size: 60.w,
            color: '#ffffff'.toColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'Face Reading',
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
        'Ancient Chinese Physiognomy • AI-Powered Analysis',
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
                  color: AppColors.deepOrange,
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Start Your Analysis',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            // Heading
            AutoTranslateText(
              'Unlock Your Facial Secrets',
              style: MyTextTheme.largeBCB.copyWith(
                color: '#3E2723'.toColor(),
                fontWeight: FontWeight.bold,
              ).merge(AppTypography.h2),
            ),
            Spacing.h(12),
            // Description
            AutoTranslateText(
              'Upload your photo and discover what your facial features reveal about your personality, destiny, and life path.',
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
                  onPressed: () async {
                    final ok = await LoginGuard.ensureLoggedIn(
                      message: 'Please login to continue with face reading.',
                    );
                    if (ok) {
                      Get.toNamed(AppRoutes.faceReadingUpload);
                    }
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepOrange,
                  foregroundColor: '#ffffff'.toColor(),
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 6,
                  shadowColor: AppColors.deepOrange.withOpacity(0.35),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 20.w,
                      color: '#ffffff'.toColor(),
                    ),
                    Spacing.w(8),
                    AutoTranslateText(
                      'Upload Photo & Analyze',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
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
                      icon: Icons.person,
                      title: 'Personality Analysis',
                      description: 'Discover your core traits.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.business_center,
                      title: 'Career Potential',
                      description: 'Professional success indicators.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.favorite,
                      title: 'Love & Relationships',
                      description: 'Romantic compatibility insights.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildAnalyzeCard(
                      icon: Icons.trending_up,
                      title: 'Wealth Indicators',
                      description: 'Financial fortune signs.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.health_and_safety,
                      title: 'Health Markers',
                      description: 'Wellness and vitality signs.',
                    ),
                    Spacing.h(12),
                    _buildAnalyzeCard(
                      icon: Icons.bolt,
                      title: 'Life Path Insights',
                      description: 'Destiny and purpose.',
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
                color: AppColors.deepOrange,
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

  Widget _buildFacialFeaturesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'Facial Features We Read',
            style: MyTextTheme.largeBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.h2),
          ),
          Spacing.h(16),
          // Grid of 6 items in 3 columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      title: 'Eyes',
                      description: 'Window to soul.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Nose',
                      description: 'Wealth indicator.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      title: 'Mouth',
                      description: 'Communication style.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Ears',
                      description: 'Fortune & longevity.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildFeatureCard(
                      title: 'Chin',
                      description: 'Determination level.',
                    ),
                    Spacing.h(12),
                    _buildFeatureCard(
                      title: 'Face Shape',
                      description: 'Core personality.',
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
    final assetPath = _featureAssetForTitle(title);
    return Container(
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
        children: [
          _featureIcon(assetPath),
          Spacing.h(8),
          AutoTranslateText(
            title,
            style: MyTextTheme.mediumBCB.copyWith(
              color: '#3E2723'.toColor(),
              fontWeight: FontWeight.bold,
            ).merge(AppTypography.body2),
          ),
          Spacing.h(4),
          AutoTranslateText(
            description,
            style: MyTextTheme.smallBCN.copyWith(
              color: '#666666'.toColor(),
            ).merge(AppTypography.label),
          ),
        ],
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
                    colors: [AppColors.deepOrangemix.withOpacity(0.35), AppColors.deepOrange.withOpacity(0.15)],
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
                      'About Face Reading',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'Face reading (Physiognomy) is an ancient practice dating back thousands of years in Chinese culture. It analyzes facial features to reveal personality traits, fortune, and destiny.',
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

  String _featureAssetForTitle(String title) {
    final key = title.toLowerCase();
    if (key.contains('eye')) return 'assets/app/eyes.png';
    if (key.contains('nose')) return 'assets/app/nose.png';
    if (key.contains('mouth') || key.contains('lips')) return 'assets/app/lips.png';
    if (key.contains('ear')) return 'assets/app/ear.png';
    if (key.contains('chin')) return 'assets/app/chin.png';
    return 'assets/app/face.png';
  }

  Widget _featureIcon(String assetPath) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: '#FFF2E8'.toColor(),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(0.w),
        child: Transform.scale(
          scale: 1.28, // enlarge image without growing background
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.image_not_supported,
              color: '#E85C0D'.toColor(),
              size: 30.w,
            ),
          ),
        ),
      ),
    );
  }
}

