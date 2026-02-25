import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/login_guard.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/controller/carrot_astrology_controller.dart';
import 'package:astrobharataiuser/screens/carrot_astrology/utils/carrot_astrology_colors.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class CarrotAstrologyView extends StatelessWidget {
  const CarrotAstrologyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CarrotAstrologyController());
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 600.w;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // Fixed Header
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: CommonHeader(
                  title: 'Carrot Astrology',
                  subtitle: AutoTranslateText(
                    'Playful Insights • AI Wisdom',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: const Color(0xFF6F221E).withValues(alpha: 0.7),
                    ),
                  ),
                  customActions: [
                    IconButton(
                      icon: Icon(
                        Icons.history,
                        color: '#6F221E'.toColor(),
                        size: 24.w,
                      ),
                      onPressed: () async {
                        final ok = await LoginGuard.ensureLoggedIn(
                          message:
                              'Login to view your carrot astrology history.',
                        );
                        if (ok) {
                          UserMainController.pushInCurrentTab(AppRoutes.carrotAstrologyHistory);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
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

                        // Discover Your Vegetable Match section
                        _buildDiscoverSection(controller),

                        Spacing.h(32),

                        // What You'll Discover section
                        _buildWhatYouDiscoverSection(),

                        Spacing.h(32),

                        // About Carrot Astrology section
                        _buildAboutSection(),

                        Spacing.h(32),
                      ],
                    ),
                  ),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: CarrotAstrologyColors.orangeColor.withValues(alpha: 0.1),
      ),
      child: Icon(
        Icons.eco,
        size: 80.w,
        color: CarrotAstrologyColors.orangeColor,
      ),
    );
  }

  Widget _buildTitle() {
    return AutoTranslateText(
      'Carrot Astrology',
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
        'Discover Your Vegetable Essence • Zodiac-Based Wellness',
        style: MyTextTheme.mediumBCN
            .copyWith(color: '#3E2723'.toColor())
            .merge(AppTypography.body1),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDiscoverSection(CarrotAstrologyController controller) {
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
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: CarrotAstrologyColors.orangeColor,
                  size: 20.w,
                ),
                Spacing.w(8),
                AutoTranslateText(
                  'Start Your Analysis',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: CarrotAstrologyColors.orangeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacing.h(12),
            AutoTranslateText(
              'Discover Your Vegetable Match',
              style: MyTextTheme.largeBCB
                  .copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.h2),
            ),
            Spacing.h(12),
            AutoTranslateText(
              'Select your zodiac sign and discover which vegetable aligns with your cosmic energy, along with personalized remedies and insights.',
              style: MyTextTheme.mediumBCN
                  .copyWith(color: '#666666'.toColor(), height: 1.5)
                  .merge(AppTypography.body1),
            ),
            Spacing.h(20),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: CarrotAstrologyColors.orangeGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: CarrotAstrologyColors.orangeColorDark.withOpacity(
                        0.35,
                      ),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => UserMainController.pushInCurrentTab(AppRoutes.carrotAstrologyForm),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: '#ffffff'.toColor(),
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 24.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 20.w,
                        color: '#ffffff'.toColor(),
                      ),
                      Spacing.w(8),
                      AutoTranslateText(
                        'Select Zodiac Sign & Analyze',
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

  Widget _buildWhatYouDiscoverSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            'What You\'ll Discover',
            style: MyTextTheme.largeBCB
                .copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                )
                .merge(AppTypography.h2),
          ),
          Spacing.h(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildDiscoverCard(
                      icon: Icons.nature,
                      title: 'Vegetable Match',
                      description: 'Your perfect vegetable companion.',
                    ),
                    Spacing.h(12),
                    _buildDiscoverCard(
                      icon: Icons.restaurant_menu,
                      title: 'Food Remedies',
                      description: 'Nourishing meal recommendations.',
                    ),
                  ],
                ),
              ),
              Spacing.w(12),
              Expanded(
                child: Column(
                  children: [
                    _buildDiscoverCard(
                      icon: Icons.fitness_center,
                      title: 'Lifestyle Tips',
                      description: 'Daily practices for harmony.',
                    ),
                    Spacing.h(12),
                    _buildDiscoverCard(
                      icon: Icons.color_lens,
                      title: 'Colors & Stones',
                      description: 'Enhancing cosmic energy.',
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

  Widget _buildDiscoverCard({
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
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  )
                  .merge(AppTypography.body2),
            ),
            Spacing.h(4),
            Expanded(
              child: AutoTranslateText(
                description,
                style: MyTextTheme.smallBCN
                    .copyWith(color: '#666666'.toColor(), height: 1.25)
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
          gradient: CarrotAstrologyColors.orangeGradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
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
                      CarrotAstrologyColors.orangeColorDark.withValues(
                        alpha: 0.35,
                      ),
                      CarrotAstrologyColors.orangeColor.withValues(alpha: 0.15),
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
                      'About Carrot Astrology',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#ffffff'.toColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacing.h(12),
                AutoTranslateText(
                  'Carrot Astrology is a unique wellness practice that connects your zodiac sign with vegetables that resonate with your cosmic energy. Discover personalized remedies, lifestyle practices, and insights to enhance your well-being and harmony.',
                  style: MyTextTheme.mediumBCN
                      .copyWith(color: '#ffffff'.toColor(), height: 1.5)
                      .merge(AppTypography.body1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
