import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_player/widgets/circle_button_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalPlayerHeaderWidget extends StatelessWidget {
  const DevotionalPlayerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleButtonWidget(icon: Icons.arrow_back, onTap: () => Get.back()),
        Container(
          padding: AppPaddings.symmetric(h: 16, v: 6),
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: AppRadius.all(20),
          ),
          child: AutoTranslateText(
            "Listen on Mandir",
            style: MyTextTheme.mediumBCN.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.lyrics);
              },
              child: const CircleButtonWidget(icon: Icons.description),
            ),
            Spacing.w(8),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.meaning);
              },
              child: const CircleButtonWidget(icon: Icons.menu_book),
            ),
          ],
        ),
      ],
    );
  }
}
