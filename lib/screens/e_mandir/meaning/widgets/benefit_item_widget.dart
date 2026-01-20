import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class BenefitItemWidget extends StatelessWidget {
  final String text;

  const BenefitItemWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoTranslateText(
            "• ",
            style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
            translate: false,
          ),
          Expanded(
            child: AutoTranslateText(
              text,
              style: MyTextTheme.mediumBCN.copyWith(
                color: Colors.grey,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
