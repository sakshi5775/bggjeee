import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class OrangeTagWidget extends StatelessWidget {
  final String text;

  const OrangeTagWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.symmetric(h: 10, v: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: AppRadius.all(12),
      ),
      child: AutoTranslateText(
        text,
        style: MyTextTheme.smallBCN.copyWith(color: Colors.white),
      ),
    );
  }
}
