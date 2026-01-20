import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/widgets/punya_mudra_points_widget.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PunyaMudraHeaderWidget extends StatelessWidget {
  const PunyaMudraHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.symmetric(h: 16, v: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
            onPressed: () {
              Get.back();
            },
          ),
          Column(
            children: [
              AutoTranslateText(
                "Punya Mudras",
                style: MyTextTheme.extraLargeBCB.copyWith(
                  color: const Color(0xFF4E342E),
                ),
              ),
              AutoTranslateText(
                "User id : 85910542",
                style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
              ),
            ],
          ),
          const PunyaMudraPointsWidget(),
        ],
      ),
    );
  }
}
