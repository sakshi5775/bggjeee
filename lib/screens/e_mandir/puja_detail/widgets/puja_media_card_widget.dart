import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_manager/network_image.dart';

class PujaMediaCardWidget extends StatelessWidget {
  const PujaMediaCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return Obx(() {
      final puja = controller.puja.value;
      if (puja == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: NetworkImageWithLoader(
                  url: puja.image!,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
