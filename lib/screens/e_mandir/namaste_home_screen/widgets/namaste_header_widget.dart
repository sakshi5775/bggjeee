import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NamasteHeaderWidget extends StatelessWidget {
  const NamasteHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.arrow_back, color: Color(0xFF8D6E63)),
        Column(
          children: [
            AutoTranslateText(
              "Namaste",
              style: MyTextTheme.extraLargeBCB.copyWith(
                color: const Color(0xFF4E342E),
              ),
            ),
            AutoTranslateText(
              "Welcome to Divine Temple",
              style: MyTextTheme.mediumBCN.copyWith(color: Colors.grey),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.punyaMudra);
          },
          child: Container(
            height: 50,
            padding: AppPaddings.all(2),
            decoration: BoxDecoration(
              borderRadius: AppRadius.all(30),
              color: Colors.white,
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: [
                Padding(
                  padding: AppPaddings.all(8),
                  child: AutoTranslateText(
                    "66",
                    style: MyTextTheme.veryLargeBCB.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: AppPaddings.all(4),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(AppConstant.eMandirOmmIcon),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
