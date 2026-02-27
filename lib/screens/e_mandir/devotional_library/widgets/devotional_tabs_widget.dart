import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Horizontal scrollable god category avatars.
class DevotionalTabsWidget extends GetView<DevotionalLibraryController> {
  const DevotionalTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCategories.value) {
        return SizedBox(
          height: 90.h,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.deepOrange),
          ),
        );
      }
      if (controller.godCategories.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 90.h,
        child: ListView.builder(
          controller: controller.godTabScrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.godCategories.length,
          itemBuilder: (context, index) {
            final god = controller.godCategories[index];
            return Obx(() {
              final isSelected = controller.selectedGodIndex.value == index;
              return GestureDetector(
                onTap: () => controller.onGodCategoryChanged(index),
                child: Container(
                  width: 72.w,
                  margin: EdgeInsets.only(right: 10.w),
                  child: Column(
                    children: [
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.deepOrange
                                : Colors.grey.shade300,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: god.godImage,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: Colors.orange.shade50,
                              child: Icon(
                                Icons.person,
                                size: 24.r,
                                color: Colors.orange.shade200,
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.orange.shade50,
                              child: Icon(
                                Icons.person,
                                size: 24.r,
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      AutoTranslateText(
                        god.godName,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.deepOrange
                              : Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}
