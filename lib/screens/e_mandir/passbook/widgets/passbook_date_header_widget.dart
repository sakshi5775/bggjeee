import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class PassbookDateHeaderWidget extends StatelessWidget {
  final String text;

  const PassbookDateHeaderWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.only(left: 6, top: 14, bottom: 6),
      child: AutoTranslateText(
        text,
        style: MyTextTheme.smallBCN.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        translate: false,
      ),
    );
  }
}
