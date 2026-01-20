import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalLibraryHeaderWidget extends StatelessWidget {
  const DevotionalLibraryHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.deepOrange,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        Spacing.w(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText(
              "Devotional Library",
              style: MyTextTheme.veryLargeBCB.copyWith(
                color: const Color(0xFF4E342E),
              ),
            ),
            AutoTranslateText(
              "Aartis, Mantras & Stories",
              style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
