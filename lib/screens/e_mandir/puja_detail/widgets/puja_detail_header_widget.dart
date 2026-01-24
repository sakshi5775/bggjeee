import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaDetailHeaderWidget extends StatelessWidget {
  const PujaDetailHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF3E2723),
            ),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          AutoTranslateText(
            'Back',
            style: MyTextTheme.mediumBCN.copyWith(
              color: const Color(0xFF3E2723),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
