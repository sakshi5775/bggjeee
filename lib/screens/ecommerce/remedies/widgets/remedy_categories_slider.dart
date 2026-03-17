import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/data_model/remedy_category_model.dart';
import 'package:astrobharataiuser/screens/ecommerce/remedies/controllers/remedies_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Horizontal slider of remedy categories. Each card: image, heading below image, Explore button.
/// On Explore → opens remedy-services listing for that category.
class RemedyCategoriesSlider extends GetView<RemediesController> {
  const RemedyCategoriesSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Remedy Categories',
                style: AppTypography.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E1212),
                ),
              ),
              GestureDetector(
                onTap: () {
                  UserMainController.pushInCurrentTab(
                    AppRoutes.remedyCategoriesAll,
                  );
                },
                child: AutoTranslateText(
                  'View All',
                  style: AppTypography.body2.copyWith(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 200.h,
          child: Obx(() {
            if (controller.isLoadingRemedies.value &&
                controller.remedyCategories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }
            if (controller.remedyCategories.isEmpty) {
              return const SizedBox.shrink();
            }
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: controller.remedyCategories.length,
              separatorBuilder: (_, __) => SizedBox(width: 16.w),
              itemBuilder: (context, index) {
                final category = controller.remedyCategories[index];
                return _CategoryCard(category: category);
              },
            );
          }),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final RemedyCategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCategoryListing(),
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image on top
            SizedBox(
              height: 100.h,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: category.image ?? '',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            // Heading below the image
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 6.h),
              child: AutoTranslateText(
                category.title ?? 'Remedy',
                style: AppTypography.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3E1212),
                  fontSize: 13.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            // Explore button
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openCategoryListing(),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        'Explore',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategoryListing() {
    UserMainController.pushInCurrentTab(
      AppRoutes.remedyCategoryListing,
      arguments: {
        'categoryId': category.id ?? '',
        'title': category.title ?? 'Remedies',
      },
    );
  }
}
