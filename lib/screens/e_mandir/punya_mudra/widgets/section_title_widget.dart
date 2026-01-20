import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  final String text;

  const SectionTitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.only(left: 16, top: 16, right: 16, bottom: 8),
      child: Row(
        children: [
          Container(height: 18, width: 3, color: Colors.deepOrange),
          Spacing.w(6),
          AutoTranslateText(
            text,
            style: MyTextTheme.veryLargeBCB.copyWith(
              color: const Color(0xFF6D2E2E),
            ),
          ),
        ],
      ),
    );
  }
}
