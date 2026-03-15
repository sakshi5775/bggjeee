import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';

class RamalShastraMethodView extends StatelessWidget {
  const RamalShastraMethodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RamalShastraController>();

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Ramal Shastra'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.h(24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: AutoTranslateText(
                        'Choose Casting Method',
                        style: MyTextTheme.veryLargeBCB
                            .copyWith(
                              color: '#3E2723'.toColor(),
                              fontWeight: FontWeight.bold,
                            )
                            .merge(AppTypography.h1),
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
                            description:
                                'Roll 4 dice × 4 rounds to generate 16 values',
                            onTap: () {
                              controller.setCastingMethod('dice');
                              UserMainController.pushInCurrentTab(AppRoutes.ramalShastraCastingDice);
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
                              UserMainController.pushInCurrentTab(AppRoutes.ramalShastraCastingCards);
                            },
                          ),
                          Spacing.h(16),
                          _buildMethodCard(
                            icon: Icons.brightness_1,
                            emoji: '●●',
                            title: 'Dots',
                            description:
                                'Tap randomly on screen 16 times - Odd taps = 1, Even taps = 0',
                            onTap: () {
                              controller.setCastingMethod('dots');
                              UserMainController.pushInCurrentTab(AppRoutes.ramalShastraCastingDots);
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
          ],
        ),
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
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1.5),
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
                child: Text(emoji, style: TextStyle(fontSize: 32.sp)),
              ),
            ),
            Spacing.w(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoTranslateText(
                    title,
                    style: MyTextTheme.largeBCB
                        .copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        )
                        .merge(AppTypography.h3),
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
              color: "#F38B3B".toColor(),
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
