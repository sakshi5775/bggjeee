import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class MeaningHeaderWidget extends StatelessWidget {
  const MeaningHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.deepOrange),
            onPressed: () => Get.back(),
          ),
          AutoTranslateText(
            "Meaning",
            style: AppTypography.h2.copyWith(
              color: Color(0xFF4E342E),
            ),
          ),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.description, color: AppColors.deepOrange),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                backgroundColor: AppColors.deepOrange,
                child: Icon(Icons.menu_book, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
