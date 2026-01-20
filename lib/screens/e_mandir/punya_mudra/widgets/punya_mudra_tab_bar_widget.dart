import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/punya_mudra/controller/punya_mudra_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PunyaMudraTabBarWidget extends StatelessWidget {
  const PunyaMudraTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PunyaMudraController>();

    return Container(
      margin: AppMargin.horizontal(16),
      color: Colors.white,
      child: Row(
        children: [
          _TabItem(title: "Earn Punya", index: 0, controller: controller),
          _TabItem(title: "Bhakti Chakra", index: 1, controller: controller),
          _TabItem(title: "Passbook", index: 2, controller: controller),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final int index;
  final PunyaMudraController controller;

  const _TabItem({
    required this.title,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => InkWell(
          onTap: () => controller.selectTab(index),
          child: Container(
            padding: AppPaddings.vertical(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: controller.selectedTab.value == index
                      ? Colors.deepOrange
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: AutoTranslateText(
              title,
              textAlign: TextAlign.center,
              style: MyTextTheme.mediumBCB.copyWith(
                color: controller.selectedTab.value == index
                    ? Colors.deepOrange
                    : const Color(0xFF6D2E2E),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
