import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevotionalLibraryTabsWidget extends StatelessWidget {
  const DevotionalLibraryTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DevotionalLibraryController>();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.tabs.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedTab.value == index;
            return GestureDetector(
              onTap: () => controller.selectTab(index),
              child: Container(
                margin: AppMargin.only(right: 10),
                padding: AppPaddings.symmetric(h: 18, v: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepOrange : Colors.white,
                  borderRadius: AppRadius.all(10),
                  border: Border.all(color: Colors.deepOrange),
                ),
                child: AutoTranslateText(
                  controller.tabs[index],
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
