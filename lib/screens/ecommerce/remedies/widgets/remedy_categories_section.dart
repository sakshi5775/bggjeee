import 'package:astrobharataiuser/data_model/category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';

class RemedyCategoriesSection extends GetView<RemediesController> {
  const RemedyCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Digital Store',
                style: AppTypography.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E1212),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.ecommerceHome);
                },
                child: AutoTranslateText(
                  'View All',
                  style: AppTypography.body2.copyWith(
                    color: const Color(0xFFD68D3C),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFD68D3C),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 135.h,
          child: Obx(() {
            if (controller.isLoadingStore.value) {
              return const Center(
                child: CircularProgressIndicator(),
              ); // Placeholder, prefer shimmer
            }

            if (controller.storeCategories.isEmpty) {
              return const SizedBox.shrink();
            }

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.storeCategories.length,
              separatorBuilder: (context, index) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final category = controller.storeCategories[index];
                return _buildCategoryItem(category);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return Column(
      children: [
        Container(
          height: 70.w, // Square-ish container
          width: 70.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E7), // Light beige bg
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFD68D3C).withOpacity(0.2)),
          ),
          child: CachedNetworkImage(
            imageUrl: category.image ?? '',
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: 70.w,
          child: AutoTranslateText(
            category.name ?? '',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3E1212),
            ),
          ),
        ),
      ],
    );
  }
}
