import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeaningHeaderWidget extends StatelessWidget {
  const MeaningHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.horizontal(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.deepOrange),
            onPressed: () => Get.back(),
          ),
          AutoTranslateText(
            "Meaning",
            style: MyTextTheme.veryLargeBCB.copyWith(
              color: const Color(0xFF4E342E),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.lyrics);
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.description, color: Colors.deepOrange),
                ),
              ),
              Spacing.w(8),
              const CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Icon(Icons.menu_book, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
