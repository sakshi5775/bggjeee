import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class HelpRowWidget extends StatelessWidget {
  const HelpRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: AppColors.deepOrange),
          const SizedBox(width: 10),
          Expanded(
            child: AutoTranslateText(
              "Know how to earn More Punya Mudras",
              style: AppTypography.body1.copyWith(
                fontSize: 13,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.deepOrange),
        ],
      ),
    );
  }
}
