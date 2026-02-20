import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class SectionTitleWidget extends StatelessWidget {
  final String text;

  const SectionTitleWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(height: 18, width: 3, color: AppColors.deepOrange),
          const SizedBox(width: 6),
          AutoTranslateText(
            text,
            style: AppTypography.h2.copyWith(
              fontSize: 20,
              color: Color(0xFF6D2E2E),
            ),
          ),
        ],
      ),
    );
  }
}
