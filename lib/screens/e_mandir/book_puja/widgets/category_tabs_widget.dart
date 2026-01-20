import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/book_puja/controller/book_puja_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryTabsWidget extends StatelessWidget {
  const CategoryTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookPujaController>();

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.filters.length,
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          final filterName = filter['name'] as String;

          return Obx(() {
            final isSelected = filterName == controller.selectedFilter.value;
            
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => controller.onFilterChanged(filterName),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.orangeGradient : null,
                    color: isSelected ? null : Colors.white,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: AppColors.orangeGradient.colors.first,
                            width: 1,
                          ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected && filterName == 'Featured')
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 18,
                        ),
                      if (isSelected && filterName == 'Popular')
                        Icon(
                          Icons.local_fire_department,
                          color: Colors.white,
                          size: 18,
                        ),
                      if ((isSelected && filterName == 'Featured') ||
                          (isSelected && filterName == 'Popular'))
                        const SizedBox(width: 6),
                      AutoTranslateText(
                        filterName,
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: isSelected ? Colors.white : AppColors.orangeGradient.colors.first,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
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
