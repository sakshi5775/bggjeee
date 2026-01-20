import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class PassbookTitleWidget extends StatelessWidget {
  const PassbookTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTranslateText(
      "✨ Your Passbook ✨",
      style: MyTextTheme.mediumBCB.copyWith(
        color: const Color(0xFF6D2E2E),
      ),
      translate: false,
    );
  }
}
