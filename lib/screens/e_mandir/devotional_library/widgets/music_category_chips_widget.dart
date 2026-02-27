import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';

/// Music category filter chips (Aarti, Chalisa, Bhajan, etc.).
class MusicCategoryChipsWidget extends GetView<DevotionalLibraryController> {
  const MusicCategoryChipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.musicCategories.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected =
                controller.selectedMusicCategoryIndex.value == index;
            return GestureDetector(
              onTap: () => controller.onMusicCategoryChanged(index),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.orangeGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.deepOrange
                        : Colors.grey.shade300,
                  ),
                ),
                child: AutoTranslateText(
                  controller.musicCategories[index],
                  style: AppTypography.body1.copyWith(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
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
