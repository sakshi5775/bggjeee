import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

class PassbookHeaderWidget extends StatelessWidget {
  const PassbookHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTranslateText(
      "✨ Your Passbook ✨",
      style: AppTypography.h2.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6D2E2E),
      ),
    );
  }
}
