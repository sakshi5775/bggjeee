import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Digital Mart tab: compact grid of product categories.
class DigitalMartTabWidget extends StatelessWidget {
  const DigitalMartTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserDashboardController>();

    // Same top padding as Digital Consultation filter (0) so spacing below slider matches.
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 4.h),
      child: Obx(() {
        if (controller.isLoadingDigitalMartCategories.value &&
            controller.digitalMartCategories.isEmpty) {
          return SizedBox(
            height: 100.h,
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFFDFB343)),
            ),
          );
        }

        final categories = controller.digitalMartCategories;

        if (categories.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: AutoTranslateText(
                'No categories yet',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: '#6F221E'.toColor(),
                ),
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6.w,
            mainAxisSpacing: 6.h,
            childAspectRatio: 0.9,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) =>
              _buildCategoryCard(context, categories[index]),
        );
      }),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return GestureDetector(
    onTap: () {
      if (category.id != null) {
        Get.toNamed('/product-list', arguments: {'category': category});
      } else if (category.slug != null) {
        Get.toNamed('/product-list', arguments: {'categorySlug': category.slug});
      }
    },
    child: Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.orangeGradient.colors.first.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // BIGGER IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: SizedBox(
              width: 80.w,
              height: 80.w,
              child: category.image != null && category.image!.isNotEmpty
                  ? NetworkImageWithLoader(
                      url: category.image!,
                      width: 80.w,
                      height: 80.w,
                      isCircular: true,
                    )
                  : Icon(
                      Icons.category_rounded,
                      size: 40.w,
                      color: AppColors.deepOrange,
                    ),
            ),
          ),

          SizedBox(height: 6.h),

          AutoTranslateText(
            category.name ?? 'Category',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: '#3D0C11'.toColor(),
              height: 1.1,
            ),
          ),
        ],
      ),
    ),
  );
  }
}

