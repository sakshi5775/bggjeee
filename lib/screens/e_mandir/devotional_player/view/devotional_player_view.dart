import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_image_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_title_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_progress_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/devotional_player_controls_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class DevotionalPlayerView extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            CommonHeader(
              showDrawer: false,
              titleWidget: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.deepOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AutoTranslateText(
                  "Listen on Mandir",
                  style: AppTypography.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              customActions: [
                InkWell(
                  onTap: () => controller.navigateToLyrics(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description,
                      color: AppColors.deepOrange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => controller.navigateToMeaning(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.menu_book,
                      color: AppColors.deepOrange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const DevotionalPlayerImageWidget(),
                    const SizedBox(height: 30),
                    const DevotionalPlayerTitleWidget(),
                    const SizedBox(height: 26),
                    const DevotionalPlayerProgressWidget(),
                    const Spacer(),
                    const DevotionalPlayerControlsWidget(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
