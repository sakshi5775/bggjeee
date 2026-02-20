import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalLibraryHeaderWidget extends GetView<DevotionalLibraryController> {
  const DevotionalLibraryHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.deepOrange,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              "Devotional Library",
              style: AppTypography.h2.copyWith(
                color: Color(0xFF4E342E),
              ),
            ),
            AutoTranslateText(
              "Aartis, Mantras & Stories",
              style: AppTypography.body1.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
