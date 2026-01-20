import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class PunyaMudraPointsWidget extends StatelessWidget {
  const PunyaMudraPointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: AppPaddings.all(2),
      decoration: BoxDecoration(
        borderRadius: AppRadius.all(30),
        color: Colors.white,
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Padding(
            padding: AppPaddings.all(4),
            child: AutoTranslateText(
              "66",
              style: MyTextTheme.veryLargeBCB,
            ),
          ),
          Padding(
            padding: AppPaddings.all(4),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(AppConstant.eMandirOmmIcon),
            ),
          ),
        ],
      ),
    );
  }
}
