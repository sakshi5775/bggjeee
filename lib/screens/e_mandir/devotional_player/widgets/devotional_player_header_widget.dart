import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/controller/devotional_player_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalPlayerHeaderWidget extends GetView<DevotionalPlayerController> {
  const DevotionalPlayerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circleButton(
          icon: Icons.arrow_back,
          onTap: () => Get.back(),
        ),
        Container(
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
        Row(
          children: [
            InkWell(
              onTap: () {
                controller.navigateToLyrics();
              },
              child: _circleButton(icon: Icons.description),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () {
                controller.navigateToMeaning();
              },
              child: _circleButton(icon: Icons.menu_book),
            ),
          ],
        )
      ],
    );
  }

  Widget _circleButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.deepOrange),
      ),
    );
  }
}
