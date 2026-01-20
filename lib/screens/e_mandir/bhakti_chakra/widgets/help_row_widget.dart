import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class HelpRowWidget extends StatelessWidget {
  const HelpRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppMargin.symmetric(v: 6),
      padding: AppPaddings.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.all(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: Colors.deepOrange),
          Spacing.w(10),
          Expanded(
            child: AutoTranslateText(
              "Know how to earn More Punya Mudras",
              style: MyTextTheme.smallBCN,
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.deepOrange),
        ],
      ),
    );
  }
}
