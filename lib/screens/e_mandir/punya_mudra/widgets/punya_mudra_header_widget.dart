import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class PunyaMudraHeaderWidget extends StatelessWidget {
  const PunyaMudraHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepOrange),
            onPressed: () {
              Get.back();
            },
          ),
          Column(
            children: [
              AutoTranslateText(
                "Punya Mudras",
                style: AppTypography.h1.copyWith(
                  fontSize: 24,
                  color: Color(0xFF4E342E),
                ),
              ),
              AutoTranslateText(
                "User id : 85910542",
                style: AppTypography.body1.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          _pointsWidget(),
        ],
      ),
    );
  }

  Widget _pointsWidget() {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.all(4),
            child: Text(
              "66",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
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
