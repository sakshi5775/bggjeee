import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class PunyaMudraTabsWidget extends GetView<PunyaMudraController> {
  const PunyaMudraTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Row(
        children: [
          _tab("Earn Punya", 0),
          _tab("Bhakti Chakra", 1),
          _tab("Passbook", 2),
        ],
      ),
    );
  }

  Widget _tab(String title, int index) {
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.onTabChanged(index);
        },
        child: Obx(() => Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: controller.selectedTab.value == index
                        ? AppColors.deepOrange
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: AutoTranslateText(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: controller.selectedTab.value == index
                      ? AppColors.deepOrange
                      : const Color(0xFF6D2E2E),
                ),
              ),
            )),
      ),
    );
  }
}
