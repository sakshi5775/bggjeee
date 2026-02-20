import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaAboutSectionWidget extends StatelessWidget {
  const PujaAboutSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return Obx(() {
      final puja = controller.puja.value;
      if (puja == null ||
          puja.longDescription == null ||
          puja.longDescription!.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              'About This Pooja',
              style: MyTextTheme.mediumBCB.copyWith(
                color: const Color(0xFF5D1C21),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            AutoTranslateText(
              puja.longDescription!,
              style: MyTextTheme.mediumBCN.copyWith(
                color: const Color(0xFF3E2723),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    });
  }
}
