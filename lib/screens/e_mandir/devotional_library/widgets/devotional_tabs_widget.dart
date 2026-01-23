import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';

class DevotionalTabsWidget extends GetView<DevotionalLibraryController> {
  const DevotionalTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.tabs.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedTab.value == index;
            return GestureDetector(
              onTap: () {
                controller.onTabChanged(index);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.deepOrange
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.deepOrange,
                  ),
                ),
                child: AutoTranslateText(
                  controller.tabs[index],
                  style: AppTypography.body1.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Colors.grey,
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
