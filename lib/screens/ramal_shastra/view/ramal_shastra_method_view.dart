import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RamalShastraMethodView extends StatelessWidget {
  const RamalShastraMethodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RamalShastraController>();

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Spacing.h(24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  'Choose Casting Method',
                  style: MyTextTheme.veryLargeBCB.copyWith(
                    color: '#3E2723'.toColor(),
                    fontWeight: FontWeight.bold,
                  ).merge(AppTypography.h1),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: AutoTranslateText(
                  'Select your preferred method to generate the pattern',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: '#666666'.toColor(),
                  ),
                ),
              ),
              Spacing.h(32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    _buildMethodCard(
                      icon: Icons.casino,
                      emoji: '🎲',
                      title: 'Dice',
                      description: 'Roll 4 dice × 4 rounds to generate 16 values',
                      onTap: () {
                        controller.setCastingMethod('dice');
                        Get.toNamed(AppRoutes.ramalShastraCastingDice);
                      },
                    ),
                    Spacing.h(16),
                    _buildMethodCard(
                      icon: Icons.style,
                      emoji: '🃏',
                      title: 'Cards',
                      description: 'Draw 16 cards - Red = 1, Black = 0',
                      onTap: () {
                        controller.setCastingMethod('cards');
                        Get.toNamed(AppRoutes.ramalShastraCastingCards);
                      },
                    ),
                    Spacing.h(16),
                    _buildMethodCard(
                      icon: Icons.brightness_1,
                      emoji: '●●',
                      title: 'Dots',
                      description: 'Tap randomly on screen 16 times - Odd taps = 1, Even taps = 0',
                      onTap: () {
                        controller.setCastingMethod('dots');
                        Get.toNamed(AppRoutes.ramalShastraCastingDots);
                      },
                    ),
                  ],
                ),
              ),
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
        ],
      ),
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String emoji,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: '#FFF2E8'.toColor(),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
            ),
            Spacing.w(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.largeBCB.copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    ).merge(AppTypography.h3),
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    description,
                    style: MyTextTheme.smallBCN.copyWith(
                      color: '#666666'.toColor(),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.deepOrange,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}


