import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class DevotionalPlayerTitleWidget extends StatelessWidget {
  const DevotionalPlayerTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AutoTranslateText(
          "Om Ganeshaya Namaha",
          style: AppTypography.h2.copyWith(
            color: Color(0xFF4E342E),
          ),
        ),
        const SizedBox(height: 6),
        AutoTranslateText(
          "Lord Ganesh",
          style: AppTypography.body1.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
