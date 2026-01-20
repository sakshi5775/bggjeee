import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class DevotionalPlayerTitleWidget extends StatelessWidget {
  const DevotionalPlayerTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoTranslateText(
          "Om Ganeshaya Namaha",
          style: MyTextTheme.veryLargeBCB.copyWith(
            color: const Color(0xFF4E342E),
          ),
        ),
        Spacing.h(6),
        AutoTranslateText(
          "Lord Ganesh",
          style: MyTextTheme.veryLargeWCN.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
